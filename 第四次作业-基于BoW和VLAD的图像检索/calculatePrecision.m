function precision = calculatePrecision(relativeMatrix)
retrievalMatrix = zeros(size(relativeMatrix, 1), 4);
for i=1:4
    [~, location] = min(relativeMatrix, [], 2);
    retrievalMatrix(:, i) = location;
    for j=1:size(location, 1)
        relativeMatrix(j, location(j, 1)) = intmax;
    end
end
precision = prec(retrievalMatrix);
end

function precision = prec(retrievalMatrix)
precision = zeros(size(retrievalMatrix, 1), 1);
for i=1:size(retrievalMatrix, 1)
    for j=1:4
        if floor((retrievalMatrix(i, j)-1) / 4) == floor((i-1) / 4)
            precision(i, 1) = precision(i, 1) + 1;
        end
    end
end
precision = mean(precision);
end
