% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ti_scoup.R
\name{ti_scoup}
\alias{ti_scoup}
\title{Inferring trajectories with SCOUP}
\usage{
ti_scoup(ndim = 2L, max_ite1 = 100, max_ite2 = 100, alpha_min = 0.1,
  alpha_max = 100, t_min = 0.001, t_max = 2, sigma_squared_min = 0.1,
  thresh = 0.01)
}
\arguments{
\item{ndim}{Number of pca dimensions}

\item{max_ite1}{Upper bound of EM iteration (without pseudo-time optimization). The detailed explanation is described in the supplementary text. (default is 1,000)}

\item{max_ite2}{Upper bound of EM iteration (including pseudo-time optimization) (default is 1,000).}

\item{alpha_min}{Lower bound of alpha (default is 0.1)}

\item{alpha_max}{Upper bound of alpha (default is 100)}

\item{t_min}{Lower bound of pseudo-time (default is 0.001)}

\item{t_max}{Upper bound of pseudo-time (default is 2.0)}

\item{sigma_squared_min}{Lower bound of sigma squared (default is 0.1)}

\item{thresh}{Threshold}
}
\description{
Inferring trajectories with SCOUP
}