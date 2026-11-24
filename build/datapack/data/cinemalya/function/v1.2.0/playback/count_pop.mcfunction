
#> cinemalya:v1.2.0/playback/count_pop
#
# @executed	at @s
#
# @within	cinemalya:v1.2.0/playback/pop with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the cinematic id
# 
# @description		Fire the events of the waypoint just reached. Then, for a teleport: a client glides every position change over `teleport_duration` ticks, which would turn a
# 				teleport into a sweep across the map. The server sends a position before the data of the same
# 				tick, so the glide has to be switched off while the frame before the jump is popped, and
# 				switched back on once the jump itself has landed.
#

scoreboard players add @s cinemalya.popped 1
$execute if score @s cinemalya.popped = @s cinemalya.event run function cinemalya:v1.2.0/playback/fire_events {i:$(i)}
scoreboard players operation #left cinemalya.data = @s cinemalya.cut
scoreboard players operation #left cinemalya.data -= @s cinemalya.popped
execute if score #left cinemalya.data matches 1 run data modify entity @s teleport_duration set value 0
$execute if score #left cinemalya.data matches 0 run function cinemalya:v1.2.0/playback/land_jump {i:$(i)}

