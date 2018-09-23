#!/usr/bin/env bash
# manage interfaces so destroy or create them
maxbridge="40"
maxtap="100"
if [ $# -eq 0 ]; then
	echo "no parameter given. please specify. create or destroy."
	exit 1
fi
source bridgetaprel.bash
if [ $1 == "create" ]; then
	> currentnetwork
	for bridgenumber in $(seq 1 ${maxbridge}); do 
		ifconfig bridge${bridgenumber} create
	done
	for nodeindex in $(seq 1 ${maxnode}); do
		# first of all, get all the bridge names that are relevant for the current node
		currentnode="n${nodeindex}"
		for currentbridgenumber in $(echo "${!currentnode}"); do
			currenttap=$(ifconfig tap create)
			ifconfig bridge${currentbridgenumber} addm ${currenttap}
			echo "Node n${nodeindex} has ${currenttap} on bridge${currentbridgenumber}" >> currentnetwork
		done
	done
	# ergebnis
	# ifconfig tap create und das in variable einlesen
	# ifconfig bridge6 addm <<eingelesenen Wert>>
else
	for bridgenumber in $(seq 1 ${maxbridge}); do 
		ifconfig bridge${bridgenumber} destroy
	done
	for tapindex in $(seq 0 ${maxtap}); do
		ifconfig tap${tapindex} destroy
	done
	> currentnetwork
fi
