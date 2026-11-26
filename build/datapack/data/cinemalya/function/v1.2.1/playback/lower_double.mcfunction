
#> cinemalya:v1.2.1/playback/lower_double
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/playback/move_double [ at @s ]
#
# @description		Eyes are where the camera is, so the feet are one eye height lower, and a block behind it so the camera is not inside the head.
#

execute if entity @s[tag=cinemalya.pose_standing] rotated ~ 0 run tp @s ^ ^-1.62 ^-1.0
execute if entity @s[tag=cinemalya.pose_crouching] rotated ~ 0 run tp @s ^ ^-1.27 ^-1.0
execute if entity @s[tag=cinemalya.pose_swimming] rotated ~ 0 run tp @s ^ ^-0.4 ^-1.0
execute if entity @s[tag=cinemalya.pose_fall_flying] rotated ~ 0 run tp @s ^ ^-0.4 ^-1.0

