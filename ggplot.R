

ad_l <- read.csv('stats_ad_l.csv', header = FALSE)
ad_r <- read.csv('stats_ad_r.csv', header = FALSE)

ad_pre <- as.factor(ad_l[,7])
ad_1 <- (ad_l[,2])
ad_7 <- ad_l[c(11:15),2]
ad_30  <- ad_l[c(16:21),2]



p <- ggplot(ad_l, aes(x=ad_pre, y=ad_1)) + 
  geom_dotplot(binaxis = 'y', stackdir = 'center',
               stackratio = 1.5, dotsize = .5)
p + scale_x_discrete(limits=c('pre','1d','7d','30d')) + stat_summary(fun.y=median, geom="point", shape=18,
                 size=3, color="red")




plot(x,ad_pre)
