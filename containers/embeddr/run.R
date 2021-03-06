library(dynwrap)
library(jsonlite)
library(readr)
library(dplyr)
library(purrr)

library(scaterlegacy)
library(embeddr)

#   ____________________________________________________________________________
#   Load data                                                               ####

data <- read_rds('/input/data.rds')
params <- jsonlite::read_json('/input/params.json')

#   ____________________________________________________________________________
#   Infer trajectory                                                        ####

run_fun <- function (counts, ndim = 2, kernel = "nn", metric = "correlation", 
    nn_pct = 0, eps = 0, t = 0, symmetrize = "mean", measure_type = "unorm", 
    thresh = 0.001, maxit = 10, stretch = 2, smoother = "smooth.spline") 
{
    requireNamespace("scaterlegacy")
    requireNamespace("embeddr")
    nn <- max(round(log(nrow(counts)) * nn_pct), 9)
    tl <- add_timing_checkpoint(NULL, "method_afterpreproc")
    sce <- scaterlegacy::newSCESet(countData = t(counts))
    sce <- embeddr::embeddr(sce, kernel = kernel, metric = metric, 
        nn = nn, eps = eps, t = t, symmetrize = symmetrize, measure_type = measure_type, 
        p = ndim)
    sce <- embeddr::fit_pseudotime(sce, thresh = thresh, maxit = maxit, 
        stretch = stretch, smoother = smoother)
    tl <- tl %>% add_timing_checkpoint("method_aftermethod")
    pseudotime <- as(sce@phenoData, "data.frame")$pseudotime %>% 
        setNames(rownames(counts))
    dimred_cells <- sce@reducedDimension
    traj <- as(sce@phenoData, "data.frame") %>% dplyr::arrange(pseudotime) %>% 
        select(starts_with("trajectory_")) %>% as.matrix()
    dimred_trajectory_segments <- cbind(traj[-nrow(traj), , drop = F], 
        traj[-1, , drop = F])
    colnames(dimred_trajectory_segments) <- c(paste0("from_", 
        colnames(dimred_cells)), paste0("to_", colnames(dimred_cells)))
    wrap_prediction_model(cell_ids = rownames(counts)) %>% add_linear_trajectory(pseudotime = pseudotime) %>% 
        add_dimred(dimred = dimred_cells, dimred_trajectory_segments = dimred_trajectory_segments) %>% 
        add_timings(timings = tl %>% add_timing_checkpoint("method_afterpostproc"))
}

args <- params[intersect(names(params), names(formals(run_fun)))]

model <- do.call(run_fun, c(args, data))

#   ____________________________________________________________________________
#   Save output                                                             ####

write_rds(model, '/output/output.rds')