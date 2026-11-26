
#> cinemalya:v1.2.1/playback/event_signal
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/playback/fire_events
#			cinemalya:v1.2.1/playback/fire_events [ at @s & as @a[tag=cinemalya.temp,limit=1] ]
#
# @input score		#waypoint cinemalya.data : the index of the waypoint reached, from 0
# @input storage	cinemalya:work fire.function : optional, the function this waypoint asked for
#

function #cinemalya:v1/signals/on_waypoint
execute if data storage cinemalya:work fire.function run function cinemalya:v1.2.1/playback/event_function with storage cinemalya:work fire

