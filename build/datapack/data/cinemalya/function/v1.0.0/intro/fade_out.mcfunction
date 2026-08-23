
#> cinemalya:v1.0.0/intro/fade_out
#
# @within	cinemalya:v1.0.0/intro/display $(display_time)t replace [ scheduled ]
#
# @description		Collapse the card away, then clean up once the interpolation has finished playing.
#

execute as @e[tag=cinemalya.intro.display] run data merge entity @s {text_opacity:-127b,interpolation_duration:12,start_interpolation:0,transformation:{scale:[0.69f,0.0f,1.0f]}}
schedule function cinemalya:v1.0.0/intro/cleanup 15t replace

