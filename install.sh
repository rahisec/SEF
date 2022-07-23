#!/bin/bash

#banner
cat <<"EOF"

  _____           _        _ _       _
 |_   _|         | |      | | |     | |
   | |  _ __  ___| |_ __ _| | |  ___| |__
   | | | '_ \/ __| __/ _` | | | / __| '_ \
  _| |_| | | \__ \ || (_| | | |_\__ \ | | |
 |_____|_| |_|___/\__\__,_|_|_(_)___/_| |_|

      @remonsec @KathanP19 @0xlittleboy
     ```````````````````````````````````

EOF

#Install Golang
Golang() {
	printf "                                \r"
	sys=$(uname -m)
	LATEST=$(curl -s 'https://go.dev/VERSION?m=text')
	[ $sys == "x86_64" ] && wget https://golang.org/dl/$LATEST.linux-amd64.tar.gz -O golang.tar.gz &>/dev/null || wget https://golang.org/dl/$LATEST.linux-386.tar.gz -O golang.tar.gz &>/dev/null
	sudo tar -C /usr/local -xzf golang.tar.gz
	echo "export GOROOT=/usr/local/go" >> $HOME/.bashrc
	echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
	echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc
  echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile

	printf "[+] Golang Installed !.\n"
}

#Install Tools
Subfinder() {
  printf "              \r"
  GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest &>/dev/null
  printf "[+] Subfinder Installed! \n"
}

Assetfinder() {
            printf "                                \r"
            go install -v github.com/tomnomnom/assetfinder@latest &>/dev/null
            printf "[+] Assetfinder Installed! \n"
}

Findomain() {
            wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux &>/dev/null
            chmod +x findomain-linux
            ./findomain-linux -h &>/dev/null &&
            sudo mv findomain-linux /usr/local/bin/findomain;
            printf "[+] Findomain Installed! \n"
}

Amass() {
            printf "                                \r"
	          GO111MODULE=on go install -v github.com/OWASP/Amass/v3/...@latest &>/dev/null
	          printf "[+] Amass Installed! \n"
}

Gauplus() {
            printf "                                \r"
            go install github.com/bp0lr/gauplus@latest &>/dev/null
            printf "[+] Gauplus Installed! \n"
}

Waybackurls() {
            printf "                \r"
            go install github.com/tomnomnom/waybackurls@latest &>/dev/null
            printf "[+] Waybackurls Installed! \n"
}

Crobat() {
            printf "                  \r"
            go install github.com/cgboal/sonarsearch/cmd/crobat@latest &>/dev/null
            printf "[+] Crobat Installed! \n"
}

Cero() {
            printf "                              \r"
            go install -v github.com/glebarez/cero@latest &>/dev/null
            printf "[+] Cero Installed! \n"
}

PureDns() {
            printf "                \r"
            go install github.com/d3mondev/puredns/v2@latest &>/dev/null
            printf "[+] PureDns Installed! \n"
}

Anew() {
            printf "                \r"
            go install -v github.com/tomnomnom/anew@latest &>/dev/null
            printf "[+] Anew Installed! \n"
}

Dmut() {
            printf "                \r"
            go install -v github.com/bp0lr/dmut@latest &>/dev/null
}

Httpx() {
            printf "                  \r"
            go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest &>/dev/null
            printf " Httpx Installed! \n"
}


#Downloading Worlists
Wordlist() {
          printf "                  \r"
          wget "https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/subdomains/subdomains.txt" &>/dev/null
          printf "[+] Wordlist Installed! \n"
}
Resolver() {
          printf "                  \r"
          wget "https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt" &>/dev/null
          printf "[+] Resolver Installed! \n"
}


#Checking Golang
hash go 2>/dev/null && printf "[!] Golang is already installed.\n" || { printf "[+] Installing Golang!" && Golang; }
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
sudo cp ~/go/bin/* /usr/local/bin

#Checking Tools
hash subfinder 2>/dev/null && printf "[!] Subfinder is already installed.\n" || { printf "[+] Installing subfinder!" && Subfinder; }
hash assetfinder 2>/dev/null && printf "[!] Assetfinder is already installed.\n" || { printf "[+] Installing Assetfinder!" && Assetfinder; }
hash findomain 2>/dev/null && printf "[!] Findomain is already installed.\n" || { printf "[+] Installing Findomain!" && Findomain; }
hash amass 2>/dev/null && printf "[!] Amass is already installed.\n" || { printf "[+] Installing Amass!" && Amass; }
hash gauplus 2>/dev/null && printf "[!] Gauplus is already installed.\n" || { printf "[+] Installing Gauplus!" && Gauplus; }
hash waybackurls 2>/dev/null && printf "[!] Waybackurls is already installed.\n" || { printf "[+] Installing Waybackurls!" && Waybackurls; }
hash crobat 2>/dev/null && printf "[!] Crobat is already installed.\n" || { printf "[+] Installing Crobat!" && Crobat; }
hash cero 2>/dev/null && printf "[!] Cero is already installed.\n" || { printf "[+] Installing Cero!" && Cero; }
hash puredns 2>/dev/null && printf "[!] PureDns is already installed.\n" || { printf "[+] Installing PureDns!" && PureDns; }
hash anew 2>/dev/null && printf "[!] Anew is already installed.\n" || { printf "[+] Installing Anew!" && Anew; }
hash dmut 2>/dev/null && printf "[!] Dmut is already installed.\n" || { printf "[+] Installing Dmut!" && Dmut; }
hash httpx 2>/dev/null && printf "[!] Httpx is already installed.\n" || { printf "[+] Installing Httpx!" && Httpx; }
find subdomains.txt &>/dev/null && printf "[!] Wordlist is already Installed.\n" || { printf "[+] Installing Wordlist!" && Wordlist; }
find resolvers.txt &>/dev/null && printf "[!] Resolver is already Installed.\n" || { printf "[+] Installing Resolver!" && Resolver; }

list=(
  Golang
  Subfinder
  Assetfinder
  Findomain
  Amass
  Gauplus
  Waybackurls
  Crobat
  Cero
  PureDns
  Anew
  Dmut
  Httpx
  Wordlist
  Resolver
)
  r="\e[31m"
  g="\e[32m"
  e="\e[0m"

  for prg in ${list[@]}
  do
        hash $prg 2>/dev/null && printf "[$prg]$g OK$e\n" || printf "[$prg]$r Not Installed!$e\n"
      done
