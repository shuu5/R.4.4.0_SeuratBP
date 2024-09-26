# パッケージの読み込み
library(BPCells)
library(Seurat)
library(tidyverse)

# データディレクトリの設定
data_dir <- file.path("data/pbmc-3k")
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
setwd(data_dir)

# データのダウンロード
url_base <- "https://cf.10xgenomics.com/samples/cell-arc/2.0.0/pbmc_granulocyte_sorted_3k/"
rna_raw_url <- paste0(url_base, "pbmc_granulocyte_sorted_3k_raw_feature_bc_matrix.h5")
atac_raw_url <- paste0(url_base, "pbmc_granulocyte_sorted_3k_atac_fragments.tsv.gz")

options(timeout=300)

# RNA-seqデータのダウンロード
if (!file.exists("pbmc_3k_10x.h5")) {
  download.file(rna_raw_url, "pbmc_3k_10x.h5", mode="wb")
}

# ATAC-seqデータのダウンロード
if (!file.exists("pbmc_3k_10x.fragments.tsv.gz")) {
  download.file(atac_raw_url, "pbmc_3k_10x.fragments.tsv.gz", mode="wb")
}

# RNA-seqデータの読み込みと変換
if (!file.exists("pbmc_3k_rna_raw")) {
  mat_raw <- open_matrix_10x_hdf5("pbmc_3k_10x.h5", feature_type="Gene Expression") %>% 
    write_matrix_dir("pbmc_3k_rna_raw")
} else {
  mat_raw <- open_matrix_dir("pbmc_3k_rna_raw")
}

# ATAC-seqデータの読み込みと変換
if (!file.exists("pbmc_3k_frags")) {
  frags_raw <- open_fragments_10x("pbmc_3k_10x.fragments.tsv.gz") %>%
      write_fragments_dir("pbmc_3k_frags")
} else {
  frags_raw <- open_fragments_dir("pbmc_3k_frags")
}

# RNA-seqデータのフィルタリング
reads_per_cell <- Matrix::colSums(mat_raw)
plot_read_count_knee(reads_per_cell, cutoff = 1e3)

# ATAC-seqデータのフィルタリング
genes <- read_gencode_transcripts(
  "./references", 
  release="42", 
  transcript_choice="MANE_Select",
  annotation_set = "basic", 
  features="transcript"
)

blacklist <- read_encode_blacklist("./references", genome="hg38")
chrom_sizes <- read_ucsc_chrom_sizes("./references", genome="hg38")

atac_qc <- qc_scATAC(frags_raw, genes, blacklist)
plot_tss_scatter(atac_qc, min_frags=1000, min_tss=10)

# 高品質な細胞の選択
pass_atac <- atac_qc %>%
    dplyr::filter(nFrags > 1000, TSSEnrichment > 10) %>%
    dplyr::pull(cellName)
pass_rna <- colnames(mat_raw)[Matrix::colSums(mat_raw) > 1e3]
keeper_cells <- intersect(pass_atac, pass_rna)

# フィルタリングされた細胞と遺伝子の選択
frags <- frags_raw %>% select_cells(keeper_cells)
keeper_genes <- Matrix::rowSums(mat_raw) > 3
mat <- mat_raw[keeper_genes, keeper_cells]

# RNAデータの正規化、PCA、UMAP
mat <- multiply_cols(mat, 1/Matrix::colSums(mat))
mat <- log1p(mat * 10000)

# 変動遺伝子の選択
stats <- matrix_stats(mat, row_stats="variance")
variable_genes <- order(stats$row_stats["variance",], decreasing=TRUE) %>% 
  head(1000) %>% 
  sort()
mat_norm <- mat[variable_genes,]

# 正規化されたデータの保存
mat_norm <- mat_norm %>% write_matrix_memory(compress=FALSE)
gene_means <- stats$row_stats["mean", variable_genes]
gene_vars <- stats$row_stats["variance", variable_genes]
mat_norm <- (mat_norm - gene_means) / gene_vars

# SVDによる次元削減
svd <- BPCells::svds(mat_norm, k=50)
pca <- multiply_cols(svd$v, svd$d)
umap <- uwot::umap(pca)

# クラスタリング
clusts <- knn_hnsw(pca, ef=500) %>% 
  knn_to_snn_graph() %>% 
  cluster_graph_louvain()

# クラスタの可視化
plot_embedding(clusts, umap)

# マーカー遺伝子の可視化
plot_embedding(
  source = mat,
  umap,
  features = c("MS4A1", "GNLY", "CD3E", 
               "CD14", "FCER1A", "FCGR3A", 
               "LYZ", "CD4", "CD8")
)