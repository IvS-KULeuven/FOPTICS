import numpy as np
import copy


class ClusterObject(object):
    def __init__(self, obj_order, obj_reach):
        self.obj_order = obj_order
        self.obj_reach = obj_reach


class GradientVector(object):
    def __init__(self, x, y, w):
        self.vector = np.array([[w], [y.obj_reach - x.obj_reach]])


class GradientMatrix(object):
    def __init__(self, gradient_vector1, gradient_vector2):
        self.matrix = np.concatenate((gradient_vector1.vector, gradient_vector2.vector), axis = 1)
        self.det = np.linalg.det(self.matrix)
        self.ii = (- self.matrix[0][0] ** 2 + ((-self.matrix[1][0]) * (self.matrix[1][1]))) / float(np.sqrt(self.matrix[:, [0]].T.dot(self.matrix[:, [0]])) * np.sqrt(self.matrix[:,[1]].T.dot(self.matrix[:,[1]])))


def gradient_extraction(clusterordering, minpts, t, w):
# Sources:
# S. Brecheisen, H.-P. Kriegel, P. Kroger, and M. Pfeifle. Visually mining through cluster hierarchies. In Society for Industrial and Applied Mathematics. Proceedings of the SIAM International Conference on Data Mining, pages 400–411, Philadelphia, 2004. Society for Industrial and Applied Mathematics
# D. Vida. Cyoptics clustering. https://github.com/dvida/cyoptics-clustering, 2018

    starting_points = []
    set_of_clusters = []
    current_cluster = []
    temp_cluster = []

    o = clusterordering[0]
    starting_points.append(o)

    t = np.cos(np.radians(t))

    ln = len(clusterordering)
    last_end_point = clusterordering[ln - 1]
    i = 1

    while i < ln - 1:
        o = clusterordering[i]

        gv1 = GradientVector(o, clusterordering[i - 1], w)
        gv2 = GradientVector(clusterordering[i + 1], o, w)
        gm = GradientMatrix(gv1, gv2)

        if i < ln - 1:
            if gm.ii > t: # check whether the object is an inflection point
                if gm.det > 0: # check whether the object is a starting point or first object outside a cluster
                    if len(current_cluster) >= minpts: # if it is the first object outside a cluster and it is large enough, add it to the set of clusters
                        set_of_clusters.append(current_cluster)

                    current_cluster = []

                    if starting_points:
                        if starting_points[-1].obj_reach < o.obj_reach: # if the reachability value of the last starting point < reachability value of current, the starting point is removed from the stack
                            starting_points.pop()

                    if starting_points:
                        while starting_points and starting_points[-1].obj_reach < o.obj_reach:
                            temp_cluster = clusterordering[starting_points[-1].obj_order:last_end_point.obj_order]

                            if len(temp_cluster) > minpts:
                                set_of_clusters.append(temp_cluster)

                            starting_points.pop()

                        if starting_points:
                            temp_cluster = clusterordering[starting_points[-1].obj_order:last_end_point.obj_order]

                        if len(temp_cluster) >= minpts:
                            set_of_clusters.append(temp_cluster)

                    if clusterordering[i + 1].obj_reach < o.obj_reach: # if the reachability distance goes down, the object is a starting point
                        starting_points.append(clusterordering[i])

                else: # the object is an end point of a cluster or second point inside a cluster
                    if clusterordering[i + 1].obj_reach > o.obj_reach: # if the reachability distance goes up, it is an end point
                        last_end_point = clusterordering[i + 1]
                        if starting_points:
                            current_cluster = clusterordering[starting_points[-1].obj_order:last_end_point.obj_order]

        else: # add clusters at the end of the plot
            while starting_points:
                current_cluster = clusterordering[starting_points[-1].obj_order:o.obj_order + 1]
                if starting_points[-1].obj_reach > o.obj_reach and len(current_cluster) >= minpts:
                    set_of_clusters.append(current_cluster)

                starting_points.pop()
        i += 1

    return set_of_clusters


def large_cluster_filtering(clusters, input_size, cluster_ratio):
# Source: D. Vida. Cyoptics clustering. https://github.com/dvida/cyoptics-clustering, 2018 (MIT License)

    filtered_clusters = []

    for i in clusters:
        if len(i) < cluster_ratio * input_size:
            filtered_clusters.append(i)

    return filtered_clusters


def merge_clusters(clusters, similarity_ratio):
# Source: D. Vida. Cyoptics clustering. https://github.com/dvida/cyoptics-clustering, 2018 (MIT License)

    clusters = sorted(clusters, key=len, reverse=True)

    prev_iterated_clusters = clusters
    merged_clusters = []

    while len(prev_iterated_clusters) != len(merged_clusters):

        clusters = sorted(clusters, key=len, reverse=True)
        skip_list = []
        prev_iterated_clusters = copy.deepcopy(merged_clusters)
        merged_clusters = []

        for i, cluster1 in enumerate(clusters):
            if i in skip_list:
                continue

            found_similar = False

            for j, cluster2 in enumerate(clusters):
                if j <= i:
                    continue
                if j in skip_list:
                    continue

                intersecting_items = len(set(cluster1[:]).intersection(cluster2[:]))

                if len(cluster1) > len(cluster2):
                    largest_length = len(cluster1)
                else:
                    largest_length = len(cluster2)

                if intersecting_items >= similarity_ratio * largest_length:

                    new_cluster = list(set(set(cluster1) | set(cluster2)))
                    merged_clusters.append(new_cluster)

                    skip_list.append(j)

                    found_similar = True

                    break

            if not found_similar:
                merged_clusters.append(cluster1)

        clusters = copy.deepcopy(merged_clusters)

    clusters = sorted(clusters, key=len, reverse=True)

    for i in range(0, len(clusters)):
        clusters[i] = sorted(clusters[i], key = lambda x: x.obj_order)

    return clusters
