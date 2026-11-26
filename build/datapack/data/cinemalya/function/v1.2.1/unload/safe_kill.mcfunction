
#> cinemalya:v1.2.1/unload/safe_kill
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/unload [ at @s ]
#

# This function is used to safely kill entities by teleporting them to the void before killing them to prevent item drops
tp @s ~ -10000 ~
kill @s

