
#> cinemalya:v1.2.0/travel/frames/land_event
#
# @within	cinemalya:v1.2.0/travel/frames/next_segment
#
# @description		The camera has flown the whole segment, so the waypoint it arrives at lands on the frame just emitted.
#

execute store result score #event_at cinemalya.data run data get storage cinemalya:work frames.points
scoreboard players operation #event_at cinemalya.data += #frame_offset cinemalya.data
scoreboard players operation #event_wp cinemalya.data = #seg cinemalya.data
scoreboard players add #event_wp cinemalya.data 1
execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #event_wp cinemalya.data
scoreboard players operation #event_wp cinemalya.data += #wp_offset cinemalya.data
function cinemalya:v1.2.0/travel/frames/event with storage cinemalya:work sel

