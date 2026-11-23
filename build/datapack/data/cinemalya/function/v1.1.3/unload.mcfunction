
#> cinemalya:v1.1.3/unload
#
# @within	#cinemalya:unload
#

# Kill entities with custom tags
execute as @e[tag=cinemalya.swap] at @s run function cinemalya:v1.1.3/unload/safe_kill

# Remove scoreboard objectives
scoreboard objectives remove cinemalya.click
scoreboard objectives remove cinemalya.cut
scoreboard objectives remove cinemalya.data
scoreboard objectives remove cinemalya.delay
scoreboard objectives remove cinemalya.drop
scoreboard objectives remove cinemalya.event
scoreboard objectives remove cinemalya.frame
scoreboard objectives remove cinemalya.ground
scoreboard objectives remove cinemalya.id
scoreboard objectives remove cinemalya.popped
scoreboard objectives remove cinemalya.smoothing
scoreboard objectives remove load.status

# Clear storages
data remove storage cinemalya:editor dialog
data remove storage cinemalya:editor drawing
data remove storage cinemalya:editor export
data remove storage cinemalya:editor iter
data remove storage cinemalya:editor keyframes
data remove storage cinemalya:editor new
data remove storage cinemalya:editor preview
data remove storage cinemalya:editor segment
data remove storage cinemalya:editor trail
data remove storage cinemalya:input intro_launch
data remove storage cinemalya:input wrap
data remove storage cinemalya:work acc
data remove storage cinemalya:work ahead
data remove storage cinemalya:work args
data remove storage cinemalya:work bounds
data remove storage cinemalya:work control
data remove storage cinemalya:work double
data remove storage cinemalya:work forward
data remove storage cinemalya:work frames
data remove storage cinemalya:work intro
data remove storage cinemalya:work last_rot
data remove storage cinemalya:work lengths
data remove storage cinemalya:work measure
data remove storage cinemalya:work mid
data remove storage cinemalya:work resolved
data remove storage cinemalya:work rest
data remove storage cinemalya:work rot_control
data remove storage cinemalya:work rot_samples
data remove storage cinemalya:work samples
data remove storage cinemalya:work scan
data remove storage cinemalya:work sel
data remove storage cinemalya:work trail
data remove storage cinemalya:work wp

