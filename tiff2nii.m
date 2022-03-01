
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.jpg'));

for index = 1 : length(files)
	thisfile = files(index); 
    niiImg = tiff2nii([d,'/',thisfile.name], 'axial', [0.325 0.325 1]);
    save_nii(niiImg, ['vol_' thisfile.name '.nii'])
end 


d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.jpg'));

parfor index = 1 : length(files)
	thisfile = files(index); 
    im=imread([d,'/',thisfile.name]);
    imwrite(im, ['vol_' thisfile.name '.png'])
end 

