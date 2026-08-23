
#> cinemalya:v1.0.0/playback/precise_rotation
#
# @executed	at @s
#
# @within	cinemalya:v1.0.0/playback/tick
#
# @description	Rotations normally reach the client quantised to steps of 360/256 = 1.40625 degrees,
# 			which is what makes a spectator camera turn in visible notches (MC-184359).
# 			Flipping OnGround to the opposite of last tick's value makes the server send the
# 			rotation at full precision instead (MC-278440), and display entities are not living
# 			entities so nothing else reacts to the flag.
# 			Discovered by the community while investigating MC-278440.
#

execute store success entity @s OnGround byte 1 store success score @s cinemalya.ground unless score @s cinemalya.ground matches 1

