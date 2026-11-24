
#> cinemalya:v1.2.0/travel/pieces/count
#
# @within	cinemalya:v1.2.0/travel/start
#
# @input storage	cinemalya:work args.waypoints : the caller's list, some waypoints carrying `tp:true`
# @output score		#pieces cinemalya.data : how many pieces the path is cut into
#

scoreboard players set #pieces cinemalya.data 1
data modify storage cinemalya:work scan set from storage cinemalya:work args.waypoints
data remove storage cinemalya:work scan[0]
function cinemalya:v1.2.0/travel/pieces/count_next

