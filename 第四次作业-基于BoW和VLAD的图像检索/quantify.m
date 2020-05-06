function result = quantify(features, codeBook, method)
distance = zeros(size(features, 1), size(codeBook, 1));
for i=1:size(features, 1)
    for j=1:size(codeBook, 1)
        distance(i, j) = calcDistance(features(i, :), codeBook(j, :), method);
    end
end
[~, result] = min(distance, [], 2);
end

function dist = calcDistance(feature, reference, method)
if method == 1
    dist = sum(abs(feature - reference));
elseif method == 2
    dist = sqrt(sum((feature - reference).^2));
else
    error('Not supported method type');
end
end