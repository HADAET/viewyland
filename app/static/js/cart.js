(() => {
  const badge = document.querySelector('.cart-badge');
  const searchToggle = document.querySelector('[data-search-toggle]');
  const searchForm = document.querySelector('[data-search-form]');

  document.querySelectorAll('[data-add-to-cart]').forEach((button) => {
    button.addEventListener('click', async () => {
      if (button.disabled) return;
      button.disabled = true;
      try {
        const response = await fetch('/cart/items', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({item_no: button.dataset.addToCart}),
        });
        if (!response.ok) throw new Error('Unable to add item');
        const data = await response.json();
        if (badge) badge.textContent = data.cart_count;
        button.classList.add('is-added');
        button.textContent = '✓';
        setTimeout(() => { button.textContent = '+'; button.classList.remove('is-added'); button.disabled = false; }, 1200);
      } catch (error) {
        button.disabled = false;
        button.setAttribute('aria-label', 'Unable to add item');
      }
    });
  });

  searchToggle?.addEventListener('click', () => {
    const open = searchForm.classList.toggle('is-open');
    if (open) searchForm.querySelector('input').focus();
  });

  document.querySelectorAll('[data-cart-change]').forEach((button) => {
    button.addEventListener('click', async () => {
      button.disabled = true;
      const response = await fetch('/cart/items', {
        method: 'PATCH',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({item_no: button.dataset.cartChange, quantity: Number(button.dataset.quantity)}),
      });
      if (response.ok) window.location.reload();
      else button.disabled = false;
    });
  });

  const confirmOpen = document.querySelector('[data-confirm-open]');
  const confirmForm = document.querySelector('[data-confirm-form]');
  const orderMessage = document.querySelector('[data-order-message]');
  confirmOpen?.addEventListener('click', () => {
    confirmForm.hidden = false;
    confirmForm.scrollIntoView({behavior: 'smooth', block: 'center'});
    confirmForm.querySelector('input')?.focus();
  });
  confirmForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const submit = confirmForm.querySelector('button[type="submit"]');
    submit.disabled = true;
    orderMessage.textContent = 'Confirming your order...';
    const response = await fetch('/cart/confirm', {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(Object.fromEntries(new FormData(confirmForm)))});
    const data = await response.json();
    if (response.ok) {
      orderMessage.className = 'order-message is-success';
      orderMessage.textContent = `Order ${data.order_no} confirmed successfully.`;
      setTimeout(() => { window.location.href = '/'; }, 1800);
    } else {
      submit.disabled = false;
      orderMessage.className = 'order-message is-error';
      orderMessage.textContent = data.detail || 'Could not confirm the order.';
    }
  });
})();
