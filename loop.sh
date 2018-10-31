for k in {'ctr0','isd01r0','isd07r0','isd30r0'};
  do
  for i in {1..7};
    do
    for j in {'l','r'}
      do
      for h in {'ad','fa','md','rd'}
        do

mrstats -mask /home/onarvaez/Downloads/chiasm_04_cropped_dti_fa_more/chiasm_04_cropped_dti_fa/${k}${i}/tensor/${j}.nii /home/onarvaez/Downloads/chiasm_04_cropped_dti_fa_more/chiasm_04_cropped_dti_fa/${k}${i}/tensor/dwi_proc_crop_tensor_${h}.nii > /home/onarvaez/Downloads/chiasm_04_cropped_dti_fa_more/chiasm_04_cropped_dti_fa/${k}${i}/tensor/${h}_${j}.txt 

cat /home/onarvaez/Downloads/chiasm_04_cropped_dti_fa_more/chiasm_04_cropped_dti_fa/${k}${i}/tensor/${h}_${j}.txt | sed -n '2'p | cut -d ']' -f 2 | sed 's/ /,/g' | sed 's/,,,,/,/g' | sed 's/,,,/,/g' | sed 's/,,/,/g' | cut -d ',' -f '2 3 4 5 6 7' >> /home/onarvaez/Downloads/chiasm_04_cropped_dti_fa_more/stats_${h}_${j}.csv

   done 
  done 
 done 
done 

