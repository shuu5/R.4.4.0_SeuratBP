renv::install(c("BiocManager", "languageserver"))


setRepositories(ind = 1:3, addURLs = c('https://satijalab.r-universe.dev', 'https://bnprks.r-universe.dev/'))
renv::install(c("BPCells", "presto"))
renv::install("bioc::glmGamPoi")


if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
install.packages('Signac')
remotes::install_github("satijalab/seurat-data", quiet = TRUE)
remotes::install_github("satijalab/azimuth", quiet = TRUE)
remotes::install_github("satijalab/seurat-wrappers", quiet = TRUE)


renv::restore()



library(fs)

work_dir <- getwd()
cache_dir <- renv::paths$cache()

# cache_dirをwork_dirからの相対パスで表現
relative_cache_dir <- path_rel(cache_dir, start = work_dir)
relative_cache_dir


renv::install(paste0(relative_cache_dir, "/BPCells"))
