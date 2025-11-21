// Konfigurasi GitHub Repository
const GITHUB_USERNAME = 'sijek1995';
const GITHUB_REPO = 'trafic-light-controll3r';
const STATUS_FILE = 'light-status.json';

async function fetchLightStatus() {
    try {
        // Fetch data dari GitHub
        const response = await fetch(`https://raw.githubusercontent.com/${GITHUB_USERNAME}/${GITHUB_REPO}/main/${STATUS_FILE}?t=${Date.now()}`);
        
        if (!response.ok) {
            throw new Error('Gagal mengambil data');
        }
        
        const status = await response.json();
        
        updateLights(status);
        updateStatusText(status);
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('statusText').textContent = 'Error loading status';
    }
}

function updateLights(status) {
    const redLight = document.getElementById('redLight');
    const yellowLight = document.getElementById('yellowLight');
    const greenLight = document.getElementById('greenLight');
    
    redLight.classList.toggle('active', status.red);
    yellowLight.classList.toggle('active', status.yellow);
    greenLight.classList.toggle('active', status.green);
}

function updateStatusText(status) {
    const lightsOn = [];
    if (status.red) lightsOn.push('MERAH');
    if (status.yellow) lightsOn.push('KUNING');
    if (status.green) lightsOn.push('HIJAU');
    
    const statusText = lightsOn.length > 0 ? lightsOn.join(', ') + ' NYALA' : 'SEMUA MATI';
    document.getElementById('statusText').textContent = statusText;
    document.getElementById('lastUpdate').textContent = new Date().toLocaleTimeString();
}

// Auto-update setiap 3 detik
setInterval(fetchLightStatus, 3000);

// Load initial status saat page pertama kali buka
fetchLightStatus();