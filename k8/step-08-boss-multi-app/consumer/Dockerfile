FROM node:18-alpine
WORKDIR /app
COPY run.js .
ENV API_URL=http://api-svc:3000
ENV INTERVAL_MS=5000
CMD ["node", "run.js"]
