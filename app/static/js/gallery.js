(() => {
  const quantityInput = document.querySelector('[data-product-quantity]');
  document.querySelectorAll('[data-quantity-step]').forEach((button) => button.addEventListener('click', () => {
    if (!quantityInput) return;
    const currentQuantity = Number(quantityInput.value);
    const nextQuantity = currentQuantity + Number(button.dataset.quantityStep);
    if (Number.isInteger(nextQuantity) && nextQuantity >= 1 && nextQuantity <= 99) {
      quantityInput.value = String(nextQuantity);
    }
  }));

  const tabs = document.querySelectorAll('[data-product-tabs] [role="tab"]');
  tabs.forEach((tab) => tab.addEventListener('click', () => {
    tabs.forEach((item) => {
      const selected = item === tab;
      item.setAttribute('aria-selected', String(selected));
      item.tabIndex = selected ? 0 : -1;
      document.getElementById(item.getAttribute('aria-controls')).hidden = !selected;
    });
  }));

  document.querySelectorAll('[data-contact-toggle]').forEach((contactToggle) => {
    const contactOptions = document.getElementById(contactToggle.getAttribute('aria-controls'));
    contactToggle.addEventListener('click', () => {
      const open = contactToggle.getAttribute('aria-expanded') !== 'true';
      contactToggle.setAttribute('aria-expanded', String(open));
      contactOptions.hidden = !open;
    });
  });

  const productContactToggle = document.querySelector('.detail-contact-toggle:not([data-contact-toggle])');
  const productContactOptions = document.getElementById('detail-contact-options');
  productContactToggle?.addEventListener('click', () => {
    const open = productContactToggle.getAttribute('aria-expanded') !== 'true';
    productContactToggle.setAttribute('aria-expanded', String(open));
    productContactOptions.hidden = !open;
  });

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