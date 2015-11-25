# clustering - derek kane
# - Connectiveity Models
# - Centroid Models
# - Distribution Models
# - Density Models
# - Group Models
# - Graph based models

# Types:
# - Hard clustering (whether an object belongs to  cluster or not)
# - Soft Clustering (Fuzzy clustering: What is the probability that an object belongs to a cluster.)

# Clustering Evaluation:
# - Silhouete Plot: How well each object lies within a cluster. 
#   Measured by average silhouette width (ASW). 
#   Silhouette width for datapoint (i) = {b(i) - a(i)}/max(a(i), b(i)),
#   where, a(i) is the avg distance between ith point to all points within the cluster. 
#          b(i) is the avg distance between ith point with all points outside teh cluster.
#   The number of clusters that give the highest average silhouette width is the most optimal.

# - Scree Plot





# Approaches: 
# 1. k-means
#
# 2. Hierarchical clustering: Single linkage, complete linkage, average linkage
#    To start with each point is assigned to its own cluster. Then, each point is assigned to one other point to make a cluster. 
#    Then each of these clusters are treated as a point and then clubbed again with one other cluster, until we are left with one cluster. 
#    There are 3 approaches to how the distance between the clusters are computed.
#     - Single linkage: Distance between one cluster to another is the shortest distance between any of the points. 
#     - Complete linkage: Distance between one cluster to another is the longest distance between any of the points. 
#     - Average linkage: Distance between one cluster to another is the average distance between any of the points. 
#
# 3. Gaussian mixed models (mclust): The goal for identifying the number of clusters is the maximise the BIC. A type of fuzzy clustering method.
