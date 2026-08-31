
#> cinemalya:v1.0.2/travel/tags/read
#
# @within	cinemalya:v1.0.2/travel/tags/one with storage cinemalya:work sel
#
# @args		i (unknown)
#

$data modify storage cinemalya:work one_tag.name set from storage cinemalya:work args.tags[$(i)]

