# Setting up Next Cloud

## Setup container
```bash
# Create Incus custom volumes for app data
incus storage volume create zfs-incus nextcloud-data
incus storage volume create zfs-incus nextcloud-db     # MySQL data
# Launch base image
incus launch images:debian/13 nextcloud --storage zfs-incus
# Set a IP address for each service 
incus config device override nextcloud eth0
incus config device set nextcloud eth0 ipv4.address 10.10.10.100
# Add a Proxy Device (port forward)
incus config device add nextcloud 8080-proxy proxy \
    listen=tcp:0.0.0.0:8080 \
    connect=tcp:127.0.0.1:8080
# Elevate container for read permission
incus config set nextcloud security.privileged true
# Make container start automatically
incus config set nextcloud boot.autostart=true
```

### Attach incus volumes to the Nextcloud container
```bash
# Incus-managed volumes (snapshottable with Incus)
incus config device add nextcloud nextcloud-data disk \
    pool=zfs-incus \
    source=nextcloud-data \
    path=/var/www/nextcloud/data
incus config device add nextcloud nextcloud-db disk \
    pool=zfs-incus \
    source=nextcloud-db \
    path=/var/lib/mysql
# Shared media (external ZFS bind)
incus config device add nextcloud media disk \
    source=/tank/media \
    path=/mnt/media
```

## Install Nextcloud in container (LAMP stack)
[Manual Nextcloud installation instructions](https://docs.nextcloud.com/server/stable/admin_manual/)
[Random Blog tutorial](https://www.howto-do.it/nextcloud-installation/)

### PHP

#### Install PHP Modules

```bash
# install php & apache
apt install php apache2
# install php modules
apt install php-xml php-zip php-mbstring php-gd php-curl 
# install php database connector
apt install php-mysql
# (optional modules)
apt install php-intl php-imagick php-ssh2 # php-ffmpeg
```
[List of required php modules](https://docs.nextcloud.com/server/stable/admin_manual/installation/php_configuration.html)
Run `php -m | grep -i <module_name>` to check if module installed.

#### Configure PHP ini Settings
Changes these values in `/etc/php/8.4/apache2/php.ini` (ignore `/etc/php/8.4/cli/php.ini`)
```bash
upload_max_filesize = 16G
post_max_size = 16G
max_input_time = 36 # or 3600 
# max_execution_time: See Uploading big files > 512MB
# memory_limit: Should be at least 512MB. See also Uploading big files > 512MB
# opcache.enable and related settings: See Memory caching and Server tuning
# open_basedir: See Hardening and security guidance
# upload_tmp_dir: See Uploading big files > 512MB

# --LLM suggestions --
# memory_limit = 512M
# upload_max_filesize = 4G
# post_max_size = 4G
# max_execution_time = 360
# max_input_time = 360
# opcache.enable = 1
# opcache.memory_consumption = 128
# opcache.interned_strings_buffer = 8
# opcache.max_accelerated_files = 10000
```


#### ???
Test php by writing dummy website.

### My-SQL
```bash
apt install mariadb-server mariadb-client
sudo mysql # sudo mysql -u root -p
```
```sql
CREATE USER 'nc-user'@'localhost' IDENTIFIED BY '********';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nc-user'@'localhost';
FLUSH PRIVILEGES;
```

### Apache

Set `Listen 8080` in `/etc/apache2/ports.conf`.

Next, add new file `/etc/apache2/sites-available/nextcloud.conf` 
```
<VirtualHost *:8080>
  DocumentRoot /var/www/nextcloud/
  ServerName  cloud.cchill.com

  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/nextcloud_error.log
  CustomLog ${APACHE_LOG_DIR}/nextcloud_access.log combined
</VirtualHost>
```
Enable all the bits
```bash
# Enable new website
a2dissite 000-default.conf
a2ensite nextcloud.conf
a2enmod rewrite headers env dir mime
# Restart the service:
systemctl restart apache2
```

### Install Nextcloud
```bash
wget https://download.nextcloud.com/server/releases/latest.tar.bz2
tar -xjf latest.tar.bz2
sudo mv nextcloud/* /var/www/nextcloud/
sudo chown -R www-data:www-data /var/www/nextcloud
sudo chmod 750 /var/www/nextcloud
```
Set up by using the wizard:
```
Admin acount name: root
password: ******** (strong)
datafolder: /var/www/nextcloud/data
database user: nc-user
password: ********
database name: nextcloud
database host: localhost
```

### Cron jobs
```bash
apt install cron
# Add a new job
crontab -u www-data -e
# Append this line
"""
*/5  *  *  *  * php -f /var/www/nextcloud/cron.php
"""
# check new job
crontab -u www-data -l
```

### PHP-FPM
