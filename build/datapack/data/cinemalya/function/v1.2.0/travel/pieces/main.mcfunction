
#> cinemalya:v1.2.0/travel/pieces/main
#
# @within	cinemalya:v1.2.0/travel/start
#
# @input storage	cinemalya:work args.waypoints : the normalized list, some waypoints carrying `tp:true`
# @input score		#pieces cinemalya.data
# @output storage	cinemalya:work frames : the frames of every piece one after the other, plus `cuts`
# 
# @description		A waypoint carrying `tp:true` is reached by teleport: nothing is flown from the one before it.
# 				Each piece in between runs the usual pipeline on its own, so the spline never bends across a cut.
# 				The duration is shared between the pieces in proportion to the segments each one flies.
#

data modify storage cinemalya:work rest set from storage cinemalya:work args.waypoints
data modify storage cinemalya:work acc set value {points:[],rotations:[],events:[],cuts:[]}

scoreboard players set #wp_offset cinemalya.data 0
scoreboard players set #hold_total cinemalya.data 0
scoreboard players operation #total_duration cinemalya.data = #duration cinemalya.data
scoreboard players operation #total_segments cinemalya.data = #count cinemalya.data
scoreboard players operation #total_segments cinemalya.data -= #pieces cinemalya.data
execute if score #total_segments cinemalya.data matches ..0 run scoreboard players set #total_segments cinemalya.data 1

# Every piece builds under its own share of what one launch may spend
scoreboard players set #launch_budget cinemalya.data 60000
scoreboard players operation #launch_budget cinemalya.data /= #pieces cinemalya.data

function cinemalya:v1.2.0/travel/pieces/next
data modify storage cinemalya:work frames set from storage cinemalya:work acc

