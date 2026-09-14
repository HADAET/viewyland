(() => {
  const message = document.querySelector('[data-auth-message]');
  const setMessage = (text, error = false) => { if (message) { message.textContent = text; message.className = `auth-message ${error ? 'is-error' : 'is-success'}`; } };
  document.querySelectorAll('[data-auth-tab]').forEach((tab) => tab.addEventListener('click', () => {
    document.querySelectorAll('[data-auth-tab]').forEach((item) => item.classList.toggle('is-active', item === tab));
    document.querySelectorAll('[data-auth-form]').forEach((form) => { form.hidden = form.dataset.authForm !== tab.dataset.authTab; });
    setMessage('');
  }));
  document.querySelectorAll('[data-auth-form]').forEach((form) => form.addEventListener('submit', async (event) => {
    event.preventDefault();
    const endpoint = form.dataset.authForm === 'login' ? '/auth/login' : '/auth/register';
    const response = await fetch(endpoint, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(Object.fromEntries(new FormData(form)))});
    const data = await response.json();
    if (!response.ok) { setMessage(data.detail || 'Could not complete this request.', true); return; }
    setMessage(data.message);
    setTimeout(() => { window.location.href = '/'; }, 700);
  }));
  const uploadProfileImage = async () => {
    const input = document.querySelector('[data-profile-image-input]');
    if (!input?.files?.length) return true;
    const formData = new FormData();
    formData.append('image', input.files[0]);
    const response = await fetch('/auth/profile-image', {method: 'POST', body: formData});
    const data = await response.json();
    if (!response.ok) { setMessage(data.detail || 'Could not upload the image.', true); return false; }
    document.querySelectorAll('[data-profile-avatar]').forEach((avatar) => {
      avatar.innerHTML = `<img src="${data.profile_image}" alt="Profile photo">`;
    });
    const hiddenImage = document.querySelector('[data-profile-form] input[name="profile_image"]');
    if (hiddenImage) hiddenImage.value = data.profile_image;
    return true;
  };
  const submitProfile = async (form, endpoint) => {
    if (endpoint === '/auth/profile' && !(await uploadProfileImage())) return;
    const response = await fetch(endpoint, {method: endpoint === '/auth/profile' ? 'PATCH' : 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(Object.fromEntries(new FormData(form)))});
    const data = await response.json();
    setMessage(data.message || data.detail || 'Could not save your changes.', !response.ok);
    if (response.ok && endpoint === '/auth/profile') setTimeout(() => window.location.reload(), 700);
  };
  document.querySelector('[data-profile-form]')?.addEventListener('submit', (event) => { event.preventDefault(); submitProfile(event.currentTarget, '/auth/profile'); });
  document.querySelector('[data-profile-image-input]')?.addEventListener('change', (event) => {
    const input = event.target;
    if (!input.files?.length) return;
    const preview = URL.createObjectURL(input.files[0]);
    document.querySelectorAll('[data-profile-avatar]').forEach((avatar) => {
      avatar.innerHTML = `<img src="${preview}" alt="Selected profile photo">`;
    });
    const hint = document.querySelector('[data-image-upload-hint]');
    if (hint) hint.textContent = `${input.files[0].name} selected. Save changes to upload.`;
  });
  document.querySelectorAll('[data-profile-tab]').forEach((tab) => tab.addEventListener('click', () => {
    document.querySelectorAll('[data-profile-tab]').forEach((item) => item.classList.toggle('is-active', item === tab));
    document.querySelectorAll('[data-profile-panel]').forEach((panel) => {
      const selected = panel.dataset.profilePanel === tab.dataset.profileTab;
      panel.hidden = !selected;
      panel.classList.toggle('is-active', selected);
      if (selected) panel.scrollIntoView({behavior: 'smooth', block: 'start'});
    });
  }));
  document.querySelector('[data-order-search]')?.addEventListener('input', (event) => {
    const term = event.target.value.toLowerCase();
    document.querySelectorAll('[data-order-row]').forEach((row) => { row.hidden = !row.textContent.toLowerCase().includes(term); });
  });
  document.querySelector('[data-logout]')?.addEventListener('click', async () => { await fetch('/auth/logout', {method: 'POST'}); window.location.reload(); });
})();