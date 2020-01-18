function P = bdpy(I)

pf = [.05, .25, .4, .25, .05];
pf = pf'*pf;

% Layer Count
minBottom = 8;
[hei, wid] = size(I);
minSize = min([hei, wid]);
layerCount = 1;
while minSize > minBottom
    minSize = floor((minSize+1)/2);
    layerCount = layerCount + 1;
end

% Build pyramid
P = cell(1, layerCount);
F = I;
for k = 1:layerCount-1
    
    F0 = F;
    
    F = imfilter(F, pf);
    R = imfilter(ones(size(F)), pf);
    F = F ./ R;
    F = F(1:2:size(F, 1), 1:2:size(F, 2));
    
    upF = zeros(size(F0));
    upF(1:2:size(upF, 1), 1:2:size(upF, 2)) = F;
    upF = imfilter(upF, pf);
    Z   = zeros(size(F0));
    Z(1:2:size(upF, 1), 1:2:size(upF, 2)) = 1;
    Z = imfilter(Z, pf);
    upF = upF ./ Z;
    
    P{k} = F0 - upF;
end
P{layerCount} = F;

end
