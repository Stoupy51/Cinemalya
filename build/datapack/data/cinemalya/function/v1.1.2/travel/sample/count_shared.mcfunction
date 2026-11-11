
#> cinemalya:v1.1.2/travel/sample/count_shared
#
# @within	cinemalya:v1.1.2/travel/sample/bound with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the waypoint ending the segment just measured
#

$execute if data storage cinemalya:work args.waypoints[$(i)].duration run return 0
scoreboard players add #shared_count cinemalya.data 1
scoreboard players operation #shared_length cinemalya.data += #length cinemalya.data
scoreboard players operation #shared_length cinemalya.data -= #bound_length cinemalya.data

