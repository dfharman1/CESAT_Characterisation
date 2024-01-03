import pyvisa
import matplotlib.pyplot as plt

sigAn_N9042B = 'TCPIP0::10.40.29.202::hislip0::INSTR'

# Create a list of commands to initialise the signal analyser
init_cmds = [
'*CLS', \
'*RST', \
':CONF:SAN1']
# Create a list of commands to setup the signal analyser
setup_cmds = [
':TRAC:CLE:ALL', \
':SENS:FREQ:STAR 0 GHz', \
':SENS:FREQ:STOP 2 GHz', \
':SENS:BAND:RES 10 KHz', \
':SENS:AVER:COUN 1000', \
':SENS:CHP:SWE:POIN 10000']
# Create a list of commands to perform the measurement
measure_cmds = [
':INIT:CONT ON', \
':INIT:SAN1', \
'*WAI', \
':INIT:CONT OFF']

# Command to get the data from the signal analyser
get_cmd = ':FETC:SAN1?'

# Find the signal analyser
rm = pyvisa.ResourceManager()
print(rm)
print("Searching for the N9042B Signal Analyser...")
rm.list_resources()
inst = rm.open_resource(sigAn_N9042B)
print(inst.query("*IDN?"))

# Print out the results of the commands
for cmd in init_cmds + setup_cmds + measure_cmds:
	inst.write(cmd)

print(inst.query(':ACP:BAND:VID?'))

# Get the data from the measurement
data = inst.query(get_cmd)
print("Length of data is {}".format(len(data)))


# Convert to amplitude and time
data_f = []
for item in data.split(","):
	data_f.append(float(item))
x, y = data_f[::2], data_f[1::2]

# Plot the data using pyplot
plt.plot(x, y)
plt.show()
