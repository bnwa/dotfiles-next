fish_vi_key_bindings

for mode in insert default visual
  bind -M $mode \cf forward-char
  # Ctrl+Shift+f for incremental accept
  bind -M $mode \ct forward-word
end


