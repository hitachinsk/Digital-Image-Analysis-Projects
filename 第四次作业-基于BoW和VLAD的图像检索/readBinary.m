function sampleFeatures = readBinary(fileName, sampleNum, sample)
fid = fopen(fileName, 'rb');
featureNum = fread(fid, 1, 'uint');
if featureNum < sampleNum || sample == 0
    sampleNum = featureNum;
end
sampleIndice = sort(randperm(featureNum, sampleNum));
sampleFeatures = zeros(sampleNum, 128);
sampled = 1;
for i=1:featureNum
    descriptor = fread(fid, 128, 'unsigned char');
    xyScaleOrentation = fread(fid, 4, 'float');
    if sampleIndice(sampled) == i
        sampleFeatures(sampled, :) = descriptor;
        sampled = sampled + 1;
    end
    if sampled == sampleNum + 1
        break;
    end
end
fclose(fid);
        
