clear
close

[x filename] = uigetfile('.csv');
filename = [filename x]
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
 
for i= 1:length(event)
    if event(i) == "Seizure"
         zero_m(i) = min(i);
    end
end

final_m = zero_m(zero_m ~= 0);

temp = {x(7:10),x(11:12),x(13:14),x(16:17),x(18:19),x(20:21)};
for i = 1:length(temp)
final(i) = str2num(temp{i});
end


if x(1:5) == 'fKH14'
    t0 = datetime(2017,6,9,14,24,00);
end
if x(1:5) == 'fKH16'
    t0 = datetime(2017,6,9,15,49,00);
end
if x(1:5) == 'fKH12'
    t0 = datetime(2017,3,4,15,49,00);
end
if x(1:5) == 'fKH33'
    t0 = datetime(2018,2,19,17,05,00);
end
if x(1:5) == 'fKH50'
    t0 = datetime(2018,3,31,17,48,00);
end

%t0 = datetime(final);
%t0 = datetime(2017,6,9,15,47,00); %injection day
t2 = datetime(final);
t1 = t2 + minutes(final_m(:));

y = days(t1-t0);
hourdec = hour(t1) + minute(t1)/60;

figure;
scatter(y, hourdec, 'filled', 'b');
title(x(1:5))
patch([y(1) y(end) y(end) y(1)],[6 6 18 18],[0.9290,0.6940,0.1250])
set(gca,'children',flipud(get(gca,'children')))
ylabel('Time of Day (HH)')
xlabel('Days since Injection (DD)')
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24])

numberOfSeizures = length(hourdec)

keyboard
close

opts = statset('Display','iter');
%[idx,C,sumd,d,midx,info] = kmedoids(hourdec,2,'Distance','cityblock','Options',opts);
stacked = [y hourdec];
[idx,C,sumd,d,midx,info] = kmedoids(stacked,4,'Distance','cityblock','Options',opts);

cluster1 = hourdec(idx == 1);
x1 = y(idx==1);
cluster2 = hourdec(idx == 2);
x2 = y(idx==2);
cluster3 = hourdec(idx == 3);
x3 = y(idx==3);
cluster4 = hourdec(idx == 4);
x4 = y(idx==4);

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
hold on
scatter(x3, cluster3, 'g', 'filled');
hold on
scatter(x4, cluster4, 'black', 'filled');
hold on
ylabel('Time of Day (HH)')
xlabel('Time since start (DD)')
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24])
hold on
plot(C(:,1),C(:,2),'x', 'MarkerSize', 15);
%legend('Cluster 1','Cluster 2', 'Medoids' ,'Location','NW');
hold off

keyboard
close

% sleep wake regions for better vizualization (only one cluster possibly)
% bin the data into 2 hr chunks (days x hours)
% seizure characteristics between sleep/wake