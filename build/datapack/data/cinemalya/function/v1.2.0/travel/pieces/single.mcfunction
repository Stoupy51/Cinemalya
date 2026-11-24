
#> cinemalya:v1.2.0/travel/pieces/single
#
# @within	cinemalya:v1.2.0/travel/pieces/next
#
# @description		A piece of one waypoint flies nowhere: it is a single frame the camera lands on.
#

data modify storage cinemalya:work frames set value {points:[],rotations:[],events:[]}
execute unless data storage cinemalya:work acc.points[0] run data modify storage cinemalya:work frames.points append from storage cinemalya:work args.waypoints[0].pos
execute unless data storage cinemalya:work acc.points[0] run data modify storage cinemalya:work frames.rotations append from storage cinemalya:work args.waypoints[0].rot
scoreboard players operation #event_at cinemalya.data = #first_at cinemalya.data
scoreboard players operation #event_wp cinemalya.data = #wp_offset cinemalya.data
data modify storage cinemalya:work sel.i set value 0
function cinemalya:v1.2.0/travel/frames/event with storage cinemalya:work sel

