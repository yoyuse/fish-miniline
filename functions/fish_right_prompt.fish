function fish_right_prompt
    set -l fg black

    set -l branch (git symbolic-ref HEAD 2>/dev/null | cut -d/ -f3)
    set -l git_stat (git status --porcelain 2>/dev/null | string collect)
    set -l untracked (echo "$git_stat" | grep '??')
    set -l index_stat (echo "$git_stat" | grep -v '?' | cut -d' ' -f1)
    set -l wtree_stat (echo "$git_stat" | grep -v '?' | cut -d' ' -f2)
    set -l index_stat (string join '' $index_stat)
    set -l wtree_stat (string join '' $wtree_stat)
    set -l upstream_stat (git status -sb 2>/dev/null | head -1)
    set -l ahead (string match -r '\[ahead (\d+)' $upstream_stat | tail -1)
    set -l behind (string match -r 'behind (\d+)\]' $upstream_stat | tail -1)
    set -l stash_stat (git stash list 2>/dev/null)

    set -l git ''
    set -l flag ''
    set -l color
    if test -n "$branch"
        set color blue
        test -n "$stash_stat" && set flag $flag'$'
        test -n "$index_stat" && set color green && set flag $flag'~' # i
        test -n "$wtree_stat" && set color red && set flag $flag'*' # w
        test -n "$untracked" && set color magenta && set flag $flag'?' # u

        test -n "$ahead" && set flag $flag'↑'$ahead
        test -n "$behind" && set flag $flag'↓'$behind

        set git (__miniline_color_rev $color $fg)"$branch"
        if test -n "$flag"
            set git "$flag"(__miniline_color_rev $color $fg)(__miniline_c)$git
        end
    end
    if test -n "$git"
        set git (__miniline_color $color)(__miniline_l)(__miniline_color_rev $color $fg)$git(__miniline_color $color)(__miniline_r)
        echo -n $git
        echo -n (set_color normal)
    end
end
