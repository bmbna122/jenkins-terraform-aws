# Step 1: Use an official Nginx image as the base
FROM nginx:alpine

# Step 2: Copy our custom HTML file into the Nginx default directory
COPY index.html /usr/share/nginx/html/index.html

# Step 3: Expose port 80 so we can access the web server
EXPOSE 80

# Step 4: Start Nginx (this is the default, but good to be explicit)
CMD ["nginx", "-g", "daemon off;"]