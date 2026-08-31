
#> cinemalya:v1.0.2/intro/display
#
# @executed	positioned ~ ~1.6 ~
#
# @within	cinemalya:v1.0.2/intro/start with storage cinemalya:work intro [ positioned ~ ~1.6 ~ ]
#
# @args		title (unknown)
#			title_color (unknown)
#			subtitle (unknown)
#			subtitle_color (unknown)
#			display_time (unknown)
#
# @input macro		title, subtitle, title_color, subtitle_color : string
# @input macro		display_time : int - ticks to hold the card before fading it out
# 
# @description		Summon the card ahead of the camera, collapsed, and schedule its whole life.
#

$summon text_display ^ ^0.0 ^1.5 {brightness:{block:15,sky:15},billboard:"center",text:{"text":"$(title)","color":"$(title_color)"},background:0,shadow:true,Tags:["cinemalya.intro.title","cinemalya.intro.display"],transformation:{translation:[0.0f,2.0f,0.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],scale:[50.0f,50.0f,1.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f]}}
$summon text_display ^ ^-0.5 ^2.5 {brightness:{block:15,sky:15},billboard:"center",text:{"text":"$(subtitle)","color":"$(subtitle_color)"},background:0,shadow:true,Tags:["cinemalya.intro.subtitle","cinemalya.intro.display"],transformation:{translation:[0.0f,0.0f,0.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],scale:[0.0f,0.69f,1.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f]}}

schedule function cinemalya:v1.0.2/intro/fade_in 30t replace
$schedule function cinemalya:v1.0.2/intro/fade_out $(display_time)t replace

