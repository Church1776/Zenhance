# Cursor styles (uncomment one)
#printf '\e[0 q'         # Default (terminal-dependent)
#printf '\e[1 q'  # Blinking block
#printf '\e[2 q'         # Steady block
printf $'\e[3 q'  # Blinking underline
#printf '\e[4 q'         # Steady underline
#printf '\e[5 q'  # Blinking bar (I-beam)
#printf '\e[6 q'         # Steady bar (recommended for modern terminals)
