% % Load saved figures
% c=hgload('fKH16_20170710_003307.fig');
% k=hgload('fKH16_20170609_185926.fig');
% % Prepare subplots
% figure
% h(1)=subplot(1,2,1);
% h(2)=subplot(1,2,2);
% % Paste figures on the subplots
% copyobj(allchild(get(k,'CurrentAxes')),h(1));
% copyobj(allchild(get(c,'CurrentAxes')),h(2));


figure
%Plot something
plot(1:10)
% Add a patch
patch([1 10 10 1],[4 4 6 6],'b')
% The order of the "children" of the plot determines which one appears on top.
% I need to flip it here.
set(gca,'children',flipud(get(gca,'children')))