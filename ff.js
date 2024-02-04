
// Získáváme všechny odkazy na detail receptu
const recipeDetailLinks = document.querySelectorAll('.recipe-detail-link');

// Přidáváme události pro každý odkaz
recipeDetailLinks.forEach(link => {
    link.addEventListener('click', function(event) {
        // Zabraňujeme výchozímu chování odkazu
        event.preventDefault();

        // Získáváme URL odkazu na detail receptu
        const detailURL = this.getAttribute('href');

        // Přecházíme na stránku s detaily receptu
        window.location.href = detailURL;
    });
});

