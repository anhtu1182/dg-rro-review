clear;

set(0,'defaultAxesFontSize',55);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',55);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])


f1 = figure('NumberTitle','off');

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

K_rro =fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

for i_a=1:length(A)
f1 = figure('NumberTitle','off','WindowState', 'maximized');
% load('signal_response_As_K_RRO.mat');
load("signal_response_As_K_"+num2str(Kcoef(i_a))+"_RRO_"+num2str(A(i_a))+".mat");

map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);

% 
% subplot(2,1,1);

[C,h,CF]=contourf(K_v,A_v,map_C,30);

hold on;
grid on;

xline(K_rro(i_a),"k:",'Linewidth',2)
% title("Signal response As K "+num2str(Kcoef(i_a))+" RRO "+num2str(A(i_a)))

set(gca,'YScale','log');

colormap('jet');

c=colorbar;

clim([0 1]);
% clim([0 0.5]);
ylim([1e-4 1])

set(h,'LineStyle','none');

c.Label.String = 'arg max {\it Corr(\tau)}';
c.Label.Rotation = 270;
c.Label.VerticalAlignment = "bottom";

% colorbar('Ticks', [0 1], 'TickLabels',[0 1])
% ylabel(c,'max {\it Corr(\tau)}','Rotation',270)


ylabel({'Input signal';'strength {\it A_s}'});
xlabel('RRO feedback signal strength: {\it K}');

exportgraphics(f1,".\Results2\RRO\signalResponse\signal_response_K_"+num2str(Kcoef(i_a))+ ...
    "_As_RRO_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)

close(f1)
end




% *****


A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];
for divide=2:2
K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

% K_dgrro_fix = fix(K_dgrro*1000)/1000;
    for i_a=1:length(A)
    
    f2 = figure('NumberTitle','off','WindowState', 'maximized');
    
    % load('signal_response_As_K_DG.mat');
    % load('signal_response_As_K_0.9_DG9.8.mat');
    load(".\Results2\DG\signalResponse\"+num2str(divide)+"\signal_response_As_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");
    
    map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);
    
    % subplot(2,1,2);
    
    [C,h,CF]=contourf(K_v,A_v,map_C,30);
    if (i_a==1)
        xlim([0 0.24])
    end
    % pbaspect([2 1 1])
    % pbaspect auto
    
    hold on;
    grid on;
    
%     K_dgrro = [0.019536820117773,0.125162315216276,0.0572201568228256];
    xline(K_dgrro(i_a),"k:",'Linewidth',2)
%     title("Signal response As K "+num2str(Kcoef(i_a))+" DG-RRO "+num2str(A(i_a)))
    
    set(gca,'YScale','log');
    
    colormap('jet');
    
    c=colorbar;
    
    clim([0 1]);
    % clim([0 0.5]);
    ylim([1e-4 1])
    
    set(h,'LineStyle','none');
    
    c.Label.String = 'arg max {\it Corr(\tau)}';
    c.Label.Rotation = 270;
    c.Label.VerticalAlignment = "bottom";
    
    ylabel({'Input signal';'strength {\it A_s}'});
    xlabel('DG-RRO feedback signal strength: {\it K}');
    
    exportgraphics(f2,".\Results2\DG\signalResponse\"+num2str(divide)+"\signal_response_K_"+num2str(Kcoef(i_a))+ ...
        "_As_DG_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    close(f2);
    end
end
