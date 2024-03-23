

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');

load('signal_response_a_K_RRO.mat');

map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);


subplot(2,1,1);

[C,h,CF]=contourf(a_v,K_v,map_C,30);

hold on;
grid on;

colormap('jet');

c=colorbar;

clim([0 1]);

set(h,'LineStyle','none');

c.Label.String = 'max {\it C(\tau)}';

xlabel('{\it a}');
ylabel('{\it K}');


load('signal_response_a_K_DG.mat');

map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);


subplot(2,1,2);

[C,h,CF]=contourf(a_v,K_v,map_C,30);

hold on;
grid on;

colormap('jet');

c=colorbar;

clim([0 1]);

set(h,'LineStyle','none');

c.Label.String = 'max {\it C(\tau)}';

xlabel('{\it a}');
ylabel('{\it K}');


ylim([-0.01 0]);