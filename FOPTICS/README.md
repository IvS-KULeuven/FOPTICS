## FOPTICS: Hierarchical Density-Based Clustering of Uncertain Data

Both the source code and a few examples of running the FOPTICS algorithm on simulated and real data are provided. Examples include:

- simulated attributes in 2D parameter space that are directly passed to the algorithm for clustering purposes; these examples are not directly related to stellar astrophysics, instead just illustrate performance of the algorithm for (close to) ideal cases.
- simulated light curves of eclipsing binaries and gravity-mode pulsators. This is a realistic astrophysical example where the light curves are first analysed by means of the Lomb-Scargle periodogram, the corresponding Fourier coefficients are transformed into classification attributes that are ultimately passed to the FOPTICS algorithm for classification.
- Kepler light curves of some 70 well-characterised gamma Dor-type pulsators and some 50 eclipsing binaries randomly selected from the Kepler Eclipsing Binary Catalogue. The analysis sequence is just the same as for the simulated light curves above.