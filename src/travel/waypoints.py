# Imports
from stewbeet import write_versioned_function


def write_waypoints(ns: str, version: str) -> None:
	""" Build the waypoint list from the caller's arguments, then normalize it into a uniform shape. """
	write_versioned_function("travel/waypoints/start_here", f"""
#> start_here
#
# @executed			as the player
#
# @description		Open the waypoint list on the player's own eyes.
#

data modify storage {ns}:work args.waypoints set value []
data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
data modify storage {ns}:work wp.pos set from entity @s Pos
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/raise_eyes
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/prepend_here", f"""
#> prepend_here
#
# @executed			as the player
#
# @description		Complete a single-waypoint path by starting it where the player currently stands.
#

data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
data modify storage {ns}:work wp.pos set from entity @s Pos
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/raise_eyes
data modify storage {ns}:work args.waypoints prepend from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/raise_eyes", f"""
#> raise_eyes
#
# @description		Lift the pending waypoint from the feet to the eyes, so the camera never starts inside the ground.
#

execute store result score #n {ns}.data run data get storage {ns}:work wp.pos[1] 1000
scoreboard players add #n {ns}.data 1600
execute store result storage {ns}:work wp.pos[1] double 0.001 run scoreboard players get #n {ns}.data
""")

	write_versioned_function("travel/waypoints/target_from_coords", f"""
#> target_from_coords
#
# @executed			as the player
#
# @description		Close the waypoint list on the coordinates the caller asked for, at eye height.
#

data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
execute store result score #n {ns}.data run data get storage {ns}:work args.x 1000
execute store result storage {ns}:work wp.pos[0] double 0.001 run scoreboard players get #n {ns}.data
execute store result score #n {ns}.data run data get storage {ns}:work args.y 1000
scoreboard players add #n {ns}.data 1600
execute store result storage {ns}:work wp.pos[1] double 0.001 run scoreboard players get #n {ns}.data
execute store result score #n {ns}.data run data get storage {ns}:work args.z 1000
execute store result storage {ns}:work wp.pos[2] double 0.001 run scoreboard players get #n {ns}.data

# The player keeps looking the same way unless the caller said otherwise
data modify storage {ns}:work wp.rot set from entity @s Rotation
function {ns}:v{version}/travel/waypoints/override_rotation
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/target_from_entity", f"""
#> target_from_entity
#
# @description		Close the waypoint list on another entity's position and rotation, at eye height.
#

data modify storage {ns}:work wp set value {{pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}}
function {ns}:v{version}/travel/waypoints/read_target with storage {ns}:work args
function {ns}:v{version}/travel/waypoints/raise_eyes
function {ns}:v{version}/travel/waypoints/override_rotation
data modify storage {ns}:work args.waypoints append from storage {ns}:work wp
""")

	write_versioned_function("travel/waypoints/read_target", f"""
#> read_target
#
# @input macro		target : string - the selector to copy the position and rotation from
#

$data modify storage {ns}:work wp.pos set from entity $(target) Pos
$data modify storage {ns}:work wp.rot set from entity $(target) Rotation
""")

	write_versioned_function("travel/waypoints/override_rotation", f"""
#> override_rotation
#
# @description		Apply the caller's yaw and pitch on top of whatever rotation the target had.
#

execute if data storage {ns}:work args.yaw store result score #n {ns}.data run data get storage {ns}:work args.yaw 1000
execute if data storage {ns}:work args.yaw store result storage {ns}:work wp.rot[0] float 0.001 run scoreboard players get #n {ns}.data
execute if data storage {ns}:work args.pitch store result score #n {ns}.data run data get storage {ns}:work args.pitch 1000
execute if data storage {ns}:work args.pitch store result storage {ns}:work wp.rot[1] float 0.001 run scoreboard players get #n {ns}.data
""")

	write_versioned_function("travel/waypoints/normalize", f"""
#> normalize
#
# @output score		#segments, #share {ns}.data
#
# @description		Give every waypoint a rotation and a duration, and unwrap the yaws so the camera
#					always turns the short way round instead of spinning most of a circle.
#

## One segment per gap between waypoints, each getting an equal share of the total by default
execute store result score #count {ns}.data run data get storage {ns}:work args.waypoints
scoreboard players operation #segments {ns}.data = #count {ns}.data
scoreboard players remove #segments {ns}.data 1
execute if score #segments {ns}.data matches ..0 run scoreboard players set #segments {ns}.data 1
scoreboard players operation #share {ns}.data = #duration {ns}.data
scoreboard players operation #share {ns}.data /= #segments {ns}.data
execute if score #share {ns}.data matches ..0 run scoreboard players set #share {ns}.data 1

## Seed the running rotation, so a waypoint without one simply keeps the previous heading
data modify storage {ns}:work last_rot set value [0.0f,0.0f]
execute unless score #mode {ns}.data matches 2 run data modify storage {ns}:work last_rot set from entity @s Rotation
execute if data storage {ns}:work args.waypoints[0].rot run data modify storage {ns}:work last_rot set from storage {ns}:work args.waypoints[0].rot
execute store result score #last_yaw {ns}.data run data get storage {ns}:work last_rot[0] 1000

scoreboard players set #w {ns}.data 0
function {ns}:v{version}/travel/waypoints/normalize_loop
""")

	write_versioned_function("travel/waypoints/normalize_loop", f"""
execute if score #w {ns}.data < #count {ns}.data run function {ns}:v{version}/travel/waypoints/normalize_one
""")

	write_versioned_function("travel/waypoints/normalize_one", f"""
execute store result storage {ns}:work sel.i int 1 run scoreboard players get #w {ns}.data
function {ns}:v{version}/travel/waypoints/fill with storage {ns}:work sel
scoreboard players add #w {ns}.data 1
function {ns}:v{version}/travel/waypoints/normalize_loop
""")

	write_versioned_function("travel/waypoints/fill", f"""
#> fill
#
# @input macro		i : int - index of the waypoint to complete
#
# @description		Inherit the missing rotation and duration, then unwrap this waypoint's yaw.
#

$execute unless data storage {ns}:work args.waypoints[$(i)].rot run data modify storage {ns}:work args.waypoints[$(i)].rot set from storage {ns}:work last_rot
$execute unless data storage {ns}:work args.waypoints[$(i)].duration store result storage {ns}:work args.waypoints[$(i)].duration int 1 run scoreboard players get #share {ns}.data

## Keep the yaw within half a turn of the previous one (a 350 degree spin becomes a 10 degree one)
$execute store result score #yaw {ns}.data run data get storage {ns}:work args.waypoints[$(i)].rot[0] 1000
scoreboard players operation #diff {ns}.data = #yaw {ns}.data
scoreboard players operation #diff {ns}.data -= #last_yaw {ns}.data
execute if score #diff {ns}.data matches 180000.. run scoreboard players remove #yaw {ns}.data 360000
execute if score #diff {ns}.data matches ..-180000 run scoreboard players add #yaw {ns}.data 360000
$execute store result storage {ns}:work args.waypoints[$(i)].rot[0] float 0.001 run scoreboard players get #yaw {ns}.data
scoreboard players operation #last_yaw {ns}.data = #yaw {ns}.data
$data modify storage {ns}:work last_rot set from storage {ns}:work args.waypoints[$(i)].rot
""")
