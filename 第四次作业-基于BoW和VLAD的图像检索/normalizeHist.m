function featureHist = normalizeHist(featureHist, method)
if method == 1
    for i=1:size(featureHist, 1)
        featureHist(i, :) = featureHist(i, :) ./ sum(featureHist(i, :));
    end
elseif method == 2
    for i=1:size(featureHist, 1)
        featureHist(i, :) = featureHist(i, :) / sqrt(sum(featureHist(i, :).^2));
    end
else
    error('Not supported method type');
end