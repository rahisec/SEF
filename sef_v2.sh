#!/bin/bash

bold="\e[1m"
Underlined="\e[4m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
end="\e[0m"
VERSION="SEF_V2"

# Banner
function banner() {
    echo ""
    echo ""
    echo -e "${bold}      ░██████╗███████╗███████╗  ${end}"
    echo -e "${bold}      ██╔════╝██╔════╝██╔════╝  ${end}"
    echo -e "${bold}      ╚█████╗░█████╗░░█████╗░░  ${end}"
    echo -e "${bold}      ░╚═══██╗██╔══╝░░██╔══╝░░  ${end}"
    echo -e "${bold}      ██████╔╝███████╗██║░░░░░  ${end}"
    echo -e "${bold}      ╚═════╝░╚══════╝╚═╝░░░░░  ${end}"
    echo -e "${end}"
    echo -e "${bold}  @remonsec @KathanP19 @litt1eb0y ${end}"
    echo -e "${bold}  Subdomain Enumeration Framework ${end}"
    echo ""

}
banner

# Variables
list_resolver=resolvers.txt
list_wordlist=wordlists.txt
list_permutation=permute.txt
amass_config=~/.config/amass/config.ini
subfinder_config=~/.config/subfinder/provider-config.yaml

#mode Variables
soft=$passive
medium="$passive + $active"
hard="$passive + $active + $Permutation"

#time
function format_time() {
    ((h=${1}/3600))
    ((m=(${1}%3600)/60))
    ((s=${1}%60))
printf "%02d:%02d:%02d\n" $h $m $s
}

# Passive enumeration
function Passive() {
    echo "[+] Running Passive Enumeration"
    subfinder -all -silent -d $domain -o subfinder.txt -pc $subfinder_config &>/dev/null
    assetfinder --subs-only $domain | sort -u > assetfinder.txt &>/dev/null
    amass enum -passive -norecursive -noalts -d $domain -config $amass_config -o amass.txt &>/dev/null
    findomain --quiet -t $domain -u findomain.txt &>/dev/null
    waybackurls $domain | unfurl domains | sort -u > wayback.txt &>/dev/null
    gau --subs $domain | unfurl domains | sort -u > gau.txt &>/dev/null
    crobat -s $domain -u > tee crobat.txt &>/dev/null
    cero $domain > cero.txt &>/dev/null
    cat subfinder.txt assetfinder.txt amass.txt findomain.txt wayback.txt gau.txt crobat.txt cero.txt | grep -F ".$domain" | sort -u > passive.txt
    rm subfinder.txt assetfinder.txt amass.txt findomain.txt wayback.txt gau.txt crobat.txt cero.txt
}

#Active Enumeration
function Active() {
  echo "[+] Running Active Enumeration"
  puredns bruteforce $list_wordlist $domain -w active_tmp.txt -r $list_resolver &>/dev/null
  cat active_tmp.txt | grep -F ".$domain" | sed "s/*.//" > active.txt
  rm active_tmp.txt
}

#Active+passive
function ActPsv() {
  echo "[+] Collecting Active and Passive Enum results.."
  cat active.txt passive.txt | grep -F ".$domain" | sort -u | puredns resolve -w active_passive.txt -r $resolvers &>/dev/null
}

#Permutation Enumeration
function Permutation() {
  echo "[+] Running Permutation Enumeration"
  if [[ $(cat active_passive.txt | wc -l) -le 100 ]]; then
  cat active_passive.txt | dmut -d $list_permutation -w 100 --dns-timeout 300 --dns-retries 5 --dns-errorLimit 25 | puredns resolve -w permute_tmp.txt -r $resolvers &>/dev/null
  cat permute_tmp.txt | grep -F ".$domain" > permute.txt
  rm permute_tmp.txt
  else
        echo "[-] No Permutation"
 fi

}

#Sorting
function Final() {
  echo "[+] Collecting and Sorting SubDomains"
  cat active.txt passive.txt permute.txt 2>/dev/null | grep -F ".$domain" | sort -u > subs.txt
}

#output
function Output() {
  mkdir -p $dir
  mv active.txt passive.txt permute.txt subs.txt alive.txt $dir 2>/dev/null
}

#httpx
function Httpx() {
  echo "[+] Running httpx"
  httpx -l subs.txt -silent -timeout 30 -o alive.txt &>/dev/null
  httpx -l subs.txt -silent -csp-probe -timeout 30 | grep -F ".$domain" | anew alive.txt &>/dev/null
  httpx -l subs.txt -silent -tls-probe -timeout 30 | grep -F ".$domain" | anew alive.txt &>/dev/null
}

#results
function sefresult() {
    echo ""
    echo "[#] Total Subdomain Found $(cat subs.txt | wc -l)"
    echo "[#] Total HTTP Probed Found $(cat alive.txt | wc -l)"
    echo "[#] Script completed in total $(format_time $SECONDS)"
}

while getopts ":hd:w:r:o:-:" optchar; do
        case "${optchar}" in
                -)
                        case "${OPTARG}" in
                                d)
                                        domain_list="${!OPTIND}"; OPTIND=$(( $OPTIND + 1))
				       for site in $(cat $domain_list);do
						domain=$site
						dir=$site
						echo -e "\n Scanning $domain Right Now"
						Passive
						SubFinal
						Htpx
						sefresult
						Output
						echo -e "\n Scanning $domain done";done
                                        ;;
                                dLa)
                                        domain_list="${!OPTIND}"; OPTIND=$(( $OPTIND + 1))
				       for site in $(cat $domain_list);do
						domain=$site
						dir=$site
						echo -e "\n Scanning $domain Right Now"
						Passive
						Active
						ActPsv
						Permute
						SubFinal
						Htpx
						sefresult
						Output
						echo -e "\n Scanning $domain done";done
                                        ;;
				ac)
                                        amass_config="${!OPTIND}"; OPTIND=$(( $OPTIND + 1))
                                        ;;
                                sc)
                                        subfinder_config="${!OPTIND}"; OPTIND=$(( $OPTIND +1 ))
                                        ;;
				soft)
                                        Passive;
					SubFinal;
					Httpx;
					sefresult;
                                        ;;
                                medium)
                                        Passive;
                                        Active;
                                        ActPsv;
                                        SubFinal;
                                        Httpx;
                                        sefresult;
                                        ;;
				hard)
                                        Passive;
					Active;
					ActPsv;
					Permute;
					SubFinal;
					Htpx;
					sefresult;
                                        ;;
                                *)
                                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                                        echo "Unknown option --${OPTARG}" >&2
                                        fi
                                        ;;
                        esac;;
                h)
                        echo "Usage: 						"
			echo "       $0 -d       To Specify Domain."
			echo "       $0 -w       To Specify wordlist to use else (Default)."
			echo "       $0 -r       To Specify resolver to use else (Default)."
                        echo "       $0 -p       To Specify permutations to use else (Default)."
			echo "       $0 -o       To Store all the result in specific folder."
			echo "       $0 --d     To quick passive scan Domain-list."
			echo "       $0 --dL     To full scan Domain-list."
                        echo "       $0 --ac     To Specify Amass-config file."
                        echo "       $0 --low   Performs Passive Enumeration"
                        echo "       $0 --medium Performs Passive + Active Enumeration"
                        echo "       $0 --hard  Performs Passive + Active + Permutation Enumeration"
			echo "	"
                        exit 2
                        ;;

                d)	domain=$OPTARG
                        ;;
                w)	list_wordlist=$OPTARG
                        ;;
                r)	list_resolver=$OPTARG
                        ;;
                p)
                        list_permutation=$OPTARG
                        ;;
                o)	dir=$OPTARG
			Output
                        ;;
                *)
                        if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                        echo "Non-option argument: '-${OPTARG}'";
                        fi
                        ;;
        esac
done
