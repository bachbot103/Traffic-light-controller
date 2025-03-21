onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /traffic_light_controller_TB/clk
add wave -noupdate /traffic_light_controller_TB/reset_n
add wave -noupdate /traffic_light_controller_TB/enable
add wave -noupdate /traffic_light_controller_TB/leds_EW
add wave -noupdate /traffic_light_controller_TB/leds_SN
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_EU
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_ET
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_WU
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_WT
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_SU
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_ST
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_NU
add wave -noupdate -radix unsigned /traffic_light_controller_TB/uut/ccount_NT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {212999998356 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {212999997948 ns} {213000000109 ns}
