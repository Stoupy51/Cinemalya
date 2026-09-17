
#> cinemalya:v1.0.4/load/valid_dependencies
#
# @within	cinemalya:v1.0.4/load/secondary
#			cinemalya:v1.0.4/load/valid_dependencies 1t replace [ scheduled ]
#

# Waiting for a player to get the game version, but stop function if no player found
execute unless entity @p run return run schedule function cinemalya:v1.0.4/load/valid_dependencies 1t replace
execute store result score #game_version cinemalya.data run data get entity @p DataVersion

# Check if the game version is supported
scoreboard players set #mcload_error cinemalya.data 0
execute unless score #game_version cinemalya.data matches 5023.. run scoreboard players set #mcload_error cinemalya.data 1

# Decode errors
execute if score #mcload_error cinemalya.data matches 1 run tellraw @a {"text":"Cinemalya Error: This version is made for Minecraft 26.3+.","color":"red"}
execute if score #dependency_error cinemalya.data matches 1 run tellraw @a {"text":"Cinemalya Error: Libraries are missing\nplease download the right Cinemalya datapack\nor download each of these libraries one by one:","color":"red"}
execute if score #dependency_error cinemalya.data matches 1 unless score $bs.spline.major load.status matches 4.. run tellraw @a {"text":"- [Bookshelf Spline (v4.2.0+)]","color":"gold","click_event":{"action":"open_url","url":"https://github.com/mcbookshelf/bookshelf/releases"}}
execute if score #dependency_error cinemalya.data matches 1 if score $bs.spline.major load.status matches 4 unless score $bs.spline.minor load.status matches 2.. run tellraw @a {"text":"- [Bookshelf Spline (v4.2.0+)]","color":"gold","click_event":{"action":"open_url","url":"https://github.com/mcbookshelf/bookshelf/releases"}}

# Load Cinemalya
execute if score #game_version cinemalya.data matches 1.. if score #mcload_error cinemalya.data matches 0 if score #dependency_error cinemalya.data matches 0 run function cinemalya:v1.0.4/load/confirm_load

