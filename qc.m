function qc(filename,n_vol)
[this_dir,this_file,this_ext] = fileparts(filename);
close all
q = niftiread(filename);
dms = size(q);
M2d = reshape(q, [(dms(1))*(dms(2))*(dms(3)),(dms(4))]);
figure
subplot(2,2,[1,2]);
imagesc(M2d(:,1:32));
subplot(2,2,[3,4])
plot(mean(M2d))
savedir = this_dir;
%Plot carpet plot and save 
graph_car = ('_carpet');
baseFile = ('.png');
full_file_name = strcat(this_file, graph_car, baseFile);
saveas(gcf,fullfile(savedir,full_file_name))
[p,tbl,stats] = friedman(M2d);
figure
mc = multcompare(stats);
%Plot multiple comparison plot and save
graph_mult = ('_mul_comp');
full_file_name_2 = strcat(this_file, graph_mult, baseFile);
saveas(gcf,fullfile(savedir,full_file_name_2))
% specgram(M2d(:,17))
x = stats.meanranks(:);
n = n_vol;
val = zeros(n,1);
row = zeros(n,1);
for i=1:n
  [val(i),idx] = min(x);
  [row(i), col] = ind2sub(size(x), idx);
  % remove for the next iteration the last smallest value:
  x(idx) = [];
end
fprintf(1,'Here shows %d min mean ranks values. Look the mean and std to compare \n',n_vol)
minvol = horzcat(val,row);
minvol

fprintf(1,'Mean value for all dwi %f \n',mean(x))
fprintf(1,'Std value for all dwi %f \n',std(x))

end



