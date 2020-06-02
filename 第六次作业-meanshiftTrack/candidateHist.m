function [histogram, q_temp] = candidateHist(histogram, roi)
[h, w, ~] = size(roi);
center = zeros(1, 2);
center(1) = h / 2;
center(2) = w / 2;
weights = zeros(h, w);
q_temp = zeros(h, w);
band = center(1)^2 + center(2)^2;

for i=1:h
    for j=1:w
        dist = (i-center(1))^2 + (j-center(2))^2;
        weights(i, j) = 1 - dist / band;
    end
end
C = 1/sum(sum(weights));
for i=1:h
    for j=1:w
        q_r = fix(double(roi(i,j,1))/16);
        q_g = fix(double(roi(i,j,2))/16);
        q_b = fix(double(roi(i,j,3))/16);
        q_temp(i, j) = q_r*256 + q_g*16 + q_b;
        histogram(q_temp(i, j)+1) = histogram(q_temp(i, j)+1) + weights(i,j);
    end
end
histogram = histogram * C;
end

