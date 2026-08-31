
#> cinemalya:v1.0.2/intro/one_player
#
# @executed	as & at one selected player
#
# @within	cinemalya:v1.0.2/intro/spread with storage cinemalya:work intro
#
# @args		target_function (unknown)
#
# @input macro		target_function : string - the function that moves @s to where they belong
# 
# @description		Move the player into place, then fly them there from the establishing shot,
# 				held back by the delay so the card finishes before the camera starts moving.
#

$function $(target_function)

## Where this player lands, at eye height so they are set back down exactly where they now stand
data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
data modify storage cinemalya:work wp.pos set from entity @s Pos
data modify storage cinemalya:work wp.rot set from entity @s Rotation
function cinemalya:v1.0.2/travel/waypoints/raise_eyes
execute if data storage cinemalya:work intro.yaw store result score #n cinemalya.data run data get storage cinemalya:work intro.yaw 1000
execute if data storage cinemalya:work intro.yaw store result storage cinemalya:work wp.rot[0] float 0.001 run scoreboard players get #n cinemalya.data
execute if data storage cinemalya:work intro.pitch store result score #n cinemalya.data run data get storage cinemalya:work intro.pitch 1000
execute if data storage cinemalya:work intro.pitch store result storage cinemalya:work wp.rot[1] float 0.001 run scoreboard players get #n cinemalya.data

## A two waypoint path: the shared establishing shot, then this player's own spot
data modify storage cinemalya:input intro_launch set from storage cinemalya:work intro
data modify storage cinemalya:input intro_launch.delay set from storage cinemalya:work intro.display_time
data modify storage cinemalya:input intro_launch.waypoints set value []
data modify storage cinemalya:input intro_launch.waypoints append from storage cinemalya:work intro.shot
data modify storage cinemalya:input intro_launch.waypoints append from storage cinemalya:work wp

data modify storage cinemalya:input wrap set value {}
data modify storage cinemalya:input wrap.with set from storage cinemalya:input intro_launch
function cinemalya:v1.0.2/travel/from_waypoints with storage cinemalya:input wrap

