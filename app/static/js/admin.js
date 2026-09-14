(() => {
  const dialog = document.querySelector('[data-row-dialog]');
  const form = document.querySelector('[data-row-form]');
  const fields = document.querySelector('[data-row-fields]');
  const title = document.querySelector('[data-row-title]');
  const close = () => dialog?.close();

  const openEditor = (button) => {
    const mode = button.dataset.mode;
    const table = button.dataset.table;
    const columns = JSON.parse(button.dataset.columns);
    const row = button.dataset.row ? JSON.parse(button.dataset.row) : {};
    form.action = button.dataset.action;
    title.textContent = mode === 'add' ? 'Add row' : 'Update row';
    fields.innerHTML = '';
    columns.forEach((column) => {
      if (mode === 'edit' && column.pk) return;
      if (mode === 'add' && (column.auto_id || (column.pk && column.type.toUpperCase().includes('INTEGER')))) return;
      if (table === 'item_image' && column.name === 'image_url') {
        const group = document.createElement('label');
        group.className = 'db-image-field';
        group.textContent = 'image_url (link, device upload, or camera)';
        const urlInput = document.createElement('input');
        urlInput.name = 'image_url';
        urlInput.type = 'url';
        urlInput.placeholder = 'https://... (leave blank if uploading a photo)';
        urlInput.value = row.image_url ?? '';
        const hint = document.createElement('small');
        hint.textContent = 'Or choose a photo from this device, or take one with your camera.';
        const fileInput = document.createElement('input');
        fileInput.name = 'image_file';
        fileInput.type = 'file';
        fileInput.accept = 'image/jpeg,image/png,image/webp';
        fileInput.capture = 'environment';
        group.append(urlInput, hint, fileInput);
        fields.append(group);
        return;
      }
      const label = document.createElement('label');
      label.textContent = `${column.name}${column.notnull ? ' *' : ''}`;
      const existingValue = row[column.name];
      let input;
      if (column.name === 'active_status') {
        input = document.createElement('select');
        ['Y', 'N'].forEach((value) => input.add(new Option(value, value, false, (existingValue ?? 'Y') === value)));
      } else if (column.is_date) {
        input = document.createElement('input');
        input.type = 'datetime-local';
        if (existingValue) input.value = String(existingValue).replace(' ', 'T').slice(0, 16);
        else if (mode === 'add') input.value = new Date().toISOString().slice(0, 16);
      } else if (column.name === 'item_no' && window.viewylandAdminItems?.length) {
        input = document.createElement('select');
        window.viewylandAdminItems.forEach((item) => {
          input.add(new Option(`${item.item_name} (${item.item_no})`, item.item_no, false, item.item_no === existingValue));
        });
      } else if (column.name === 'item_category' && window.viewylandAdminCategories?.length) {
        input = document.createElement('select');
        window.viewylandAdminCategories.forEach((category) => input.add(new Option(category, category, false, category === existingValue)));
      } else if (column.name === 'wsm_store_no' && window.viewylandAdminStores?.length) {
        input = document.createElement('select');
        window.viewylandAdminStores.forEach((store) => {
          input.add(new Option(`${store.wsm_store_name} (${store.wsm_store_no})`, store.wsm_store_no, false, store.wsm_store_no === existingValue));
        });
      } else if (['registration_no', 'sh_registration_no'].includes(column.name) && window.viewylandAdminCustomers?.length) {
        input = document.createElement('select');
        window.viewylandAdminCustomers.forEach((customer) => {
          input.add(new Option(`${customer.customer_name} (${customer.mobile_no})`, customer.registration_no, false, customer.registration_no === existingValue));
        });
      } else {
        input = document.createElement('input');
        input.value = existingValue ?? (column.name === 'currency' ? 'TK.' : '');
        input.placeholder = column.type || 'Value';
        if (column.type.toUpperCase().includes('INT') || column.type.toUpperCase().includes('REAL')) input.type = 'number';
        if (column.type.toUpperCase().includes('REAL')) input.step = '0.01';
      }
      input.name = column.name;
      if (column.notnull) input.required = true;
      label.append(input);
      fields.append(label);
    });

    dialog.showModal();
  };

  document.querySelectorAll('[data-row-editor]').forEach((button) => button.addEventListener('click', () => openEditor(button)));
  document.querySelectorAll('[data-dialog-close]').forEach((button) => button.addEventListener('click', close));
  dialog?.addEventListener('click', (event) => { if (event.target === dialog) close(); });
  form?.addEventListener('submit', () => close());
})();
