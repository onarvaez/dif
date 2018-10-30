format long
folder = '/misc/torrey/onarvaez/ex_vivo/lps/lps05/past/stats/';
stats = {'mean','median','std','min','max','count'};
metric = {'fa','adc','rd','ad'};
nname = {'stats_op_l', 'stats_op_r'};
ext   = '.txt';
ns = length(stats);
nm = length(metric);
nn = length(nname);
A = zeros(nm,ns,nn);
for l = 1:nn 
for k = 1:nm
for i = 1:ns
    fname = [folder nname{l} '_' metric{k} '_' stats{i} ext];
    a = load(fname);
    A(k,i,l) = a;
end
end
end
Al = A(:,:,1);
Ar = A(:,:,2);
rowNames = {'fa','adc','rd','ad'};
colNames = {'mean','median','std', 'min','max','count'};
sTable_l = array2table(Al,'RowNames',rowNames,'VariableNames',colNames)
sTable_r = array2table(Ar,'RowNames',rowNames,'VariableNames',colNames)
writetable(sTable_l, 'cat_par_l.csv','Delimiter',',','WriteRowNames',true)
writetable(sTable_r, 'cat_par_r.csv','Delimiter',',','WriteRowNames',true)