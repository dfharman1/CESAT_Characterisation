#! /usr/bin/bash

# Source the vivado script
#source /tools/Xilinx/Vivado/2020.2/settings.sh

# Run the script to create the tcl script to regenerate a working copy of the Pentek base design
# Already in the scripts directory
vivado -mode batch -source recreateBaseDesign.tcl

# Clear the working directory
echo "Work directory does not exist, creating it..."
mkdir -p -- ../work

# Clear the contents of the working directory
cd ../work
rm -r *

# Recreate the Vivado script from the project
vivado -mode batch -source ../scripts/createPentekBaseDesign.tcl -tclargs --origin_dir ../scripts

# Copy over the bitworkaround file to the new project directory - this shouldn't be required!
echo "Copying over bitworkaround.tcl..."
cp ../pentekBaseDesign/bitworkaround.tcl ../work/bitworkaround.tcl

# Remove the generated script and all journal/log files
rm ../scripts/createPentekBaseDesign.tcl
rm ../scripts/*.jou
rm ../scripts/*.log

# Now we can open the copied design and run builds
vivado -mode batch -source 
