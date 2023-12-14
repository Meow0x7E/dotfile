local this="${0:A:h}"

local BUFFER_PATH="${HOME}/.cache/hitokoto.txt"

local function get_hitokoto_text() {
    curl --fail --silent 'https://v1.hitokoto.cn/?c=a&c=b&c=c&c=d&c=e&c=f&c=g&c=h&c=i&c=j&c=k&c=l&encode=text&charset=utf-8&min_length=0&max_length=128'
}

local function writer_hitokoto_buffer() {
    local f=${BUFFER_PATH:h}
    [ -d $f ] || mkdir -p $f
    get_hitokoto_text > $BUFFER_PATH &
}

local function get_hitokoto() {
    if [[ -r $BUFFER_PATH && -w $BUFFER_PATH ]] {
        print "$(<$BUFFER_PATH)"
    } else {
        get_hitokoto_text
    }
    writer_hitokoto_buffer
}

local hitokoto=$(get_hitokoto)

#${this}/slow_scan_print --speed 2 --text "$(print -n "$(<${this}/title.txt)")"
fastfetch --load-config "${this}/fastfetch.jsonc" --pipe 0
${this}/slow_scan_print --speed 1 --text "$(print $hitokoto | lolcat --force-color)"
