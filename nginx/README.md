# Nginx

### Running Nginx and config

The default nginx conf file is edited, `sendfile` is disabled to prevent caching and volume mount problems.

| NGINX                             | Command(s)                 | Info                                   |
|-----------------------------------|----------------------------|----------------------------------------|
| run your static website           | http://localhost:80        | depending on your environment add sudo |
| edit the nginx configuration file | nano /etc/nginx/nginx.conf |                                        |
| test the nginx configuration file | nginx -t                   |                                        |
| nginx restart                     | nginx -s reload            |                                        |
| nginx directory                   | cd /etc/nginx/html         |                                        |
| location of nginx (error) logs    | /var/log/nginx/error.log   |                                        |
| fuser -k 80/tcp                   | list process on port       |                                        |
| service nginx status -l           | list all                   |                                        |


>`ps auwx | grep nginx` list all nginx                                                                                                               
> a - list all processes with a terminal                                                                                   
> u - provides additional information columns                                                                              
> w - for when you have a screen wide enough to show all info                                                              
> x - a+x == list everything
> output is piped through grep which filters and displays any lines with nginx         
> 
> `lsof -i TCP:[portnumber] `                 which service is listening on port....                                                                               
> `cat /var/log/nginx/error.log | less`  open logs, stop with control Z                    
> `service nginx start`                       for linux                                                                                                            
> `service nginx reload`                     for linux                                                                                                            
> `service nginx restart`                     for linux                                                                                                            
> `netstat -tulpn` show ports
> `find /etc -name index.html`
---
