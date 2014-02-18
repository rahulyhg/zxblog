zxblog
======

the wordpress blog theme for a colleague

intro
------

`zxblog` is a `wordpress` front-end theme with `thermal-api` plugin installed.

Since it's really difficult to write `wordpress` theme, I decide to write a one-page html with `backbone`.

That's it.


Installation
------

### Apache

in `site-available/default`, add following config to `vhost`

```apache
Options Indexes FollowSymLinks MultiViews
AllowOverride All
```

### wordpress

#### Enable `permanent URL`

#### install `thermal-api` plugin

#### Add the following `.htaccess` files under the wordpress directory

```apache
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress
```
