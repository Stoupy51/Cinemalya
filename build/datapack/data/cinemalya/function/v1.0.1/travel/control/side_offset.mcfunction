
#> cinemalya:v1.0.1/travel/control/side_offset
#
# @executed	as a throwaway item_display
#
# @within	cinemalya:v1.0.1/travel/control/mid_point with storage cinemalya:work forward
#
# @args		tx (unknown)
#			ty (unknown)
#			tz (unknown)
#			turn (unknown)
#			amount (unknown)
#
# @input macro		amount : double - how far to step sideways
# @input macro		turn : int - a quarter turn, left or right
# @input macro		tx, ty, tz : double - the point to face before turning
# 
# @description		Stand on the midpoint, look at the destination on the level, turn a quarter
# 				turn, then step. Local coordinates follow the execution rotation, so the
# 				sidestep stays perpendicular to the travel wherever in the world it happens.
#

data modify entity @s Pos set from storage cinemalya:work mid
$execute at @s facing $(tx) $(ty) $(tz) rotated ~$(turn) ~ run tp @s ^ ^ ^$(amount)
data modify storage cinemalya:work mid set from entity @s Pos
kill @s

