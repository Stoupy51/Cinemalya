
#> cinemalya:v1.1.2/editor/start
#
# @executed	as the player
#
# @within	cinemalya:v1.1.2/api/editor/start
#
# @description		Give the player the editor item and start reading its clicks.
# 				A stale click score from any other carrot on a stick would otherwise place a keyframe at once.
#

execute if entity @s[tag=cinemalya.editor] run return fail
tag @s add cinemalya.editor
scoreboard players add #editors cinemalya.data 1
scoreboard players reset @s cinemalya.click
scoreboard players reset @s cinemalya.drop
execute unless data storage cinemalya:editor keyframes run data modify storage cinemalya:editor keyframes set value []
execute store result score #keyframes cinemalya.data run data get storage cinemalya:editor keyframes
give @s minecraft:carrot_on_a_stick[custom_data={cinemalya:{editor:true}},item_name={text:"Cinemalya Editor",color:"gold"},item_model="minecraft:spyglass",lore=[[{text:"Right click",color:"yellow",italic:false},{text:": place a keyframe",color:"white",italic:false}],[{text:"Left click",color:"yellow",italic:false},{text:": remove the last one",color:"white",italic:false}],[{text:"Sneak + right click",color:"yellow",italic:false},{text:": preview",color:"white",italic:false}],[{text:"Drop",color:"yellow",italic:false},{text:": export the command",color:"white",italic:false}]],piercing_weapon={},attack_range={min_reach:0.0f,max_reach:0.0f,min_creative_reach:0.0f,max_creative_reach:0.0f,hitbox_margin:0.0f},enchantments={"cinemalya:editor_left_click":1},enchantment_glint_override=false,tooltip_display={hidden_components:["minecraft:enchantments"]},tool={rules:[],can_destroy_blocks_in_creative:false}]

