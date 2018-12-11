data_dmri <- function(filename1,filename2,y,save,graph){
library(ggplot2)
library(filesstrings)
patha<- ('/home/omar/Documents/Tesis/data_mri/C1/')
pathe<- ('/home/omar/Documents/Tesis/data_mri/C2/')
patho <- ("/home/omar/Documents/Tesis/data_mri/")
graph_dest <- ("/home/omar/Documents/Tesis/data_mri/graphs/")
test_dest <- ("/home/omar/Documents/Tesis/data_mri/test/")
file_name_1 <- filename1
file_name_2 <- filename2
eje_y <- y
save_name <- save
graph_name <- graph

absolute_path <- paste(patha,file_name_1,sep = '')

mean_data <- (read.delim(absolute_path, sep = ' ', header = FALSE))[1]
ctrl <- (mean_data[1:5,][-2])
isq_1 <- (mean_data[6:10,])
isq_7 <- (mean_data[11:15,])
isq_30 <- (mean_data[16:22,][-c(3,5)])

absolute_path_2 <- paste(pathe,file_name_2,sep = '')

mean_data <- (read.delim(absolute_path_2, sep = ' ', header = FALSE))[1]
ctrl_b <- (mean_data[1:5,][-2])
isq_1_b <- (mean_data[6:10,])
isq_7_b <- (mean_data[11:15,])
isq_30_b <- (mean_data[16:22,][-c(3,5)])

control <- rep('Control', times=4)
un_dia <- rep('Uno', times=5)
siete_dias <- rep('Siete', times=5)
treinta_dias <- rep('Treinta', times=5)

day <- c(control,un_dia,siete_dias,treinta_dias)

intact <- rep('intact', times=19)
damaged <- rep('damaged', times=19)
treat <- c(intact,damaged)

metric <- as.numeric((c(c(ctrl,isq_1,isq_7,isq_30),c(ctrl_b,isq_1_b,isq_7_b,isq_30_b))))
data_pre <- data.frame(metric,day,treat)

ctrl_mean <- mean(data_pre$metric[1:4])
isq_1_mean <- mean(data_pre$metric[5:9])
isq_7_mean <- mean(data_pre$metric[10:14])
isq_30_mean <- mean(data_pre$metric[15:19])
ctrl_mean_b <- mean(data_pre$metric[20:23])
isq_1_mean_b <- mean(data_pre$metric[24:28])
isq_7_mean_b <- mean(data_pre$metric[29:33])
isq_30_mean_b <- mean(data_pre$metric[34:38])

metric_mean <- c(c(ctrl_mean,isq_1_mean,isq_7_mean,isq_30_mean),c(ctrl_mean_b,isq_1_mean_b,isq_7_mean_b,isq_30_mean_b))
treat_b <- c("intact","intact","intact","intact","damaged","damaged","damaged","damaged")
day_mean <- c("Control","Uno","Siete","Treinta")
data_pre_mean <- data.frame(metric_mean,day_mean,treat_b)


#Graficar datos


p <- ggplot(data_pre, aes(x=day, y=metric, group=treat)) +
  labs(title=(paste(file_name_1,'vs',file_name_2)),x="Dias", y = eje_y) +
  geom_point(data = data_pre, shape=16, position=position_jitter(0.08), aes(colour = treat), size =2.5, alpha = 1/3) +
  scale_x_discrete(limits=c("Control", "Uno", "Siete","Treinta")) +
  geom_line(data = data_pre_mean,aes(day_mean,metric_mean,group = treat_b, color = treat_b), size=1) +
  geom_point(data = data_pre_mean, aes(x = day_mean, y = metric_mean,group=treat_b, color = treat_b), size=1)
  ggsave(graph_name,device = svg)
print(p)
file.move(graph_name,graph_dest)

#q <- ggplot(data_pre, aes(x=day, y=metric)) +
#  geom_boxplot(position=position_dodge(1), aes(fill = treat)) + 
#  labs(title=(paste(file_name_1,'vs',file_name_2)),x="Dias", y = eje_y) +
  #geom_jitter(shape=16, position=position_jitter(0.08), aes(colour = treat), size =2.5) +
#  scale_x_discrete(limits=c("Control", "Uno", "Siete","Treinta"))
#print(q)

#r <- ggplot(data_pre, aes(x=day, y=metric)) +
#  geom_boxplot(position=position_dodge(1), aes(fill = treat)) + 
#  labs(title=(paste(file_name_1,'vs',file_name_2)),x="Dias", y = eje_y) +
#  geom_jitter(shape=16, position=position_jitter(0.08), aes(colour = treat), size =2.5) +
#  scale_x_discrete(limits=c("Control", "Uno", "Siete","Treinta"))
#print(r)

#s <- ggplot(data_pre, aes(x=day, y=metric)) +
#  geom_boxplot(position=position_dodge(1), aes(color = treat), alpha=1/2) + 
#  labs(title=(paste(file_name_1,'vs',file_name_2)),x="Dias", y = eje_y) +
#  geom_dotplot(binaxis='y', stackdir='center', stackratio = 1.5,position=position_dodge(1), aes(fill=treat),dotsize =1/2) +
#  scale_x_discrete(limits=c("Control", "Uno", "Siete","Treinta"))
#print(s)
#ggsave(graph_name,device = svg)

###

#pruebas estadísticas

ctrl_test <- as.vector((t.test(ctrl,ctrl_b, paired = F))$p.value)
isq_1_test <- as.vector((t.test(isq_1,isq_1_b, paired = F))$p.value)
isq_7_test <- as.vector((t.test(isq_7,isq_7_b, paired = F))$p.value)
isq_30_test <- as.vector((t.test(isq_30,isq_30_b, paired = F))$p.value)

isq_1_vs_7 <- as.vector((t.test(isq_1,isq_7, paired = F))$p.value)
isq_1_vs_7_b <- as.vector((t.test(isq_1_b,isq_7_b, paired = F))$p.value)
isq_7_vs_30 <- as.vector((t.test(isq_7,isq_30, paired = F))$p.value)
isq_7_vs_30_b <- as.vector((t.test(isq_7_b,isq_30_b, paired = F))$p.value)

pvalues <- c(ctrl_test,isq_1_test,isq_7_test,isq_30_test, isq_1_vs_7,isq_1_vs_7_b, isq_7_vs_30,isq_7_vs_30_b)
names_test <- c('ctrl_test','isq_1_test','isq_7_test','isq_30_test', 'isq_1_vs_7','isq_1_vs_7_b', 'isq_7_vs_30','isq_7_vs_30_b')
p_names <- data.frame(pvalues,names_test)
print(p_names)
write.table(p_names, (paste(patho,save_name, sep = '')),sep = ',')
file.move(paste(patho,save_name, sep=''),destinations = test_dest)
}