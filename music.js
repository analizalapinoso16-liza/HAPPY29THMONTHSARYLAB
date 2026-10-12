const pages = document.querySelectorAll('.page');
const music = document.getElementById('bgMusic');
const musicBtn = document.getElementById('musicBtn');
const heartButton = document.getElementById('heartButton');
const heartEffects = document.getElementById('heartEffects');

if (music && musicBtn) {
    music.addEventListener('play', () => {
        musicBtn.textContent = '❚❚';
        musicBtn.setAttribute('aria-label', 'Pause music');
    });
    music.addEventListener('pause', () => {
        musicBtn.textContent = '♫';
        musicBtn.setAttribute('aria-label', 'Play music');
    });
    music.addEventListener('error', () => {
        musicBtn.textContent = '♫';
        musicBtn.setAttribute('aria-label', 'Play music');
    });
}

function showPage(pageId) {
    pages.forEach((page) => {
        const isActive = page.id === pageId;
        page.classList.toggle('active', isActive);
    });
}

function startStory() {
    showPage('letter');
    if (music) {
        music.volume = 0.6;
        music.play().catch(() => {
            if (musicBtn) musicBtn.textContent = '♫';
        });
    }
}

function toggleMusic() {
    if (!music) return;

    music.volume = 0.6;

    if (music.paused) {
        music.play().catch(() => {
            if (musicBtn) musicBtn.setAttribute('aria-label', 'Play music');
        });
    } else {
        music.pause();
    }
}

function sendHeartBurst() {
    if (!heartButton || !heartEffects) return;

    const colors = ['#e85d75', '#f28da4', '#b777a3', '#d74661'];
    const particleCount = 14;

    const heartGlyph = heartButton.querySelector('span');
    heartGlyph.animate(
        [{ transform: 'scale(1)' }, { transform: 'scale(1.3)' }, { transform: 'scale(1)' }],
        { duration: 360, easing: 'ease-out' }
    );

    for (let index = 0; index < particleCount; index += 1) {
        const angle = (Math.PI * 2 * index) / particleCount - Math.PI / 2;
        const distance = 42 + Math.random() * 46;
        const particle = document.createElement('span');

        particle.className = 'heart-particle';
        particle.textContent = '♥';
        particle.style.setProperty('--heart-x', `${Math.cos(angle) * distance}px`);
        particle.style.setProperty('--heart-y', `${Math.sin(angle) * distance}px`);
        particle.style.color = colors[index % colors.length];
        particle.style.animationDelay = `${index * 12}ms`;
        particle.addEventListener('animationend', () => particle.remove(), { once: true });
        heartEffects.append(particle);
    }
}

if (heartButton) {
    heartButton.addEventListener('click', sendHeartBurst);
}

document.addEventListener('DOMContentLoaded', () => {
    showPage('home');
    if (musicBtn) {
        musicBtn.setAttribute('aria-label', 'Play music');
    }
});
