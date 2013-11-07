# Filename: CoordTransform.py
# Author: Morgan Wall
# Date: 7-11-2013
#
# A rough script used to convert text files of coordinate values 
# into compatible plist files (for Xcode).

from xml.etree.ElementTree import *
from string import *
import os

X_INDEX = 0
Y_INDEX = 1
REL_TRANSFORM = 0.5

plist_header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
	+ "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" " \
	+ "\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"

def CoordTransform(point, width, height):
	transformPoint = (point[X_INDEX] / width * REL_TRANSFORM), \
		(point[Y_INDEX] / height * REL_TRANSFORM)
	return transformPoint

def XMLCoordFileWriter(directory, filename, points, row, column):
	top_x = Element('plist', version="1.0")
	top_y = Element('plist', version="1.0")

	array_x = SubElement(top_x, 'array')
	array_y = SubElement(top_y, 'array')

	for point in points:
		xChild = SubElement(array_x, 'real')
		xChild.text = str(point[X_INDEX])
		yChild = SubElement(array_y, 'real')
		yChild.text = str(point[Y_INDEX])

	xCoordFilename = directory + filename + "_x_" + str(row) + str(column) + ".plist";
	xCoordFile = open(xCoordFilename, 'w')
	xCoordFile.write(plist_header + tostring(top_x))
	xCoordFile.close()

	yCoordFilename = directory + filename + "_y_" + str(row) + str(column) + ".plist";
	yCoordFile = open(yCoordFilename, 'w')
	yCoordFile.write(plist_header + tostring(top_y))
	yCoordFile.close()

def CoordFileParser(coordDirectory, transformDirectory, filename):
	transformPoints = []
	coordFile = open(coordDirectory + filename, 'r')

	row = -1
	column = -1

	# extract image dimensions
	parsedDimensions = split(strip(coordFile.readline(), '/'), ',')
	width = atof(parsedDimensions[0])
	height = atof(parsedDimensions[1])

	# extract and transform points in file
	for line in coordFile:
		if (line.strip()):
			if (line[0] != "/" or line[1] == "/"):
				if (line[1] == "/"):
					if (row != -1 and column != -1):
						XMLCoordFileWriter(transformDirectory, 
							split(filename, '.')[0], transformPoints, row, 
							column)
						transformPoints = []

					words = split(strip(line, '/'), ",")
					row = atoi(words[0])
					column = atoi(words[1])
				else:
					line = strip(line, '\n')
					words = split(line, ", ")
					point = atof(words[0]), atof(words[1])
					transformPoints.append(CoordTransform(point, width, height))		

	coordFile.close()

	if (len(transformPoints) != 0):
		XMLCoordFileWriter(transformDirectory, split(filename, '.')[0], 
			transformPoints, row, column)

def CoordDirectoryParser(coordDirectory, transformDirectory):
	fileListing = os.listdir(coordDirectory)

	if (not os.path.exists(transformDirectory)):
		os.makedirs(transformDirectory)

	for currentFile in fileListing:
		if ((currentFile[0] != '.') \
				and (not os.path.isdir(coordDirectory + currentFile))):
			CoordFileParser(coordDirectory, transformDirectory, currentFile)

CoordDirectoryParser("Coordinate Files/", "Coordinate Files/Transformed Coordinate Files/")