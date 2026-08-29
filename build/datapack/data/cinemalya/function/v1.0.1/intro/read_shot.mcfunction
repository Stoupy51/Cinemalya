
#> cinemalya:v1.0.1/intro/read_shot
#
# @executed	as a throwaway marker standing on the establishing shot
#
# @within	cinemalya:v1.0.1/intro/start
#
# @output storage	cinemalya:work intro.shot : the establishing shot as a waypoint, at eye height
# 
# @description		`execute summon` hands the marker the execution position but not the execution
# 				rotation, so the rotation is recovered by facing a second marker placed one
# 				block down the line of sight.
#

tp @s ~ ~ ~ facing entity @e[type=marker,tag=cinemalya.shot_ahead,limit=1] feet
data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
data modify storage cinemalya:work wp.pos set from entity @s Pos
data modify storage cinemalya:work wp.rot set from entity @s Rotation
function cinemalya:v1.0.1/travel/waypoints/raise_eyes
data modify storage cinemalya:work intro.shot set from storage cinemalya:work wp
kill @s

