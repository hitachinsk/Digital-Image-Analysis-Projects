function [depots, customers, vehicleNum] = readFile(filePath)
% author: kaidong zhang
% date: 5/30/2020
% READFILE takes a file and return the customer instance array/depots
% instance array contained in it.
fid = fopen(filePath);
metaData = fgetl(fid);
[vehicleNum, customerNum, depotNum] = parseMeta(metaData);
[depots, customers] = parseBody(fid, customerNum, depotNum);
fclose(fid);
end

function [vehicleNum, customerNum, depotNum] = parseMeta(metaData)
strBlocks = strsplit(metaData);
metaInfo = parseStrBlocks(strBlocks, 4);
if metaInfo(1, 1) ~= 2
    error('Not MDVRP dataset');
end
vehicleNum = metaInfo(1, 2);
customerNum = metaInfo(1, 3);
depotNum = metaInfo(1, 4);
end

function [depots, customers] = parseBody(fid, customerNum, depotNum)
depotInfo = zeros(depotNum, 4);
depots = [];
customers = [];
for i=1:depotNum
    depotMeta = fgetl(fid);
    [depotInfo(i, 3), depotInfo(i, 4)] = parseDepotMeta(depotMeta);
end
for i=1:customerNum
    customerMeta = fgetl(fid);
    [id, xAxis, yAxis, serviceDuration, demand] = parseCustomerMeta(customerMeta);
    individual = customer(id, xAxis, yAxis, serviceDuration, demand);
    customers = [customers, individual];
end
for i=1:depotNum
    depotAxisMeta = fgetl(fid);
    [depotInfo(i, 1), depotInfo(i, 2)] = parseDepotMeta(depotAxisMeta);
end
for i=1:depotNum
    singleDepot = depot(depotInfo(i, 1), depotInfo(i, 2), depotInfo(i, 3), depotInfo(i, 4));
    depots = [depots, singleDepot];
end
end

function [outArg1, outArg2] = parseDepotMeta(metaData)
strBlocks = strsplit(metaData);
if size(strBlocks, 2) == 2
    outArg1 = parseStrBlock(strBlocks(1, 1));
    outArg2 = parseStrBlock(strBlocks(1, 2));
else
    info = parseStrBlocks(strBlocks, 3);
    outArg1 = info(1, 2);
    outArg2 = info(1, 3);
end
end

function [id, xAxis, yAxis, serviceDuration, demand] = parseCustomerMeta(metaData)
strBlocks = strsplit(metaData);
ret = parseStrBlocks(strBlocks, 5);
id = ret(1, 1);
xAxis = ret(1, 2);
yAxis = ret(1, 3);
serviceDuration = ret(1, 4);
demand = ret(1, 5);
end

function ret = parseStrBlocks(blocks, volume)
ret = zeros(1, volume);
counter = 1;
for i=1:size(blocks, 2)
    temp = parseStrBlock(blocks(1, i));
    if ~isnan(temp)
        ret(1, counter) = temp;
        counter = counter + 1;
    end
    if counter > volume
        break;
    end
end
if counter ~= (volume+1)
    error('Not complete data');
end
end

function numData = parseStrBlock(block)
numData = str2double(char(block));
end
        

