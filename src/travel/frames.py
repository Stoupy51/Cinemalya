# Imports
from stewbeet import write_versioned_function


def write_frames(ns: str, version: str) -> None:
	""" Pick, once and for all, the sample every playback tick will land on. """
	write_versioned_function("travel/frames/main", f"""
#> main
#
# @input storage	{ns}:work samples, {ns}:work rot_samples : the dense polyline
# @output storage	{ns}:work frames : one entry per playback step
#
# @description		Walk the waypoints segment by segment, giving each one as many frames as its own
#					duration buys. Doing it here means playback never computes anything: it just pops.
#

data modify storage {ns}:work frames set value {{points:[],rotations:[]}}
scoreboard players set #seg {ns}.data 0
function {ns}:v{version}/travel/frames/segment_loop
""")

	write_versioned_function("travel/frames/segment_loop", f"""
execute if score #seg {ns}.data < #segments {ns}.data run function {ns}:v{version}/travel/frames/segment
""")

	write_versioned_function("travel/frames/segment", f"""
#> segment
#
# @description		Emit every frame belonging to the segment that ends on waypoint #seg + 1.
#

## This segment's own share of the travel, in frames
scoreboard players operation #n {ns}.data = #seg {ns}.data
scoreboard players add #n {ns}.data 1
execute store result storage {ns}:work sel.i int 1 run scoreboard players get #n {ns}.data
function {ns}:v{version}/travel/frames/read_duration with storage {ns}:work sel
scoreboard players operation #seg_frames {ns}.data /= #smoothing {ns}.data
execute if score #seg_frames {ns}.data matches ..0 run scoreboard players set #seg_frames {ns}.data 1

scoreboard players set #f {ns}.data 1
function {ns}:v{version}/travel/frames/frame_loop

scoreboard players add #seg {ns}.data 1
function {ns}:v{version}/travel/frames/segment_loop
""")

	write_versioned_function("travel/frames/read_duration", f"""
$execute store result score #seg_frames {ns}.data run data get storage {ns}:work args.waypoints[$(i)].duration
""")

	write_versioned_function("travel/frames/frame_loop", f"""
execute if score #f {ns}.data <= #seg_frames {ns}.data run function {ns}:v{version}/travel/frames/frame
""")

	write_versioned_function("travel/frames/frame", f"""
#> frame
#
# @description		Map this frame's position within its segment onto a sample of the dense polyline.
#

## Progress through the segment, in ten thousandths, bent by the easing curve
scoreboard players operation #p {ns}.data = #f {ns}.data
scoreboard players operation #p {ns}.data *= #10000 {ns}.data
scoreboard players operation #p {ns}.data /= #seg_frames {ns}.data
function {ns}:v{version}/travel/frames/ease

## Progress through the whole curve, then the nearest sample to it
scoreboard players operation #g {ns}.data = #seg {ns}.data
scoreboard players operation #g {ns}.data *= #10000 {ns}.data
scoreboard players operation #g {ns}.data += #p {ns}.data
scoreboard players operation #g {ns}.data /= #segments {ns}.data
scoreboard players operation #g {ns}.data *= #last {ns}.data
scoreboard players add #g {ns}.data 5000
scoreboard players operation #g {ns}.data /= #10000 {ns}.data
execute if score #g {ns}.data > #last {ns}.data run scoreboard players operation #g {ns}.data = #last {ns}.data

execute store result storage {ns}:work sel.i int 1 run scoreboard players get #g {ns}.data
function {ns}:v{version}/travel/frames/append with storage {ns}:work sel

scoreboard players add #f {ns}.data 1
function {ns}:v{version}/travel/frames/frame_loop
""")

	write_versioned_function("travel/frames/append", f"""
$data modify storage {ns}:work frames.points append from storage {ns}:work samples[$(i)]
$data modify storage {ns}:work frames.rotations append from storage {ns}:work rot_samples[$(i)]
""")

	write_versioned_function("travel/frames/ease", f"""
#> ease
#
# @input score		#p {ns}.data : linear progress, 0 to 10000
# @output score		#p {ns}.data : eased progress, 0 to 10000
#
# @description		Bend the progress so the camera accelerates, decelerates, or does both.
#

execute if score #ease {ns}.data matches 1 run function {ns}:v{version}/travel/frames/ease_in
execute if score #ease {ns}.data matches 2 run function {ns}:v{version}/travel/frames/ease_out
execute if score #ease {ns}.data matches 3 run function {ns}:v{version}/travel/frames/ease_in_out
""")

	write_versioned_function("travel/frames/ease_in", f"""
# p squared: slow to start, fastest on arrival
scoreboard players operation #p {ns}.data *= #p {ns}.data
scoreboard players operation #p {ns}.data /= #10000 {ns}.data
""")

	write_versioned_function("travel/frames/ease_out", f"""
# One minus the square of the remainder: fastest at launch, settling onto the target
scoreboard players operation #q {ns}.data = #10000 {ns}.data
scoreboard players operation #q {ns}.data -= #p {ns}.data
scoreboard players operation #q {ns}.data *= #q {ns}.data
scoreboard players operation #q {ns}.data /= #10000 {ns}.data
scoreboard players operation #p {ns}.data = #10000 {ns}.data
scoreboard players operation #p {ns}.data -= #q {ns}.data
""")

	write_versioned_function("travel/frames/ease_in_out", f"""
# Smoothstep, staged through two divisions so the intermediate product stays inside an int
scoreboard players operation #q {ns}.data = #p {ns}.data
scoreboard players operation #q {ns}.data *= #p {ns}.data
scoreboard players operation #q {ns}.data /= #10000 {ns}.data
scoreboard players operation #p {ns}.data *= #-2 {ns}.data
scoreboard players operation #p {ns}.data += #30000 {ns}.data
scoreboard players operation #p {ns}.data *= #q {ns}.data
scoreboard players operation #p {ns}.data /= #10000 {ns}.data
""")
