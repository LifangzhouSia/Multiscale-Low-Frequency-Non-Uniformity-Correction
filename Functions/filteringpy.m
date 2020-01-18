function [S, NU] = filteringpy(Im, lambda, kappa, radius)

if ~exist('kappa','var')
    kappa = 5.0;
end
if ~exist('lambda','var')
    lambda = 0.01;
end

S0 = double(Im);
S  = double(Im);
betamax = 1e7;
fx = [1, -1];
fy = [1; -1];
[N,M,D] = size(Im);
sizeI2D = [N,M];
otfFx = psf2otf(fx,sizeI2D);
otfFy = psf2otf(fy,sizeI2D);
Normin1 = fft2(S);
Denormin2 = abs(otfFx).^2 + abs(otfFy).^2;
if D>1
    Denormin2 = repmat(Denormin2,[1,1,D]);
end
beta = 2*lambda;
iter = 1;
sg = 0.1;
NU = zeros(sizeI2D);
C  = ones(sizeI2D);
while beta < betamax
    
    Denormin = 1 + beta*Denormin2;
    
    if iter ~= 1
        Normin1 = fft2(S0 - NU);
        er = (S0 - NU - S).^2;
        er = (er + sg^2).^2;
        C = (2*sg^2)./er;
    end
    
    % h-v subproblem
    h = [diff(S,1,2), S(:,1,:) - S(:,end,:)];
    v = [diff(S,1,1); S(1,:,:) - S(end,:,:)];
    if D==1
        t = (h.^2+v.^2)<lambda/beta;
    else
        t = sum((h.^2+v.^2),3)<lambda/beta;
        t = repmat(t,[1,1,D]);
    end
    h(t)=0; v(t)=0;
    
    % S subproblem
    Normin2 = [h(:,end,:) - h(:, 1,:), -diff(h,1,2)];
    Normin2 = Normin2 + [v(end,:,:) - v(1,:,:); -diff(v,1,1)];
    S = (Normin1 + beta*fft2(Normin2))./Denormin;
    S = real(ifft2(S));
    beta = beta*kappa;
    
    % NU subploblem
    L = S0 - S;
    [dL] = weightedLinearRidgeRegression(L, C, radius, 0.001);
    NU = dL;
%     figure, imshow([newlp(S) newlp(NU);newlp(C) newlp(S0 - NU)]), title(iter), pause(0.01)
    
    iter = iter + 1;
end

end
