#' Inferring trajectories with Sincell
#'
#' @inherit ti_angle description
#'
#' @param distance_method Distance method to be used. The available distances are the Euclidean distance (method="euclidean"), Manhattan distance (also called L1 distance, method="L1"), cosine distance (method="cosine") , distance based on Pearson (method="pearson") or Spearman (method="spearman") correlation coefficients, and distance based on Mutual Information (method="MI"). Intervals used to assess Mutual Information are indicated in the parameter "bins".
#' @param dimred_method Dimensionality reduction algorithm to be used. Options are: Principal Component Analysis (method="PCA"), Independent Component Analysis (method="ICA"; using fastICA() function in fastICA package), t-Distributed Stochastic Neighbor Embedding (method="tSNE"; using Rtsne() function in Rtsne package with parameters tsne.perplexity=1 and tsne.theta=0.25), classical Multidimensional Scaling (method="classical-MDS"; using the cmdscale() function) and non-metric Multidimensional Scaling (method="nonmetric-MDS";using the isoMDS() function in MASS package). if method="PCA" is chosen, the proportion of variance explained by each of the principal axes is plotted. We note that Sincell makes use of the Rtsne implementation of the Barnes-Hut algorithm, which approximates the likelihood. The user should be aware that this is a less accurate version of t-SNE than e.g. the one used as basis of viSNE (Amir,E.D. et al. 2013, Nat Biotechnol 31, 545-552).
#' @inheritParams sincell::sc_clusterObj
#' @inheritParams sincell::sc_GraphBuilderObj
#' @param k_imc If IMC algorithm is selected, the number of nearest neighbors used in the underlying K-Mutual Nearest Neighbour (K-MNN) algorithm is set to k.
#' @param pct_leaf_node_cutoff Leaf nodes are iteratively removed until the percentage of leaf nodes is below the given cutoff. Removed nodes are projected to their closest neighbour. This is to constrain the number of milestones being created.
#'
#' @seealso [sincell::sc_distanceObj()], [sincell::sc_DimensionalityReductionObj()], [sincell::sc_clusterObj()]
#'
#' @export
ti_sincell <- create_ti_method(
  name = "Sincell",
  short_name = "sincell",
  package_loaded = c(),
  package_required = c("sincell"),
  doi = "10.1093/bioinformatics/btv368",
  trajectory_types = c("cycle", "linear", "bifurcation", "convergence", "multifurcation", "binary_tree", "tree", "acyclic_graph", "graph", "disconnected_graph"),
  topology_inference = "free",
  type = "algorithm",
  license = "GPL (>= 2)",
  authors = list(
    list(
      given = "Antonio",
      family = "Rausell",
      email = "antonio.rausell@institutimagine.org",
      github = "Cortalak"
    ),
    list(
      given = "Miguel",
      family = "Julia",
      email = "migueljuliamolina@gmail.com"
    )
  ),
  preprint_date = "2015-01-27",
  publication_date = "2015-06-22",
  code_url = "https://github.com/Cortalak/MCA_Sincell_0",
  parameters = list(
    distance_method = list(
      type = "discrete",
      default = "euclidean",
      values = c("euclidean", "cosine", "pearson", "spearman", "L1", "MI"),
      description = "Distance method to be used. The available distances are the Euclidean distance (method=\"euclidean\"), Manhattan distance (also called L1 distance, method=\"L1\"), cosine distance (method=\"cosine\") , distance based on Pearson (method=\"pearson\") or Spearman (method=\"spearman\") correlation coefficients, and distance based on Mutual Information (method=\"MI\"). Intervals used to assess Mutual Information are indicated in the parameter 'bins'."),

    dimred_method = list(
      type = "discrete",
      default = "none",
      values = c("none", "PCA", "ICA", "tSNE", "classical-MDS", "nonmetric-MDS"),
      description = "Dimensionality reduction algorithm to be used. Options are: Principal Component Analysis (method=\"PCA\"), Independent Component Analysis (method=\"ICA\"; using fastICA() function in fastICA package), t-Distributed Stochastic Neighbor Embedding (method=\"tSNE\"; using Rtsne() function in Rtsne package with parameters tsne.perplexity=1 and tsne.theta=0.25), classical Multidimensional Scaling (method=\"classical-MDS\"; using the cmdscale() function) and non-metric Multidimensional Scaling (method=\"nonmetric-MDS\";using the isoMDS() function in MASS package). if method=\"PCA\" is chosen, the proportion of variance explained by each of the principal axes is plotted. We note that Sincell makes use of the Rtsne implementation of the Barnes-Hut algorithm, which approximates the likelihood. The user should be aware that this is a less accurate version of t-SNE than e.g. the one used as basis of viSNE (Amir,E.D. et al. 2013, Nat Biotechnol 31, 545-552)."),

    clust.method = list(
      type = "discrete",
      default = "max.distance",
      values = c("max.distance", "percent", "knn", "k-medoids", "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"),
      description = "\nIf clust.method=\"max.distance\", clusters are defined as subgraphs generated by a maximum pair-wise distance cut-off, that is: from a totally connected graph where all cells are connected to each other, the algorithm only keeps pairs of cells connected by a distance lower than a given threshold.\n\nIf clust.method=\"percent\", clusters are defined as subgraphs generated by a given rank-percentile of the shortest pair-wise distances, that is; from a totally connected graph where all cells are connected to each other, the algorithm only keeps the top 'x' percent of shortest pairwise distances as indicated by \"shortest.rank.percent\".\n\nIf clust.method=\"knn\", unsupervised K-Nearest Neighbors (K-NN) clustering is performed: From a totally disconnected graph where none of the cells are connected to each other, the algorithm connects each cell to its 'k' nearest neighbors. If parameter \"mutual=TRUE\", Unsupervised K-Mutual Nearest Neighbours (K-MNN) clustering is performed, that is: only reciprocal k nearest neighbors are connected.\n\nIf clust.method=\"k-medoids\", clustering around medoids (a more robust version of k-means) is performed with function \"pam\" from package \"cluster\" on the distance matrix in mySincellObject$cell2celldist with a desired number of groups indicated in parameter \"num.clusters\"\n\nHierarchical agglomerative clustering can be performed by internally calling function \"hclust\" where the agglomeration method is indicated in parameter \"clust.method\" as one of \"ward.D\", \"ward.D2\", \"single\", \"complete\", \"average\" (= UPGMA), \"mcquitty\" (= WPGMA), \"median\" (= WPGMC) or \"centroid\" (= UPGMC). Clusters are obtained by cutting the tree produced by hclust with function cutree with a desired number of groups indicated in parameter \"num.clusters\" \n\n"),

    mutual = list(
      type = "logical",
      default = TRUE,
      description = "\nIf clust.method=\"knn\" and \"mutual=TRUE\", Unsupervised K-Mutual Nearest Neighbours (K-MNN) clustering is performed, that is: only reciprocal k nearest neighbors are connected.\n"),
    max.distance = list(
      type = "numeric",
      default = 0,
      upper = 5,
      lower = 0,
      description = "\nin max.distance algorithm, select up to which distance the points will be linked\n"),
    k = list(
      type = "integer",
      default = 3L,
      upper = 99L,
      lower = 1L,
      description = "\nIf clust.method=\"knn\", k is an integer specifying the number of nearest neighbors to consider in K-NN and K-KNN\n"),
    shortest.rank.percent = list(
      type = "numeric",
      default = 10,
      upper = 100,
      lower = 0,
      description = "\nin percent algorithm, select the percent of shortest distances will be represented as links\n"),
    graph.algorithm = list(
      type = "discrete",
      default = "MST",
      values = c("MST", "SST", "IMC"),
      description = "\nGraph building algorithm to be used: the Minimum Spanning Tree \n(graph.algorithm=\"MST\"), the Maximum Similarity Spanning Tree \n(graph.algorithm=\"SST\") and the Iterative Mutual Clustering Graph \n(graph.algorithm=\"IMC\").\n"),

    graph.using.cells.clustering = list(
      type = "logical",
      default = FALSE,
      description = "\nIf graph.using.cells.clustering=TRUE and graph.algorithm=\"MST\" or graph.algorithm=\"MST\", a precalculated clustering of cells is used. The clustering of cells is taken from SincellObject$cellsClustering as calculated by function sc_clusterObj().\n"),
    k_imc = list(
      type = "integer",
      default = 3L,
      upper = 99L,
      lower = 1L,
      description = "If IMC algorithm is selected, the number of nearest neighbors used in the underlying K-Mutual Nearest Neighbour (K-MNN) algorithm is set to k."),

    pct_leaf_node_cutoff = list(
      type = "numeric",
      default = 0.5,
      upper = 0.8,
      lower = 0.01,
      description = "Leaf nodes are iteratively removed until the percentage of leaf nodes is below the given cutoff. Removed nodes are projected to their closest neighbour. This is to constrain the number of milestones being created.")
  ),
  run_fun = "dynmethods::run_sincell",
  plot_fun = "dynmethods::plot_sincell"
)

run_sincell <- function(
  expression,
  distance_method = "spearman",
  dimred_method = "none",
  clust.method = "max.distance",
  mutual = TRUE,
  max.distance = 0,
  k = 3L,
  shortest.rank.percent = 10,
  graph.algorithm = "MST",
  graph.using.cells.clustering = FALSE,
  k_imc = 3L,
  pct_leaf_node_cutoff = .5
) {
  requireNamespace("sincell")

  # TIMING: done with preproc
  tl <- add_timing_checkpoint(NULL, "method_afterpreproc")

  # initialise sincell object
  SO <- sincell::sc_InitializingSincellObject(t(expression))

  # calculate distances
  SO <- SO %>% sincell::sc_distanceObj(
    method = distance_method
  )

  # perform dimred, if necessary
  if (dimred_method != "none") {
    SO <- SO %>% sincell::sc_DimensionalityReductionObj(
      method = dimred_method
    )
  }

  # cluster cells
  SO <- SO %>% sincell::sc_clusterObj(
    clust.method = clust.method,
    mutual = mutual,
    max.distance = max.distance,
    shortest.rank.percent = shortest.rank.percent,
    k = k
  )

  # build graph
  SO <- SO %>% sincell::sc_GraphBuilderObj(
    graph.algorithm = graph.algorithm,
    graph.using.cells.clustering = graph.using.cells.clustering,
    k = k_imc
  )

  # TIMING: done with method
  tl <- tl %>% add_timing_checkpoint("method_aftermethod")

  # extract cell hierarchy
  cell_graph <- SO$cellstateHierarchy %>%
    igraph::as_data_frame() %>%
    rename(length = weight) %>%
    mutate(directed = FALSE)

  # Leaf nodes are iteratively removed until the percentage of leaf nodes
  # is below the given cutoff. Removed nodes are projected to their closest
  # neighbour.
  # This is to constrain the number of milestones being created.
  gr <- SO$cellstateHierarchy
  deg <- igraph::degree(gr)
  prev_deg <- deg * 0
  while (length(deg) > 10 && mean(deg <= 1) > pct_leaf_node_cutoff && any(deg != prev_deg)) {
    del_v <- names(which(deg == 1))
    cat("Removing ", length(del_v), " vertices with degree 1\n", sep = "")
    gr <- igraph::delete_vertices(gr, del_v)
    prev_deg <- deg[names(igraph::V(gr))]
    deg <- igraph::degree(gr)
  }
  to_keep <- setNames(rownames(expression) %in% names(igraph::V(gr)), rownames(expression))

  # return output
  wrap_prediction_model(
    cell_ids = rownames(expression)
  ) %>% add_cell_graph(
    cell_graph = cell_graph,
    to_keep = to_keep
  ) %>% add_timings(
    timings = tl %>% add_timing_checkpoint("method_afterpostproc")
  )
}

#' @importFrom magrittr set_colnames
plot_sincell<- function(prediction) {
  requireNamespace("ggraph")
  requireNamespace("tidygraph")

  prediction$milestone_network %>%
    igraph::graph_from_data_frame(directed = F) %>%
    tidygraph::as_tbl_graph() %>%
    ggraph::ggraph() +
    ggraph::geom_node_point() +
    ggraph::geom_edge_link() +
    ggraph::theme_graph()
}
