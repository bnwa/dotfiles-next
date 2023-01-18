function fish_prompt
    printf "%s %s" (set_color $fish_color_cwd)(basename (pwd))(set_color red) λ (set_color normal)
end

