function fish_prompt
    set -l __status $status

    set -l __arrow '' # \uE0B0
    set -l __arrow2 '│' # \uE0B1
    set -l __color blue
    set -l __color2 $__color
    set -l root root
    set -l __fg black

    test $__status -eq 0 || set __color red

    test "$USER" = "$root" && set __color2 yellow

    if test $SSH_TTY
        echo -n (set_color -b magenta)(set_color $__fg)
        echo -n ' '$USER'@'(prompt_hostname)' '
        echo -n (set_color -b $__color2)(set_color magenta)$__arrow
    end

    if test "$USER" = "$root"
        echo -n (set_color -b yellow)(set_color $__fg)
        echo -n ' # '
        echo -n (set_color -b $__color)(set_color yellow)$__arrow
    end

    echo -n (set_color -b $__color)(set_color $__fg)

    test $__status -eq 0 || echo -n " $__status $__arrow2"

    echo -n ' '(prompt_pwd)' '
    echo -n (set_color normal)(set_color $__color)$__arrow
    echo -n (set_color normal)' '
end
