clc;
close all;
clear;
%%
hold on;
scatter(23, 25, [], [0.2, 0.2, 0.2]);
scatter(33, 25, [], [0.3, 0.5, 0.3]);
scatter(43, 25, [], [0.4, 0.8, 0.4]);
scatter(53, 25, [], [0.5, 0.6, 0.5]);
scatter(63, 25, [], [0.6, 0.1, 0.6]);
hold off;
%% gplot
A = [0, 1, 1, 1; 1, 0, 0, 0; 1, 0, 0, 0; 1, 0, 0, 0];
p = [1,2;5,8;2,6;4,3];
hold on;
scatter(1, 2);
scatter(5, 8);
scatter(2, 6);
scatter(4, 3);
gplot(A, p);
hold off;
%%
indiceDemandRelation = [2 6;5 1;4 7;3 9;2 4;6 8];
for i=1:size(indiceDemandRelation, 1)-1
    flag = 0;
    for j=size(indiceDemandRelation, 1):-1:(i+1)
        if indiceDemandRelation(j, 2) > indiceDemandRelation(j-1, 2)
            temp = indiceDemandRelation(j, :);
            indiceDemandRelation(j, :) = indiceDemandRelation(j-1, :);
            indiceDemandRelation(j-1, :) = temp;
            flag = 1;
        end
    end
    if flag == 0
        break;
    end
end
indiceDemandRelation
%% 
A = [0 1 1 1 1;0 0 0 0 0;0 0 0 0 0;0 0 0 0 0;0 0 0 0 0];
nLabels = {'a1', 'a2', 'a3', 'a4', 'a5'};
G = digraph(A);
G2 = digraph(1, 2:4);
% G = addedge(G,2,6:15);
x = [2 3 5 7 9];
y = [6 2 7 1 4];
x2 = [4,7,2,8];
y2 = [6,5,3,7];
a = plot(G, 'XData', x, 'YData', y, 'NodeLabel', nLabels);
hold on;
b = plot(G2, 'XData', x2, 'YData', y2);
hold off;
legend({'kp', 'dp'});