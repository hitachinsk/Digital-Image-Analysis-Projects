function [matchInd, falseInd] = geometricVerificationInterface(r, paraFeat_1, paraFeat_2, matchInd)
[feature_q, feature_m, nonZeros] = generateMatrix(paraFeat_1, paraFeat_2, matchInd);
falseNums = removeFalseMatch(r, feature_q, feature_m, nonZeros);
falseInd = matchInd;
matchInd(falseNums, 1) = 0;
falseInd(setdiff(1:numel(matchInd), falseNums), 1) = 0;
end

function [feature_q, feature_m, nonZeros] = generateMatrix(paraFeat_1, paraFeat_2, matchInd)
feature_q = [];
feature_m = [];
nonZeros = [];
for i=1:size(matchInd, 1)
    if matchInd(i, 1) ~= 0
        feature_q = [feature_q, paraFeat_1(1:2, i)];
        feature_m = [feature_m, paraFeat_2(1:2, matchInd(i, 1))];
        nonZeros = [nonZeros, i];
    end
end
end