# Imports
from stewbeet import write_versioned_function

from ..limits import (
	FRAME_COST,
	LAUNCH_BUDGET,
	MIN_SAMPLING_STEP,
	SAMPLE_COST,
	WAYPOINT_COST,
)


def write_sampling(ns: str, version: str) -> None:
	""" Run the control points through Bookshelf's spline sampler. """
	write_versioned_function("travel/sample/main", f"""
#> main
#
# @output storage	{ns}:work samples, {ns}:work rot_samples
# @output score		#last {ns}.data
#
# @description		Sample the curve into a polyline about as fine as the frames. Frames are interpolated
#					between samples, so a denser one would only cost more commands.
#

## One sample per frame, or fewer when the frames and waypoints leave less of the launch budget
scoreboard players operation #frames {ns}.data = #duration {ns}.data
scoreboard players operation #frames {ns}.data /= #smoothing {ns}.data
scoreboard players set #samples {ns}.data {LAUNCH_BUDGET}
scoreboard players operation #n {ns}.data = #frames {ns}.data
scoreboard players operation #n {ns}.data *= #{FRAME_COST} {ns}.data
scoreboard players operation #samples {ns}.data -= #n {ns}.data
scoreboard players operation #n {ns}.data = #count {ns}.data
scoreboard players operation #n {ns}.data *= #{WAYPOINT_COST} {ns}.data
scoreboard players operation #samples {ns}.data -= #n {ns}.data
scoreboard players operation #samples {ns}.data /= #{SAMPLE_COST} {ns}.data
execute if score #samples {ns}.data > #frames {ns}.data run scoreboard players operation #samples {ns}.data = #frames {ns}.data
execute if score #samples {ns}.data matches ..32 run scoreboard players set #samples {ns}.data 32
execute if score #samples {ns}.data matches 400.. run scoreboard players set #samples {ns}.data 400

## Sampling step, in millionths, spread over the whole curve
# The floor is what keeps the sampler terminating: Bookshelf reads the step back as an int, so a smaller
# one arrives as zero, never advances, and recurses on the same point until the watchdog kills the server.
scoreboard players operation #step {ns}.data = #segments {ns}.data
scoreboard players operation #step {ns}.data *= #1000000 {ns}.data
scoreboard players operation #step {ns}.data /= #samples {ns}.data
execute if score #step {ns}.data matches ..{MIN_SAMPLING_STEP} run scoreboard players set #step {ns}.data {MIN_SAMPLING_STEP}
execute store result storage {ns}:work control.step double 0.000001 run scoreboard players get #step {ns}.data
data modify storage {ns}:work rot_control.step set from storage {ns}:work control.step

execute if score #curve {ns}.data matches 0 run function {ns}:v{version}/travel/sample/bezier
execute if score #curve {ns}.data matches 1 run function {ns}:v{version}/travel/sample/catmull_rom

## Land exactly on the destination, whatever the sampler's own last step happened to be
data modify storage {ns}:work samples append from storage {ns}:work args.waypoints[-1].pos
data modify storage {ns}:work rot_samples append from storage {ns}:work args.waypoints[-1].rot

## Trust the sampler's output length rather than the requested step
execute store result score #last {ns}.data run data get storage {ns}:work samples
scoreboard players remove #last {ns}.data 1
execute if score #last {ns}.data matches ..0 run scoreboard players set #last {ns}.data 0
function {ns}:v{version}/travel/sample/measure
""")

	write_versioned_function("travel/sample/measure", f"""
#> measure
#
# @output storage	{ns}:work lengths : the arc length from the start to every sample, in hundredths of a block
# @output storage	{ns}:work bounds : the same at every waypoint
# @output score		#shared_length, #shared_count {ns}.data : the length and number of segments without a duration
#
# @description		Every sample interval also counts one hundredth, so a camera turning on the spot still
#					moves through its samples instead of sitting on a path of length zero.
#

data modify storage {ns}:work measure set from storage {ns}:work samples
data modify storage {ns}:work lengths set value [0]
data modify storage {ns}:work bounds set value [0]
scoreboard players set #length {ns}.data 0
scoreboard players set #bound_length {ns}.data 0
scoreboard players set #shared_length {ns}.data 0
scoreboard players set #shared_count {ns}.data 0
scoreboard players set #root {ns}.data 1
scoreboard players set #i {ns}.data 0
scoreboard players set #k {ns}.data 0
function {ns}:v{version}/travel/sample/next_bound
execute store result score #prev_x {ns}.data run data get storage {ns}:work measure[0][0] 100
execute store result score #prev_y {ns}.data run data get storage {ns}:work measure[0][1] 100
execute store result score #prev_z {ns}.data run data get storage {ns}:work measure[0][2] 100
execute if data storage {ns}:work measure[1] run function {ns}:v{version}/travel/sample/measure_step
""")

	write_versioned_function("travel/sample/measure_step", f"""
execute store result score #delta_x {ns}.data run data get storage {ns}:work measure[1][0] 100
execute store result score #delta_y {ns}.data run data get storage {ns}:work measure[1][1] 100
execute store result score #delta_z {ns}.data run data get storage {ns}:work measure[1][2] 100
scoreboard players operation #delta_x {ns}.data -= #prev_x {ns}.data
scoreboard players operation #delta_y {ns}.data -= #prev_y {ns}.data
scoreboard players operation #delta_z {ns}.data -= #prev_z {ns}.data
scoreboard players operation #prev_x {ns}.data += #delta_x {ns}.data
scoreboard players operation #prev_y {ns}.data += #delta_y {ns}.data
scoreboard players operation #prev_z {ns}.data += #delta_z {ns}.data
scoreboard players operation #delta_x {ns}.data *= #delta_x {ns}.data
scoreboard players operation #delta_y {ns}.data *= #delta_y {ns}.data
scoreboard players operation #delta_z {ns}.data *= #delta_z {ns}.data
scoreboard players operation #sq {ns}.data = #delta_x {ns}.data
scoreboard players operation #sq {ns}.data += #delta_y {ns}.data
scoreboard players operation #sq {ns}.data += #delta_z {ns}.data
execute if score #sq {ns}.data matches 1.. run function {ns}:v{version}/travel/sample/root
scoreboard players add #length {ns}.data 1
data modify storage {ns}:work lengths append value 0
execute store result storage {ns}:work lengths[-1] int 1 run scoreboard players get #length {ns}.data

data remove storage {ns}:work measure[0]
scoreboard players add #i {ns}.data 1
execute if score #next {ns}.data <= #i {ns}.data run function {ns}:v{version}/travel/sample/bound
execute if data storage {ns}:work measure[1] run function {ns}:v{version}/travel/sample/measure_step
""")

	write_versioned_function("travel/sample/root", f"""
#> root
#
# @input score		#sq {ns}.data : the squared length of a sample interval
# @output score		#length {ns}.data : grown by that interval's length, its integer square root
#
# @description		Newton's method, seeded with the previous interval's root since neighbours are close.
#					Its first step lands above the root from any seed, then the rest fall onto it from above.
#

scoreboard players operation #quot {ns}.data = #sq {ns}.data
scoreboard players operation #quot {ns}.data /= #root {ns}.data
scoreboard players operation #root {ns}.data += #quot {ns}.data
scoreboard players operation #root {ns}.data /= #2 {ns}.data
function {ns}:v{version}/travel/sample/root_descend
scoreboard players operation #length {ns}.data += #root {ns}.data
""")

	write_versioned_function("travel/sample/root_descend", f"""
scoreboard players operation #quot {ns}.data = #sq {ns}.data
scoreboard players operation #quot {ns}.data /= #root {ns}.data
scoreboard players operation #quot {ns}.data += #root {ns}.data
scoreboard players operation #quot {ns}.data /= #2 {ns}.data
execute unless score #quot {ns}.data < #root {ns}.data run return 0
scoreboard players operation #root {ns}.data = #quot {ns}.data
function {ns}:v{version}/travel/sample/root_descend
""")

	write_versioned_function("travel/sample/next_bound", f"""
#> next_bound
#
# @output score		#next {ns}.data : the sample standing for waypoint #k, splitting the samples evenly between segments
#

scoreboard players add #k {ns}.data 1
scoreboard players operation #next {ns}.data = #k {ns}.data
scoreboard players operation #next {ns}.data *= #last {ns}.data
scoreboard players operation #n {ns}.data = #segments {ns}.data
scoreboard players operation #n {ns}.data /= #2 {ns}.data
scoreboard players operation #next {ns}.data += #n {ns}.data
scoreboard players operation #next {ns}.data /= #segments {ns}.data
""")

	write_versioned_function("travel/sample/bound", f"""
#> bound
#
# @description		Record the arc length at waypoint #k, then look for the next one, which may share this sample.
#

execute store result storage {ns}:work sel.i int 1 run scoreboard players get #k {ns}.data
function {ns}:v{version}/travel/sample/count_shared with storage {ns}:work sel
data modify storage {ns}:work bounds append value 0
execute store result storage {ns}:work bounds[-1] int 1 run scoreboard players get #length {ns}.data
scoreboard players operation #bound_length {ns}.data = #length {ns}.data
function {ns}:v{version}/travel/sample/next_bound
execute if score #next {ns}.data <= #i {ns}.data run function {ns}:v{version}/travel/sample/bound
""")

	write_versioned_function("travel/sample/count_shared", f"""
#> count_shared
#
# @input macro		i : int - the waypoint ending the segment just measured
#

$execute if data storage {ns}:work args.waypoints[$(i)].duration run return 0
scoreboard players add #shared_count {ns}.data 1
scoreboard players operation #shared_length {ns}.data += #length {ns}.data
scoreboard players operation #shared_length {ns}.data -= #bound_length {ns}.data
""")

	write_versioned_function("travel/sample/bezier", f"""
data modify storage bs:in spline.sample_bezier set from storage {ns}:work control
function #bs.spline:sample_bezier
data modify storage {ns}:work samples set from storage bs:out spline.sample_bezier

data modify storage bs:in spline.sample_bezier set from storage {ns}:work rot_control
function #bs.spline:sample_bezier
data modify storage {ns}:work rot_samples set from storage bs:out spline.sample_bezier
""")

	write_versioned_function("travel/sample/catmull_rom", f"""
data modify storage bs:in spline.sample_catmull_rom set from storage {ns}:work control
function #bs.spline:sample_catmull_rom
data modify storage {ns}:work samples set from storage bs:out spline.sample_catmull_rom

data modify storage bs:in spline.sample_catmull_rom set from storage {ns}:work rot_control
function #bs.spline:sample_catmull_rom
data modify storage {ns}:work rot_samples set from storage bs:out spline.sample_catmull_rom
""")

