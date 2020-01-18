function I = readImage(method)

pathstr = fileparts(which(method));
dirname = fullfile(pathstr, 'Datasets', '*.mat');
imglist = dir(dirname);

disp('  Available test images:');
disp(' ');
for k = 1:length(imglist)
  fprintf('  %d. %s\n', k, imglist(k).name);
end
disp(' ');

imnum = 0;
while (~isnumeric(imnum) || imnum<1 || imnum>length(imglist))
  imnum = input(sprintf('  Image to denoise (%d-%d): ', 1, length(imglist)), 's');
  imnum = sscanf(imnum, '%d');
end

imgname = fullfile(pathstr, 'Datasets', imglist(imnum).name);


I = load(imgname);


end
