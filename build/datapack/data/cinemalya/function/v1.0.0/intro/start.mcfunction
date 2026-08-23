
#> cinemalya:v1.0.0/intro/start
#
# @executed	positioned & rotated at the establishing shot the intro opens on
#
# @within	cinemalya:v1.0.0/api/intro {with:$(with)}
#
# @args		with (unknown)
#
# @input macro		with : compound - see the intro documentation in the README
# 
# @description		Show a title card at the camera, meanwhile moving every selected player to where
# 				they belong, then fly them from the establishing shot down to their own position.
#

$data modify storage cinemalya:work intro set value $(with)

## Optional arguments
execute unless data storage cinemalya:work intro.target_function run data modify storage cinemalya:work intro.target_function set value "cinemalya:v1.0.0/intro/none"
execute unless data storage cinemalya:work intro.selector run data modify storage cinemalya:work intro.selector set value "@a"
execute unless data storage cinemalya:work intro.display_time run data modify storage cinemalya:work intro.display_time set value 130
execute unless data storage cinemalya:work intro.duration run data modify storage cinemalya:work intro.duration set value 50
execute unless data storage cinemalya:work intro.smoothing run data modify storage cinemalya:work intro.smoothing set value 3
execute unless data storage cinemalya:work intro.sound run data modify storage cinemalya:work intro.sound set value "minecraft:item.mace.smash_ground_heavy"
execute unless data storage cinemalya:work intro.title run data modify storage cinemalya:work intro.title set value ""
execute unless data storage cinemalya:work intro.subtitle run data modify storage cinemalya:work intro.subtitle set value ""
execute unless data storage cinemalya:work intro.title_color run data modify storage cinemalya:work intro.title_color set value "yellow"
execute unless data storage cinemalya:work intro.subtitle_color run data modify storage cinemalya:work intro.subtitle_color set value "white"

## Freeze the establishing shot once, so every player's travel opens on the very same camera
execute positioned ^ ^ ^1 summon marker run tag @s add cinemalya.shot_ahead
execute summon marker run function cinemalya:v1.0.0/intro/read_shot
kill @e[type=marker,tag=cinemalya.shot_ahead]

## Place every player, then start their travel from that shot
function cinemalya:v1.0.0/intro/spread with storage cinemalya:work intro

## The card holds for display_time, less the ticks the fade out needs to play through
execute store result score #display cinemalya.data run data get storage cinemalya:work intro.display_time
scoreboard players remove #display cinemalya.data 20
execute if score #display cinemalya.data matches ..1 run scoreboard players set #display cinemalya.data 1
execute store result storage cinemalya:work intro.display_time int 1 run scoreboard players get #display cinemalya.data
execute positioned ~ ~1.6 ~ run function cinemalya:v1.0.0/intro/display with storage cinemalya:work intro

