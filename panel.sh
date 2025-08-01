#!/bin/bash
# Eco PANEL INSTALLER BY PRO GAMER

while true; do
  clear
  echo "==============================="
  echo "🌐 ECO PANEL INSTALLER BY PRO GAMER"
  echo "==============================="
  echo "[1] Pterodactyl"
  echo "[2] Zexatyle"
  echo "[3] Exit"
  echo "==============================="
  read -p "Choose an option: " panel_choice

  if [[ $panel_choice == "1" ]]; then
    while true; do
      clear
      echo "=== PTERODACTYL INSTALLER ==="
      echo "[1] Install Panel"
      echo "[2] Install Wings"
      echo "[3] Install Blueprint"
      echo "[4] Back"
      echo "==============================="
      read -p "Select an option: " pt_option

      case $pt_option in
        1)
          echo "Installing Pterodactyl Panel..."
          apt update -y && apt upgrade -y
          apt install -y nginx mariadb-server php php-cli php-mysql php-gd php-mbstring php-xml php-bcmath php-curl unzip git curl tar
          curl -s https://raw.githubusercontent.com/pterodactyl/installer/main/install.sh | bash
          echo "✅ Panel installed!"
          read -p "Press enter to continue..."
          ;;
        2)
          echo "Installing Wings..."
          curl -s https://raw.githubusercontent.com/pterodactyl/wings/main/install.sh | bash
          echo "✅ Wings installed!"
          read -p "Enter your Wings token: " token
          echo "$token" > /etc/pterodactyl/token.txt
          echo "Token saved. Setup your node in the panel."
          read -p "Press enter to continue..."
          ;;
        3)
          echo "Installing Blueprint..."
          cd /var/www/pterodactyl
          curl -s https://raw.githubusercontent.com/BlueprintPanel/Blueprint/main/scripts/install.sh | bash
          echo "✅ Blueprint installed!"
          read -p "Press enter to continue..."
          ;;
        4)
          break
          ;;
        *)
          echo "❌ Invalid option"
          sleep 1
          ;;
      esac
    done

  elif [[ $panel_choice == "2" ]]; then
    while true; do
      clear
      echo "=== ZEXATYLE INSTALLER ==="
      echo "[1] Install Panel"
      echo "[2] Install Wings"
      echo "[3] Install Themes"
      echo "[4] Install Modules"
      echo "[5] Back"
      echo "==============================="
      read -p "Select an option: " zx_option

      case $zx_option in
        1)
          echo "Installing Zexatyle Panel..."
          apt update && apt upgrade -y
          apt install -y nginx mariadb-server php php-cli php-mysql php-gd php-mbstring php-xml php-bcmath php-curl unzip git curl tar
          curl -s https://raw.githubusercontent.com/ZexatyleDev/installer/main/install.sh | bash
          echo "✅ Zexatyle Panel installed!"
          read -p "Press enter to continue..."
          ;;
        2)
          echo "Installing Wings for Zexatyle..."
          curl -s https://raw.githubusercontent.com/ZexatyleDev/wings/main/install.sh | bash
          read -p "Enter your Wings token: " token
          echo "$token" > /etc/zexatyle/token.txt
          echo "Token saved. Setup your node in the panel."
          read -p "Press enter to continue..."
          ;;
        3)
          echo "Installing Zexatyle Themes..."
          cd /var/www/zexatyle
          git clone https://github.com/ZexatyleDev/themes themes
          bash themes/install.sh
          echo "✅ Themes installed!"
          read -p "Press enter to continue..."
          ;;
        4)
          echo "Installing Zexatyle Modules..."
          cd /var/www/zexatyle
          git clone https://github.com/ZexatyleDev/modules modules
          bash modules/install.sh
          echo "✅ Modules installed!"
          read -p "Press enter to continue..."
          ;;
        5)
          break
          ;;
        *)
          echo "❌ Invalid option"
          sleep 1
          ;;
      esac
    done

  elif [[ $panel_choice == "3" ]]; then
    echo "Exiting installer. Bye, PRO GAMER!"
    break
  else
    echo "❌ Invalid input"
    sleep 1
  fi
done
