function R = upsample(I, filter, M)

[r, c] = size(M);

% interpolate, convolve with 2D separable filter
R = zeros(r,c);
R(1:2:r, 1:2:c) = I;
R = imfilter(R,filter);

% reweight, brute force weights from 1's in valid image positions
Z = zeros(r,c);
Z(1:2:r, 1:2:c) = 1;
Z = imfilter(Z,filter);
R = R./Z;

end