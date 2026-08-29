
#> cinemalya:v1.0.1/travel/frames/append
#
# @within	cinemalya:v1.0.1/travel/frames/frame with storage cinemalya:work sel
#
# @args		i (unknown)
#

$data modify storage cinemalya:work frames.points append from storage cinemalya:work samples[$(i)]
$data modify storage cinemalya:work frames.rotations append from storage cinemalya:work rot_samples[$(i)]

