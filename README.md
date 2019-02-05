## Software package for parameterisation of stellar light curves and classification of stars according to type of their variability by means of unsupervised clustering algorithm

### Light curve analysis and parametrisation

Two implementations are available up until now:

- `NoUncertainties`: each light curve is parameterised through a sequence of features that are further used for classification by means of the FOPTICS clustering algorithm. Classification features have no uncertainties assigned to them in this particular implementation (standard practice in classification business)
- `Uncertainties`: each data point of a given light curve is perturbed within the uncertainties claimed for that data point. The result is a perturbed light curve and the number of such perturbations, N, is to be defined by the user. The net result is that each stellar object is assigned N perturbed light curves which are in turn parametrised the same way as in the `NoUncertainties` case. This allows to assign uncertainties to classification features and the clustering algorithm takes these uncertainties into account during the classification process. This particular implementation has two options, single- and multi-CPU running mode, where parallelisation is realised by means of OpenMPI.

### FOPTICS: Hierarchical Density-Based Clustering of Uncertain Data

Unsupervised clustering classification algorithm that assigns stellar objects to a particular class of variable stars by using light curve parameterisation (with or without uncertainties) as an input.