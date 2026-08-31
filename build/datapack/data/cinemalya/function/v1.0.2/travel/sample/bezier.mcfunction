
#> cinemalya:v1.0.2/travel/sample/bezier
#
# @within	cinemalya:v1.0.2/travel/sample/main
#

data modify storage bs:in spline.sample_bezier set from storage cinemalya:work control
function #bs.spline:sample_bezier
data modify storage cinemalya:work samples set from storage bs:out spline.sample_bezier

data modify storage bs:in spline.sample_bezier set from storage cinemalya:work rot_control
function #bs.spline:sample_bezier
data modify storage cinemalya:work rot_samples set from storage bs:out spline.sample_bezier

