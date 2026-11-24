
#> cinemalya:v1.2.0/playback/fire_events
#
# @executed	at @s
#
# @within	cinemalya:v1.2.0/playback/count_pop {i:$(i)}
#			cinemalya:v1.2.0/playback/fire_events {i:$(i)}
#
# @args		i (unknown)
#
# @input macro		i : int - the cinematic id
# 
# @description		Run the oldest pending event as the rider, at the camera, then the next one if it lands on this same frame.
# 				A free flying camera has no rider, so it runs them itself.
#

$data modify storage cinemalya:work fire set from storage cinemalya:work paths.i$(i).events[0]
$data remove storage cinemalya:work paths.i$(i).events[0]
execute store result score #waypoint cinemalya.data run data get storage cinemalya:work fire.wp
execute if entity @s[tag=cinemalya.detached] run function cinemalya:v1.2.0/playback/event_signal
execute unless entity @s[tag=cinemalya.detached] at @s as @a[tag=cinemalya.temp,limit=1] run function cinemalya:v1.2.0/playback/event_signal
$execute store result score @s cinemalya.event run data get storage cinemalya:work paths.i$(i).events[0].at
$execute if score @s cinemalya.popped = @s cinemalya.event run function cinemalya:v1.2.0/playback/fire_events {i:$(i)}

