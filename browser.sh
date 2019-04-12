#!/bin/bash

HEADER="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
CON_TIME="15"
TRANS_TIME="15"

get() {
    URL="$1"
    curl -s \
    --connect-timeout "$CON_TIME" \
    -m "$TRANS_TIME" \
    -H "'$HEADER'" \
    "$URL"
}

getFollowRedirect() {
    URL="$1"
    curl -s \
    --connect-timeout "$CON_TIME" \
    -m "$TRANS_TIME" \
    -H "$HEADER" \
    -L "$URL"
}

post() {
    URL="$1"
    PAYLOAD="$2"
    echo "$PAYLOAD"
    wget --quiet \
    --header "'$HEADER'" \
    --method POST \
    --body-data "$PAYLOAD" \
    --output-document \
    - "$URL"
}

saveCookies() {
    URL="$1"
    OUTPUT="$2"
    curl -s \
    --connect-timeout "$CON_TIME" \
    -m "$TRANS_TIME" \
    -H "'$HEADER'" \
    -c "$OUTPUT" "$URL"
}

urlencode() {
    string=$1; format=; set --
    while
    literal=${string%%[!-._~0-9A-Za-z]*}
    case "$literal" in
        ?*)
            format=$format%s
            set -- "$@" "$literal"
        string=${string#$literal};;
    esac
    case "$string" in
        "") false;;
    esac
    do
        tail=${string#?}
        head=${string%$tail}
        format=$format%%%02x
        set -- "$@" "'$head"
        string=$tail
    done
    printf "$format\\n" "$@"
}

urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}