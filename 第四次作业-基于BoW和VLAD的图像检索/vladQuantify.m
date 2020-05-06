function v = vladQuantify(features, codeBook)
NN = quantify(features, codeBook, 2);
v = zeros(1, 128 * size(codeBook, 1));
for i=1:size(NN, 1)
    lowerBound = (NN(i, 1) - 1) * 128;
    v(1, lowerBound+1:lowerBound+128) = v(1, lowerBound+1:lowerBound+128) + features(i, :) - codeBook(NN(i, 1), :);
end
