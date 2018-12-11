patho <- "/home/omar/Documents/Tesis/data_mri/"
source(paste(patho,"data_dmri.R", sep = ''))
dir.create("/home/omar/Documents/Tesis/data_mri/graphs")
dir.create("/home/omar/Documents/Tesis/data_mri/test")


x <- (list.files("/home/omar/Documents/Tesis/data_mri/N1/"))
y <- (list.files("/home/omar/Documents/Tesis/data_mri/N2/"))
t <- c("AFD","AFDm","CX","DISP","PEAK","AXIAL_mrds", "FA_mrds","MD_mrds", "RADIAL_mrds","SIZES_mrds",
                     "AXIAL","FA","MD","RADIAL")
z <- c("AFD_nerv.svg","AFDm_nerv.svg","CX_nerv.svg","DISP_nerv.svg","PEAK_nerv.svg","AXIAL_nerv_mrds.svg",
                     "FA_nerv_mrds.svg","MD_nerv_mrds.svg", "RADIAL_nerv_mrds.svg","SIZES_nerv_mrds.svg","AXIAL_nerv.svg",
                     "FA_nerv.svg","MD_nerv.svg","RADIAL_nerv.svg")
tex <- c("AFD_nerv.csv","AFDm_nerv.csv","CX_nerv.csv","DISP_nerv.csv","PEAK_nerv.csv","AXIAL_nerv_mrds.csv",
                 "FA_nerv_mrds.csv","MD_nerv_mrds.csv", "RADIAL_nerv_mrds.csv","SIZES_nerv_mrds.csv","AXIAL_nerv.csv",
                 "FA_nerv.csv","MD_nerv.csv","RADIAL_nerv.csv")
gf <- c(1:14)
for (i in 1:length(gf)){
  print(paste(x[i],"+",y[i],"+",t[i],"+",tex[i],"+",z[i]))
  data_dmri(x[i],y[i],t[i],tex[i],z[i])
}

rm(ls=ls())

x_c <- (list.files("/home/omar/Documents/Tesis/data_mri/C1/"))
y_c <- (list.files("/home/omar/Documents/Tesis/data_mri/C2/"))
t_c <- c("AFD","AFDm","DISP","PEAK","AXIAL_mrds", "FA_mrds","MD_mrds", "RADIAL_mrds","SIZES_mrds")
z_c <- c("AFD_chiasm.svg","AFDm_chiasm.svg","DISP_chiasm.svg","PEAK_chiasm.svg","AXIAL_chiasm_mrds.svg",
       "FA_chiasm_mrds.svg","MD_chiasm_mrds.svg", "RADIAL_chiasm_mrds.svg","SIZES_chiasm_mrds.svg")
tex_c <- c("AFD_chiasm.csv","AFDm_chiasm.csv","DISP_chiasm.csv","PEAK_chiasm.csv","AXIAL_chiasm_mrds.csv",
         "FA_chiasm_mrds.csv","MD_chiasm_mrds.csv", "RADIAL_chiasm_mrds.csv","SIZES_chiasm_mrds.csv")
gf_c <- c(1:9)
for (i in 1:length(gf_c)){
  print(paste(x_c[i],"+",y_c[i],"+",t_c[i],"+",tex_c[i],"+",z_c[i]))
  data_dmri(x_c[i],y_c[i],t_c[i],tex_c[i],z_c[i])
}








