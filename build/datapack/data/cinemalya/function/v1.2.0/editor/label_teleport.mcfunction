
#> cinemalya:v1.2.0/editor/label_teleport
#
# @executed	as @e[type=text_display,tag=cinemalya.keyframe]
#
# @within	cinemalya:v1.2.0/editor/toggle_teleport with storage cinemalya:editor label [ as @e[type=text_display,tag=cinemalya.keyframe] ]
#
# @args		n (unknown)
#

$data modify entity @s text set value {text:"$(n) TP",color:"aqua",bold:true}

