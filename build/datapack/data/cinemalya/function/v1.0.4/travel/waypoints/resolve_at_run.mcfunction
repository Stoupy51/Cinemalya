
#> cinemalya:v1.0.4/travel/waypoints/resolve_at_run
#
# @executed	at @s
#
# @within	cinemalya:v1.0.4/travel/waypoints/resolve_at_anchor with storage cinemalya:work one_at [ at @s ]
#
# @args		at (unknown)
#
# @input macro		at : string - a coordinate triple, ex: "~10 ~5 ~3" or "^ ^ ^12"
#

$execute positioned $(at) summon marker run function cinemalya:v1.0.4/travel/waypoints/capture_resolved

