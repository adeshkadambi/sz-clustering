clear
close

[x filename] = uigetfile('.csv');
%filename = [filename x]
delimiter = ',';
startRow = 10;
formatSpec = '%*s%*s%f%*s%s%[^\n\r]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

datavec = table(dataArray{1:end-1}, 'VariableNames', {'Minutes','Event'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

min = datavec{1:height(datavec),{'Minutes'}};
event = datavec{1:height(datavec),{'Event'}};
 
for i= 1:length(event)-1
    if event(i) == "Seizure"
         zero_m(i) = min(i);
    end;
end;

final_m = zero_m(zero_m ~= 0);

temp = {x(7:10),x(11:12),x(13:14),x(16:17),x(18:19),x(20:21)};
for i = 1:length(temp);
final(i) = str2num(temp{i});
end

t0 = datetime(final);
t1 = t0 + minutes(final_m(:));

y = days(t1-t0);
hourdec = hour(t1) + minute(t1)/60;

figure;
scatter(y,hourdec, 'filled', 'b');
title(x(1:5))
ylabel('Time of Day (HH)')
xlabel('Time since start (DD)')
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24])

keyboard
close

opts = statset('Display','iter');
%[idx,C,sumd,d,midx,info] = kmedoids(hourdec,2,'Distance','cityblock','Options',opts);
stacked = [y hourdec];
[idx,C,sumd,d,midx,info] = kmedoids(stacked,2,'Distance','cityblock','Options',opts);

cluster1 = hourdec(idx == 1);
x1 = y(idx==1);
cluster2 = hourdec(idx == 2);
x2 = y(idx==2);

% How to convert for loop into logical indexing

% for i= 1:length(hourdec)
%     if idx(i) == 1
%          cluster1 = [cluster1 ; hourdec(i)];
%          x1 = [x1 ; y(i)];
%     else
%         cluster2 = [cluster2 ; hourdec(i)];
%         x2 = [x2 ; y(i)];
%     end;
% end;

figure;
scatter(x1, cluster1, 'r', 'filled');
hold on
scatter(x2, cluster2, 'b', 'filled');
ylabel('Time of Day (HH)')
xlabel('Time since start (DD)')
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24])
hold on
plot(C(:,1),C(:,2),'x', 'MarkerSize', 15);
legend('Cluster 1','Cluster 2', 'Medoids' ,'Location','NW');
hold off

keyboard
close

% sleep wake regions for better vizualization (only one cluster possibly)
% bin the data into 2 hr chunks (days x hours)
% seizure characteristics between sleep/wake