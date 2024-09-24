## Ubuntu
1. Install latest tsb-exter
2. install latest sigma.deb
3.  
    ```
    sudo apt install libjpeg-dev libcurl3-gnutls 
    sudo apt install libtiff5-dev  # missing tiffio.h
    ```
4. add `net.core.wmen=2097512` to `/etc/sysctl.conf`

## Jetpack
1. `sudo apt install ./tsb-extern.deb`
2. `sudo apt install mariadb-client mariadb-server`
2. `sudo apt install libmariadb3`
2. `sudo apt install ./sigma.deb`

### Mariadb hacking (get the forced version)
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=10.6
