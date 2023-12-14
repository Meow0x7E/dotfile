#!/usr/bin/zsh

local this="${0:A:h}"

local function copy_directory() {
    local source=${1:A}
    local target=${2:A}
    if [[ -d $target ]] {
        print "[33;1;5m[0m [33;1m警告: 目录 [30:1m${target}[33;1m 已存在[0m"
        while ((1)) {
            print "1.覆盖 2.删除目标后复制 3.跳过(默认)"
            case $(read -e) {
                (1)
                    cp -ruv $source ${target:h}
                ;;
                (2)
                    rm -frv $target
                    cp -rv $source $target
                ;;
                ('') ;;
                (3) ;;
                (*)
                    continue
                ;;
            }
            break
        }
        return
    }
    cp -rv $source $target
}

[[ -d $HOME/.config ]] || mkdir $HOME/.config

copy_directory $this/.config/zsh $HOME/.config/zsh && {
    [[ -f $HOME/.zshrc ]] || ln -v -s $HOME/.config/zsh/zshrc.zsh $HOME/.zshrc
}
