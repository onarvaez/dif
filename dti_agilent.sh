mrconvert epip3d_diffusion_omar_b0_01.nii -fslgrad epip3d_diffusion_omar_b0_01_FSL.bvec epip3d_diffusion_omar_b0_01_FSL.bval b0.mif

mrconvert epip3d_diffusion_omar_500_01.nii -fslgrad epip3d_diffusion_omar_500_01_FSL.bvec epip3d_diffusion_omar_500_01_FSL.bval 500.mif

mrconvert epip3d_diffusion_omar_1500_01.nii -fslgrad epip3d_diffusion_omar_1500_01_FSL.bvec epip3d_diffusion_omar_1500_01_FSL.bval 1500.mif

mrconvert epip3d_diffusion_omar_2500_01.nii -fslgrad epip3d_diffusion_omar_2500_01_FSL.bvec epip3d_diffusion_omar_2500_01_FSL.bval 2500.mif

mrconvert epip3d_diffusion_omar_3500_01.nii -fslgrad epip3d_diffusion_omar_3500_01_FSL.bvec epip3d_diffusion_omar_3500_01_FSL.bval 3500.mif

mrconvert epip3d_diffusion_omar_4500_01.nii -fslgrad epip3d_diffusion_omar_4500_01_FSL.bvec epip3d_diffusion_omar_4500_01_FSL.bval 4500.mif

mrconvert epip3d_diffusion_omar_5500_01.nii -fslgrad epip3d_diffusion_omar_5500_01_FSL.bvec epip3d_diffusion_omar_5500_01_FSL.bval 5500.mif

mrcat 500.mif 1500.mif 2500.mif 3500.mif 4500.mif 5500.mif cat_all.mif

mkdir analisis 
mv cat_all.mif analisis 
cd analisis 

dwidenoise cat_all.mif dwi_pre_den.mif
mrdegibbs dwi_pre_den.mif dwi_pre_den_gibbs.mif
mrmath -axis 3 dwi_pre_den.mif mean mean_dwi.mif
mrconvert mean_dwi.mif mean_dwi.nii.gz
fslmaths mean_dwi.nii.gz -thr 14000 -bin mean_mask.nii.gz
mrview mean_mask.nii.gz
 

mrinfo dwi_pre_den_gibbs.mif -export_grad_mrtrix b.txt -bvalue_scaling false
mrconvert dwi_pre_den_gibbs.mif -grad b_cor.txt dwi_proc.mif

mkdir motion
mv dwi_proc.mif motion
cd motion
#b0
dwiextract -bvalue_scaling false -shell 58 dwi_proc.mif  b0.mif 
mrinfo b0.mif -export_grad_mrtrix b0.txt -bvalue_scaling false
mrconvert b0.mif b0.nii.gz
fslsplit b0.nii.gz
mrcat vol0000.nii.gz vol0001.nii.gz vol0002.nii.gz - | mrmath -axis 3 - mean avb0_3.nii.gz
fslmaths avb0_3.nii.gz -thr 28000 -bin b0_mean_mask.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb0_3.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb0_3.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb0_3.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done

mrcat vol*_mean_Warped.nii.gz b0_cat.nii.gz
rm vol*
mrmath -axis 3 b0_cat.nii.gz mean avb0.nii.gz

#b500
dwiextract -bvalue_scaling false -shell 500 dwi_proc.mif b500.mif
mrinfo b500.mif -export_grad_mrtrix b500.txt -bvalue_scaling false
mrconvert b500.mif b500.nii.gz
fslsplit b500.nii.gz
for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb0.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb0.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb0.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b500_cat.nii.gz
rm vol*
mrmath -axis 3 b500_cat.nii.gz mean avb500.nii.gz

#b1500
dwiextract -bvalue_scaling false -shell 1500 dwi_proc.mif b1500.mif
mrinfo b1500.mif -export_grad_mrtrix b1500.txt -bvalue_scaling false
mrconvert b1500.mif b1500.nii.gz
fslsplit b1500.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb500.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b1500_cat.nii.gz
rm vol*
mrmath -axis 3 b1500_cat.nii.gz mean avb1500.nii.gz

#b2500
dwiextract -bvalue_scaling false -shell 2500 dwi_proc.mif b2500.mif
mrinfo b2500.mif -export_grad_mrtrix b2500.txt -bvalue_scaling false
mrconvert b2500.mif b2500.nii.gz
fslsplit b2500.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb1500.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb1500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb1500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done

mrcat vol*_mean_Warped.nii.gz b2500_cat.nii.gz
rm vol*
mrmath -axis 3 b2500_cat.nii.gz mean avb2500.nii.gz

#b3500
dwiextract -bvalue_scaling false -shell 3500 dwi_proc.mif b3500.mif
mrinfo b3500.mif -export_grad_mrtrix b3500.txt -bvalue_scaling false
mrconvert b3500.mif b3500.nii.gz
fslsplit b3500.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb2500.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb2500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb2500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done

mrcat vol*_mean_Warped.nii.gz b3500_cat.nii.gz
rm vol*
mrmath -axis 3 b3500_cat.nii.gz mean avb3500.nii.gz


#b4500
dwiextract -bvalue_scaling false -shell 4500 dwi_proc.mif b4500.mif
mrinfo b4500.mif -export_grad_mrtrix b4500.txt -bvalue_scaling false
mrconvert b4500.mif b4500.nii.gz
fslsplit b4500.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb3500.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb3500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb3500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b4500_cat.nii.gz
rm vol*
mrmath -axis 3 b4500_cat.nii.gz mean avb4500.nii.gz


#b5500
dwiextract -bvalue_scaling false -shell 5500 dwi_proc.mif b5500.mif
mrinfo b5500.mif -export_grad_mrtrix b5500.txt -bvalue_scaling false
mrconvert b5500.mif b5500.nii.gz
fslsplit b5500.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb4500.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb4500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb4500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [b0_mean_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b5500_cat.nii.gz
rm vol*
mrmath -axis 3 b5500_cat.nii.gz mean avb5500.nii.gz

#######end motion next thing - add gradients
mrconvert b0_cat.nii.gz -grad b0.txt b0_cat.mif
mrconvert b500_cat.nii.gz -grad b500.txt b500_cat.mif
mrconvert b1500_cat.nii.gz -grad b1500.txt b1500_cat.mif
mrconvert b2500_cat.nii.gz -grad b2500.txt b2500_cat.mif
mrconvert b3500_cat.nii.gz -grad b3500.txt b3500_cat.mif
mrconvert b4500_cat.nii.gz -grad b4500.txt b4500_cat.mif
mrconvert b5500_cat.nii.gz -grad b5500.txt b5500_cat.mif

mrcat b0_cat.mif b500_cat.mif b1500_cat.mif b2500_cat.mif b3500_cat.mif b4500_cat.mif b5500_cat.mif dwi_proc_motion.mif 

############################







dwi2tensor dwi_proc_motion.mif -mask mean_mask.nii.gz dt.mif
tensor2metric dt.mif -fa fa.mif -adc adc.mif -rd rd.mif -ad ad.mif -vector vec.mif

dwi2response dhollander dwi_proc.mif -mask mean_mask.nii.gz -info out_wm.txt out_gm.txt out_csf.txt -voxels csd_voxel.mif

dwi2fod msmt_csd dwi_proc.mif -mask mean_mask.nii.gz out_wm.txt fod_wm.mif out_gm.txt fod_gm.mif out_csf.txt fod_csf.mif

mtnormalise fod_wm.mif wmfod_norm.mif fod_gm.mif gmfod_norm.mif fod_csf.mif csffod_norm.mif -mask mean_mask.nii.gz

fod2fixel wmfod_norm.mif -mask mean_mask.nii.gz fixel -afd afd.mif -peak peak.mif -disp disp.mif

cd fixel
fixel2voxel afd.mif sum afd_sum.mif
fixel2voxel afd.mif mean afd_mean.mif
fixel2voxel afd.mif split_data afd_split.mif
fixel2voxel peak.mif sum peak_sum.mif
fixel2voxel peak.mif mean peak_mean.mif
fixel2voxel peak.mif split_data peak_split.mif
fixel2voxel disp.mif sum disp_sum.mif
fixel2voxel disp.mif mean disp_mean.mif
fixel2voxel disp.mif split_data disp_split.mif
cd ..









dwi2mask dwi_pre_den.mif mask.mif 
dwiextract -bvalue_scaling false -shell 55 dwi_pre_den.mif  b55.mif 
dwiextract -bvalue_scaling false -shell 5500 dwi_pre_den.mif  b5500.nii.gz 

fslsplit b5500.nii.gz
mrcat vol0000.nii.gz vol0001.nii.gz vol0002.nii.gz - | mrmath -axis 3 - mean avb5500_3.nii.gz
fslmaths avb5500_3.nii.gz -thr 110 -bin avb5500_3_mask.nii.gz


for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [mean_bzero.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[mean_bzero.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[mean_bzero.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [mean_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b500_cat.mif
rm vol*
mrmath -axis 3 b500_cat.mif mean avb500.nii.gz


fslsplit b3500.nii.gz
for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb2500.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb2500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb2500.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [mean_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b3500_cat.mif
rm vol*
mrmath -axis 3 b3500_cat.mif mean avb3500.nii.gz




mrcat b55.mif b5500_cat.mif dwi_proc_no_grads.mif

dwi2tensor dwi_proc_grads.mif dt_5500.mif 

fslsplit b5500.nii.gz



tckedit optic_visual_sift.tck -include optic_nerves_roi_l.mif -include optic_tracts_roi_l.mif -exclude optic_tracts_roi_r.mif -exclude supra_chiasm_roi_l.mif -exclude supra_chiasm_roi_r.mif optic_tract_sift_ipsi_l.tck


tckedit optic_visual_sift.tck -include optic_nerves_roi_r.mif -include optic_tracts_roi_l.mif -exclude optic_tracts_roi_r.mif -exclude supra_chiasm_roi_l.mif -exclude supra_chiasm_roi_r.mif optic_tract_sift_contra_r.tck





find $PDW -name "*cv*"|sort
fixel2voxel afd.mif split_data -number 3 afd_split.mif -force
mrcrop afd_split.mif -mask chiasm_roi.mif chiasm.mif
mrconvert chiasm.mif chiasm.nii.gz -force
fslsplit chiasm.nii.gz
mv vol0000.nii.gz afd1.nii.gz
mv vol0001.nii.gz afd2.nii.gz
mv vol0002.nii.gz afd3.nii.gz


mrstats -mask right_roi.mif ad.mif 
mrstats -mask left_roi.mif ad.mif 
mrstats -mask right_roi.mif rd.mif 
mrstats -mask left_roi.mif rd.mif
mrstats -mask right_roi.mif adc.mif 
mrstats -mask left_roi.mif adc.mif 
mrstats -mask right_roi.mif fixel/peak_mean.mif
mrstats -mask left_roi.mif fixel/peak_mean.mif
mrstats -mask right_roi.mif fixel/disp_mean.mif
mrstats -mask left_roi.mif fixel/disp_mean.mif


