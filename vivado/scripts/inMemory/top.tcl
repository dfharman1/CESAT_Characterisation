# Create a directory if it doesn't already exist
proc make_directory { directoryName } {
  if { [file isdirectory $directoryName] } {
    file delete -force $directoryName 
    puts "Deleting existing directory $directoryName..."
  }
  file mkdir $directoryName
  puts "Creating directory $directoryName..."
}

# Procedure to create directory and run synthesis script in that directory
proc run_script { script_name working_dir } {
  make_directory $working_dir
  cd $working_dir
  source [file join ".." $script_name]
  cd ../
}



# List the synthesis directives
set synth_directives [list \
  default \
  RuntimeOptimized \
  AreaOptimized_high \
  AreaOptimized_medium \
  AlternateRoutability \
  AreaMapLargeShiftRegToBRAM \
  AreaMultThresholdDSP \
  FewerCarryChains \
  PerformanceOptimized \
  LogicCompaction]

# List the placement directives
set place_directives [list \
  Default \
  Auto1 \
  Auto2 \
  Auto3 \
  Explore \
  WLDrivenBlockPlacement \
  EarlyBlockPlacement \
  ExtraNetDelay_high \
  ExtraNetDelay_low \
  SSI_SpreadLogic_high \
  SSI_SpreadLogic_low \
  AltSpreadLogic_high \
  AltSpreadLogic_medium \
  AltSpreadLogic_low \
  ExtraPostPlacementOpt \
  ExtraTimingOpt \
  SSI_SpreadSLLs \
  SSI_BalanceSLLs \
  SSI_BalanceSLRs \
  SSI_HighUtilSLRs \
  Quick ]

# List the physical optimisation directives
set phys_opt_directives [list \
  Default \
  Explore \
  ExploreWithHoldFix \
  ExploreWithAggressiveHoldFix \
  AggressiveExplore \
  AlternateReplication \
  AggressiveFanoutOpt \
  AddRetime \
  AlternateFlowWithRetiming]

# List the route_directives
set route_directives [list \
  Default \
  Explore \
  AggressiveExplore \
  NoTimingRelaxation \
  MoreGlobalIterations \
  HigherDelayCost \
  RuntimeOptimized \
  AlternateCLBRouting \
  Quick]


# Set the project configuration parameters
set ::top p6003_2
set ::part "xczu47dr-ffvg1517-1-i"
set ::srcDir "/home/fpga/Pentek/fdk/2020.2/p6003_2_47_151/p6003_2.srcs/sources_1"
set ::constrsDir "/home/fpga/Pentek/fdk/2020.2/p6003_2_47_151/p6003_2.srcs/constrs_1"
set ::ipDir "/home/fpga/Pentek/ip"
set ::tempDir [pwd]

# Set up the project
source setup_source_cutdown.tcl

# Run Synthesis
set ::synth_directive default
run_script synth_cutdown.tcl synth_${::synth_directive}

set ::place_directive Auto1
set ::phys_opt_directive AggressiveFanoutOpt
set ::route_directive AggressiveExplore
run_script impl_cutdown.tcl impl_${::synth_directive}_${::place_directive}_${::phys_opt_directive}_${::route_directive}





## Iterate through the synthesis directives
#foreach syndirec $synth_directives {
#  set ::synth_directive $syndirec
#
#  # Run the synthesis
#  run_synth_script synth_cutdown.tcl synth_${syndirec}
#
#  # Iterate through the implementation directives
#  foreach podirec $phys_opt_directives {
#  
#    set ::phys_opt_directive $podirec
#
#    # Iterate through the implementation directives
#    foreach rtdirec $route_directives {
#
#      set ::route_directive $rtdirec
#
#      # Run the implementation
#      run_impl_script impl_cutdown.tcl impl_${podirec}_${rtdirec}
#    }
#  }
#}

exit
