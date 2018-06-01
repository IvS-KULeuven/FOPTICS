## FOPTICS: Hierarchical Density-Based Clustering of Uncertain Data

### Installation

- Execute `make clean` on the command line
- Execute `make` on the command line
- An executable 'foptics' will be produced in the same folder as the Makefile

### How to run 

`/foptics arg1 arg2 arg3 arg4 arg5`

where

- arg1: the input directory (e.g., InputDirectory/). This directory contains files with object IDs and attributes
- arg2: the output file where the object order, object ID, and reachability distance (in this order) are stored (e.g., OutputFile.txt)
- arg3: the number of attributes to be used (e.g., 7)
- arg4: the value of undefined distance (any large number, e.g., 99)
- arg5: the minimum number of objects in the neighbourhood (e.g., 30)

### References

- How to reference this code: TBW
- Ankerst et al., 1999, *OPTICS: Ordering points to identify the clustering structure*
- Kriegel H.-P. and Pfeifle M., 2005, *Hierarchical density-based clustering of uncertain data*
