
#> cinemalya:v1.0.2/travel/sample/catmull_rom
#
# @within	cinemalya:v1.0.2/travel/sample/main
#

data modify storage bs:in spline.sample_catmull_rom set from storage cinemalya:work control
function #bs.spline:sample_catmull_rom
data modify storage cinemalya:work samples set from storage bs:out spline.sample_catmull_rom

data modify storage bs:in spline.sample_catmull_rom set from storage cinemalya:work rot_control
function #bs.spline:sample_catmull_rom
data modify storage cinemalya:work rot_samples set from storage bs:out spline.sample_catmull_rom

