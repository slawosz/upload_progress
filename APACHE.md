Apache config working with this thin start command: `thin -p 5000 -s 3 -R app.ru -r `pwd`/lib/upload_progress.rb -b Thin::Backends::UploadProgressBackend -e production start`

```apache
<VirtualHost *:80>
  ServerName sc.slawosz.com
  ServerAlias www.sc.slawosz.com

  DocumentRoot /home/slawosz/path/to/upload_progress

  RewriteEngine On

  <Proxy balancer://thin>
    BalancerMember http://127.0.0.1:5000
    BalancerMember http://127.0.0.1:5001
    BalancerMember http://127.0.0.1:5002
  </Proxy>

  # Redirect all non-static requests to thin
  RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
  RewriteRule ^/(.*)$ balancer://thin%{REQUEST_URI} [P,QSA,L]

  ProxyPass / balancer://thin/
  ProxyPassReverse / balancer://thin/
  ProxyPreserveHost on

  <Proxy *>
    Order deny,allow
    Allow from all
  </Proxy>

  # Custom log file locations
  ErrorLog  /var/log/apache/gerror.log
  CustomLog /var/log/apache/access.log combined

</VirtualHost>
```