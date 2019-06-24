## Gradient Clustering
The (F)OPTICS algorithm does not explicitly assign objects to clusters, but instead
provides an augmented ordering which can be plotted in a reachability diagram. This algorithm can be used to extract the clusters from this augmented ordering or reachability diagram, based on the gradients of the vectors.


### How to run

There are three separate functions in this library:

* `gradient_extraction(clusterordering, minpts, t, w)`, where *clusterordering* is a list of ClusterObjects as defined in the the code, *minpts* the minimum number of points required for a set to be considered a cluster (as in (F)OPTICS), *t* the angle between two adjacent vectors and *w* the width by which each object is separated in the ordering. The function returns a list of clusters where the individual items are represented as ClusterObjects.
* `large_cluster_filtering(clusters, input_size, cluster_ratio)`, where *clusters* is the output from gradient_extraction, *input_size* the total number of items that are clustered and *cluster_ratio* the maximum ratio of the cluster size w.r.t. the total data set size.
* `merge_clusters(clusters, similarity_ratio)`, where *clusters* is the output of gradient_extraction or large_cluster_filtering and *similarity_ratio* the minimum size of the intersection between two clusters in terms of the largest of the two in order for the two clusters to be merged together.


### References:
* S. Brecheisen, H.-P. Kriegel, P. Kroger, and M. Pfeifle. Visually mining through cluster hierarchies. In Society for Industrial and Applied Mathematics. Proceedings of the SIAM International Conference on Data Mining, pages 400–411, Philadelphia, 2004. Society for Industrial and Applied Mathematics
* D. Vida. Cyoptics clustering. https://github.com/dvida/cyoptics-clustering, 2018