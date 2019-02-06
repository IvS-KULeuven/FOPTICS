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

### Examples

A couple of data sets are provided as examples (see the directory of the same name) to run the light curve analysis and attribute calculation codes. These are:

- `SimulatedBinariesGammaDor`: simulated light curves of a total of 300 eclipsing binaries and 500 gamma Dor-type pulsators.
- `KeplerBinariesGammaDor`: Kepler light curves of some 70 gamma Dor-type pulsators from Van Reeth et al. (2015, ApJS, 2018, 27) and some 50 eclipsing binaries randomly selected from the Kepler Eclipsing Binary Catalogue.

By executing the entire sequence `Light_Curve_Analysis` --> `Attribute_transformation` --> `AttributeSelection` on either of these data sets, an input list of attributes required for classification with the FOPTICS algorithm will be obtained. These lists are made available in the `Examples` folder accompanying the FOPTICS sources.