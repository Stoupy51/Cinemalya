
#> cinemalya:v1.1.1/editor/export/append
#
# @executed	at @s
#
# @within	cinemalya:v1.1.1/editor/export/loop with storage cinemalya:editor export
#
# @args		abs (unknown)
#			sep (unknown)
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
#			yaw_s (unknown)
#			yaw_i (unknown)
#			yaw_p (unknown)
#			yaw_f (unknown)
#			pitch_s (unknown)
#			pitch_i (unknown)
#			pitch_p (unknown)
#			pitch_f (unknown)
#			rel (unknown)
#			dx_s (unknown)
#			dx_i (unknown)
#			dx_p (unknown)
#			dx_f (unknown)
#			dy_s (unknown)
#			dy_i (unknown)
#			dy_p (unknown)
#			dy_f (unknown)
#			dz_s (unknown)
#			dz_i (unknown)
#			dz_p (unknown)
#			dz_f (unknown)
#

$data modify storage cinemalya:editor export.abs set value '$(abs)$(sep){args:[$(x_s)$(x_i).$(x_p)$(x_f),$(y_s)$(y_i).$(y_p)$(y_f),$(z_s)$(z_i).$(z_p)$(z_f),$(yaw_s)$(yaw_i).$(yaw_p)$(yaw_f),$(pitch_s)$(pitch_i).$(pitch_p)$(pitch_f)]}'
$data modify storage cinemalya:editor export.rel set value '$(rel)$(sep){at:"~$(dx_s)$(dx_i).$(dx_p)$(dx_f) ~$(dy_s)$(dy_i).$(dy_p)$(dy_f) ~$(dz_s)$(dz_i).$(dz_p)$(dz_f)",rot:[$(yaw_s)$(yaw_i).$(yaw_p)$(yaw_f),$(pitch_s)$(pitch_i).$(pitch_p)$(pitch_f)]}'

