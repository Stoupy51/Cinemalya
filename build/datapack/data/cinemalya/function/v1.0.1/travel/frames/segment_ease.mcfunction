
#> cinemalya:v1.0.1/travel/frames/segment_ease
#
# @within	cinemalya:v1.0.1/travel/frames/segment
#
# @input score		#ease_path cinemalya.data : the easing asked for by the whole path
# @output score		#ease cinemalya.data : the easing this one segment runs
# 
# @description		Easing bends progress from 0 to 1, so running the path's curve inside every segment
# 				would bring the camera to a near stop on each intermediate waypoint. The path's
# 				curve therefore lands on its ends only: it accelerates away from the first
# 				waypoint, cruises through the middle ones, and settles onto the last.
# 				A waypoint carrying its own `ease` overrides that for the segment arriving at it.
#

## Middle segments cruise, the ends accelerate away from rest and settle back onto it
scoreboard players set #ease cinemalya.data 0
execute if score #seg cinemalya.data matches 0 if score #ease_path cinemalya.data matches 1 run scoreboard players set #ease cinemalya.data 4
execute if score #seg cinemalya.data matches 0 if score #ease_path cinemalya.data matches 3 run scoreboard players set #ease cinemalya.data 4
execute if score #seg cinemalya.data = #last_seg cinemalya.data if score #ease_path cinemalya.data matches 2 run scoreboard players set #ease cinemalya.data 5
execute if score #seg cinemalya.data = #last_seg cinemalya.data if score #ease_path cinemalya.data matches 3 run scoreboard players set #ease cinemalya.data 5

## A single segment is both ends at once, so it runs the path's curve whole
execute if score #segments cinemalya.data matches 1 run scoreboard players operation #ease cinemalya.data = #ease_path cinemalya.data

## The waypoint this segment arrives at has the final say
function cinemalya:v1.0.1/travel/frames/read_ease with storage cinemalya:work sel

