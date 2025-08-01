#!/bin/bash

clear
echo "==============================================="
echo "         PANEL INSTALLER BY PRO GAMER"
echo "==============================================="

main_menu() {
    echo ""
    echo "[1] Pterodactyl"
    echo "[2] Jexactyl"
    echo "[3] Exit"
    echo ""
    read -p "Enter your choice: " main_choice

    case $main_choice in
        1) pterodactyl_menu ;;
        2) jexactyl_menu ;;
        3) exit 0 ;;
        *) echo "Invalid choice."; main_menu ;;
    esac
}

pterodactyl_menu() {
    echo ""
    echo "=== PTERODACTYL INSTALL OPTIONS ==="
    echo "[1] Panel Install"
    echo "[2] Wings Install"
    echo "[3] Blueprint Install"
    echo "[4] Back"
    read -p "Choose an option: " ptero_choice

    case $ptero_choice in
        1) install_pterodactyl_panel ;;
        2) install_wings ;;
        3) install_blueprint ;;
        4) main_menu ;;
        *) echo "Invalid choice."; pterodactyl_menu ;;
    esac
}

jexactyl_menu() {
    echo ""
    echo "=== JEXACTYL INSTALL OPTIONS ==="
    echo "[1] Panel Install"
    echo "[2] Wings Install"
    echo "[3] Back"
    read -p "Choose an option: " jex_choice

    case $jex_choice in
        1) install_jexactyl_panel ;;
        2) install_wings ;;
        3) main_menu ;;
        *) echo "Invalid choice."; jexactyl_menu ;;
    esac
}

install_pterodactyl_panel() {
    echo "Updating system..."
    apt update && apt upgrade -y
    apt install -y nginx mariadb-server php php-cli php-mysql php-mbstring php-xml php-bcmath unzip curl tar git redis php-redis

    echo ""
    read -p "Enter your domain (leave blank to use VPS IP): " domain
    if [ -z "$domain" ]; then
        domain=$(curl -s https://ipinfo.io/ip)
        echo "Using IP: $domain"
    fi

    echo ""
    read -p "Enter database name: " dbname
    read -p "Enter database username: " dbuser
    read -p "Enter database password: " dbpass

    mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE ${dbname};
CREATE USER '${dbuser}'@'127.0.0.1' IDENTIFIED BY '${dbpass}';
GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'127.0.0.1';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

    cd /var/www/
    curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
    mkdir -p pterodactyl && tar -xzvf panel.tar.gz -C pterodactyl
    cd pterodactyl
    cp .env.example .env
    curl -sL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs yarn
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    composer install --no-dev --optimize-autoloader

    php artisan key:generate --force
    php artisan p:environment:setup
    php artisan p:environment:database
    php artisan migrate --seed --force
    php artisan p:user:make

    yarn install
    yarn build:production

    chown -R www-data:www-data /var/www/pterodactyl/*
    systemctl restart nginx

    echo ""
    echo "✅ Pterodactyl Panel installed at: http://$domain"
    pterodactyl_menu
}

install_wings() {
    echo ""
    read -p "Enter Node token from panel: " token

    curl -sSL https://get.docker.com/ | sh
    systemctl enable --now docker

    curl -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
    chmod +x /usr/local/bin/wings
    mkdir -p /etc/pterodactyl
    echo "$token" > /etc/pterodactyl/config.yml

    systemctl enable --now wings

    echo "✅ Wings installed and configured"
    main_menu
}

install_blueprint() {
    echo ""
    cd /var/www/pterodactyl
    mkdir -p extensions
    curl -L https://github.com/pterodactyl/blueprint/releases/latest/download/blueprint.phar -o blueprint.phar
    chmod +x blueprint.phar
    ./blueprint.phar install
    php artisan optimize:clear
    yarn build:production
    chown -R www-data:www-data /var/www/pterodactyl/*
    systemctl restart nginx

    echo "✅ Blueprint installed"
    main_menu
}

install_jexactyl_panel() {
    echo "Updating system..."
    apt update && apt upgrade -y
    apt install -y nginx mariadb-server php php-cli php-mysql php-mbstring php-xml php-bcmath unzip curl tar git redis php-redis

    echo ""
    read -p "Enter your domain (leave blank to use VPS IP): " domain
    if [ -z "$domain" ]; then
        domain=$(curl -s https://ipinfo.io/ip)
        echo "Using IP: $domain"
    fi

    echo ""
    read -p "Enter database name: " dbname
    read -p "Enter database username: " dbuser
    read -p "Enter database password: " dbpass

    mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE ${dbname};
CREATE USER '${dbuser}'@'127.0.0.1' IDENTIFIED BY '${dbpass}';
GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'127.0.0.1';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

    cd /var/www/
    git clone https://github.com/jexactyl/jexactyl.git
    cd jexactyl
    cp .env.example .env

    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    composer install --no-dev --optimize-autoloader

    curl -sL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs yarn
    yarn install
    yarn build

    php artisan key:generate --force
    php artisan migrate --seed --force
    php artisan p:user:make

    chown -R www-data:www-data /var/www/jexactyl
    systemctl restart nginx

    echo ""
    echo "✅ Jexactyl Panel installed at: http://$domain"
    jexactyl_menu
}

# Start the installer
main_menu
