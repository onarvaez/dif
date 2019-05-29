library(corrplot)
library(viridis)
dft <- read.delim("concat_all_first_dif_ants_chiasm.csv",header = TRUE, sep = ",")
rows <- as.matrix(dft[1])
dft <- read.delim("concat_all_first_dif_ants_chiasm.csv",header = TRUE, sep = ",",row.names = rows)[-1]
dft_col <- read.delim("color_cor_no_c_per_group.csv",header = FALSE, sep = ",",row.names = NULL)
dft_col <- as.numeric(dft_col)

M <- cor(dft)
res1 <- cor.mtest(dft, conf.level = .95)

Mp <- corrplot::cor.mtest(M)$p
corrplot(M, p.mat = res1$p, method = "color", type = "lower", title = "",
         sig.level =.05,
         insig = "blank",outline = T, addgrid.col = "white", tl.srt = 45, tl.col = "black",bg="gray86",tl.cex = .7, col = viridis(50))


#Interactive corplot
library(qtlcharts)
#spearman <- cor(dft, use="pairwise.complete.obs", method="spearman")

iplotCorr(dft, reorder = F, corr=spearman)
corrplot_nerve <- iplotCorr(dft,dft_col,reorder=FALSE,
                            chartOpts=list(scatcolors=c("Deepskyblue", "mediumseagreen", "tomato"),rectcolor = "#EFF5FB",pointsize = 5,
                                           margin = list(left=260, top=40, right=50, bottom=80, inner=20),cortitle = "Correlations",
                                           corcolors=c("steelblue", "white", "orange"),
                                           scattitle = "Scatter", height=600, width=1600, caption=paste("Click on the heatmap on the left to see",
                                                                                                        "corresponding scatterplots on the right.")))
corrplot_nerve



#some normality tests
cts <- dft[-c(5,6,7,8,9),]
cts_2 <- dft[-c(1,2,3,4,10,11,12,13,14,15,16,17,18),]
library(ggpubr)
ggqqplot(cts$avf)
ggdensity(cts$avf, 
          main = "Density plot of tooth length",
          xlab = "Tooth length")
shapiro.test(cts$avf)

ggqqplot(cts_2$AFD_median)
ggdensity(cts_2$AFD_median, 
          main = "Density plot of tooth length",
          xlab = "Tooth length")
shapiro.test(cts_2$AFD_median)
