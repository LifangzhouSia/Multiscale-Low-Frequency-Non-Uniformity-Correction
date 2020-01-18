function multiscalednudemo
%D1WLSDESTRIPEDEMO CNLM denoising method.
%  D1WLSDESTRIPEDEMO reads and denoises raw uncooled infrared images with
%  stripe noise.
%
%  To run the demo, type D1WLSDESTRIPEDEMO from the Matlab prompt.

%  Fangzhou Li
%
%  November 2019

disp(' ');
disp('  **********  D1-WLS Destriping Demo  **********');
disp(' ');
disp('  This demo reads raw uncooled infrared images with stripe noise.');
disp('  The stripe noise will be removed using two 1D filters on horizontal and vertical direction.');
disp('  The denoised image and the estimated stripe noise will be shown.');
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

% denoise!
disp('Performing Multiscale DNU...');
[bias] = mainpy(im);

% show results %

figure; imshow(newlp(im));
title('Original noisy image');

figure; imshow(newlp(im - bias));
title('Denoised image')

figure; imshow(newlp(bias))
title('Estimated NU')
