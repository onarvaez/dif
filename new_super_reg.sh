dwiextract cat_all.mif -no_bzero no_bzero.mif
dwiextract cat_all.mif -bzero bzero.mif
mrcat bzero.mif no_bzero.mif dwi_pre.mif
mrcrop dwi_pre.mif -axis 2 19 121 - 	| mrcrop - -axis 1 35 138 dwi_pre_crop.mif
dwidenoise dwi_pre_crop.mif dwi_denoised_crop.mif -noise noise.mif
mrdegibbs dwi_denoised_crop.mif dwi_denoised_crop_gibbs.mif
dwibiascorrect -ants dwi_denoised_crop_gibbs.mif dwi_denoised_crop_unbias.mif -ants.b [7,3] -ants.c [700,0.0] -bias bias.mif
mrinfo dwi_denoised_crop_unbias.mif -export_grad_mrtrix b.txt -bvalue_scaling false
dwiextract dwi_denoised_crop_unbias.mif  -bzero bzero_cropped.nii.gz
fslsplit bzero_cropped.nii.gz
mrcat vol0000.nii.gz vol0001.nii.gz vol0002.nii.gz vol0003.nii.gz vol0004.nii.gz - | mrmath -axis 3 - mean avbzero_5.nii.gz
fslmaths avbzero_5.nii.gz -thr 400 -bin avbzero_5_mask.nii.gz

for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avbzero_5.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avbzero_5.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avbzero_5.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [avbzero_5_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz bzero_cat.mif
rm vol*
mrmath -axis 3 bzero_cat.mif mean avbzero.nii.gz
#mii
dwiextract -bvalue_scaling false -shell 1000 dwi_denoised_crop_unbias.mif  b1000.nii.gz
fslsplit b1000.nii.gz
for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avbzero.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avbzero.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avbzero.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [avbzero_5_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b1000_cat.mif
rm vol*
mrmath -axis 3 b1000_cat.mif mean avb1000.nii.gz
#tresmil
dwiextract -bvalue_scaling false -shell 3000 dwi_denoised_crop_unbias.mif  b3000.nii.gz
fslsplit b3000.nii.gz
for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb1000.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb1000.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb1000.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [avbzero_5_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b3000_cat.mif
rm vol*
mrmath -axis 3 b3000_cat.mif mean avb3000.nii.gz
#cincomil
dwiextract -bvalue_scaling false -shell 5000 dwi_denoised_crop_unbias.mif  b5000.nii.gz
fslsplit b5000.nii.gz
for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb3000.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb3000.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb3000.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [avbzero_5_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b5000_cat.mif
rm vol*
mrmath -axis 3 b5000_cat.mif mean avb5000.nii.gz
#sietemil
dwiextract -bvalue_scaling false -shell 7000 dwi_denoised_crop_unbias.mif  b7000.nii.gz
fslsplit b7000.nii.gz
for i in vol*.nii.gz
  do
vol=$(echo $i | cut -d '.' -f 1)
antsRegistration --verbose 1 --dimensionality 3 --output [${i},${vol}_mean_Warped.nii.gz,${vol}_mean_InverseWarped0.nii.gz] --interpolation Linear --winsorize-image-intensities [0.009,0.991] --initial-moving-transform [avb5000.nii.gz,${i},0] --transform Rigid[0.08] --metric MI[avb5000.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox --transform Affine[0.08] --metric MI[avb5000.nii.gz,${i},0.7,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,30] --shrink-factors 8x4x2x1 --smoothing-sigmas 0.5x0x0x0vox  --float 0 --collapse-output-transforms 1 --use-histogram-matching 1 -x [avbzero_5_mask.nii.gz]
done
mrcat vol*_mean_Warped.nii.gz b7000_cat.mif
rm vol*
mrmath -axis 3 b7000_cat.mif mean avb7000.nii.gz
#modelos
mrcat bzero_cat.mif b1000_cat.mif b3000_cat.mif b5000_cat.mif b7000_cat.mif dwi_no_grad.mif

mrconvert dwi_no_grad.mif  -grad b.txt dwi_proc.mif
fslmaths avbzero.nii.gz -thr 150 -bin avbzero_mask.nii.gz

dwi2tensor dwi_proc.mif -mask avbzero_mask.nii.gz dt.mif
tensor2metric dt.mif -fa fa.mif -vector vector.mif -adc adc.mif -ad ad.mif -rd rd.mif

dwi2response dhollander dwi_proc.mif -info out_wm.txt out_gm.txt out_csf.txt
dwi2fod dwi_proc.mif -mask avbzero_mask.nii.gz out_wm.txt fod_wm.mif out_gm.txt fod_gm.mif out_csf.txt fod_csf.mif
fod2fixel fod_wm.mif -mask avbzero_mask.nii.gz fixel -afd afd.mif -peak peak.mif -disp disp.mif
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
