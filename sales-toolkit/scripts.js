/**
 * CatWeightLoss Sales Toolkit
 * Interactive animations and behaviors
 */

document.addEventListener('DOMContentLoaded', () => {
    initScrollAnimations();
    initCounterAnimations();
    initFlowDiagram();
    initNavHighlight();
    initSmoothScroll();
    initInteractiveElements();
});

/**
 * Scroll-triggered fade-in animations
 */
function initScrollAnimations() {
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const fadeInObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                fadeInObserver.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Observe all animatable elements
    const animatables = document.querySelectorAll(`
        .value-card,
        .problem-card,
        .feature-card,
        .step-card,
        .kpi-card,
        .dashboard-card,
        .revenue-card,
        .traction-metric,
        .team-member,
        .flow-node,
        .journey-step,
        .slide
    `);

    animatables.forEach((el, index) => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
        fadeInObserver.observe(el);
    });

    // Add visible class styles
    const style = document.createElement('style');
    style.textContent = `
        .visible {
            opacity: 1 !important;
            transform: translateY(0) !important;
        }
    `;
    document.head.appendChild(style);
}

/**
 * Animated counters for statistics
 */
function initCounterAnimations() {
    const counters = document.querySelectorAll('.kpi-value, .traction-value, .metric-value');

    const counterObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter(entry.target);
                counterObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    counters.forEach(counter => counterObserver.observe(counter));
}

function animateCounter(element) {
    const text = element.textContent;
    const hasPrefix = text.startsWith('$');
    const hasSuffix = text.endsWith('%') || text.endsWith('K') || text.endsWith('M') || text.endsWith('x');

    let prefix = '';
    let suffix = '';
    let numStr = text;

    if (hasPrefix) {
        prefix = '$';
        numStr = numStr.substring(1);
    }

    if (hasSuffix) {
        suffix = numStr.slice(-1);
        numStr = numStr.slice(0, -1);
    }

    // Handle numbers with commas
    numStr = numStr.replace(/,/g, '');
    const target = parseFloat(numStr);

    if (isNaN(target)) return;

    const duration = 1500;
    const steps = 60;
    const increment = target / steps;
    let current = 0;

    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            current = target;
            clearInterval(timer);
        }

        let displayValue = current;
        if (target >= 1000) {
            displayValue = Math.round(current).toLocaleString();
        } else if (target < 10) {
            displayValue = current.toFixed(1);
        } else {
            displayValue = Math.round(current);
        }

        element.textContent = prefix + displayValue + suffix;
    }, duration / steps);
}

/**
 * Interactive money flow diagram
 */
function initFlowDiagram() {
    const flowNodes = document.querySelectorAll('.flow-node');
    const flowConnectors = document.querySelectorAll('.flow-connector');

    flowNodes.forEach((node, index) => {
        node.addEventListener('mouseenter', () => {
            // Highlight this node
            node.classList.add('active');

            // Animate connected paths
            if (flowConnectors[index]) {
                flowConnectors[index].classList.add('active');
            }
        });

        node.addEventListener('mouseleave', () => {
            node.classList.remove('active');
            flowConnectors.forEach(c => c.classList.remove('active'));
        });
    });

    // Add flow animation styles
    const style = document.createElement('style');
    style.textContent = `
        .flow-node.active {
            transform: scale(1.05);
            box-shadow: 0 0 30px rgba(212, 175, 55, 0.4);
        }

        .flow-connector.active path {
            stroke-dashoffset: 0 !important;
        }
    `;
    document.head.appendChild(style);
}

/**
 * Active nav link highlighting
 */
function initNavHighlight() {
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.nav-links a');

    if (sections.length === 0) return;

    window.addEventListener('scroll', () => {
        let current = '';

        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            if (scrollY >= sectionTop - 200) {
                current = section.getAttribute('id');
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('current');
            if (link.getAttribute('href').includes(current)) {
                link.classList.add('current');
            }
        });
    });
}

/**
 * Smooth scroll for anchor links
 */
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

/**
 * Interactive element behaviors
 */
function initInteractiveElements() {
    // Period buttons on dashboard
    const periodBtns = document.querySelectorAll('.period-btn');
    periodBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            periodBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            // Could trigger data refresh animation here
            animateChartRefresh();
        });
    });

    // Retailer selection on app mockup
    const retailers = document.querySelectorAll('.mock-retailer');
    retailers.forEach(retailer => {
        retailer.addEventListener('click', () => {
            retailers.forEach(r => r.classList.remove('chewy'));
            retailer.classList.add('chewy');
        });
    });

    // Button hover effects
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(btn => {
        btn.addEventListener('mouseenter', () => {
            btn.style.transform = 'translateY(-2px)';
        });
        btn.addEventListener('mouseleave', () => {
            btn.style.transform = 'translateY(0)';
        });
    });

    // Phone mockup tilt effect
    const phones = document.querySelectorAll('.phone-frame');
    phones.forEach(phone => {
        phone.addEventListener('mousemove', (e) => {
            const rect = phone.getBoundingClientRect();
            const x = (e.clientX - rect.left) / rect.width - 0.5;
            const y = (e.clientY - rect.top) / rect.height - 0.5;

            phone.style.transform = `perspective(1000px) rotateY(${x * 10}deg) rotateX(${-y * 10}deg)`;
        });

        phone.addEventListener('mouseleave', () => {
            phone.style.transform = 'perspective(1000px) rotateY(0) rotateX(0)';
        });
    });
}

/**
 * Chart refresh animation
 */
function animateChartRefresh() {
    const chart = document.querySelector('.engagement-chart');
    if (!chart) return;

    chart.style.opacity = '0.5';
    setTimeout(() => {
        chart.style.opacity = '1';
    }, 300);
}

/**
 * Typewriter effect for hero text
 */
function typeWriter(element, text, speed = 50) {
    let i = 0;
    element.textContent = '';

    function type() {
        if (i < text.length) {
            element.textContent += text.charAt(i);
            i++;
            setTimeout(type, speed);
        }
    }

    type();
}

/**
 * Parallax effect for floating elements
 */
function initParallax() {
    const floatingCards = document.querySelectorAll('.floating-card');

    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;

        floatingCards.forEach((card, index) => {
            const speed = 0.1 * (index + 1);
            card.style.transform = `translateY(${scrolled * speed}px)`;
        });
    });
}

/**
 * Intersection observer for lazy loading
 */
function lazyLoadImages() {
    const images = document.querySelectorAll('img[data-src]');

    const imageObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                imageObserver.unobserve(img);
            }
        });
    });

    images.forEach(img => imageObserver.observe(img));
}

/**
 * Toast notification system
 */
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    toast.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        padding: 16px 24px;
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        color: var(--text);
        font-size: 0.875rem;
        box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        z-index: 1000;
        animation: slideIn 0.3s ease;
    `;

    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

/**
 * Export functions for external use
 */
window.CWLToolkit = {
    showToast,
    typeWriter,
    animateCounter
};

// Add animation keyframes
const animationStyles = document.createElement('style');
animationStyles.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }

    @keyframes pulse {
        0%, 100% {
            opacity: 1;
        }
        50% {
            opacity: 0.5;
        }
    }

    @keyframes float {
        0%, 100% {
            transform: translateY(0);
        }
        50% {
            transform: translateY(-10px);
        }
    }
`;
document.head.appendChild(animationStyles);
