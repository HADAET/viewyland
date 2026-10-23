(() => {
  const badge = document.querySelector('.cart-badge');
  const searchToggle = document.querySelector('[data-search-toggle]');
  const searchForm = document.querySelector('[data-search-form]');

  document.querySelectorAll('[data-add-to-cart], [data-order-now]').forEach((button) => {
    button.addEventListener('click', async () => {
      if (button.hasAttribute('data-order-now')) {
        const quantityInput = button.closest('.product-detail')?.querySelector('[data-product-quantity]');
        const quantity = quantityInput ? Number(quantityInput.value) : 1;
        if (quantityInput && !quantityInput.checkValidity()) {
          quantityInput.reportValidity();
          return;
        }
        window.location.href = `/cart?buy_now=${encodeURIComponent(button.dataset.orderNow)}&quantity=${quantity}`;
        return;
      }
      if (button.disabled) return;
      const quantityInput = button.closest('.product-detail')?.querySelector('[data-product-quantity]');
      const quantity = quantityInput ? Number(quantityInput.value) : 1;
      if (quantityInput && !quantityInput.checkValidity()) {
        quantityInput.reportValidity();
        return;
      }
      button.disabled = true;
      try {
        const response = await fetch('/cart/items', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({item_no: button.dataset.addToCart, quantity}),
        });
        if (!response.ok) throw new Error('Unable to add item');
        const data = await response.json();
        if (badge) badge.textContent = data.cart_count;
        button.classList.add('is-added');
        button.textContent = '✓';
        setTimeout(() => { button.textContent = 'Add to Cart'; button.classList.remove('is-added'); button.disabled = false; }, 1200);
      } catch (error) {
        button.disabled = false;
        button.textContent = 'Try again';
        button.setAttribute('aria-label', error.message || 'Unable to add item');
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

  document.querySelectorAll('[data-buy-now-change]').forEach((button) => {
    button.addEventListener('click', () => {
      const quantity = Number(button.dataset.quantity);
      const itemNo = button.dataset.buyNowChange;
      if (!itemNo || quantity < 1 || quantity > 99) return;
      window.location.href = `/cart?buy_now=${encodeURIComponent(itemNo)}&quantity=${quantity}`;
    });
  });

  document.querySelector('[data-buy-now-remove]')?.addEventListener('click', () => {
    window.location.href = '/cart';
  });

  const addBuyNowButton = document.querySelector('[data-add-buy-now]');
  const buyNowMessage = document.querySelector('[data-buy-now-message]');
  addBuyNowButton?.addEventListener('click', async () => {
    addBuyNowButton.disabled = true;
    buyNowMessage.className = 'order-message';
    buyNowMessage.textContent = 'Adding item to your cart...';
    try {
      const response = await fetch('/cart/items', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          item_no: addBuyNowButton.dataset.addBuyNow,
          quantity: Number(addBuyNowButton.dataset.quantity),
        }),
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.detail || 'Could not add this item to your cart.');
      window.location.href = '/cart';
    } catch (error) {
      addBuyNowButton.disabled = false;
      buyNowMessage.className = 'order-message is-error';
      buyNowMessage.textContent = error.message || 'Could not add this item to your cart.';
    }
  });

  const confirmOpen = document.querySelector('[data-confirm-open]');
  const confirmForm = document.querySelector('[data-confirm-form]');
  const orderMessage = document.querySelector('[data-order-message]');
  const deliveryChoices = document.querySelectorAll('[data-delivery-area-choice]');
  const deliveryAreaValue = document.querySelector('[data-delivery-area-value]');
  const deliveryCharge = document.querySelector('[data-delivery-charge]');
  const cartTotal = document.querySelector('[data-cart-total]');
  const cartSubtotal = document.querySelector('[data-cart-subtotal]');

  const updateDeliveryTotal = () => {
    const selectedArea = document.querySelector('[data-delivery-area-choice]:checked');
    if (confirmOpen) confirmOpen.disabled = !selectedArea;
    if (deliveryAreaValue) deliveryAreaValue.value = selectedArea ? selectedArea.value : '';
    if (!selectedArea || !cartTotal || !cartSubtotal) {
      if (deliveryCharge) deliveryCharge.textContent = 'Choose delivery area';
      if (cartTotal) cartTotal.textContent = 'Select area to calculate total';
      return;
    }
    const charge = Number(selectedArea.dataset.charge);
    const subtotal = Number(cartSubtotal.dataset.cartSubtotal);
    const currency = cartTotal.dataset.currency;
    deliveryChoices.forEach((choice) => choice.closest('label').classList.toggle('is-selected', choice === selectedArea));
    deliveryCharge.textContent = `${currency} ${charge.toFixed(2)}`;
    cartTotal.textContent = `${currency} ${(subtotal + charge).toFixed(2)}`;
  };
  deliveryChoices.forEach((choice) => choice.addEventListener('change', updateDeliveryTotal));
  updateDeliveryTotal();

  confirmOpen?.addEventListener('click', () => {
    if (!document.querySelector('[data-delivery-area-choice]:checked')) return;
    confirmForm.hidden = false;
    confirmForm.scrollIntoView({behavior: 'smooth', block: 'center'});
    confirmForm.querySelector('input')?.focus();
  });
  confirmForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    if (!document.querySelector('[data-delivery-area-choice]:checked')) {
      orderMessage.className = 'order-message is-error';
      orderMessage.textContent = 'Please select your delivery area.';
      return;
    }
    const submit = confirmForm.querySelector('button[type="submit"]');
    submit.disabled = true;
    orderMessage.textContent = 'Confirming your order...';
    try {
      const response = await fetch('/cart/confirm', {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(Object.fromEntries(new FormData(confirmForm)))});
      const data = await response.json();
      if (!response.ok) throw new Error(data.detail || 'Could not confirm the order.');
      orderMessage.className = 'order-message is-success';
      orderMessage.textContent = `Order ${data.order_no} confirmed successfully.`;
      setTimeout(() => { window.location.href = `/checkout/confirmation/${encodeURIComponent(data.order_no)}`; }, 900);
    } catch (error) {
      submit.disabled = false;
      orderMessage.className = 'order-message is-error';
      orderMessage.textContent = error.message || 'Could not confirm the order.';
    }
  });
})();
