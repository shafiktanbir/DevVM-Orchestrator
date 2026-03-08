const http = require('http');
const fs = require('fs');
const path = require('path');
const port = process.env.PORT || 3000;
const dataDir = process.env.DATA_DIR || '/data';
const counterPath = path.join(dataDir, 'counter.txt');

function readCounter() {
  try {
    return parseInt(fs.readFileSync(counterPath, 'utf8'), 10) || 0;
  } catch {
    return 0;
  }
}
function writeCounter(n) {
  fs.writeFileSync(counterPath, String(n), 'utf8');
}

const server = http.createServer((req, res) => {
  const count = readCounter();
  writeCounter(count + 1);
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`Visit count: ${count + 1} (stored in volume)\n`);
});
server.listen(port, () => console.log(`Listening on ${port}, data: ${dataDir}`));
