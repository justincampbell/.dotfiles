google() { open "https://www.google.com/search?q=$@" ;}

# Fuzzy finders
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
branch() {
  git checkout ${1:-$(
  git for-each-ref \
    --sort=-committerdate \
    --format='%(refname:short)' \
    refs/heads/ \
    | fzf
  )}
}
code() {
  cd ~/Code/${1:-$(
  find ~/Code -type d -maxdepth 2 | \
    grep ".*/.*$" | \
    cut -f 5-6 -d "/" | \
    fzf
  )}
}
cookbook() { cd ~/Code/cookbooks/${1:-$(ls -at ~/Code/cookbooks | pick)} ;}
codego() {
  cd $GOPATH/src/${1:-$(
  find $GOPATH/src -type d -maxdepth 3 | \
    grep "src/.*/.*/.*$" | \
    cut -f 7-9 -d "/" | \
    fzf
  )}
}

# Directory jumping
cdcode() { cd ~/Code ;}
cdgo() { cd $GOPATH ;}
cddotfiles() { cd ~/.dotfiles ;}
cdnotes() { cd ~/Notes ;}
cdroot() { cd `git rev-parse --git-dir`/.. ;}

# Show screen size
xy() {
  echo "$(tput cols)x$(tput lines)"
}

# Heroku
production() {
  echo $ heroku $@ --remote production
  heroku $@ --remote production
}

staging() {
  echo $ heroku $@ --remote staging
  heroku $@ --remote staging
}

acceptance() {
  echo $ heroku $@ --remote acceptance
  heroku $@ --remote acceptance
}

pr() {
  pr=$1
  if [[ $pr =~ ^[0-9]+$ ]]; then
    shift
  else
    pr=$(hub pr list --format="%I" --limit=1)
    echo -n "Using latest PR "
    hub pr list | grep \#$pr
  fi
  app=$(git remote -v | grep ^staging | grep "(push)" | cut -f 4 -d "/" | cut -f 1 -d ".")-pr-$pr
  echo $ heroku $@ --app $app
  heroku $@ --app $app
}

promote() { staging pipelines:promote ;}

publicip() {
  curl https://api.ipify.org
}

charles() {
  export ALL_PROXY=http://localhost:8888
  export FTP_PROXY=$ALL_PROXY
  export HTTPS_PROXY=$ALL_PROXY
  export HTTP_PROXY=$ALL_PROXY
  export RSYNC_PROXY=$ALL_PROXY
  export ftp_proxy=$ALL_PROXY
  export http_proxy=$ALL_PROXY
  export https_proxy=$ALL_PROXY
  export rsync_proxy=$ALL_PROXY

  export SSL_CERT_FILE=~/.charles/charles-ssl-proxying-certificate.pem
}

fix_camera() {
  sudo killall VDCAssistant
}

# Go Modules
mod() {
  value="${1}"

  if [ -z "$value" ]; then
    case "${GO111MODULE}" in
      "on")
        value="off"
        ;;
      "off")
        value="auto"
        ;;
      *)
        value="on"
        ;;
    esac
  fi

  export GO111MODULE="$value"
  env | grep GO111MODULE
}

gym() {
  slack_status :deadlift: 60 "Gym"
}

lunch() {
  slack_status :burritoda: 60 "Lunch"
}

reading() {
  slack_dnd 25
  slack_status :book: 25 "Reading"
}

writing() {
  slack_dnd 25
  slack_status :writing_hand: 25 "Writing"
}

dnd() {
  slack_dnd 25
  slack_status :pomodoro: 25 "Pomodoro"
}

back() {
  slack_dnd
  slack_status "" 0 ""
}

slack_dnd() {
  minutes="$1"

  if [ -n "$minutes" ]; then
    slack_get dnd.setSnooze "num_minutes=$minutes"
  else
    slack_post dnd.endSnooze
  fi
}

slack_status() {
  if [ -n "$1" ]; then
    emoji="$1"
    minutes="$2"
    text="$3"
    seconds="$(expr 60 \* $minutes)"
  else
    emoji=""
    minutes="0"
    text=""
    seconds="0"
  fi

  expiration="$(expr $(date +%s) + $seconds)"

  payload="{\"profile\":{\"status_text\":\"$text\",\"status_emoji\":\"$emoji\",\"status_expiration\":$expiration}}"

  slack_post users.profile.set "$payload"
}

slack_get() {
  method="$1"
  params="$2"

  curl \
    --header "Authorization: Bearer $SLACK_TOKEN" \
    --silent \
    "https://slack.com/api/$method?$params" \
    > /dev/null
}

slack_post() {
  method="$1"
  payload="$2"

  curl \
    --header "Authorization: Bearer $SLACK_TOKEN" \
    --header "Content-Type: application/json; charset=utf-8" \
    --data "$payload" \
    --silent \
    "https://slack.com/api/$method" \
    > /dev/null
}

gogo() {
  url=http://airborne.gogoinflight.com/abp/ws/absServices/statusTray
  response=$(curl $url)
  flightInfo=$(echo $response | jq .Response.flightInfo)
  echo $flightInfo | jq '"\(.departureAirportCodeIata) ✈️ \(.destinationAirportCodeIata)"'
  echo $flightInfo | jq '"\(.altitude) ft"'
  echo $flightInfo | jq '"\(.hspeed) knots"'
  echo $flightInfo | jq '"Now:     \(.utcTime)"'
  echo $flightInfo | jq '"Arrival: \(.expectedArrival)"'
}

tfe() {
  method=$(echo "$1" | tr a-z A-Z)
  path=$2
  shift 2

  host=${TFE_ADDRESS:-"https://app.terraform.io"}
  url="${host}${path}"

  (set -x; curl \
    --header "Authorization: Bearer $TFE_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request "$method" \
    --silent \
    "$url" "${@}")
}


# Returns nonzero if there's no internet connection
online() {
  scutil -r 8.8.8.8 | grep "^Reachable" > /dev/null
}

# Returns nonzero if I'm not at home.
at_home() {
  networksetup -getairportnetwork en0 | grep Campbell > /dev/null
}

hue_brightness() {
  hour=$(date +"%H")
  if [ "$hour" -ge 7 -a "$hour" -le 19 ]; then
    echo "254"
  else
    echo "192"
  fi
}

hue_temperature() {
  hour=$(date +"%H")
  if [ "$hour" -ge 7 -a "$hour" -le 19 ]; then
    echo "4500k"
  else
    echo "2700k"
  fi
}

meeting() {
  slack_dnd 25
  slack_status :zoom: 25 Meeting
  hueadm group "Justin’s Office" reset > /dev/null
  hueadm group "Justin’s Office" "$(hue_temperature)" bri=$(hue_brightness) > /dev/null
}
