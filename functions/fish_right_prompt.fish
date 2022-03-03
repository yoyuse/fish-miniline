function fish_right_prompt
    set -l __arrow '' # \uE0B2
    set -l __arrow2 '│' # \uE0B3
    set -l __fg black

    set -l branch (git symbolic-ref HEAD 2>/dev/null | cut -d/ -f3)
    set -l git_stat (git status --porcelain 2>/dev/null | string collect)
    set -l untracked (echo "$git_stat" | grep "??")
    set -l index_stat (echo "$git_stat" | grep -v "?" | cut -d" " -f1)
    set -l wtree_stat (echo "$git_stat" | grep -v "?" | cut -d" " -f2)

    set -l upstream_stat (git status -sb 2>/dev/null | head -1)
    set -l ahead (string match -r '\[ahead (\d+)' $upstream_stat | tail -1)
    set -l behind (string match -r 'behind (\d+)\]' $upstream_stat | tail -1)

    set -l _git ""
    set -l flag ""
    set -l __color
    if test -n "$branch"
        set __color blue
        test -n "$index_stat" && set __color green && set flag $flag'~' # i
        test -n "$wtree_stat" && set __color red && set flag $flag'*' # w
        test -n "$untracked" && set __color magenta && set flag $flag'?' # u

        test -n "$ahead" && set flag $flag'↑'$ahead
        test -n "$behind" && set flag $flag'↓'$behind

        set _git " "$branch" "(set_color normal)
        test $flag && set _git (set_color $__fg)" "$flag" "$__arrow2$_git
        set _git (set_color $__color)$__arrow(set_color $__fg)(set_color -b $__color)$_git
    end
    echo -n $_git
end
