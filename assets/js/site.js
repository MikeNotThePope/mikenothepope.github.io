// Reset mobile menu when resizing to desktop
(function() {
  let resizeTimer;
  window.addEventListener('resize', function() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(function() {
      // If screen is desktop size (md breakpoint is 768px in Tailwind)
      if (window.innerWidth >= 768) {
        const menuToggle = document.getElementById('menu-toggle');
        if (menuToggle) {
          menuToggle.checked = false;
        }
      }
    }, 250);
  });
})();
