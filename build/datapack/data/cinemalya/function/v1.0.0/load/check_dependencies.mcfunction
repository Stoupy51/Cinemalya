
#> cinemalya:v1.0.0/load/check_dependencies
#
# @within	cinemalya:v1.0.0/load/secondary
#

## Check if Cinemalya is loadable (dependencies)
scoreboard players set #dependency_error cinemalya.data 0
execute if score #dependency_error cinemalya.data matches 0 unless score $bs.spline.major load.status matches 4.. run scoreboard players set #dependency_error cinemalya.data 1
execute if score #dependency_error cinemalya.data matches 0 if score $bs.spline.major load.status matches 4 unless score $bs.spline.minor load.status matches 1.. run scoreboard players set #dependency_error cinemalya.data 1

