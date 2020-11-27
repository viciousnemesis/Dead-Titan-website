server { 

	root /srv/www/deadtitan.com/html; 
	index index.html index.htm index.nginx-debian.html; 

	server_name deadtitan.com www.deadtitan.com; 

	location / {
		try_files $uri $uri/ =404;
	}

	listen [::]:443 ssl; #ipv6only=on; # managed by Certbot
	listen 443 ssl; # managed by Certbot
	ssl_certificate /etc/letsencrypt/live/deadtitan.com/fullchain.pem; # managed by Certbot
	ssl_certificate_key /etc/letsencrypt/live/deadtitan.com/privkey.pem; # managed by Certbot
	include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
	ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot




}
server {

	listen 80; 
	listen [::]:80; 

	server_name deadtitan.com www.deadtitan.com;

	if ($host = www.deadtitan.com) {
		return 301 https://$host$request_uri;
	} # managed by Certbot


	if ($host = deadtitan.com) {
		return 301 https://$host$request_uri;
	} # managed by Certbot

	return 404; # managed by Certbot

}
