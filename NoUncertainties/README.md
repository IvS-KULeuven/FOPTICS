## Light curve analysis and parametrisation

No light curve perturbation is possible in this implementation, hence feature uncertainties are ignored when these modules are coupled with the clustering algorithm for variability classification

### Individual (software) components (configuration and Makefile(s) reside in the `Config` folder)

- `Light_Curve_Analysis` module performs frequency extraction from time-series of stellar brightness variations by means of the Lomb-Scargle method. Number of frequencies, N\_f, and their harmonics, N\_h, to be extracted is optional; basic correction of light curves in time domain is also possible. 
- `Attribute_transformation` module transforms light curve parameters into physical/statistical quantities that can be used for classification purposes.
- `AttributeSelection` module allows for selection of a sub-set of attributes to be immediately used in the FOPTICS classification algorithm

### Installation

`Config` directory contains Makefile for each of the three modules. Corresponding Makefile needs to be copied to the folder of the module of interest; compilation is done by executing `make -f Makefile_XXX` on the command line, where `XXX` stands for the module in question (e.g., Makefile_LCAnalysis)

### Running

To run the module of interest, execute `./executable_name config_file` on the command line. For example, light curve analysis module is ran with the `./LCAnalysis LightCurveAnalysis.config` assuming configuration file is in the same folder with the binary file (otherwise, path to the configuration file has to be included).