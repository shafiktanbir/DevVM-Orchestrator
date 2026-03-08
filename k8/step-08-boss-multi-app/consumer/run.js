const apiUrl = process.env.API_URL || 'http://api-svc:3000';
const intervalMs = parseInt(process.env.INTERVAL_MS || '5000', 10);

async function fetchItems() {
  try {
    const res = await fetch(apiUrl + '/items');
    const data = await res.json();
    console.log(new Date().toISOString(), 'Items:', JSON.stringify(data));
  } catch (err) {
    console.error(new Date().toISOString(), 'Error:', err.message);
  }
}

console.log('Consumer started, API_URL=', apiUrl, 'INTERVAL_MS=', intervalMs);
setInterval(fetchItems, intervalMs);
fetchItems();
