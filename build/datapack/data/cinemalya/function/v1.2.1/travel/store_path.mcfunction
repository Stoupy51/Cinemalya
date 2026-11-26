
#> cinemalya:v1.2.1/travel/store_path
#
# @within	cinemalya:v1.2.1/travel/spawn with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the cinematic id
# 
# @description		Move the freshly built frame lists into this cinematic's own storage slot.
#

$data modify storage cinemalya:work paths.i$(i) set value {}
$data modify storage cinemalya:work paths.i$(i).points set from storage cinemalya:work frames.points
$data modify storage cinemalya:work paths.i$(i).rotations set from storage cinemalya:work frames.rotations
$data modify storage cinemalya:work paths.i$(i).events set from storage cinemalya:work frames.events
$execute if data storage cinemalya:work frames.cuts[0] run data modify storage cinemalya:work paths.i$(i).cuts set from storage cinemalya:work frames.cuts

