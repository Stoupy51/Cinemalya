
#> cinemalya:v1.0.1/intro/spread
#
# @executed	positioned & rotated at the establishing shot
#
# @within	cinemalya:v1.0.1/intro/start with storage cinemalya:work intro
#
# @args		selector (unknown)
#
# @input macro		selector : string - which players the intro plays for
# 
# @description		Macro arguments are resolved when a function is instantiated, all at once, so a
# 				function taking `with` cannot also read a key out of it. This second hop reads the
# 				defaulted arguments back out of storage, where `selector` now sits at the top level.
#

$execute as $(selector) at @s run function cinemalya:v1.0.1/intro/one_player with storage cinemalya:work intro

