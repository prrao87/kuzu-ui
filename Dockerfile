FROM node:20-bookworm-slim

ARG SKIP_GRAMMAR=false
ARG SKIP_BUILD_APP=false

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "SKIP_GRAMMAR: $SKIP_GRAMMAR"
RUN echo "SKIP_BUILD_APP: $SKIP_BUILD_APP"

# Install dependencies
RUN if [ "$SKIP_GRAMMAR" != "true" ] ; then apt update && apt-get install -y openjdk-17-jdk ; else echo "Skipping openjdk installation as grammar generation is skipped" ; fi

# Copy app
COPY . /home/node/app
RUN chown -R node:node /home/node/app

# Make data and database directories
RUN mkdir -p /database
RUN mkdir -p /data
RUN chown -R node:node /database
RUN chown -R node:node /data

# Switch to node user
USER node

# Set working directory
WORKDIR /home/node/app

# Install dependencies
RUN npm install

# Generate grammar
RUN if [ "$SKIP_GRAMMAR" != "true" ] ; then npm run generate-grammar-prod ; else echo "Skipping grammar generation" ; fi

# Build app
RUN if [ "$SKIP_BUILD_APP" != "true" ] ; then npm run build ; else echo "Skipping build" ; fi

# Expose port
EXPOSE 8000

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8000
ENV KUZU_PATH=/database

# Run app
ENTRYPOINT ["node", "src/server/index.js"]
