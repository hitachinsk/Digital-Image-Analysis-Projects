function falseNums = removeFalseMatch(r, features_q, features_m, nonZeros)
[Sx, Sy] = inconsistencyOp(r, features_q, features_m);
falseNums = [];
counter = 0;
while (sum(Sx) ~= 0) || (sum(Sy) ~= 0)
    if counter > 100000
        error('Fail to converge');
    end
    [~, falseNum] = max(Sx + Sy);
    falseNums = [falseNums, nonZeros(falseNum)];
    [features_q, features_m, nonZeros] = removeSingleFeature(features_q, features_m, nonZeros, falseNum); 
    [Sx, Sy] = inconsistencyOp(r, features_q, features_m);
    counter = counter + 1;
end
end

function [Sx, Sy] = inconsistencyOp(r, features_q, features_m)
[Gx_q, Gy_q] = spatialCoding(r, features_q);
[Gx_m, Gy_m] = spatialCoding(r, features_m);
[Sx, Sy] = computeInconsistency(Gx_q, Gx_m, Gy_q, Gy_m);
end

function [newFeature_q, newFeature_m, nonZeros] = removeSingleFeature(features_q, features_m, nonZeros, falseNum)
newFeature_q = [features_q(:, 1:falseNum-1), features_q(:, falseNum+1:end)];
newFeature_m = [features_m(:, 1:falseNum-1), features_m(:, falseNum+1:end)];
nonZeros = [nonZeros(:, 1:falseNum-1), nonZeros(:, falseNum+1:end)];
end