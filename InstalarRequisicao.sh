#!/bin/bash

# Obter o nome do usuário logado
USER=$(whoami)

# Verificar se o Firefox está instalado
if ! command -v firefox &> /dev/null
then
    echo "Firefox não está instalado. Instalando..."
    # Comando para instalar o Firefox
    sudo apt update
    sudo apt install -y firefox
else
    echo "Firefox já está instalado."
fi

# Verificar se o onboard está instalado
if ! command -v onboard &> /dev/null
then
    echo "Onboard não está instalado. Instalando..."
    # Comando para instalar o onboard
    sudo apt update
    sudo apt install -y onboard
else
    echo "Onboard já está instalado."
fi

# Verificar se o wmctrl está instalado
if ! command -v wmctrl &> /dev/null
then
    echo "wmctrl não está instalado. Instalando..."
    # Comando para instalar o wmctrl
    sudo apt update
    sudo apt install -y wmctrl
else
    echo "wmctrl já está instalado."
fi

# Criar um script para abrir o site com teclado touchscreen
sudo bash -c 'cat << EOF > /usr/local/bin/open_stock_site_with_keyboard.sh
#!/bin/bash

# Abrir o site no Firefox
firefox --new-window "http://stock.margramar.com.br:8090/stockmgm/login" &

# Esperar alguns segundos para o Firefox abrir
sleep 5

# Abrir o teclado touchscreen
onboard &

# Esperar alguns segundos para o onboard abrir
sleep 5

# Mover o teclado para a parte superior da tela
wmctrl -r "Onboard" -e 0,0,0,-1,-1
EOF'

# Tornar o script executável
sudo chmod +x /usr/local/bin/open_stock_site_with_keyboard.sh

# Verificar se o diretório Desktop do usuário logado existe
DESKTOP_DIR="/home/$USER/Desktop"
if [ ! -d "$DESKTOP_DIR" ]; then
    echo "Criando diretório Desktop para o usuário $USER..."
    mkdir -p "$DESKTOP_DIR"
fi

# Criar um atalho na área de trabalho do usuário logado para o script
cat << EOF > "$DESKTOP_DIR/Abrir-Requisicao.desktop"
[Desktop Entry]
Version=1.0
Name=Abrir-Requisicao
Comment=Abrir o site http://stock.margramar.com.br:8090/stockmgm/login com teclado touchscreen
Exec=/usr/local/bin/open_stock_site_with_keyboard.sh
Icon=firefox
Terminal=false
Type=Application
EOF

# Tornar o atalho executável
chmod +x "$DESKTOP_DIR/Abrir-Requisicao.desktop"

# Configurar o gerenciador de arquivos para confiar no atalho
gio set "$DESKTOP_DIR/Abrir-Requisicao.desktop" metadata::trusted true
sudo chown $USER:$USER "$DESKTOP_DIR/Abrir-Requisicao.desktop"

echo "Script criado em /usr/local/bin/open_stock_site_with_keyboard.sh."
echo "Atalho criado na área de trabalho do usuário '$USER' como 'Abrir-Requisicao'."
