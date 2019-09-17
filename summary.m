clear
close

file = csvread('times.csv',1,0);

fkh12 = [file(:,1) file(:,2)];
fkh14 = [file(:,3) file(:,4)];
fkh16 = [file(:,5) file(:,6)];
fkh33 = [file(:,7) file(:,8)];
fkh50 = [file(:,9) file(:,10)];

fkh12 = fkh12(any(fkh12,2),:);
fkh14 = fkh14(any(fkh14,2),:);
fkh16 = fkh16(any(fkh16,2),:);
fkh33 = fkh33(any(fkh33,2),:);
fkh50 = fkh50(any(fkh50,2),:);

opts = statset('Display','iter');
[idx1,C1,sumd1,d1,midx1,info1] = kmedoids(fkh12,1,'Distance','cityblock','Options',opts);
[idx2,C2,sumd2,d2,midx2,info2] = kmedoids(fkh14,1,'Distance','cityblock','Options',opts);
[idx3,C3,sumd3,d3,midx3,info3] = kmedoids(fkh16,1,'Distance','cityblock','Options',opts);
[idx4,C4,sumd4,d4,midx4,info4] = kmedoids(fkh33,1,'Distance','cityblock','Options',opts);
[idx5,C5,sumd5,d5,midx5,info5] = kmedoids(fkh50,1,'Distance','cityblock','Options',opts);

C = [C1;C2;C3;C4;C5];


figure;
scatter(fkh12(:,1), fkh12(:,2), 'b')
hold on
scatter(fkh14(:,1), fkh14(:,2), 'r')
hold on
scatter(fkh16(:,1), fkh16(:,2), 'c')
hold on
scatter(fkh33(:,1), fkh33(:,2), 'g')
hold on
scatter(fkh50(:,1), fkh50(:,2), 'k')
hold on
plot(C(:,1),C(:,2),'+', 'MarkerSize', 20);


xlabel('Days since injection (DD)')
ylabel('Time of day (HH)')
yticks([0 2 4 6 8 10 12 14 16 18 20 22 24])

a=length(fkh12(fkh12(:,2) >= 6 & fkh12(:,2) <= 18));
a=length(fkh14(fkh14(:,2) >= 6 & fkh14(:,2) <= 18))+a;
a=length(fkh16(fkh16(:,2) >= 6 & fkh16(:,2) <= 18))+a;
a=length(fkh33(fkh33(:,2) >= 6 & fkh33(:,2) <= 18))+a;
a=length(fkh50(fkh50(:,2) >= 6 & fkh50(:,2) <= 18))+a

b=length(fkh12(fkh12(:,2) > 18 | fkh12(:,2) < 6));
b=length(fkh14(fkh14(:,2) > 18 | fkh14(:,2) < 6))+b;
b=length(fkh16(fkh16(:,2) > 18 | fkh16(:,2) < 6))+b;
b=length(fkh33(fkh33(:,2) > 18 | fkh33(:,2) < 6))+b;
b=length(fkh50(fkh50(:,2) > 18 | fkh50(:,2) < 6))+b
