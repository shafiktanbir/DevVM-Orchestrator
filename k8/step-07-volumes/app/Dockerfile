FROM node:18-alpine
WORKDIR /app
COPY server.js .
ENV PORT=3000
ENV DATA_DIR=/data
EXPOSE 3000
CMD ["node", "server.js"]
