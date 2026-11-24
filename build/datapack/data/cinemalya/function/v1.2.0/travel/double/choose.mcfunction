
#> cinemalya:v1.2.0/travel/double/choose
#
# @within	cinemalya:v1.2.0/travel/defaults
#
# @output storage	cinemalya:work double.pose : the pose asked for in `pose`, standing when it is missing or unknown
#

data modify storage cinemalya:work double set value {pose:"standing"}
execute if data storage cinemalya:work args{pose:"standing"} run data modify storage cinemalya:work double.pose set value "standing"
execute if data storage cinemalya:work args{pose:"crouching"} run data modify storage cinemalya:work double.pose set value "crouching"
execute if data storage cinemalya:work args{pose:"swimming"} run data modify storage cinemalya:work double.pose set value "swimming"
execute if data storage cinemalya:work args{pose:"fall_flying"} run data modify storage cinemalya:work double.pose set value "fall_flying"

