function I = conspy(P)

layerCount = size(P, 2);

pf = [.05, .25, .4, .25, .05];
pf = pf'*pf;

I = P{layerCount};
for k = (layerCount-1) : -1 : 1
    
    upI = zeros(size(P{k}));
    upI(1:2:size(upI, 1), 1:2:size(upI, 2)) = I;
    upI = imfilter(upI, pf);
    Z   = zeros(size(P{k}));
    Z(1:2:size(upI, 1), 1:2:size(upI, 2)) = 1;
    Z = imfilter(Z, pf);
    upI = upI ./ Z;
    
    I = upI + P{k};
end

end