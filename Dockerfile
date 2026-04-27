FROM nginx:alpine
# Copy the index.html file to the NGINX default public directory
COPY index.html /usr/share/nginx/html/index.html
# Expose port 80
EXPOSE 80
