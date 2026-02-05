# FROM node:lts-alpine AS BUILD
# WORKDIR /app

# # 1. Copy and install dependencies first for layer caching
# COPY package*.json ./
# RUN npm install --silent

# # 2. Copy all application source code
# COPY . .

# # 3. Build the Angular application for production
# # This uses the correct ng build command structure to create the 'dist' folder.
# RUN npm run build -- --configuration=production --base-href=/

# # --- Stage 2: Production Stage (Uses a tiny Nginx image to serve static files) ---
# # --- Stage 2: Production Stage ---
# FROM nginx:alpine

# # 1. Copy the custom Nginx configuration file
# # Make sure your custom file is named 'nginx.conf' and is in the project root
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# # 2. Copy the built Angular files (Use the correct path you found earlier)
# COPY --from=BUILD /app/dist/vendoroct/browser /usr/share/nginx/html 

# # Nginx runs on port 80 by default
# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]



# Stage 1: Build the Angular application
FROM node:lts-alpine AS BUILD
WORKDIR /app

# Copy and install dependencies first for layer caching
COPY package*.json ./
RUN npm install --silent

# Copy all application source code
COPY . .

# Build the Angular application for production
RUN npm run build -- --configuration=production --base-href=/

# Stage 2: Production Stage (Uses Nginx to serve static files)
FROM nginx:alpine

# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built Angular files from the build stage
# Note: Ensure the path matches your angular.json 'outputPath'
COPY --from=BUILD /app/dist/vendoroct /usr/share/nginx/html 

# Cloud Run sets the PORT environment variable. Nginx typically uses 80.
# We will use a script or environment substitution if needed, 
# but often simply listening on 80 and mapping in Cloud Run works.
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
