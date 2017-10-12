server {
	listen 80;
	listen [::]:80;

	# root /home/nat/www/webshop; 

	# Add index.php to the list if you are using PHP
	# index index.html index.htm index.nginx-debian.html;

	server_name draw.ironbeard.com;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		proxy_pass http://localhost:8010;
		#try_files $uri $uri/ =404;
		# autoindex on;
	}

	location /socket {
		proxy_pass http://localhost:8010;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";	 	 
        }

	location ~* ^.+\.(css|cur|gif|gz|ico|jpg|jpeg|js|png|svg|woff|woff2)$ {
		root /home/draw/src/draw/priv/static;
		etag off;
		expires max;
		add_header Cache-Control public;
	}	 
}
