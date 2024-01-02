# Run this script in vivado to write out the project script for the original Pentek design

# Name of script to generate
set scriptName "./createOriginalDesign.tcl"

# Change directory to the directory containing this script
cd [file normalize [file dirname [info script]]]
puts "Changed to directory [pwd]"

# Set the directory for the project to be written out to
set newProjectDir "~/git/CESAT_Characterisation/hw/vivado"

# Open the base Pentek project
open_project "/home/fpga/Pentek/fdk/2020.2/p6003_2_37_151/6003_2.xpr"

# Run the tcl command to write the tcl project script
write_project_tcl -force -absolute_path -target_proj_dir $newProjectDir $scriptName

# Close the project
close_project


