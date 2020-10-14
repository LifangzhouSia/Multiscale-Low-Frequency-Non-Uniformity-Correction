function [dL] = weightedLinearRidgeRegression(L, C, r, eps)
% This function calculates the solution of
% \| C(ax + by + ce - z) \|_2^2 + \epsilon(a^2 + b^2)
% for each local area, which matches the local linear observation of NU

[hei, wid] = size(L);
x = repmat([1:hei].', 1, wid);
y = repmat([1:wid]  , hei, 1);

N  = boxfilter(C, r);
Ne = boxfilter(ones(hei, wid), r);

mean_x  = boxfilter(x.*C, r) ./ N;
mean_y  = boxfilter(y.*C, r) ./ N;
mean_L  = boxfilter(L.*C, r) ./ N;

mean_xx = boxfilter(x.*x.*C, r) ./ N;
mean_yy = boxfilter(y.*y.*C, r) ./ N;
mean_xy = boxfilter(x.*y.*C, r) ./ N;
mean_xL = boxfilter(x.*L.*C, r) ./ N;
mean_yL = boxfilter(y.*L.*C, r) ./ N;

var_x   = mean_xx - mean_x.*mean_x;
var_y   = mean_yy - mean_y.*mean_y;
cov_xy  = mean_xy - mean_x.*mean_y;
cov_xL  = mean_xL - mean_x.*mean_L;
cov_yL  = mean_yL - mean_y.*mean_L;

M  = (var_x + eps).*(var_y + eps) - cov_xy.*cov_xy;
Sa = (var_y + eps).*cov_xL - cov_xy.*cov_yL;
Sb = (var_x + eps).*cov_yL - cov_xy.*cov_xL;

a  = Sa./M;
b  = Sb./M;
c  = mean_L - mean_x.*a - mean_y.*b;

mean_a = boxfilter(a, r) ./ Ne;
mean_b = boxfilter(b, r) ./ Ne;
mean_c = boxfilter(c, r) ./ Ne;

dL = mean_a.*x + mean_b.*y + mean_c;

end

% A copy of boxfilter function from the 
% official Matlab implementation of 'Guided image filtering'
function imDst = boxfilter(imSrc, r)
%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
%   - Running time independent of r; 
%   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
%   - But much faster.

[hei, wid] = size(imSrc);
imDst = zeros(size(imSrc));

%cumulative sum over Y axis
imCum = cumsum(imSrc, 1);
%difference over Y axis
imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
imDst(r+2:hei-r, :) = imCum(2*r+2:hei, :) - imCum(1:hei-2*r-1, :);
imDst(hei-r+1:hei, :) = repmat(imCum(hei, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :);

%cumulative sum over X axis
imCum = cumsum(imDst, 2);
%difference over Y axis
imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
imDst(:, r+2:wid-r) = imCum(:, 2*r+2:wid) - imCum(:, 1:wid-2*r-1);
imDst(:, wid-r+1:wid) = repmat(imCum(:, wid), [1, r]) - imCum(:, wid-2*r:wid-r-1);
end