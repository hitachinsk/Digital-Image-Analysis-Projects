function loc = newLoc(roi, weightMap, q_temp, y)
% xi是位置信息，输出应该是一个表示x和y的二元变量
[h, w, ~] = size(roi);
loc = zeros(1, 2);
locNorm = zeros(1, 2);
g = 1;
for i=1:h
    for j=1:w
        loc = loc + weightMap(uint32(q_temp(i, j))+1) * [i-y(1), j-y(2)] * g;
        locNorm = locNorm + weightMap(uint32(q_temp(i, j))+1) * g;
    end
end
loc = loc ./ locNorm;
end

