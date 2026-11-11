
#> cinemalya:v1.1.2/editor/on_use
#
# @executed	at @s
#
# @within	cinemalya:v1.1.2/editor/player [ at @s ]
#
# @description		The click score counts every carrot on a stick, so the hand is checked here.
#

scoreboard players reset @s cinemalya.click
execute unless items entity @s weapon.mainhand *[custom_data~{cinemalya:{editor:true}}] run return 0
execute if predicate {type:"minecraft:entity_properties",entity:"this",predicate:{flags:{is_sneaking:true}}} run return run function cinemalya:v1.1.2/editor/preview
function cinemalya:v1.1.2/editor/place

