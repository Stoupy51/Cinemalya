
#> cinemalya:v1.1.3/travel/pieces/next
#
# @within	cinemalya:v1.1.3/travel/pieces/main
#			cinemalya:v1.1.3/travel/pieces/next
#
# @description		Cut the next piece off the front of the list and build its frames.
#

data modify storage cinemalya:work args.waypoints set value []
function cinemalya:v1.1.3/travel/pieces/take
execute store result score #first_at cinemalya.data run data get storage cinemalya:work acc.points
scoreboard players add #first_at cinemalya.data 1
scoreboard players operation #frame_offset cinemalya.data = #first_at cinemalya.data
scoreboard players remove #frame_offset cinemalya.data 1
execute if data storage cinemalya:work acc.points[0] run scoreboard players add #frame_offset cinemalya.data 1

execute store result score #count cinemalya.data run data get storage cinemalya:work args.waypoints
scoreboard players operation #segments cinemalya.data = #count cinemalya.data
scoreboard players remove #segments cinemalya.data 1
execute if score #segments cinemalya.data matches 0 run function cinemalya:v1.1.3/travel/pieces/single
execute if score #segments cinemalya.data matches 1.. run function cinemalya:v1.1.3/travel/pieces/build

function cinemalya:v1.1.3/travel/pieces/append
scoreboard players operation #wp_offset cinemalya.data += #count cinemalya.data
execute if data storage cinemalya:work rest[0] run function cinemalya:v1.1.3/travel/pieces/next

