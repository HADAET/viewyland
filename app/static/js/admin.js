(() => {
  const dialog = document.querySelector('[data-row-dialog]');
  const form = document.querySelector('[data-row-form]');
  const fields = document.querySelector('[data-row-fields]');
  const title = document.querySelector('[data-row-title]');
  const close = () => dialog?.close();

  // Helper function to compress and resize image client-side under target size (250KB)
  async function compressImage(file, targetSizeInBytes) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = (event) => {
        const img = new Image();
        img.src = event.target.result;
        img.onload = () => {
          const canvas = document.createElement('canvas');
          let width = img.width;
          let height = img.height;

          const MAX_DIMENSION = 1200;
          if (width > height && width > MAX_DIMENSION) {
            height *= MAX_DIMENSION / width;
            width = MAX_DIMENSION;
          } else if (height > MAX_DIMENSION) {
            width *= MAX_DIMENSION / height;
            height = MAX_DIMENSION;
          }

          canvas.width = width;
          canvas.height = height;
          const ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0, width, height);

          let quality = 0.8;
          const attemptCompression = () => {
            canvas.toBlob(
              (blob) => {
                if (!blob) {
                  reject(new Error('Canvas blob creation failed'));
                  return;
                }
                if (blob.size <= targetSizeInBytes || quality <= 0.1) {
                  const compressedFile = new File([blob], file.name, {
                    type: 'image/jpeg',
                    lastModified: Date.now(),
                  });
                  resolve(compressedFile);
                } else {
                  quality -= 0.1;
                  attemptCompression();
                }
              },
              'image/jpeg',
              quality
            );
          };
          attemptCompression();
        };
        img.onerror = (err) => reject(err);
      };
      reader.onerror = (err) => reject(err);
    });
  }

  const createItemPicker = (existingValue) => {
    const wrapper = document.createElement('div');
    wrapper.className = 'db-searchable-select';
    const search = document.createElement('input');
    search.type = 'search';
    search.className = 'db-item-search';
    search.placeholder = 'Search item name or code...';
    search.autocomplete = 'off';
    search.setAttribute('role', 'combobox');
    search.setAttribute('aria-expanded', 'false');
    search.setAttribute('aria-autocomplete', 'list');
    search.required = true;
    const selected = document.createElement('input');
    selected.type = 'hidden';
    selected.name = 'item_no';
    const list = document.createElement('div');
    list.className = 'db-item-options';
    list.setAttribute('role', 'listbox');
    list.hidden = true;
    const items = window.viewylandAdminItems || [];

    const choose = (item) => {
      selected.value = item.item_no;
      search.value = `${item.item_name} (${item.item_no})`;
      search.setCustomValidity('');
      list.hidden = true;
      search.setAttribute('aria-expanded', 'false');
    };
    const render = () => {
      const term = search.value.trim().toLocaleLowerCase();
      const matches = items.filter((item) => `${item.item_name} ${item.item_no}`.toLocaleLowerCase().includes(term)).slice(0, 80);
      list.replaceChildren();
      matches.forEach((item) => {
        const option = document.createElement('button');
        option.type = 'button';
        option.className = 'db-item-option';
        option.setAttribute('role', 'option');
        option.textContent = `${item.item_name} (${item.item_no})`;
        option.addEventListener('click', () => choose(item));
        list.append(option);
      });
      if (!matches.length) {
        const empty = document.createElement('div');
        empty.className = 'db-item-no-results';
        empty.textContent = 'No matching items';
        list.append(empty);
      }
    };

    search.addEventListener('focus', () => { render(); list.hidden = false; search.setAttribute('aria-expanded', 'true'); });
    search.addEventListener('input', () => {
      selected.value = '';
      search.setCustomValidity('Select an item from the list.');
      render();
      list.hidden = false;
      search.setAttribute('aria-expanded', 'true');
    });
    search.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') { list.hidden = true; search.setAttribute('aria-expanded', 'false'); }
      if (event.key === 'ArrowDown') { event.preventDefault(); list.querySelector('button')?.focus(); }
    });
    list.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') { list.hidden = true; search.setAttribute('aria-expanded', 'false'); search.focus(); }
      if (event.key === 'ArrowDown') { event.preventDefault(); event.target.nextElementSibling?.focus(); }
      if (event.key === 'ArrowUp') { event.preventDefault(); event.target.previousElementSibling?.focus() || search.focus(); }
    });
    document.addEventListener('click', (event) => {
      if (!wrapper.contains(event.target)) { list.hidden = true; search.setAttribute('aria-expanded', 'false'); }
    });

    wrapper.append(search, selected, list);
    const current = items.find((item) => item.item_no === existingValue);
    if (current) choose(current);
    return wrapper;
  };

  const openEditor = (button) => {
    const mode = button.dataset.mode;
    const table = button.dataset.table;
    const columns = JSON.parse(button.dataset.columns);
    const row = button.dataset.row ? JSON.parse(button.dataset.row) : {};
    form.action = button.dataset.action;
    title.textContent = mode === 'add' ? 'Add row' : 'Update row';
    fields.innerHTML = '';
    
    columns.forEach((column) => {
      if (column.virtual) return;
      if (mode === 'edit' && column.pk) return;
      if (mode === 'add' && (column.is_identity || column.auto_id || (column.pk && column.type.toUpperCase().includes('INTEGER')))) return;
      
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
        // 'capture' omitted to allow choosing from gallery, files, or camera on mobile

        fileInput.addEventListener('change', async (e) => {
          const file = e.target.files[0];
          if (!file) return;

          if (file.size <= 250 * 1024) return;

          try {
            hint.textContent = 'Compressing image to under 250KB... Please wait.';
            const compressedFile = await compressImage(file, 250 * 1024);
            
            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(compressedFile);
            fileInput.files = dataTransfer.files;
            
            hint.textContent = `Compressed from ${(file.size / 1024).toFixed(1)}KB to ${(compressedFile.size / 1024).toFixed(1)}KB successfully!`;
          } catch (err) {
            console.error('Image compression failed:', err);
            hint.textContent = 'Compression failed, original file will be used.';
          }
        });

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
        const picker = createItemPicker(existingValue);
        picker.querySelector('input[type="hidden"]').name = column.name;
        if (column.notnull) picker.querySelector('.db-item-search').required = true;
        label.append(picker);
        fields.append(label);
        return;
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
