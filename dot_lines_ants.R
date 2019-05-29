data_file <- read.csv("/media/omar/data/M-isq_long/concat_all_first_dif_ants.csv")
data_file$grupo <- as.factor(data_file$grupo)
library(ggplot2)
library(filesstrings)
library(wesanderson)
library(plotly)
library(viridis)
library(ggthemes)

dir.create("/media/omar/data/M-isq_long/graphs_test_ants_tesis")
graph_dest <- "/media/omar/data/M-isq_long/graphs_test_ants_tesis/"
rowname_data <- c("gRatio_mean","axon_diameter_mean","myelin_diameter_mean","mielyn_thickness_mean","myelin_area_mean","axon_area_mean","gRatio_median",	
                  "axon_diameter_median","myelin_diameter_median","myelin_thickness_median","myelin_area_median","axon_area_median","mvf","avf","total_axon_mean","axon_per_micra",
                  "AFD_mean", "Cx_mean","Disp_mean","Peak_mean",	
                  "Ax_mrds_mean","Fa_mrds_mean","Md_mrds_mean","Rd_mrds_mean",
                  "Sizes_mrds_mean","Ax_tensor_mean","Fa_tensor_mean","Md_tensor_mean",
                 "Rd_tensor_mean","AFD_mean_c","Disp_mean_c","Peak_mean_c",	"Cx_mean_c",
                  "Ax_mrds_mean_c","Fa_mrds_mean_c","Md_mrds_mean_c","Rd_mrds_mean_c","Sizes_mrds_mean_c")

plot_name <- c("Tasa-g","Diametro axonal (\u03BCm)","Diametro axonal con mielina (\u03BCm)","Grosor de mielina (\u03BCm)","Area de mielina (\u03BCm\u00B2)","Area axonal (\u03BCm\u00B2)","Tasa-g","Diametro axonal (\u03BCm)","Diametro axonal con mielina (\u03BCm)",
               "Grosor de mielina (\u03BCm)","Area de mielina (\u03BCm\u00B2)","Area axonal (\u03BCm\u00B2)","Fracción de volumen de mielina","Fracción de volumen axonal","Número de axones","Densidad axonal (axones/\u03BCm\u00B2)",
               "AFD_mean","Cx_mean","Disp_mean","Peak_mean",	
               "Ax_mrds_mean","Fa_mrds_mean","Md_mrds_mean","Rd_mrds_mean",
               "Sizes_mrds_mean","Ax_tensor_mean","Fa_tensor_mean","Md_tensor_mean",
               "Rd_tensor_mean","AFD_mean_c","Disp_mean_c","Peak_mean_c",	"Cx_mean_c",
               "Ax_mrds_mean_c","Fa_mrds_mean_c","Md_mrds_mean_c","Rd_mrds_mean_c","Sizes_mrds_mean_c")

graph_save <- c("gRatio_mean.svg","axon_diameter_mean.svg","myelin_diameter_mean.svg","mielyn_thickness_mean.svg","myelin_area_mean.svg","axon_area_mean.svg","gRatio_median.svg",	
                "axon_diameter_median.svg","myelin_diameter_median.svg","myelin_thickness_median.svg","myelin_area_median.svg","axon_area_median.svg","mvf.svg","avf.svg","total_axon_mean.svg","axon_per_micra.svg",
                "AFD_mean.svg","Cx_mean.svg","Disp_mean.svg","Peak_mean.svg",
                "Ax_mrds_mean.svg","Fa_mrds_mean.svg","Md_mrds_mean.svg","Rd_mrds_mean.svg",
                "Sizes_mrds_mean.svg","Ax_tensor_mean.svg","Fa_tensor_mean.svg","Md_tensor_mean.svg",
                "Rd_tensor_mean.svg","AFD_mean_c.svg","Disp_mean_c.svg","Peak_mean_c.svg", "Cx_mean.svg",	
                "Ax_mrds_mean_c.svg","Fa_mrds_mean_c.svg","Md_mrds_mean_c.svg","Rd_mrds_mean_c.svg","Sizes_mrds_mean_c.svg")

gf <- c(1:50)
for (i in 1:length(gf)){
data_file$grupo <- as.factor(data_file$grupo)
p <- ggplot(data_file, aes_string(x="X", y=rowname_data[i], fill="grupo")) +
      geom_boxplot(position=position_dodge(.5), alpha=.4,width=0.7/length(unique(data_file$grupo)),aes(color = grupo)) +
      geom_boxplot(aes(color = grupo),
             fatten = NULL, fill = NA, coef = 0, outlier.alpha = 0,
             show.legend = F,width=0.7/length(unique(data_file$grupo)),position=position_dodge(.5))+
      geom_dotplot(binaxis='y', stackdir='center', 
                   position=position_dodge(.5),width=0.7/length(unique(data_file$grupo)),dotsize =.4,alpha=.6) +
  labs(x="Dias posteriores a la isquemia", y = plot_name[i])+
  scale_x_discrete(limits=c("ct","isq1d","isq7d","isq30d")) +
  scale_color_manual(values=c("#00BFC4", "#F8766D")) +
  scale_fill_manual(values=c("#00BFC4", "#F8766D")) +
  stat_summary(geom = "crossbar", position=position_dodge(.5),width=0.7/length(unique(data_file$grupo)), fatten=0, color="black", fun.data = function(x){ return(c(y=median(x), ymin=median(x), ymax=median(x))) })+
  stat_summary(fun.y=median, geom="line", position=position_dodge(.5),aes(group=grupo,color=grupo),size=.2)  + 
  #stat_summary(fun.y=median, geom="point",position=position_dodge(.5)) +
  theme_minimal(base_size = 26, base_rect_size = 23) + 
  theme(legend.position="none") 
  ggsave(graph_save[i],device = svg, width = 38, height = 26, units = "cm")
  file.move(graph_save[i],graph_dest,overwrite = TRUE)
print(p)    
}




data_file$grupo <- as.factor(data_file$grupo)
p <- ggplot(data_file, aes(x=X, y=Ax_tensor_mean, fill=grupo)) +
  geom_boxplot(position=position_dodge(.5), alpha=.6,width=0.7/length(unique(data_file$grupo)),aes(color = grupo)) +
  geom_boxplot(aes(color = grupo),
               fatten = NULL, fill = NA, coef = 0, outlier.alpha = 0,
               show.legend = F,width=0.7/length(unique(data_file$grupo)),position=position_dodge(.5))+
  geom_dotplot(binaxis='y', stackdir='center', 
               position=position_dodge(.5),width=0.7/length(unique(data_file$grupo)),dotsize =.4,alpha=.4) +
  labs(x="Dias posteriores a la isquemia", y ="plot_name[i]")+
  scale_x_discrete(limits=c("ct","isq1d","isq7d","isq30d")) +
  scale_color_manual(values=c("#00BFC4", "#F8766D")) +
  scale_fill_manual(values=c("#00BFC4", "#F8766D")) +
  stat_summary(geom = "crossbar", position=position_dodge(.5),width=0.7/length(unique(data_file$grupo)), fatten=0, color="black", fun.data = function(x){ return(c(y=median(x), ymin=median(x), ymax=median(x))) })+
  stat_summary(fun.y=median, geom="line", position=position_dodge(.5),aes(group=grupo,color=grupo),size=.2)  + 
  #stat_summary(fun.y=median, geom="point",position=position_dodge(.5)) +
  theme_minimal(base_size = 12) 
#theme(legend.position="none") 
#ggsave(graph_save[i],device = svg)
#file.move(graph_save[i],graph_dest)
p
#ggplotly(p)    
#"Axon density (axons/\u03BCm\u00B2)","Axon volume fraction (AVF)","Myelin volume fraction (MVF)","g-Ratio","Axon diameter (\u03BCm)","Myelin thickness (\u03BCm)"

####work but mejorara
gf <- c(1:97)
for (i in 1:length(gf)){
p <- ggplot(data =data_file,aes_string(x="X", y="avf", color=color_row_bubble_median[i], size = "grupo"))+
  geom_point(alpha=.8,aes(size= grupo),position = position_jitter(w = 0.1, h = 0))+
  scale_color_gradientn(colours = plasma(100))+
  scale_x_discrete(limits=c("ct","isq1d","isq7d","isq30d")) +
  labs(x="Dias posteriores a la isquemia", y ="Fracción de volumen axonal") +
  theme_minimal(base_size = 12)
print(p)
  }
#######

p <- ggplot(data=data_file,aes(x=X, y=avf, size=AFD_mean_c, colour=grupo))+
  geom_point(alpha=.8,aes(size=AFD_mean_c), position=position_jitter(w=0.1, h=0))+
  #scale_color_gradientn(colours = plasma(100))+
  scale_color_manual(values=c("#00BFC4","#F8766D"))+
  scale_x_discrete(limits=c("ct","isq1d","isq7d","isq30d")) +
  labs(x="Days after ischemia", y ="Axon volume fraction") +
  theme_minimal(base_size=12)
print(p)
#ggplotly(p)
#####con plotly

# Make a basic scatter plot :
p=plot_ly(data_file, x = ~X_2, y = ~avf, type="scatter",
          mode = "markers", color = ~Fa_tensor_mean, size = ~Fa_tensor_mean,
          text = ~paste("rata: ", X, 'Fa:', Fa_tensor_mean)) %>% 
add_trace(data_file, y = ~avf_mean, type="scatter",mode = 'lines')
p


rowname_data_bubble <- c("gRatio_mean","axon_diameter_mean","myelin_diameter_mean","mielyn_thickness_mean","myelin_area_mean","axon_area_mean","gRatio_median",	
                  "axon_diameter_median","myelin_diameter_median","myelin_thickness_median","myelin_area_median","axon_area_median","mvf","avf","total_axon_mean","axon_per_micra")
color_row_bubble_mean <- c("AFD_mean","AFDm_mean","Cx_mean","Disp_mean","Peak_mean",	
                      "Ax_mrds_mean","Fa_mrds_mean","Md_mrds_mean","Rd_mrds_mean",
                      "Sizes_mrds_mean","Ax_tensor_mean","Fa_tensor_mean","Md_tensor_mean",
                      "Rd_tensor_mean","AFD_mean_c","AFDm_mean_c","Disp_mean_c","Peak_mean_c",	
                      "Ax_mrds_mean_c","Fa_mrds_mean_c","Md_mrds_mean_c","Rd_mrds_mean_c","Sizes_mrds_mean_c")

color_row_bubble_median <- c("AFD_median","AFDm_median","Cx_median","Disp_median","Peak_median",	
                      "Ax_mrds_median","Fa_mrds_median","Md_mrds_median","Rd_mrds_median",
                      "Sizes_mrds_median","Ax_tensor_median","Fa_tensor_median",
                      "Md_tensor_median","Rd_tensor_median","AFD_median_c","AFDm_median_c","Disp_median_c",	
                      "Peak_median_c","Ax_mrds_median_c","Fa_mrds_median_c","Md_mrds_median_c","Rd_mrds_median_c","Sizes_mrds_median_c")




