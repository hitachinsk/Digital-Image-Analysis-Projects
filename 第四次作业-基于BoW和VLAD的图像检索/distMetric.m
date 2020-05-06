function dist = distMetric(feature, reference, method)
if method == 1
    dist = sum(abs(feature - reference));
elseif method == 2
    dist = sqrt(sum((feature - reference).^2));
else
    error('Not supported method type');
end