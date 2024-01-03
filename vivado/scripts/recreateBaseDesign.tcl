# Run this script in vivado to write out the project script for the original Pentek design

# Name of script to generate
set scriptName "createPentekBaseDesign.tcl"

# Pentek base project
set baseProject "../pentekBaseDesign/p6003_2.xpr"

# Set the directory for the project and script to be written out to
set newProjectDir "../work"

# Open the base Pentek project
puts "Opening $baseProject"
open_project $baseProject

# Run the tcl command to write the tcl project script
puts "Writing tcl script to regenerate Pentek base design..."
write_project_tcl -force -target_proj_dir $newProjectDir -quiet $scriptName

# Close the project
puts "Finished writing script, closing project..."
close_project




#  Start Vivado in tcl mode and execute following commands:
#    % open_project test/test.xpr
#    % write_project_tcl -force recreate.tcl
#    % close_project
#    % exit
#
#  From OS shell:
#    # mkdir my_test
#    # cd my_test
#    # vivado -mode batch -source ../recreate.tcl -tclargs --origin_dir ..
#
#  Start Vivado in tcl mode and execute following commands:
#    % open_project test/test.xpr 
#    % get_files -of_objects [get_filesets sources_1]
#    % report_property [current_project]
#    % close_project
