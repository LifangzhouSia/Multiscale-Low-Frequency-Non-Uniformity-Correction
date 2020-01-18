function b = mainpy(Insy)

% Initial B with all zeros
P = bdpy(Insy);
layerCount = size(P, 2); 
B = cell(1, layerCount);
for g = 1:size(B, 2)
    B{g} = zeros(size(P{g}));
end

% Automate set radius of Local Linear Model of NU
sizeTable = zeros(1, layerCount);
for k = 1:layerCount
    sizeTable(layerCount+1-k) = min(size(P{k}));
end

radius = ones(size(sizeTable));
radius(1) = floor((sizeTable(1) - 1)/3);
for k = 2:length(radius)
    radius(k) = 2*radius(k-1);
end
lambda = [0.2, 0.1, 0.07, 0.04, 0.03, 0.02, 0.01]/2;

% Another Method of Parameter Setting
% radius = floor((sizeTable-1)/4);
% lambda = [0.2, 0.1, 0.07, 0.04, 0.03, 0.02, 0.01]/2;

% You can also maually set the parameters
% radius = [2, 3, 4, 10, 10, 10, 10];
% lambda = [0.1, 0.07, 0.04, 0.01, 0.01, 0.01, 0.01];

for k = layerCount:-1:1
    
    % Construct this layer
    if k == layerCount
        thisLayer = P{k};
    else
        thisLayer = P{k} + upsample(y, pyramid_filter, P{k});
    end
    
    [yt, bt] = filteringpy(thisLayer, lambda(layerCount+1-k), 20, radius(layerCount+1-k));
    
    B{k} = bt;
    
    y = thisLayer - bt;
     
end

b = conspy(B);

end