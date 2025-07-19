// Page Transition and Animation Handler
class PageAnimations {
    constructor() {
        this.init();
    }

    init() {
        this.setupLoadingScreen();
        this.setupHoverEffects();
        this.setupFormAnimations();
        this.setupButtonAnimations();
    }

    setupLoadingScreen() {
        const loadingScreen = document.getElementById('loadingScreen');
        if (loadingScreen) {
            window.addEventListener('load', () => {
                setTimeout(() => {
                    loadingScreen.style.opacity = '0';
                    loadingScreen.style.transition = 'opacity 0.5s ease-in-out';
                    setTimeout(() => {
                        loadingScreen.style.display = 'none';
                    }, 500);
                }, 1000);
            });
        }
    }

    setupHoverEffects() {
        // Portfolio page specific animations
        const skillTexts = document.querySelectorAll('.skill-text');
        skillTexts.forEach(skill => {
            skill.addEventListener('mouseenter', () => {
                skill.style.transform = 'scale(1.05)';
                skill.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.1)';
            });
            
            skill.addEventListener('mouseleave', () => {
                skill.style.transform = 'scale(1)';
                skill.style.boxShadow = 'none';
            });
        });

        // Settings page specific animations
        const formControls = document.querySelectorAll('.form-control');
        formControls.forEach(control => {
            control.addEventListener('focus', () => {
                control.style.transform = 'scale(1.02)';
                control.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)';
            });
            
            control.addEventListener('blur', () => {
                control.style.transform = 'scale(1)';
                control.style.boxShadow = '';
            });
        });
    }

    setupFormAnimations() {
        const editButtons = document.querySelectorAll('.edit-icon-btn');
        editButtons.forEach(btn => {
            btn.addEventListener('mouseenter', () => {
                btn.style.transform = 'scale(1.1) rotate(5deg)';
                btn.style.boxShadow = '0 4px 15px rgba(124, 58, 237, 0.3)';
            });
            
            btn.addEventListener('mouseleave', () => {
                btn.style.transform = 'scale(1) rotate(0deg)';
                btn.style.boxShadow = '';
            });
        });
    }

    setupButtonAnimations() {
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(btn => {
            btn.addEventListener('mouseenter', () => {
                btn.style.transform = 'translateY(-2px)';
                btn.style.boxShadow = '0 5px 15px rgba(0, 0, 0, 0.2)';
            });
            
            btn.addEventListener('mouseleave', () => {
                btn.style.transform = 'translateY(0)';
                btn.style.boxShadow = '';
            });

            // Add ripple effect
            btn.addEventListener('click', (e) => {
                const ripple = document.createElement('span');
                const rect = btn.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.classList.add('ripple');
                
                btn.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
    }

    // Add staggered animation to elements
    animateStaggered(elements, delay = 100) {
        elements.forEach((element, index) => {
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * delay);
        });
    }

    // Add entrance animation
    addEntranceAnimation(element, animationType = 'fadeInUp') {
        const animations = {
            fadeInUp: {
                from: { opacity: 0, transform: 'translateY(30px)' },
                to: { opacity: 1, transform: 'translateY(0)' }
            },
            slideInFromRight: {
                from: { opacity: 0, transform: 'translateX(100px)' },
                to: { opacity: 1, transform: 'translateX(0)' }
            },
            slideInFromLeft: {
                from: { opacity: 0, transform: 'translateX(-100px)' },
                to: { opacity: 1, transform: 'translateX(0)' }
            },
            scaleIn: {
                from: { opacity: 0, transform: 'scale(0.9)' },
                to: { opacity: 1, transform: 'scale(1)' }
            }
        };

        const animation = animations[animationType];
        if (animation) {
            Object.assign(element.style, animation.from);
            element.style.transition = 'all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
            
            requestAnimationFrame(() => {
                Object.assign(element.style, animation.to);
            });
        }
    }
}

// Initialize animations when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new PageAnimations();
});

// Add CSS for ripple effect
const style = document.createElement('style');
style.textContent = `
    .btn {
        position: relative;
        overflow: hidden;
    }
    
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        transform: scale(0);
        animation: ripple-animation 0.6s linear;
        pointer-events: none;
    }
    
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style); 