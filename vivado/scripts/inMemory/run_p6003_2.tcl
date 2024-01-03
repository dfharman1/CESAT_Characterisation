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

run_script p6003_2.tcl run_p6003_2
