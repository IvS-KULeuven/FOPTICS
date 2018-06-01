## FOPTICS: Hierarchical Density-Based Clustering of Uncertain Data

### Installation

- Execute 'make clean' on the command line
- Execute 'make' on the command line
- An executable 'foptics' will be produced in the same folder as the Makefile

### How to run 

./foptics arg1 arg2 arg3 arg4 arg5

where

- arg1 is the input directory (e.g., InputDirectory/). This directory contains files with object IDs and attributes
- arg2 gives the output file where the object order, object ID, and reachability distance (in this order) are stored (e.g., OutputFile.txt)
- arg3 defines the number of attributes to be used (e.g., 7)
- arg4 defines the value of undefined distance (any large number, e.g., 99)
- arg5 specifies the minimum number of objects in the neighbourhood (e.g., 30)
