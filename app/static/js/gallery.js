(() => {
  const main = document.querySelector('[data-gallery-main]');
  const mainImage = document.querySelector('[data-gallery-image]');
  const lightbox = document.querySelector('[data-image-lightbox]');
  const lightboxImage = document.querySelector('[data-lightbox-image]');
  if (!main) return;
  document.querySelectorAll('[data-gallery-thumb]').forEach((thumb) => thumb.addEventListener('click', () => {
    const source = thumb.dataset.galleryThumb;
    if (mainImage) { mainImage.src = source; mainImage.hidden = false; }
    if (lightboxImage) lightboxImage.src = source;
    document.querySelectorAll('[data-gallery-thumb]').forEach((item) => item.classList.toggle('is-active', item === thumb));
  }));
  main.addEventListener('click', () => {
    if (!mainImage || !lightbox) return;
    lightboxImage.src = mainImage.src;
    lightbox.hidden = false;
    document.body.classList.add('lightbox-open');
  });
  const close = () => { if (lightbox) lightbox.hidden = true; document.body.classList.remove('lightbox-open'); };
  lightbox?.querySelector('[data-lightbox-close]')?.addEventListener('click', close);
  lightbox?.addEventListener('click', (event) => { if (event.target === lightbox) close(); });
  document.addEventListener('keydown', (event) => { if (event.key === 'Escape') close(); });
})();