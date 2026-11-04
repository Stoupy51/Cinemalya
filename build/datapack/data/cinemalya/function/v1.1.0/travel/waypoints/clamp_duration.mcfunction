
#> cinemalya:v1.1.0/travel/waypoints/clamp_duration
#
# @within	cinemalya:v1.1.0/travel/waypoints/fill with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint whose duration to bound
# 
# @description		A waypoint duration drives its own segment's frames, so it gets the same bounds as the travel total.
#

$execute store result score #wp_duration cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].duration
execute if score #wp_duration cinemalya.data matches ..0 run scoreboard players set #wp_duration cinemalya.data 1
execute if score #wp_duration cinemalya.data matches 36001.. run scoreboard players set #wp_duration cinemalya.data 36000
$execute store result storage cinemalya:work args.waypoints[$(i)].duration int 1 run scoreboard players get #wp_duration cinemalya.data

