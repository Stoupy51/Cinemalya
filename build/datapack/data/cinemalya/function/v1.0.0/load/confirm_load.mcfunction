
#> cinemalya:v1.0.0/load/confirm_load
#
# @within	cinemalya:v1.0.0/load/valid_dependencies
#

# Confirm load
tellraw @a[tag=convention.debug] {"text":"[Loaded Cinemalya v1.0.0]","color":"green"}
scoreboard players set #cinemalya.loaded load.status 1
function cinemalya:v1.0.0/load/set_items_storage

# Objectives initialization
scoreboard objectives add cinemalya.data dummy
scoreboard objectives add cinemalya.id dummy
scoreboard objectives add cinemalya.delay dummy
scoreboard objectives add cinemalya.frame dummy
scoreboard objectives add cinemalya.smoothing dummy

# A /reload keeps the entities and their sampled paths, so only the live counter has to be rebuilt
execute store result score #entities cinemalya.data if entity @e[tag=cinemalya.cinematic]
execute unless score #next_id cinemalya.id matches 0.. run scoreboard players set #next_id cinemalya.id 0

# Set scoreboard constants for cinemalya.data
scoreboard players set #-2 cinemalya.data -2
scoreboard players set #-1 cinemalya.data -1
scoreboard players set #2 cinemalya.data 2
scoreboard players set #4 cinemalya.data 4
scoreboard players set #10000 cinemalya.data 10000
scoreboard players set #30000 cinemalya.data 30000
scoreboard players set #1000000 cinemalya.data 1000000

