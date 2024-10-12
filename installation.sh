#!/bin/bash

LOG_FILE="${HOME}/installation.log"

# Function to log actions and failures
log() {
    echo "$1" | tee -a $LOG_FILE
}

fail() {
    echo "Failed at: $1" | tee -a $LOG_FILE
    exit 1
}

log "Starting post-installation script..."

# Add Microsoft repository for .NET
log "Setting up Microsoft package repository for .NET 8..."
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb || fail "Downloading Microsoft repository"
sudo dpkg -i packages-microsoft-prod.deb || fail "Adding Microsoft repository"
sudo apt update
sudo apt install -y dotnet-sdk-8.0 || fail ".NET 8 SDK"
rm -f packages-microsoft-prod.deb

# Install nvm for Node.js version management
log "Installing nvm (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash || fail "Installing nvm"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || fail "Loading nvm"

# Install Node.js using nvm
log "Installing Node.js using nvm..."
nvm install 18 || fail "Node.js via nvm"
nvm use 18 || fail "Switching to Node.js 18"
nvm alias default 18 || fail "Setting default Node.js version"

# Install Docker using official repository
log "Setting up Docker repository..."
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || fail "Docker GPG key"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || fail "Docker"

# Install Visual Studio Code via Microsoft repository
log "Setting up repository for Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg || fail "Downloading Microsoft GPG key"
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ || fail "Adding Microsoft GPG key"
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code || fail "Visual Studio Code"
rm -f packages.microsoft.gpg

# Install VLC via package manager
log "Installing VLC..."
sudo apt install -y vlc || fail "VLC"

# Install DBeaver via package manager
log "Installing DBeaver..."
sudo apt install -y dbeaver || fail "DBeaver"

# Install WireGuard via package manager
log "Installing WireGuard..."
sudo apt install -y wireguard || fail "WireGuard"

# Install Keepass via package manager
log "Installing Keepass..."
sudo apt install -y keepass2 || fail "Keepass"

# Install Discord via package manager
log "Installing Discord..."
sudo apt install -y discord || fail "Discord"

# Install Telegram via package manager
log "Installing Telegram..."
sudo apt install -y telegram-desktop || fail "Telegram"

# Install Viber via package manager
log "Installing Viber..."
wget -O /tmp/viber.deb https://download.cdn.viber.com/desktop/Linux/viber.deb || fail "Downloading Viber"
sudo dpkg -i /tmp/viber.deb || fail "Installing Viber"
sudo apt install -f || fail "Resolving dependencies for Viber"

# Install Brave browser via official repository
log "Setting up Brave browser repository..."
sudo apt install -y apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg || fail "Brave GPG key"
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser || fail "Brave browser"

# Install Firefox via package manager
log "Installing Firefox..."
sudo apt install -y firefox || fail "Firefox"

# Install LibreWolf via repository
log "Setting up LibreWolf repository..."
echo "deb https://deb.librewolf.net/ buster main" | sudo tee /etc/apt/sources.list.d/librewolf.list
wget -qO - https://deb.librewolf.net/librewolf.asc | sudo gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/librewolf.gpg > /dev/null
sudo apt update
sudo apt install -y librewolf || fail "LibreWolf"

# Install qBittorrent via package manager
log "Installing qBittorrent..."
sudo apt install -y qbittorrent || fail "qBittorrent"

# Install FileZilla via package manager
log "Installing FileZilla..."
sudo apt install -y filezilla || fail "FileZilla"

# Install JetBrains Toolbox
log "Installing JetBrains Toolbox..."
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.4.15002.tar.gz -O /tmp/jetbrains-toolbox.tar.gz || fail "Downloading JetBrains Toolbox"
tar -zxvf /tmp/jetbrains-toolbox.tar.gz -C /tmp || fail "Extracting JetBrains Toolbox"
sudo mv /tmp/jetbrains-toolbox-1.27.4.15002 /opt/jetbrains-toolbox || fail "Moving JetBrains Toolbox"
sudo ln -s /opt/jetbrains-toolbox/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox || fail "Symlinking JetBrains Toolbox"

# Install MongoDB Compass via .deb package
log "Installing MongoDB Compass..."
wget https://downloads.mongodb.com/compass/mongodb-compass_1.32.6_amd64.deb -O /tmp/mongodb-compass.deb || fail "Downloading MongoDB Compass"
sudo dpkg -i /tmp/mongodb-compass.deb || fail "Installing MongoDB Compass"
sudo apt install -f || fail "Resolving dependencies for MongoDB Compass"

# Install RedisInsight via .deb package
log "Installing Redis Insight..."
wget https://download.redisinsight.redis.com/latest/redisinsight-linux.deb -O /tmp/redisinsight-linux.deb || fail "Downloading RedisInsight"
sudo dpkg -i /tmp/redisinsight-linux.deb || fail "Installing RedisInsight"
sudo apt install -f || fail "Resolving dependencies for RedisInsight"  # If dependencies are missing

# Install Ollama via .deb package
log "Installing Ollama..."
wget https://ollama.com/download/ollama.deb -O /tmp/ollama.deb || fail "Downloading Ollama"
sudo dpkg -i /tmp/ollama.deb || fail "Installing Ollama"
sudo apt install -f || fail "Resolving dependencies for Ollama"

# Install Syncthing via official repository
log "Setting up repository for Syncthing..."
curl -s https://syncthing.net/release-key.txt | sudo apt-key add - || fail "Adding Syncthing GPG key"
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt update
sudo apt install -y syncthing || fail "Syncthing"

# Install Wireshark via package manager
log "Installing Wireshark..."
sudo apt install -y wireshark || fail "Wireshark"

# Install Zenmap via package manager
log "Installing Zenmap..."
sudo apt install -y zenmap || fail "Zenmap"

# Install kubectl via official repository
log "Setting up repository for kubectl..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - || fail "Adding kubectl GPG key"
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl || fail "kubectl"

# Install Digital Ocean CLI via official repository
log "Setting up repository for Digital Ocean CLI..."
sudo snap install doctl || fail "Digital Ocean CLI"

# Install LocalSend via Snap
log "Installing LocalSend..."
sudo snap install localsend || fail "LocalSend"

# Install Joplin via Snap
log "Installing Joplin..."
sudo snap install joplin-desktop || fail "Joplin"

# Install Insomnia via Snap
log "Installing Insomnia..."
sudo snap install insomnia || fail "Insomnia"

# Install Postman via Snap
log "Installing Postman..."
sudo snap install postman || fail "Postman"

# Install Spotify via Snap
log "Installing Spotify..."
sudo snap install spotify || fail "Spotify"

log "Post-installation script completed successfully."
