#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue May  1 19:32:43 2018

@author: onarvaez
"""
import os
import nipype 
import nipype.interfaces.mrtrix as mrt
tck2trk = mrt.MRTrix2TrackVis()
tck2trk.inputs.in_file = '/misc/torrey/onarvaez/difusion_test/Marcos_a/scans/mrtrix/tckwhole_1millon.tck'
tck2trk.inputs.image_file = '/misc/torrey/onarvaez/difusion_test/Marcos_a/scans/nii/dwi_final.nii.gz'
tck2trk.run()
