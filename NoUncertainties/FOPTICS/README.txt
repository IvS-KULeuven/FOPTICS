------ Compilation ------

Two commands need to be executed to compile the code: do "make clean" first and "make" afterwards. "foptics" executable will be produced in the same directory where the sources and Makefile are located. Any time the sources code is changed by the user, the sequence “make clean“ & “make” needs to be repeated to re-compile the code.

------ Running ------

The code is ran with the following command:

./foptics arg1 arg2 arg3 arg4 arg5

where arg1 refers to the input directory (e.g., InputDirectory/). This directory contains files with object IDs and attributes
      arg2 gives the output file where the object order, object ID, and reachability distance (in this order) are stored (e.g., OutputFile.txt)
      arg3 defines the number of attributes to be used (e.g., 7)
      arg4 defines the value of undefined distance (any large number, e.g., 99)
      arg5 specifies the minimum number of objects in the neighbourhood (e.g., 30)