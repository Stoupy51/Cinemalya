
#> cinemalya:v1.0.4/intro/fade_in
#
# @within	cinemalya:v1.0.4/intro/display 30t replace [ scheduled ]
#
# @description		Settle both lines from their collapsed transform into place, the subtitle trailing the title.
#

execute as @e[tag=cinemalya.intro.title] run data merge entity @s {interpolation_duration:12,start_interpolation:0,transformation:{scale:[1.0f,1.0f,1.0f],translation:[0.0f,0.0f,0.0f]}}
execute as @e[tag=cinemalya.intro.subtitle] run data merge entity @s {interpolation_duration:6,start_interpolation:20,transformation:{scale:[1.0f,1.0f,1.0f]}}
schedule function cinemalya:v1.0.4/intro/playsound 10t replace

