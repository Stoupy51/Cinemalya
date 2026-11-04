
#> cinemalya:v1.1.0/travel/frames/shared_span
#
# @within	cinemalya:v1.1.0/travel/frames/read_duration
#
# @description		A segment without a duration ends where its length takes it at the shared pace.
# 				The last of them ends exactly on the shared time, so rounding never stretches the travel.
#

scoreboard players operation #shared_done cinemalya.data += #seg_length cinemalya.data
scoreboard players operation #seg_span cinemalya.data = #shared_done cinemalya.data
scoreboard players operation #seg_span cinemalya.data *= #pace cinemalya.data
scoreboard players operation #seg_span cinemalya.data /= #10000 cinemalya.data
execute if score #shared_done cinemalya.data >= #shared_length cinemalya.data run scoreboard players operation #seg_span cinemalya.data = #shared_time cinemalya.data
scoreboard players operation #seg_span cinemalya.data -= #shared_spent cinemalya.data
scoreboard players operation #shared_spent cinemalya.data += #seg_span cinemalya.data

