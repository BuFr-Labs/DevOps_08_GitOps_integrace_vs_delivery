# Pouzijeme oficialni stabilni nginx z Docker Hubu jako zaklad
FROM nginx:alpine

# Zkopirujeme nas index.html do adresare, odkud nginx standardne serviruje web
COPY index.html /usr/share/nginx/html/

# Exponujeme port 80 do site
EXPOSE 80