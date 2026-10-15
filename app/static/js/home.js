(() => { const items=[...document.querySelectorAll('[data-hero-item]')]; if(!items.length)return; const current=document.querySelector('[data-carousel-current]'); let active=0; const show=(index)=>{active=(index+items.length)%items.length;items.forEach((item,n)=>item.classList.toggle('is-active',n===active));if(current)current.textContent=String(active+1).padStart(2,'0')}; items.forEach((item,index)=>item.addEventListener('mouseenter',()=>show(index))); show(0); setInterval(()=>show(active+1),3500); })();
(() => {
	const slides = [...document.querySelectorAll('[data-banner-slide]')];
	const dots = [...document.querySelectorAll('[data-banner-dot]')];
	if (!slides.length) return;
	let active = 0;
	const show = (index) => {
		active = (index + slides.length) % slides.length;
		slides.forEach((slide, n) => slide.classList.toggle('is-active', n === active));
		dots.forEach((dot, n) => dot.classList.toggle('is-active', n === active));
	};
	dots.forEach((dot, index) => dot.addEventListener('click', () => show(index)));
	show(0);
	setInterval(() => show(active + 1), 5000);
})();

(() => {
	const bannerImages = [...document.querySelectorAll('[data-banner-image]')];

	bannerImages.forEach((banner) => {
		const image = banner.dataset.bannerImage;
		if (image) {
			banner.style.backgroundImage = `url("${image}")`;
		}
	});
})();

(() => {
	const viewport = document.querySelector('[data-category-carousel]');
	const track = viewport?.querySelector('.featured-collections');
	if (!viewport || !track || track.children.length < 2) return;
	const carousel = viewport.closest('.home-collections') || viewport;
	const originals = [...track.children];
	const count = originals.length;
	track.prepend(...originals.map((card) => card.cloneNode(true)));
	track.append(...originals.map((card) => card.cloneNode(true)));

	let timer;
	let moving = false;
	let startX = null;
	let pointerId = null;
	let baseX = 0;
	let dragDistance = 0;
	let didDrag = false;
	let suppressClick = false;
	let position = count;
	const modulo = (value, length) => ((value % length) + length) % length;
	const stepSize = () => {
		const gap = parseFloat(getComputedStyle(track).columnGap) || 0;
		return track.firstElementChild.getBoundingClientRect().width + gap;
	};
	const applyPosition = (index) => { track.style.transform = `translateX(${-index * stepSize()}px)`; };
	const settle = (target) => {
		let done = false;
		let fallback;
		const finish = () => {
			if (done) return;
			done = true;
			clearTimeout(fallback);
			track.removeEventListener('transitionend', onEnd);
			position = target;
			const centered = count + modulo(position - count, count);
			if (centered !== position) {
				track.style.transition = 'none';
				position = centered;
				applyPosition(position);
				track.offsetHeight;
			}
			track.style.transition = '';
			moving = false;
			start();
		};
		const onEnd = (event) => {
			if (event.target === track && event.propertyName === 'transform') finish();
		};
		track.addEventListener('transitionend', onEnd);
		track.style.transition = 'transform .48s cubic-bezier(.22,.7,.25,1)';
		applyPosition(target);
		fallback = setTimeout(finish, 650);
	};
	const moveBy = (steps) => {
		if (moving || !steps) return;
		moving = true;
		settle(position + steps);
	};
	const start = () => {
		const motionReduced = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;
		if (!timer && !motionReduced && !carousel.matches(':hover') && !carousel.contains(document.activeElement)) {
			timer = setInterval(() => moveBy(1), 3500);
		}
	};
	const stop = () => { clearInterval(timer); timer = null; };
	track.style.transition = 'none';
	applyPosition(position);
	carousel.addEventListener('mouseenter', stop);
	carousel.addEventListener('mouseleave', start);
	carousel.addEventListener('focusin', stop);
	carousel.addEventListener('focusout', (event) => {
		if (!carousel.contains(event.relatedTarget)) start();
	});
	viewport.addEventListener('pointerdown', (event) => {
		if (moving || event.button !== 0 || event.target.closest('button')) return;
		stop();
		startX = event.clientX;
		pointerId = event.pointerId;
		baseX = -position * stepSize();
		dragDistance = 0;
		didDrag = false;
		track.style.transition = 'none';
	});
	viewport.addEventListener('dragstart', (event) => event.preventDefault());
	viewport.addEventListener('pointermove', (event) => {
		if (startX === null || event.pointerId !== pointerId) return;
		dragDistance = event.clientX - startX;
		if (!didDrag && Math.abs(dragDistance) > 5) {
			didDrag = true;
			viewport.classList.add('is-dragging');
			viewport.setPointerCapture(event.pointerId);
		}
		if (didDrag) track.style.transform = `translateX(${baseX + dragDistance}px)`;
	});
	viewport.addEventListener('pointerup', (event) => {
		if (startX === null || event.pointerId !== pointerId) return;
		startX = null;
		pointerId = null;
		viewport.classList.remove('is-dragging');
		if (didDrag) {
			suppressClick = true;
			const cardStep = stepSize();
			let steps = Math.round(-dragDistance / cardStep);
			if (!steps && Math.abs(dragDistance) >= Math.min(45, cardStep * .15)) steps = dragDistance < 0 ? 1 : -1;
			steps = Math.max(-count + 1, Math.min(count - 1, steps));
			if (steps) moveBy(steps);
			else {
				moving = true;
				settle(position);
			}
			setTimeout(() => { suppressClick = false; }, 350);
		} else {
			track.style.transition = '';
			start();
		}
	});
	viewport.addEventListener('pointercancel', () => {
		startX = null;
		pointerId = null;
		viewport.classList.remove('is-dragging');
		if (didDrag) {
			moving = true;
			settle(position);
		} else start();
	});
	viewport.addEventListener('click', (event) => {
		if (!suppressClick) return;
		event.preventDefault();
		event.stopPropagation();
	}, true);
	window.addEventListener('resize', () => {
		if (!moving && startX === null) {
			track.style.transition = 'none';
			applyPosition(position);
			track.offsetHeight;
			track.style.transition = '';
		}
	});
	start();
})();
