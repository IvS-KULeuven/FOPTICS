## FOPTICS: Hierarchical Density-Based Clustering of Uncertain Data

### Installation

- Execute `make clean -f Makefile_FOPTICS` on the command line
- Execute `make -f Makefile_FOPTICS` on the command line
- An executable 'foptics' will be produced in the same folder as the Makefile

### How to run 

`/foptics arg1 arg2 arg3 arg4 arg5`

where

- arg1: file that holds the list of files with attributes (e.g., foptics_list)
- arg2: the output file where the final (column 1) and original (column 2) object order, object ID (column 3), reachability distance (column 4), and normalised reachability distance (column 5) are stored (e.g., OutputFile.txt). Reachability diagram is simply a plot of the final object order (column 1) versus normalised reachability distance (column 5). 
- arg3: the number of attributes to be used (e.g., 2)
- arg4: the value of undefined distance (any large number, e.g., 1)
- arg5: the minimum number of objects in the neighbourhood (e.g., 20)

### References

- How to reference this code: TBW
- Ankerst et al., 1999, *OPTICS: Ordering points to identify the clustering structure*
- Kriegel H.-P. and Pfeifle M., 2005, *Hierarchical density-based clustering of uncertain data*
