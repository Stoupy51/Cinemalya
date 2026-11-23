# Imports
from stewbeet import write_versioned_function

from ..limits import LAUNCH_BUDGET, MAX_DURATION


def write_pieces(ns: str, version: str) -> None:
	""" Cut a path at its teleports, build every piece as a path of its own, and chain their frames. """
	write_versioned_function("travel/pieces/count", f"""
#> count
#
# @input storage	{ns}:work args.waypoints : the caller's list, some waypoints carrying `tp:true`
# @output score		#pieces {ns}.data : how many pieces the path is cut into
#

scoreboard players set #pieces {ns}.data 1
data modify storage {ns}:work scan set from storage {ns}:work args.waypoints
data remove storage {ns}:work scan[0]
function {ns}:v{version}/travel/pieces/count_next
""")

	write_versioned_function("travel/pieces/count_next", f"""
execute unless data storage {ns}:work scan[0] run return 0
execute if data storage {ns}:work scan[0].tp run scoreboard players add #pieces {ns}.data 1
data remove storage {ns}:work scan[0]
function {ns}:v{version}/travel/pieces/count_next
""")

	write_versioned_function("travel/pieces/main", f"""
#> main
#
# @input storage	{ns}:work args.waypoints : the normalized list, some waypoints carrying `tp:true`
# @input score		#pieces {ns}.data
# @output storage	{ns}:work frames : the frames of every piece one after the other, plus `cuts`
#
# @description		A waypoint carrying `tp:true` is reached by teleport: nothing is flown from the one before it.
#					Each piece in between runs the usual pipeline on its own, so the spline never bends across a cut.
#					The duration is shared between the pieces in proportion to the segments each one flies.
#

data modify storage {ns}:work rest set from storage {ns}:work args.waypoints
data modify storage {ns}:work acc set value {{points:[],rotations:[],events:[],cuts:[]}}

scoreboard players set #wp_offset {ns}.data 0
scoreboard players set #hold_total {ns}.data 0
scoreboard players operation #total_duration {ns}.data = #duration {ns}.data
scoreboard players operation #total_segments {ns}.data = #count {ns}.data
scoreboard players operation #total_segments {ns}.data -= #pieces {ns}.data
execute if score #total_segments {ns}.data matches ..0 run scoreboard players set #total_segments {ns}.data 1

# Every piece builds under its own share of what one launch may spend
scoreboard players set #launch_budget {ns}.data {LAUNCH_BUDGET}
scoreboard players operation #launch_budget {ns}.data /= #pieces {ns}.data

function {ns}:v{version}/travel/pieces/next
data modify storage {ns}:work frames set from storage {ns}:work acc
""")

	write_versioned_function("travel/pieces/next", f"""
#> next
#
# @description		Cut the next piece off the front of the list and build its frames.
#

data modify storage {ns}:work args.waypoints set value []
function {ns}:v{version}/travel/pieces/take
execute store result score #first_at {ns}.data run data get storage {ns}:work acc.points
scoreboard players add #first_at {ns}.data 1
scoreboard players operation #frame_offset {ns}.data = #first_at {ns}.data
scoreboard players remove #frame_offset {ns}.data 1
execute if data storage {ns}:work acc.points[0] run scoreboard players add #frame_offset {ns}.data 1

execute store result score #count {ns}.data run data get storage {ns}:work args.waypoints
scoreboard players operation #segments {ns}.data = #count {ns}.data
scoreboard players remove #segments {ns}.data 1
execute if score #segments {ns}.data matches 0 run function {ns}:v{version}/travel/pieces/single
execute if score #segments {ns}.data matches 1.. run function {ns}:v{version}/travel/pieces/build

function {ns}:v{version}/travel/pieces/append
scoreboard players operation #wp_offset {ns}.data += #count {ns}.data
execute if data storage {ns}:work rest[0] run function {ns}:v{version}/travel/pieces/next
""")

	write_versioned_function("travel/pieces/take", f"""
data modify storage {ns}:work args.waypoints append from storage {ns}:work rest[0]
data remove storage {ns}:work rest[0]
execute if data storage {ns}:work rest[0] unless data storage {ns}:work rest[0].tp run function {ns}:v{version}/travel/pieces/take
""")

	write_versioned_function("travel/pieces/single", f"""
#> single
#
# @description		A piece of one waypoint flies nowhere: it is a single frame the camera lands on.
#

data modify storage {ns}:work frames set value {{points:[],rotations:[],events:[]}}
execute unless data storage {ns}:work acc.points[0] run data modify storage {ns}:work frames.points append from storage {ns}:work args.waypoints[0].pos
execute unless data storage {ns}:work acc.points[0] run data modify storage {ns}:work frames.rotations append from storage {ns}:work args.waypoints[0].rot
scoreboard players operation #event_at {ns}.data = #first_at {ns}.data
scoreboard players operation #event_wp {ns}.data = #wp_offset {ns}.data
data modify storage {ns}:work sel.i set value 0
function {ns}:v{version}/travel/frames/event with storage {ns}:work sel
""")

	write_versioned_function("travel/pieces/build", f"""
#> build
#
# @description		The usual pipeline on this piece alone, with the part of the duration its segments are worth.
#

scoreboard players operation #duration {ns}.data = #total_duration {ns}.data
scoreboard players operation #duration {ns}.data *= #segments {ns}.data
scoreboard players operation #duration {ns}.data /= #total_segments {ns}.data
execute if score #duration {ns}.data matches ..0 run scoreboard players set #duration {ns}.data 1
execute if score #duration {ns}.data matches {MAX_DURATION + 1}.. run scoreboard players set #duration {ns}.data {MAX_DURATION}

function {ns}:v{version}/travel/control/main
function {ns}:v{version}/travel/sample/main
function {ns}:v{version}/travel/frames/main
""")

	write_versioned_function("travel/pieces/append", f"""
#> append
#
# @description		Chain this piece's frames after the previous ones, noting where the camera jumps.
#

execute if data storage {ns}:work acc.points[0] run function {ns}:v{version}/travel/pieces/mark_cut
data modify storage {ns}:work acc.points append from storage {ns}:work frames.points[]
data modify storage {ns}:work acc.rotations append from storage {ns}:work frames.rotations[]
data modify storage {ns}:work acc.events append from storage {ns}:work frames.events[]
""")

	write_versioned_function("travel/pieces/mark_cut", f"""
#> mark_cut
#
# @description		`at` is the number of the pop that lands on the waypoint this piece starts on, which gets a frame of its own
#					so the teleport arrives exactly where it was placed. `delay` is the ticks the camera then holds there.
#

data modify storage {ns}:work acc.cuts append value {{at:0,delay:0}}
execute store result score #n {ns}.data run data get storage {ns}:work acc.points
scoreboard players add #n {ns}.data 1
execute store result storage {ns}:work acc.cuts[-1].at int 1 run scoreboard players get #n {ns}.data
execute if data storage {ns}:work args.waypoints[0].delay store result storage {ns}:work acc.cuts[-1].delay int 1 run data get storage {ns}:work args.waypoints[0].delay
execute store result score #hold {ns}.data run data get storage {ns}:work acc.cuts[-1].delay
scoreboard players operation #hold_total {ns}.data += #hold {ns}.data
data modify storage {ns}:work acc.points append from storage {ns}:work args.waypoints[0].pos
data modify storage {ns}:work acc.rotations append from storage {ns}:work args.waypoints[0].rot
""")

