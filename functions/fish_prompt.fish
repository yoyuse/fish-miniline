function __miniline_has_powerline
    switch $__miniline_use_powerline
        case 1 yes true
            true
        case 0 no false
            false
        case '*'
            switch $TERM_PROGRAM
                case iTerm.app WezTerm
                    true
                case '*'
                    false
            end
    end
end

function __miniline_color
    set_color normal
    if __miniline_has_powerline
        test -n "$argv[1]" && set_color $argv[1]
        test -n "$argv[2]" && set_color -b $argv[2]
    else
        test -n "$argv[1]" && set_color -b $argv[1]
        test -n "$argv[2]" && set_color $argv[2]
    end
end

function __miniline_color_rev
    set_color normal
    test -n "$argv[1]" && set_color -b $argv[1]
    test -n "$argv[2]" && set_color $argv[2]
end

function __miniline_l
    __miniline_has_powerline &&
    echo -n \uE0B6 ||           # 
    echo -n ' '
end

function __miniline_r
    __miniline_has_powerline &&
    echo -n \uE0B4 ||           # 
    echo -n ' '
end

function __miniline_c
    echo -n ' | '
end

function fish_prompt
    set -l st $status

    set -l color blue
    test $st -ne 0 && set color red
    set -l color2 $color
    set -l __fg black

    set prompt (__miniline_color_rev $color $__fg)(prompt_pwd)

    if test $st -ne 0
        set prompt (__miniline_color_rev red $__fg)$st(__miniline_c)"$prompt"
        set color2 red
    end

    if test "$USER" = "root"
        set prompt (__miniline_color_rev yellow $__fg)'# '(__miniline_color_rev $color2 $__fg)" $prompt"
        set color2 yellow
    end

    if test -n "$SSH_TTY"
        set prompt (__miniline_color_rev magenta $__fg)"$USER@"(prompt_hostname)' '(__miniline_color_rev $color2 $__fg)" $prompt"
        set color2 magenta
    end

    set prompt (__miniline_color $color2)(__miniline_l)$prompt(__miniline_color $color)(__miniline_r)
    echo -n $prompt
    echo -n (set_color normal)' '
end
