onerror {resume}
quietly WaveActivateNextPane {} 0

radix define States {
    "7'b1000000" "0" -color "magenta",
    "7'b1111001" "1" -color "magenta",
    "7'b0100100" "2" -color "magenta",
    "7'b0110000" "3" -color "magenta",
    "7'b0011001" "4" -color "magenta",
    "7'b0010010" "5" -color "magenta",
    "7'b0000010" "6" -color "magenta",
    "7'b1111000" "7" -color "magenta",
    "7'b0000000" "8" -color "magenta",
    "7'b0011000" "9" -color "magenta",
    "7'b0001000" "A" -color "magenta",
    "7'b0000011" "B" -color "magenta",
    "7'b1000110" "C" -color "magenta",
    "7'b0100001" "D" -color "magenta",
    "7'b0000110" "E" -color "magenta",
    "7'b0001110" "F" -color "magenta",
    -default default
}

# Add wave lines here...  i.e. add wave -noupdate -colorhsl(300, 82.10%, 56.30%) /tb/led_output
add wave -noupdate /tlde_bench/uut/clk
add wave -noupdate /tlde_bench/uut/reset
add wave -noupdate /tlde_bench/enter_btn 
add wave -radix unsigned -noupdate /tlde_bench/switch_in
add wave -radix States -noupdate /tlde_bench/hex_out(2) 
add wave -radix States -noupdate /tlde_bench/hex_out(1) 
add wave -radix States -noupdate /tlde_bench/hex_out(0) 

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {175 ns} {275 ns}
run 4000 ns