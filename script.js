const menuButton = document.querySelector('[data-menu-button]');
const nav = document.querySelector('[data-nav]');

if (menuButton && nav) {
  menuButton.addEventListener('click', () => {
    const open = nav.classList.toggle('is-open');
    menuButton.setAttribute('aria-expanded', String(open));
  });

  nav.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      nav.classList.remove('is-open');
      menuButton.setAttribute('aria-expanded', 'false');
    });
  });
}

const copyButton = document.querySelector('[data-copy-code]');
const command = document.querySelector('#encode-command');

if (copyButton && command) {
  copyButton.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(command.textContent);
      copyButton.textContent = 'Copied';
      window.setTimeout(() => { copyButton.textContent = 'Copy'; }, 1800);
    } catch {
      copyButton.textContent = 'Select text';
    }
  });
}
