const http = require('http');
const port = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
  const url = req.url || '/';
  if (url === '/health') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    return res.end('ok');
  }
  if (url === '/ready') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    return res.end('ready');
  }
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello\n');
});
server.listen(port, () => console.log(`Listening on ${port}`));
