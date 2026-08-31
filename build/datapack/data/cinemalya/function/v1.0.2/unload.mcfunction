
#> cinemalya:v1.0.2/unload
#
# @within	#cinemalya:unload
#

# Remove scoreboard objectives
scoreboard objectives remove cinemalya.data
scoreboard objectives remove cinemalya.delay
scoreboard objectives remove cinemalya.frame
scoreboard objectives remove cinemalya.ground
scoreboard objectives remove cinemalya.id
scoreboard objectives remove cinemalya.smoothing
scoreboard objectives remove load.status

# Clear storages
data remove storage cinemalya:input intro_launch
data remove storage cinemalya:input wrap
data remove storage cinemalya:work ahead
data remove storage cinemalya:work args
data remove storage cinemalya:work control
data remove storage cinemalya:work forward
data remove storage cinemalya:work frames
data remove storage cinemalya:work intro
data remove storage cinemalya:work last_rot
data remove storage cinemalya:work mid
data remove storage cinemalya:work resolved
data remove storage cinemalya:work rot_control
data remove storage cinemalya:work rot_samples
data remove storage cinemalya:work samples
data remove storage cinemalya:work trail
data remove storage cinemalya:work wp

