function histogram = createHist(quantifyResult, types)
histogram = zeros(1, types);
for i=1:size(quantifyResult, 1)
    histogram(1, quantifyResult(i, 1)) = histogram(1, quantifyResult(i, 1)) + 1;
end