# Lightweight nginx
FROM nginx:alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy static site
COPY site/site/ /usr/share/nginx/html/

# Expose HTTP port
EXPOSE 80

# Health check endpoint
RUN echo "OK" > /usr/share/nginx/html/health.txt

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
