dwiextract cat_all.mif -no_bzero no_bzero.mif
dwiextract cat_all.mif -bzero bzero.mif
mrcat bzero.mif no_bzero.mif dwi_pre.mif
dwidenoise dwi_pre.mif dwi_denoised.mif -noise noise.mif
mrcrop dwi_denoised.mif -axis 2 2 121 dwi_denoised_cropped.mif
dwiextract dwi_denoised_cropped.mif -bzero bzero_cropped.mif
inb_dwi_exclude_volumes.sh bzero_cropped.mif bzero_5.mif 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
mrmath bzero_5.mif -axis 3 mean bzero_5_mean.mif
mrconvert bzero_5_mean.mif bzero_5_mean.nii.gz
mrconvert bzero_cropped.mif bzero_cropped.nii.gz
fslsplit bzero_cropped.nii.gz bvol

for i in bvol*.nii.gz

  do
bvol=$(echo $i | cut -d '.' -f 1)

flirt -ref bzero_5_mean.nii.gz -in $i -out ${bvol}_bz_to_bzero_mean.nii.gz -cost mutualinfo -searchcost mutualinfo -v -nosearch -omat reg_${bvol}_bz_to_bzero_mean.mat -dof 12
done

mrcat bvol*_bz_to_bzero_mean.nii.gz concat_b0.nii.gz
mrmath concat_b0.nii.gz -axis 3 mean b0_mean.nii.gz

rm bvol*
rm reg*

#mil

mrinfo dwi_denoised_cropped.mif -export_grad_mrtrix b.txt -bvalue_scaling false

dwiextract -bvalue_scaling false -shell 1000 dwi_denoised_cropped.mif b1000.mif
mrconvert b1000.mif b1000.nii.gz
fslsplit b1000.nii.gz

for i in vol*.nii.gz

  do
vol=$(echo $i | cut -d '.' -f 1)
flirt -ref b0_mean.nii.gz -in $i -out ${vol}_dif1000_to_bzero_mean.nii.gz -cost mutualinfo -searchcost mutualinfo -v -nosearch -omat reg_${vol}_dif_to_bzero_mean.mat -dof 12
done

mrcat vol*_dif1000_to_bzero_mean.nii.gz dwi1000_cat.mif
mrmath -axis 3 dwi1000_cat.mif mean avb1000.mif
mrconvert avb1000.mif avb1000.nii.gz

rm vol*
rm reg*

#tresmil

dwiextract -bvalue_scaling false -shell 3000 dwi_denoised_cropped.mif b3000.mif
mrconvert b3000.mif b3000.nii.gz
fslsplit b3000.nii.gz

for i in vol*.nii.gz

  do
vol=$(echo $i | cut -d '.' -f 1)
flirt -ref avb1000.nii.gz -in $i -out ${vol}_dif3000_to_b1000_mean.nii.gz -cost mutualinfo -searchcost mutualinfo -v -nosearch -omat reg_${vol}_dif3000_to_b1000_mean.mat -dof 12
done

mrcat vol*_dif3000_to_b1000_mean.nii.gz dwi3000_cat.mif
mrmath -axis 3 dwi3000_cat.mif mean avb3000.mif
mrconvert avb3000.mif avb3000.nii.gz

rm vol*
rm reg*

#cincomil

dwiextract -bvalue_scaling false -shell 5000 dwi_denoised_cropped.mif b5000.mif
mrconvert b5000.mif b5000.nii.gz
fslsplit b5000.nii.gz

for i in vol*.nii.gz

  do
vol=$(echo $i | cut -d '.' -f 1)
flirt -ref avb3000.nii.gz -in $i -out ${vol}_dif5000_to_b3000_mean.nii.gz -cost mutualinfo -searchcost mutualinfo -v -nosearch -omat reg_${vol}_dif5000_to_b3000_mean.mat -dof 12
done

mrcat vol*_dif5000_to_b3000_mean.nii.gz dwi5000_cat.mif
mrmath -axis 3 dwi5000_cat.mif mean avb5000.mif
mrconvert avb5000.mif avb5000.nii.gz

rm vol*
rm reg*

#sietemil


dwiextract -bvalue_scaling false -shell 7000 dwi_denoised_cropped.mif b7000.mif
mrconvert b7000.mif b7000.nii.gz
fslsplit b7000.nii.gz

for i in vol*.nii.gz

  do
vol=$(echo $i | cut -d '.' -f 1)
flirt -ref avb5000.nii.gz -in $i -out ${vol}_dif7000_to_b5000_mean.nii.gz -cost mutualinfo -searchcost mutualinfo -v -nosearch -omat reg_${vol}_dif7000_to_b5000_mean.mat -dof 12
done

mrcat vol*_dif7000_to_b5000_mean.nii.gz dwi7000_cat.mif
mrmath -axis 3 dwi7000_cat.mif mean avb7000.mif
mrconvert avb7000.mif avb7000.nii.gz

rm vol*
rm reg*

mrcat concat_b0.nii.gz dwi1000_cat.mif dwi3000_cat.mif dwi5000_cat.mif dwi7000_cat.mif dwi_cat_all_no_grad.mif
mrconvert dwi_cat_all_no_grad.mif dwi_cat_grad.mif -grad b.txt 


inb_dwibiascorrect.sh dwi_cat_grad.mif nomask dwi_proc.mif "-s 2 -v -b 6x6x6x3"
dwi2tensor dwi_proc.mif dt.mif -force
tensor2metric -fa fa.mif -adc adc.mif -vector vec.mif -ad ad.mif -rd rd.mif dt.mif
dwi2response dhollander dwi_proc.mif out_wm.txt out_gm.txt out_csf.txt
dwi2fod msmt_csd dwi_proc.mif out_wm.txt fod_wm.mif out_gm.txt fod_gm.mif out_csf.txt fod_csf.mif
fod2fixel fod_wm.mif fixel -afd afd.mif -peak peak.mif -disp disp.mif
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
rm avb* b1000* b3000* b5000* b7000* dwi1000* dwi3000* dwi5000* dwi7000* no_bzero* bzero.mif bzero_5.mif concat_b0* dwi_cat_all_no* dwi_proc_bias* dwi_cat_grad.mif dwi_deno* bzero_cropp* dwi_pre* bzero_5_mean*

mrview dwi_proc.mif


