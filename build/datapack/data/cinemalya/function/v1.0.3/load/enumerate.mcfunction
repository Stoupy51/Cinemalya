
#> cinemalya:v1.0.3/load/enumerate
#
# @within	#cinemalya:enumerate
#

# If current major is too low, set it to the current major
execute unless score #cinemalya.major load.status matches 1.. run scoreboard players set #cinemalya.major load.status 1

# If current minor is too low, set it to the current minor (only if major is correct)
execute if score #cinemalya.major load.status matches 1 unless score #cinemalya.minor load.status matches 0.. run scoreboard players set #cinemalya.minor load.status 0

# If current patch is too low, set it to the current patch (only if major and minor are correct)
execute if score #cinemalya.major load.status matches 1 if score #cinemalya.minor load.status matches 0 unless score #cinemalya.patch load.status matches 3.. run scoreboard players set #cinemalya.patch load.status 3

