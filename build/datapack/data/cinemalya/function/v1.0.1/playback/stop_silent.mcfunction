
#> cinemalya:v1.0.1/playback/stop_silent
#
# @executed	as the player
#
# @within	cinemalya:v1.0.1/travel/start
#
# @description		Clear any cinematic still running for this player, leaving their gamemode alone:
# 				the launch about to happen is what decides where they end up.
#

scoreboard players set #restore cinemalya.data 0
function cinemalya:v1.0.1/playback/stop_for_player

