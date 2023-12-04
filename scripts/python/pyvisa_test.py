import pyvisa
import matplotlib.pyplot as plt

sigAn_N9042B = 'TCPIP0::10.40.29.202::hislip0::INSTR'

# Find the signal analyser
rm = pyvisa.ResourceManager()
print(rm)
print("Searching for the N9042B Signal Analyser...")
rm.list_resources()
inst = rm.open_resource(sigAn_N9042B)
print(inst.query("*IDN?"))

# Set a list of queries to apply to get the configuration of the SA
cmds = ['INST:CAT?', \
        'SYST:APPL?', \
        'SYST:APPL:REV?']
# Print out the results of the commands
for cmd in cmds:
	print(inst.query(cmd))

# Set the centre frequency
inst.write('FREQ:CENT 100e6')
print("Centre frequency set to {}".format(inst.query('FREQ:CENT?')))
# Set the start frequency
inst.write('FREQ:STAR 0 MHz')
print("Start frequency set to {}".format(inst.query('FREQ:STAR?')))
# Set the frequency span
inst.write('FREQ:SPAN 1 GHz')
print("Frequency span set to {}".format(inst.query('FREQ:SPAN?')))

# Capture the data from the SA
inst.write(':TRAC:CLE TRACE1')
data = inst.query(':MEAS:SAN?')
datasplit = data.split(",")
datafloat = []
for item in datasplit:
	datafloat.append(float(item))
print(datafloat[0:10])
x, y = datafloat[::2], datafloat[1::2]
print("The data returned has length {}".format(len(data)))
# Write to a file on the SA

# Transfer the data from the SA

# Plot the data using pyplot
#plt.plot([1, 2, 3, 4])
plt.plot(x, y)
plt.show()
