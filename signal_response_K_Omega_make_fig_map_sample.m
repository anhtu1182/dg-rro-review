clear;

set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

% K_rro = [0.105825142911035  0.684580422277283  0.285316008060030];

for i_a=1:length(A)
f1 = figure('NumberTitle','off','WindowState', 'maximized');

load("signal_response_Omega_K_"+num2str(Kcoef(i_a))+"_RRO_"+num2str(A(i_a))+".mat");

% map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);

% subplot(2,1,1);

% [C,h,CF]=contourf(K_v,A_v,map_C,30);

map_C=mean(max_C,1);
    
plot(A_list,map_C);

hold on;
grid on;

% xline(K_rro(i_a),"r",'Linewidth',2)
title("Signal response \Omega K "+num2str(Kcoef(i_a))+" RRO "+num2str(A(i_a)))

set(gca,'XScale','log');

% colormap('jet');
% 
% c=colorbar;
% 
% clim([0 1]);
% 
% c.Label.String = 'max {\it C(\tau)}';

ylim([1e-4 1e-1])

% set(h,'LineStyle','none');

ylabel('{\it arg max_\tau}');
xlabel('{\it \Omega}');

exportgraphics(f1,".\Results2\RRO\signalResponse\Omega\signal_response_K_"+num2str(Kcoef(i_a))+ ...
    "_Omega_RRO_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)

close(f1)
end




% *****
A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];
for divide=4:4
K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");


    for i_a=1:length(A)

    f2 = figure('NumberTitle','off','WindowState', 'maximized');

    
%     load('signal_response_Omega_K_DG9.8.mat');
    load(".\Results2\DG\signalResponse\"+num2str(divide)+"\signal_response_Omega_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");

%     map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);

%     subplot(2,1,2);

%     [C,h,CF]=contourf(K_v,A_v,map_C,30);

    map_C=mean(max_C,1);
    
    plot(A_list,map_C);

    hold on;
    grid on;

%     xline(K_dgrro(i_a),"r",'Linewidth',2)
    title("Signal response \Omega K "+num2str(Kcoef(i_a))+" DG-RRO "+num2str(A(i_a)))

    set(gca,'XScale','log');
% 
%     colormap('jet');
%     
%     c=colorbar;
%     clim([0 1]);
%     c.Label.String = 'max {\it C(\tau)}';
%     
    ylim([1e-4 1e-1])

%     set(h,'LineStyle','none');

%     ylabel('{\it \Omega}');
%     xlabel('{\it K}');
    ylabel('{\it arg max_\tau}');
    xlabel('{\it \Omega}');

    exportgraphics(f2,".\Results2\DG\signalResponse\Omega\"+num2str(divide)+"\signal_response_K_"+num2str(Kcoef(i_a))+ ...
        "_Omega_DG_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    close(f2);
    end
end


%********


clear;
A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];
for divide=2:2:2
    for i_a=1:length(A)

    f3 = figure('NumberTitle','off','WindowState', 'maximized');

    load("signal_response_Omega_K_"+num2str(Kcoef(i_a))+"_RRO_"+num2str(A(i_a))+".mat");
    map_C_RRO=mean(max_C,1);    
    plot(A_list,map_C_RRO);

    hold on;
    grid on;

    load(".\Results2\DG\signalResponse\"+num2str(divide)+"\signal_response_Omega_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");
    map_C_DG=mean(max_C,1);
    plot(A_list,map_C_DG);

    title("Signal response \Omega K "+num2str(Kcoef(i_a))+" DG-RRO "+num2str(A(i_a)))
    legend("RRO","DG-RRO")
    set(gca,'XScale','log');
    xlim([1e-4 1e-1])

    ylabel('{\it arg max_\tau}');
    xlabel('{\it \Omega}');

    exportgraphics(f3,".\Results2\Compare\Omega\"+num2str(divide)+"\signal_response_K_"+num2str(Kcoef(i_a))+ ...
        "_Omega_DG_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    close(f3);
    end
end

