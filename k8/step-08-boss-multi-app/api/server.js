const http = require('http');
const port = process.env.PORT || 3000;
const items = [{ id: 1, name: 'Widget' }, { id: 2, name: 'Gadget' }];
const server = http.createServer((req, res) => {
  if ((req.url || '/') === '/items' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify(items));
  }
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('API: GET /items\n');
});
server.listen(port, () => console.log(`API listening on ${port}`));
