# ruff: noqa: E501
# Imports
from stewbeet import Mem, write_versioned_function


def write_start(ns: str, version: str) -> None:
	""" The intro entry point: place the players, fly them in, and show a title card while they travel. """
	write_versioned_function("intro/start", f"""
#> start
#
# @executed			positioned & rotated at the establishing shot the intro opens on
#
# @input macro		with : compound - see the intro documentation in the README
#
# @description		Show a title card at the camera, meanwhile moving every selected player to where
#					they belong, then fly them from the establishing shot down to their own position.
#

$data modify storage {ns}:work intro set value $(with)

## Optional arguments
execute unless data storage {ns}:work intro.target_function run data modify storage {ns}:work intro.target_function set value "{ns}:v{version}/intro/none"
execute unless data storage {ns}:work intro.selector run data modify storage {ns}:work intro.selector set value "@a"
execute unless data storage {ns}:work intro.display_time run data modify storage {ns}:work intro.display_time set value 130
execute unless data storage {ns}:work intro.duration run data modify storage {ns}:work intro.duration set value 50
execute unless data storage {ns}:work intro.smoothing run data modify storage {ns}:work intro.smoothing set value 3
execute unless data storage {ns}:work intro.sound run data modify storage {ns}:work intro.sound set value "minecraft:item.mace.smash_ground_heavy"
execute unless data storage {ns}:work intro.title run data modify storage {ns}:work intro.title set value ""
execute unless data storage {ns}:work intro.subtitle run data modify storage {ns}:work intro.subtitle set value ""
execute unless data storage {ns}:work intro.title_color run data modify storage {ns}:work intro.title_color set value "yellow"
execute unless data storage {ns}:work intro.subtitle_color run data modify storage {ns}:work intro.subtitle_color set value "white"

## Freeze the establishing shot once, so every player's travel opens on the very same camera
function {ns}:v{version}/travel/waypoints/look_ahead
execute summon marker run function {ns}:v{version}/travel/waypoints/read_here
function {ns}:v{version}/travel/waypoints/raise_eyes
data modify storage {ns}:work intro.shot set from storage {ns}:work wp

## Place every player, then start their travel from that shot
function {ns}:v{version}/intro/spread with storage {ns}:work intro

## The card holds for display_time, less the ticks the fade out needs to play through
execute store result score #display {ns}.data run data get storage {ns}:work intro.display_time
scoreboard players remove #display {ns}.data 20
execute if score #display {ns}.data matches ..1 run scoreboard players set #display {ns}.data 1
execute store result storage {ns}:work intro.display_time int 1 run scoreboard players get #display {ns}.data
execute positioned ~ ~1.6 ~ run function {ns}:v{version}/intro/display with storage {ns}:work intro
""")

	write_versioned_function("intro/spread", f"""
#> spread
#
# @executed			positioned & rotated at the establishing shot
#
# @input macro		selector : string - which players the intro plays for
#
# @description		Macro arguments are resolved when a function is instantiated, all at once, so a
#					function taking `with` cannot also read a key out of it. This second hop reads the
#					defaulted arguments back out of storage, where `selector` now sits at the top level.
#

$execute as $(selector) at @s run function {ns}:v{version}/intro/one_player with storage {ns}:work intro
""")

	write_versioned_function("intro/none", """
#> none
#
# @description		Default target_function: the players stay wherever they already are.
#
""")

	write_versioned_function("intro/one_player", f"""
#> one_player
#
# @executed			as & at one selected player
#
# @input macro		target_function : string - the function that moves @s to where they belong
#
# @description		Move the player into place, then fly them there from the establishing shot,
#					held back by the delay so the card finishes before the camera starts moving.
#

$function $(target_function)

## Where this player lands, at eye height so they are set back down exactly where they now stand
data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
data modify storage {ns}:work wp.pos set from entity @s Pos
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/raise_eyes
execute if data storage {ns}:work intro.yaw store result score #n {ns}.data run data get storage {ns}:work intro.yaw 1000
execute if data storage {ns}:work intro.yaw store result storage {ns}:work wp.rot[0] float 0.001 run scoreboard players get #n {ns}.data
execute if data storage {ns}:work intro.pitch store result score #n {ns}.data run data get storage {ns}:work intro.pitch 1000
execute if data storage {ns}:work intro.pitch store result storage {ns}:work wp.rot[1] float 0.001 run scoreboard players get #n {ns}.data

## A two waypoint path: the shared establishing shot, then this player's own spot
data modify storage {ns}:input intro_launch set from storage {ns}:work intro
data modify storage {ns}:input intro_launch.delay set from storage {ns}:work intro.display_time
data modify storage {ns}:input intro_launch.waypoints set value []
data modify storage {ns}:input intro_launch.waypoints append from storage {ns}:work intro.shot
data modify storage {ns}:input intro_launch.waypoints append from storage {ns}:work wp

data modify storage {ns}:input wrap set value {{}}
data modify storage {ns}:input wrap.with set from storage {ns}:input intro_launch
function {ns}:v{version}/travel/from_waypoints with storage {ns}:input wrap
""")


def write_display(ns: str, version: str) -> None:
	""" The title card itself: two text displays that grow in, hold, then shrink away. """
	write_versioned_function("intro/display", f"""
#> display
#
# @executed			positioned & rotated at the establishing shot
#
# @input macro		title, subtitle, title_color, subtitle_color : string
# @input macro		display_time : int - ticks to hold the card before fading it out
#
# @description		Summon the card ahead of the camera, collapsed, and schedule its whole life.
#

$summon text_display ^ ^0.0 ^1.5 {{brightness:{{block:15,sky:15}},billboard:"center",text:{{"text":"$(title)","color":"$(title_color)"}},background:0,shadow:true,Tags:["{ns}.intro.title","{ns}.intro.display"],transformation:{{translation:[0.0f,2.0f,0.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],scale:[50.0f,50.0f,1.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f]}}}}
$summon text_display ^ ^-0.5 ^2.5 {{brightness:{{block:15,sky:15}},billboard:"center",text:{{"text":"$(subtitle)","color":"$(subtitle_color)"}},background:0,shadow:true,Tags:["{ns}.intro.subtitle","{ns}.intro.display"],transformation:{{translation:[0.0f,0.0f,0.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f],scale:[0.0f,0.69f,1.0f],left_rotation:[0.0f,0.0f,0.0f,1.0f]}}}}

schedule function {ns}:v{version}/intro/fade_in 30t replace
$schedule function {ns}:v{version}/intro/fade_out $(display_time)t replace
""")

	write_versioned_function("intro/fade_in", f"""
#> fade_in
#
# @description		Settle both lines from their collapsed transform into place, the subtitle trailing the title.
#

execute as @e[tag={ns}.intro.title] run data merge entity @s {{interpolation_duration:12,start_interpolation:0,transformation:{{scale:[1.0f,1.0f,1.0f],translation:[0.0f,0.0f,0.0f]}}}}
execute as @e[tag={ns}.intro.subtitle] run data merge entity @s {{interpolation_duration:6,start_interpolation:20,transformation:{{scale:[1.0f,1.0f,1.0f]}}}}
schedule function {ns}:v{version}/intro/playsound 10t replace
""")

	write_versioned_function("intro/playsound", f"""
execute if entity @e[tag={ns}.intro.title,limit=1] run function {ns}:v{version}/intro/play with storage {ns}:work intro
""")

	write_versioned_function("intro/play", f"""
$execute at @e[tag={ns}.intro.title,limit=1] run playsound $(sound) ambient @a
""")

	write_versioned_function("intro/fade_out", f"""
#> fade_out
#
# @description		Collapse the card away, then clean up once the interpolation has finished playing.
#

execute as @e[tag={ns}.intro.display] run data merge entity @s {{text_opacity:-127b,interpolation_duration:12,start_interpolation:0,transformation:{{scale:[0.69f,0.0f,1.0f]}}}}
schedule function {ns}:v{version}/intro/cleanup 15t replace
""")

	write_versioned_function("intro/cleanup", f"""
kill @e[tag={ns}.intro.display]
""")


def main() -> None:
	""" Write the title card intro built on top of the travel primitive. """
	ns: str = Mem.ctx.project_id
	version: str = Mem.ctx.project_version

	write_start(ns, version)
	write_display(ns, version)
