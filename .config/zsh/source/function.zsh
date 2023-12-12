function doc-ansi() {
    text=(
        '字符' '名称' '默认值' '介绍'
        'A' '光标上移' '1' '将光标向上移动 $1'
        'B' '光标下移' '1' '将光标向下移动 $1'
        'C' '光标右移' '1' '将光标向右移动 $1'
        'D' '光标左移' '1' '将光标向左移动 $1'
        'E' 'null' '1' 'null'
        'F' '光标下行' '1' '将光标下移至 $1 行的起始'
        'G' '光标上行' '1' '将光标上移至 $1 行的起始'
        'H' '光标位置' '1, 1' '将光标移至第 $1 行第 $2 列，从左上角开始计数'
        'J' '显示清空' '0' '清空部分屏幕. 0, 1, 2, 3 各有不同的功能'
        'K' 'null' 'null' 'null'
        'S' 'null' 'null' 'null'
        'T' 'null' 'null' 'null'
        's' 'null' 'null' 'null'
        'u' 'null' 'null' 'null'
        'f' 'null' 'null' 'null'
        'm' 'null' 'null' 'null'
    )
    print -a -c -C 4 $text
}

function it-is-mine() {
    local user="$(whoami)"
    local group=":$(whoami)"
    local directoryPermissions="755"
    local filePermissions="644"
    local opt=""

    while {getopts u:g:d:f:vh arg} {
        case $arg {
            (u)
                user="$OPTARG"
            ;;
            (g)
                group=":$OPTARG"
            ;;
            (d)
                directoryPermissions="$OPTARG"
            ;;
            (f)
                filePermissions="$OPTARG"
            ;;
            (v)
                opt="-v"
            ;;
            (h)
                print -u 2 -X 2 \
"\e[6m用法: it-is-mine [选项...] [文件...]
遍历并根据参数分别设置目录或文件的权限

\t-h\t获取帮助信息
\t-v\t输出详细信息
\t-u\t设置所有者;默认为当前用户
\t-g\t设置所有组;默认为当前用户组
\t-d\t设置目录权限;默认为755
\t-f\t设置文件权限;默认为644\e[0m"
                return
            ;;
            (?)
                return 1
            ;;
        }
    }

    local function loopDirectory() {
        for f (${(f)"$(print -l ${1}/*)"}) { l $f }
    }

    local function l() {
        f=${1:A}
        chown $opt "${user}${group}" $f
        if [[ -d $f ]] {
            chmod $opt $directoryPermissions $f
            loopDirectory $f
        } elif [[ -f $f ]] {
            chmod $opt $filePermissions $f
        }
    }

    for f ($*[$OPTIND,-1]) {
        l $f
    }

    unfunction loopDirectory
    unfunction l
}
