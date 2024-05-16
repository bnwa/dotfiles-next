fish_vi_key_bindings

for mode in insert default visual
  bind -M $mode \cg forward-char
  # Ctrl+Shift+f for incremental accept
  bind -M $mode \ct forward-word
end


