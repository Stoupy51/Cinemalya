
#> cinemalya:v1.1.1/load/confirm_load
#
# @within	cinemalya:v1.1.1/load/valid_dependencies
#

# Confirm load
tellraw @a[tag=convention.debug] {"text":"[Loaded Cinemalya v1.1.1]","color":"green"}
scoreboard players set #cinemalya.loaded load.status 1

# Objectives initialization
scoreboard objectives add cinemalya.data dummy
scoreboard objectives add cinemalya.id dummy
scoreboard objectives add cinemalya.delay dummy
scoreboard objectives add cinemalya.frame dummy
scoreboard objectives add cinemalya.smoothing dummy
scoreboard objectives add cinemalya.ground dummy
scoreboard objectives add cinemalya.click minecraft.used:minecraft.carrot_on_a_stick
scoreboard objectives add cinemalya.drop minecraft.dropped:minecraft.carrot_on_a_stick

# A /reload keeps the entities and their sampled paths, so only the live counter has to be rebuilt
execute store result score #entities cinemalya.data if entity @e[tag=cinemalya.cinematic]
execute unless score #next_id cinemalya.id matches 0.. run scoreboard players set #next_id cinemalya.id 0

# Set scoreboard constants for cinemalya.data
scoreboard players set #-2 cinemalya.data -2
scoreboard players set #-1 cinemalya.data -1
scoreboard players set #2 cinemalya.data 2
scoreboard players set #48 cinemalya.data 48
scoreboard players set #100 cinemalya.data 100
scoreboard players set #165 cinemalya.data 165
scoreboard players set #200 cinemalya.data 200
scoreboard players set #600 cinemalya.data 600
scoreboard players set #1000 cinemalya.data 1000
scoreboard players set #10000 cinemalya.data 10000
scoreboard players set #30000 cinemalya.data 30000
scoreboard players set #1000000 cinemalya.data 1000000

