function index = indexGen(num)
if floor(num / 10) == 0
    index = strcat('0000', num2str(num));
elseif floor(num / 100) == 0
    index = strcat('000', num2str(num));
else
    index = strcat('00', num2str(num));
end

