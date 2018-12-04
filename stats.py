#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  3 23:16:29 2018

@author: omar
"""

import pandas as pd
import os 
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stts

def file_charge(filename1,filename2):
#ubicar el path del archivo
    main_path = "/home/omar/Documents/Tesis/data_mri"
    filename = filename1
    full_path = os.path.join(main_path,filename)

#cargar el file
    data = pd.read_table(full_path, sep=" ", names = ['mean','median','dev_std'], 
                     header = None)

#Se extrajo la mediana para cada grupo, en el grupo ctrl se excluye la rata 2
#y en el grupo thirty_d se excluye rata 3 y 5 

    ctrl = (data.iloc[:5,1]).drop((data.iloc[:5,1]).index[1])
    one_d = data.iloc[5:10,1]
    seven_d = data.iloc[10:15,1]
    thirty_d = (data.iloc[15:22,1]).drop((data.iloc[15:22,1]).index[[2,4]])

    ctrl_1= (pd.DataFrame(ctrl)).reset_index()
    one_d_1= (pd.DataFrame(one_d)).reset_index()
    seven_d_1= (pd.DataFrame(seven_d)).reset_index()
    thirty_d_1= (pd.DataFrame(thirty_d)).reset_index()

    all_files = [ctrl_1,one_d_1,seven_d_1,thirty_d_1]
    all_data = pd.DataFrame(pd.concat(all_files, keys =['ctrl','one_d','seven_d','thirty_d'],
                     axis = 1, ignore_index = True))
    print(all_data.drop([0,2,4,6], axis=1))
    data_1=all_data.drop([0,2,4,6], axis=1)

#%%
#ubicar el path del archivo
    main_path = "/home/omar/Documents/Tesis/data_mri"
    filename = filename2
    full_path_2 = os.path.join(main_path,filename)

#cargar el file
    data_pre_2 = pd.read_table(full_path_2, sep=" ", names = ['mean','median','dev_std'], 
                     header = None)

#Se extrajo la mediana para cada grupo, en el grupo ctrl se excluye la rata 2
#y en el grupo thirty_d se excluye rata 3 y 5 

    ctrl_2 = (data_pre_2.iloc[:5,1]).drop((data.iloc[:5,1]).index[1])
    one_d_2 = data_pre_2.iloc[5:10,1]
    seven_d_2 = data_pre_2.iloc[10:15,1]
    thirty_d_2 = (data_pre_2.iloc[15:22,1]).drop((data.iloc[15:22,1]).index[[2,4]])

    ctrl_2= (pd.DataFrame(ctrl_2)).reset_index()
    one_d_2= (pd.DataFrame(one_d_2)).reset_index()
    seven_d_2= (pd.DataFrame(seven_d_2)).reset_index()
    thirty_d_2= (pd.DataFrame(thirty_d_2)).reset_index()

    all_files_2 = [ctrl_2,one_d_2,seven_d_2,thirty_d_2]
    all_data_2 = pd.DataFrame(pd.concat(all_files_2, keys =['ctrl','one_d','seven_d','thirty_d'],
                     axis = 1, ignore_index = True))
    print(all_data_2.drop([0,2,4,6], axis=1))
    data_2=all_data_2.drop([0,2,4,6], axis=1)
    


#%%
#Intentar plotear

    fig, ax = plt.subplots()
    ax.set_title(filename1)
    ax.boxplot(data_1, labels=['ctrl','1 dia','7 dias','30 dias',''], manage_xticks = True)
    fig, ax = plt.subplots()
    ax.set_title(filename2)
    ax.boxplot(data_2, labels=['ctrl','1 dia','7 dias','30 dias',''], manage_xticks = True)


#%% stats1 

    ct_vs_1 = stts.mannwhitneyu(data_1[1], data_1[3])
    print(filename1 + " " + "ct_vs_1")
    print(data_1[1]) 
    print(data_1[3])
    print(ct_vs_1)
    ct_vs_7 = stts.mannwhitneyu(data_1[1], data_1[5])
    print(filename1 + " " + "ct_vs_7")
    print(data_1[1]) 
    print(data_1[5])
    print(ct_vs_7)
    ct_vs_30 = stts.mannwhitneyu(data_1[1], data_1[7])
    print(filename1 + " " + "ct_vs_30")
    print(data_1[1]) 
    print(data_1[7])
    print(ct_vs_30)

    ct_vs_1 = stts.mannwhitneyu(data_2[1], data_2[3])
    print(filename2 + " " + "ct_vs_1")
    print(data_2[1]) 
    print(data_2[3])
    print(ct_vs_1)
    ct_vs_7 = stts.mannwhitneyu(data_2[1], data_2[5])
    print(filename2 + " " + "ct_vs_7")
    print(data_2[1]) 
    print(data_2[5])
    print(ct_vs_7)
    ct_vs_30 = stts.mannwhitneyu(data_2[1], data_2[7])
    print(filename2 + " " + "ct_vs_30")
    print(data_2[1]) 
    print(data_2[7])
    print(ct_vs_30)