
#> cinemalya:v1.1.3/travel/double/spawn
#
# @executed	at @s
#
# @within	cinemalya:v1.1.3/travel/attach [ at @s ]
#
# @description		Summon a mannequin with the player's skin, armor and hands. Its skin is read off a player head
# 				filled by the player, since a mannequin cannot take it from a player directly.
#

function cinemalya:v1.1.3/travel/double/summon with storage cinemalya:work double
item replace entity @n[type=mannequin,tag=cinemalya.new] weapon.mainhand with minecraft:player_head
item modify entity @n[type=mannequin,tag=cinemalya.new] weapon.mainhand {type:"minecraft:fill_player_head",entity:"this"}
data modify entity @n[type=mannequin,tag=cinemalya.new] profile set from entity @n[type=mannequin,tag=cinemalya.new] equipment.mainhand.components."minecraft:profile"
data modify entity @n[type=mannequin,tag=cinemalya.new] equipment set from entity @s equipment
data remove entity @n[type=mannequin,tag=cinemalya.new] equipment.saddle
data modify entity @n[type=mannequin,tag=cinemalya.new] equipment.mainhand set from entity @s SelectedItem
execute unless data entity @s SelectedItem run data remove entity @n[type=mannequin,tag=cinemalya.new] equipment.mainhand
scoreboard players operation @n[type=mannequin,tag=cinemalya.new] cinemalya.id = @s cinemalya.id
tag @n[type=mannequin,tag=cinemalya.new] add cinemalya.double
tag @n[type=mannequin,tag=cinemalya.new] remove cinemalya.new

