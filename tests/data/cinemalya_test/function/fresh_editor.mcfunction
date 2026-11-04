# Cinemalya waits for a player before it loads, this one stays for the whole run
dummy loader spawn

# The editor path is shared by the whole world, and a server kept up between runs keeps it
kill @e[type=text_display,tag=cinemalya.keyframe]
data remove storage cinemalya:editor keyframes
data remove storage cinemalya:editor trail
data remove storage cinemalya:editor export
scoreboard players reset #editors cinemalya.data
scoreboard players set #keyframes cinemalya.data 0
