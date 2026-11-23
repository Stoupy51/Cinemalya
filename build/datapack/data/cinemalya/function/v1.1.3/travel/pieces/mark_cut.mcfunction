
#> cinemalya:v1.1.3/travel/pieces/mark_cut
#
# @within	cinemalya:v1.1.3/travel/pieces/append
#
# @description		`at` is the number of the pop that lands on the waypoint this piece starts on, which gets a frame of its own
# 				so the teleport arrives exactly where it was placed. `delay` is the ticks the camera then holds there.
#

data modify storage cinemalya:work acc.cuts append value {at:0,delay:0}
execute store result score #n cinemalya.data run data get storage cinemalya:work acc.points
scoreboard players add #n cinemalya.data 1
execute store result storage cinemalya:work acc.cuts[-1].at int 1 run scoreboard players get #n cinemalya.data
execute if data storage cinemalya:work args.waypoints[0].delay store result storage cinemalya:work acc.cuts[-1].delay int 1 run data get storage cinemalya:work args.waypoints[0].delay
execute store result score #hold cinemalya.data run data get storage cinemalya:work acc.cuts[-1].delay
scoreboard players operation #hold_total cinemalya.data += #hold cinemalya.data
data modify storage cinemalya:work acc.points append from storage cinemalya:work args.waypoints[0].pos
data modify storage cinemalya:work acc.rotations append from storage cinemalya:work args.waypoints[0].rot

