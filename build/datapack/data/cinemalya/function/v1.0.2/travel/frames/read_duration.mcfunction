
#> cinemalya:v1.0.2/travel/frames/read_duration
#
# @within	cinemalya:v1.0.2/travel/frames/segment with storage cinemalya:work sel
#
# @args		i (unknown)
#

$execute store result score #seg_frames cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].duration

