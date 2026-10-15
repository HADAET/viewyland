(() => {
  const toggle = document.querySelector('.contact-toggle');
  const panel = document.getElementById('communication_panel');
  if (!toggle || !panel) return;
  const setOpen = (open) => {
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'যোগাযোগের অপশন লুকান' : 'যোগাযোগের অপশন দেখান');
    panel.hidden = !open;
  };
  toggle.addEventListener('click', () => setOpen(toggle.getAttribute('aria-expanded') !== 'true'));
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && toggle.getAttribute('aria-expanded') === 'true') { setOpen(false); toggle.focus(); }
  });
  document.addEventListener('click', (event) => {
    if (toggle.getAttribute('aria-expanded') === 'true' && !event.target.closest('.contact-widget')) setOpen(false);
  });
})();
