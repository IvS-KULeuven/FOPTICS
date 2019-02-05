## Light curve analysis and parametrisation; stellar variability unsupervised classification

A bunch of software packages for detailed analysis of time series of stellar brightness variations (=light curves) by means of the Lomb-Scargle periodogram; parametric description of light curves through a set of features (=attributes) that can further be used for unsupervised classification according to the type of stellar variability

### Light curve analysis and parametrisation

Two implementations are available up until now:

- `NoUncertainties`: each light curve is parameterised through a sequence of features that are further used for classification by means of the FOPTICS clustering algorithm. Classification features have no uncertainties assigned to them in this particular implementation (standard practice in the classification business)
- `Uncertainties`: each data point of a given light curve is perturbed within the uncertainties claimed for that data point. The result is a perturbed light curve and the number of such perturbations, N, is to be defined by the user. The net result is that each stellar object is assigned N number perturbed light curves which are in turn parametrised the same way as in the `NoUncertainties` case. This allows to assign uncertainties to classification features and the clustering algorithm takes these uncertainties into account during the classification process. This particular implementation has two options, single- and multi-CPU running mode, where parallelisation is realised by means of the OpenMPI distribution. This implementation is currently being tested against compatibility with the GNU Fortran compiler and is available in the "develop" branch only. 

### FOPTICS: Hierarchical Density-Based Clustering of Uncertain Data

Unsupervised clustering classification algorithm that assigns stellar objects to a particular class of variable stars by using light curve parameterisation (with or without uncertainties) as an input.