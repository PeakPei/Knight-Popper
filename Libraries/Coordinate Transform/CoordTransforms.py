# Filename: CoordTransform.py
# Author: Morgan Wall
# Date: 7-11-2013

from xml.etree.ElementTree import *
from string import *
import os

X_INDEX = 0
Y_INDEX = 1
REL_TRANSFORM = 0.5

def CoordTransform(point, width, height):
	transformPoint = (point[X_INDEX] / width * REL_TRANSFORM), \
		(point[Y_INDEX] / height * REL_TRANSFORM)
	return transformPoint

def XMLCoordFileWriter(directory, filename, points):
	top_x = Element('array')
	top_y = Element('array')

	for point in points:
		xChild = SubElement(top_x, 'real')
		xChild.text = str(point[X_INDEX])
		yChild = SubElement(top_y, 'real')
		yChild.text = str(point[Y_INDEX])

	xCoordFile = open(directory + filename + '_x' + '.xml', 'w')
	xCoordFile.write(tostring(top_x))
	xCoordFile.close()

	yCoordFile = open(directory + filename + '_y' +'.xml', 'w')
	yCoordFile.write(tostring(top_y))
	yCoordFile.close()

def CoordFileParser(coordDirectory, transformDirectory, filename):
	transformPoints = []
	coordFile = open(coordDirectory + filename, 'r')

	# extract image dimensions
	parsedDimensions = split(strip(coordFile.readline(), '/'), ',')
	width = atof(parsedDimensions[0])
	height = atof(parsedDimensions[1])

	# extract and transform points in file
	for line in coordFile:
		if (line.strip()):
			if (line[0] != "/"):
				line = strip(line, '\n')
				words = split(line, ", ")
				point = atof(words[0]), atof(words[1])
				transformPoints.append(CoordTransform(point, width, height))		

	coordFile.close()

	XMLCoordFileWriter(transformDirectory, split(filename, '.')[0], transformPoints)

def CoordDirectoryParser(coordDirectory, transformDirectory):
	fileListing = os.listdir(coordDirectory)

	if (not os.path.exists(transformDirectory)):
		os.makedirs(transformDirectory)

	for currentFile in fileListing:
		if ((currentFile[0] != '.') \
				and (not os.path.isdir(coordDirectory + currentFile))):
			CoordFileParser(coordDirectory, transformDirectory, currentFile)

CoordDirectoryParser("Coordinate Files/", "Coordinate Files/Transformed Coordinate Files/")