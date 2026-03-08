const http = require('http');
const port = process.env.PORT || 3000;
const greeting = process.env.GREETING || 'Hello from Kubernetes';
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(greeting + '\n');
});
server.listen(port, () => console.log(`Listening on ${port}, greeting: ${greeting}`));
