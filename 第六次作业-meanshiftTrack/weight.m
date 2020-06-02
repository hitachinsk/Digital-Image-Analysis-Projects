function weightMap = weight(initTarget, candTarget)
weightMap = zeros(1, 4096);
for i=1:4096
    if candTarget(i) ~= 0
        weightMap(i) = sqrt(initTarget(i) / candTarget(i));
    else
        weightMap(i) = 0;
    end
end
end

