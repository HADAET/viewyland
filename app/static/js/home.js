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
