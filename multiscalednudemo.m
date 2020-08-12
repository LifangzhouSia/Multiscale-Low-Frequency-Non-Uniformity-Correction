function multiscalednudemo
%a single-frame-based multi-scale low-frequency NU correction method
%  MULTISCALEDNUDEMO reads and denoises raw uncooled infrared images with
%  low-frequency NU. 
%
%  To run the demo, type MULTISCALEDNUDEMO from the Matlab prompt.
%
%  Fangzhou Li
%  November 2019

disp(' ');
disp('  **********  Multi-scale Low-frequency NU removal Demo  **********');
disp(' ');
disp('  This demo reads raw uncooled infrared images with low-frequency NU(LFNU)');
disp('  The LFNU is obtained from coarse to fine from the Gaussian pyramid of the image.');
disp('  The denoised image and the estimated LFNU will be shown.');
disp(' ');

%% prompt user for image %%

addpath('.\Functions')

img = readImage('multiscalednudemo');

% The strength of NU, adjust between [0, 1]
NU_Level = 0.7;
NU = (img.img.NU - min(img.img.NU(:)))./(max(img.img.NU(:)) - min(img.img.NU(:)));
im = (img.img.img - min(img.img.img(:)))./(max(img.img.img(:)) - min(img.img.img(:)));
im = im + NU_Level*NU;

%% generate noisy image %% 

% denoise
disp('Performing Multiscale DNU...');
[bias] = mainpy(im);

% show results %
figure; imshow(newlp(im));
title('Original noisy image');

figure; imshow(newlp(im - bias));
title('Denoised image')

figure; imshow(newlp(bias))
title('Estimated NU')
