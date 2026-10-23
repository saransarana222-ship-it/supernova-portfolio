/**
 * SuperNova Portfolio Engine - Saran A
 * Dynamic interactions, live quote estimator, and client inquiry handling
 */

document.addEventListener('DOMContentLoaded', () => {
  // Mobile Navigation Toggle
  const mobileMenuBtn = document.getElementById('mobileMenuBtn');
  const mobileMenu = document.getElementById('mobileMenu');

  if (mobileMenuBtn && mobileMenu) {
    mobileMenuBtn.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });

    document.querySelectorAll('.mobile-nav-link').forEach(link => {
      link.addEventListener('click', () => {
        mobileMenu.classList.add('hidden');
      });
    });
  }

  // Interactive Live Project Cost Estimator
  const projectTypeSelect = document.getElementById('projectType');
  const pageCountRange = document.getElementById('pageCount');
  const pageCountVal = document.getElementById('pageCountVal');
  const speedToggle = document.getElementById('speedToggle');
  const seoToggle = document.getElementById('seoToggle');
  const estimatedPriceEl = document.getElementById('estimatedPrice');
  const estimatedPriceInrEl = document.getElementById('estimatedPriceInr');

  function calculateEstimate() {
    if (!projectTypeSelect || !pageCountRange) return;

    let baseRate = 120; // Default base USD
    const type = projectTypeSelect.value;
    const pages = parseInt(pageCountRange.value, 10);

    if (type === 'landing') {
      baseRate = 149;
    } else if (type === 'fullstack') {
      baseRate = 399;
    } else if (type === 'mobile') {
      baseRate = 499;
    } else if (type === 'audit') {
      baseRate = 99;
    }

    let total = baseRate;
    if (type !== 'landing' && type !== 'audit') {
      total += (pages - 1) * 60;
    }

    if (seoToggle && seoToggle.checked) {
      total += 75;
    }

    if (speedToggle && speedToggle.checked) {
      total = Math.round(total * 1.25); // 25% expedited fee
    }

    const usdPrice = total;
    const inrPrice = Math.round(usdPrice * 85);

    if (estimatedPriceEl) estimatedPriceEl.textContent = `$${usdPrice.toLocaleString()}`;
    if (estimatedPriceInrEl) estimatedPriceInrEl.textContent = `₹${inrPrice.toLocaleString()}`;
    if (pageCountVal) pageCountVal.textContent = pages;
  }

  if (pageCountRange) {
    pageCountRange.addEventListener('input', calculateEstimate);
  }
  if (projectTypeSelect) {
    projectTypeSelect.addEventListener('change', calculateEstimate);
  }
  if (speedToggle) {
    speedToggle.addEventListener('change', calculateEstimate);
  }
  if (seoToggle) {
    seoToggle.addEventListener('change', calculateEstimate);
  }

  // Initial Calculation
  calculateEstimate();

  // Portfolio Category Filtering
  const filterButtons = document.querySelectorAll('.filter-btn');
  const projectCards = document.querySelectorAll('.project-card');

  filterButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      filterButtons.forEach(b => {
        b.classList.remove('bg-indigo-600', 'text-white');
        b.classList.add('bg-slate-800/60', 'text-slate-300');
      });
      btn.classList.remove('bg-slate-800/60', 'text-slate-300');
      btn.classList.add('bg-indigo-600', 'text-white');

      const filter = btn.getAttribute('data-filter');

      projectCards.forEach(card => {
        const category = card.getAttribute('data-category');
        if (filter === 'all' || category === filter) {
          card.style.display = 'block';
        } else {
          card.style.display = 'none';
        }
      });
    });
  });

  // Contact Form Submission (Client Inquiries)
  const contactForm = document.getElementById('contactForm');
  const formSuccess = document.getElementById('formSuccess');

  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const submitBtn = contactForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.textContent;
      
      submitBtn.disabled = true;
      submitBtn.textContent = 'Transmitting to Saran A...';

      setTimeout(() => {
        contactForm.reset();
        submitBtn.disabled = false;
        submitBtn.textContent = originalText;
        if (formSuccess) {
          formSuccess.classList.remove('hidden');
          setTimeout(() => {
            formSuccess.classList.add('hidden');
          }, 6000);
        }
      }, 900);
    });
  }

  // Quick Book from Estimator
  const bookEstimateBtn = document.getElementById('bookEstimateBtn');
  if (bookEstimateBtn && contactForm) {
    bookEstimateBtn.addEventListener('click', () => {
      const type = projectTypeSelect ? projectTypeSelect.value : 'landing';
      const price = estimatedPriceEl ? estimatedPriceEl.textContent : '$149';
      const messageField = document.getElementById('clientMessage');
      
      if (messageField) {
        messageField.value = `Hi Saran! I want to start a ${type.toUpperCase()} project estimated around ${price}. Let's discuss details!`;
      }
      
      const contactSection = document.getElementById('contact');
      if (contactSection) {
        contactSection.scrollIntoView({ behavior: 'smooth' });
      }
    });
  }
});
