
#> cinemalya:v1.1.1/editor/export/wrap
#
# @executed	at @s
#
# @within	cinemalya:v1.1.1/editor/export/main with storage cinemalya:editor export
#
# @args		abs (unknown)
#			x_s (unknown)
#			x_i (unknown)
#			x_p (unknown)
#			x_f (unknown)
#			y_s (unknown)
#			y_i (unknown)
#			y_p (unknown)
#			y_f (unknown)
#			z_s (unknown)
#			z_i (unknown)
#			z_p (unknown)
#			z_f (unknown)
#			rel (unknown)
#

$data modify storage cinemalya:editor export.abs set value 'execute as @a run function #cinemalya:v1/launch_path {with:{duration:200,ease:"linear",smoothing:1,delay:0,gamemode:"restore",precise_rotation:true,tags:[],waypoints:[$(abs)]}}'
$data modify storage cinemalya:editor export.rel set value 'execute as @a positioned $(x_s)$(x_i).$(x_p)$(x_f) $(y_s)$(y_i).$(y_p)$(y_f) $(z_s)$(z_i).$(z_p)$(z_f) run function #cinemalya:v1/launch_path {with:{duration:200,ease:"linear",smoothing:1,delay:0,gamemode:"restore",precise_rotation:true,tags:[],waypoints:[$(rel)]}}'

