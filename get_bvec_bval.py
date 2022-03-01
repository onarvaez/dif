#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar  6 21:10:50 2021

@author: omar
"""
##Import libraries
import numpy as np
import os.path
import pandas as pd
## Load paths 
dwi_folder = ('/home/omar/Desktop/QBI10RPAT12_QBI10RPAT12_4785104_1_Default_QBI10RPAT12_4785107_6.0.1/20210304_133633_QBI10RPAT12_QBI10RPAT12_1_1/')
filename = ('/home/omar/Desktop/QBI10RPAT12_QBI10RPAT12_4785104_1_Default_QBI10RPAT12_4785107_6.0.1/20210304_133633_QBI10RPAT12_QBI10RPAT12_1_1/25/method')
with open(filename,"rt") as file_method: 
    lines = file_method.read().split ('##$')
## you need to put ## after ##$PVM_DwDir directions 
# Here it identifies the fields to read from the method file
for line in lines:
    if line.startswith ('PVM_DwGradVec='):
      amp = line.split('\n',1)[1].split()
      print ('amp', amp)
    elif line.startswith ('PVM_DwEffBval='):
      bval = line.split('\n',1)[1].split()
      print ('bval', bval)
    elif line.startswith ('PVM_DwDir='):
      bvec = line.split('\n',1)[1].split()
      print ('bvec',bvec)
    elif line.startswith ('PVM_DwAoImages='):
      A0 = line.split('=',1)[1].split()
      print ('A0',A0)
      
# How many b0 are in the study then create an array of  0 0 0 and multiply the number of b0
      
for i in range(0, len(A0)): 
    A0[i] = int(A0[i]) 

numero = int(''.join(map(str,A0)))

array = np.array([0, 0, 0]).reshape(1,3)
array = pd.DataFrame(array)
A0_repeated_with_index = pd.concat([array]*numero)
#divide the bvecs by rows of 3 columns and make it a dataframe as well the bvals
bvec = [ bvec[n:n+3] for n in range(0,len(bvec),3) ]
bvec = pd.DataFrame(bvec)
bval = pd.DataFrame(bval)
# repeat them for two in this case because I have two bvalues with same directions, this could be modify to generalize to other studies
df_repeated_with_index = pd.concat([bvec]*2)
bvec_repeat = df_repeated_with_index.sort_index()
#merge b0 with bvecs and add bval
bvec_together = [A0_repeated_with_index,bvec_repeat]
bvec = pd.concat(bvec_together)
bval = bval.reset_index(drop=True)
bvec = bvec.reset_index(drop=True)

frames = [bvec,bval]

grad = pd.concat(frames, axis=1)
## save everything in different files for mrtrix format and fsl, it is needed to made changes 
#in bvec swaping the axis or something else but I haven't test that
base_filename = 'grad_high.txt'
with open(os.path.join(dwi_folder, base_filename),'w') as outfile:
    outfile.write(
        grad.to_string(header = False, index = False)
    )


base_filename = 'bvecs_high.txt'
with open(os.path.join(dwi_folder, base_filename),'w') as outfile:
    outfile.write(
        bvec.to_string(header = False, index = False)
    )


base_filename = 'bvals_high.txt'
with open(os.path.join(dwi_folder, base_filename),'w') as outfile:
    outfile.write(
        bval.to_string(header = False, index = False)
    )



