clear;

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

for divide=2:2
K_rro = fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");
K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");
delta_K_rro=fix(K_rro*200)/50000;
delta_K_dgrro=fix(K_dgrro*200)/50000;

for i_a=1:length(A)
set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off','WindowState', 'maximized');

% load('signal_response_As_K_RRO9.8.mat');
% load('signal_response_As_K_RRO12.mat');
% load('signal_response_As_K_0.9_RRO9.8.mat');
load("signal_response_As_K_"+num2str(Kcoef(i_a))+"_RRO_"+num2str(A(i_a))+".mat");

% map_C(isnan(map_C)) = 0;

map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);
map_C_std=reshape(std(max_C,1),[size(max_C,2),size(max_C,3)]);
% RRO_max=fix(0.105825142911035/0.001);
% RRO_max=fix(0.684580422277283/0.004);

RRO_max(i_a)=fix(K_rro(i_a)/delta_K_rro(i_a));
st_pos=[1 10 19 28];


RRO_max_C_A_large_1=max_C(:,st_pos(1),RRO_max(i_a));
RRO_max_C_A_large_2=max_C(:,st_pos(2),RRO_max(i_a));
RRO_max_C_A_large_3=max_C(:,st_pos(3),RRO_max(i_a));
RRO_max_C_A_large_4=max_C(:,st_pos(4),RRO_max(i_a));

rro_line=semilogx(A_v(:,RRO_max(i_a)),smooth(A_v(:,RRO_max(i_a)),map_C(:,RRO_max(i_a))),'k','Linewidth',2,'DisplayName','RRO');
xlim([1e-4 1e-1]);
ylim([0 1]);
hold on;
grid on;

semilogx(A_v(:,RRO_max(i_a)),smooth(A_v(:,RRO_max(i_a)),map_C(:,RRO_max(i_a)))+map_C_std(:,RRO_max(i_a)),':k','Linewidth',2);
semilogx(A_v(:,RRO_max(i_a)),smooth(A_v(:,RRO_max(i_a)),map_C(:,RRO_max(i_a)))-map_C_std(:,RRO_max(i_a)),':k','Linewidth',2);

% ---------------------

% load('signal_response_As_K_DG9.8.mat');
% load('signal_response_As_K_DG12.mat');

% load('signal_response_As_K_0.9_DG9.8.mat');
load(".\Results2\DG\signalResponse\"+num2str(divide)+"\signal_response_As_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");

map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);
map_C_std=reshape(std(max_C,1),[size(max_C,2),size(max_C,3)]);
% DG_max=fix(0.0195560308656910/0.0003);
% DG_max=fix(0.126166594684946/0.002);
% DG_max=fix(0.348332668369278/0.005);

DG_max(i_a)=fix(K_dgrro(i_a)/delta_K_dgrro(i_a));

dgrro_line=semilogx(A_v(:,DG_max(i_a)),smooth(A_v(:,DG_max(i_a)),map_C(:,DG_max(i_a))),'r','Linewidth',2,'DisplayName',"DG-RRO"+num2str(divide));

hold on;
grid on;

semilogx(A_v(:,DG_max(i_a)),smooth(A_v(:,DG_max(i_a)),map_C(:,DG_max(i_a)))+map_C_std(:,DG_max(i_a)),':r','Linewidth',2);
semilogx(A_v(:,DG_max(i_a)),smooth(A_v(:,DG_max(i_a)),map_C(:,DG_max(i_a)))-map_C_std(:,DG_max(i_a)),':r','Linewidth',2);

% xlim([1e-2 0.3]);

DG_max_C_A_large_1=max_C(:,st_pos(1),DG_max(i_a));
DG_max_C_A_large_2=max_C(:,st_pos(2),DG_max(i_a));
DG_max_C_A_large_3=max_C(:,st_pos(3),DG_max(i_a));
DG_max_C_A_large_4=max_C(:,st_pos(4),DG_max(i_a));

% legend('RRO','DG-RRO')
legend([rro_line dgrro_line],{'RRO','DG-RRO'},"Location","southeast")

L = legend;
L.AutoUpdate = 'off';

xline(A_list(st_pos(1)),"b:",'Linewidth',4)
xline(A_list(st_pos(2)),"b:",'Linewidth',4)
xline(A_list(st_pos(3)),"b:",'Linewidth',4)
xline(A_list(st_pos(4)),"b:",'Linewidth',4)

xticks([A_list(st_pos(1)) A_list(st_pos(2)) A_list(st_pos(3)) A_list(st_pos(4))])

xlabel('Input signal strength: A_s')
ylabel({'Corr coef';'arg max_{\it\tau} Corr({\it\tau})'});

exportgraphics(f1,".\Results2\Compare\As\"+num2str(divide)+"\signal_response_profile_K_"+num2str(Kcoef(i_a))+ ...
    "_As_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
close(f1)

% --------------------------------

X1=DG_max_C_A_large_1;
X2=RRO_max_C_A_large_1;

[fh,fp]=vartest2(X1,X2);
if fh==1
    [h,p,ci,stats]=ttest2(X1,X2,'Vartype','unequal');
    result_large_1=stats.tstat;
    result_large_p_1=p;

elseif fh==0
    [h,p,ci,stats]=ttest2(X1,X2);
    result_large_1=stats.tstat;
    result_large_p_1=p;

end

X1=DG_max_C_A_large_2;
X2=RRO_max_C_A_large_2;

[fh,fp]=vartest2(X1,X2);
if fh==1
    [h,p,ci,stats]=ttest2(X1,X2,'Vartype','unequal');
    result_large_2=stats.tstat;
    result_large_p_2=p;

elseif fh==0
    [h,p,ci,stats]=ttest2(X1,X2);
    result_large_2=stats.tstat;
    result_large_p_2=p;

end

X1=DG_max_C_A_large_3;
X2=RRO_max_C_A_large_3;

[fh,fp]=vartest2(X1,X2);
if fh==1
    [h,p,ci,stats]=ttest2(X1,X2,'Vartype','unequal');
    result_large_3=stats.tstat;
    result_large_p_3=p;

elseif fh==0
    [h,p,ci,stats]=ttest2(X1,X2);
    result_large_3=stats.tstat;
    result_large_p_3=p;

end


X1=DG_max_C_A_large_4;
X2=RRO_max_C_A_large_4;

[fh,fp]=vartest2(X1,X2);
if fh==1
    [h,p,ci,stats]=ttest2(X1,X2,'Vartype','unequal');
    result_large_4=stats.tstat;
    result_large_p_4=p;

elseif fh==0
    [h,p,ci,stats]=ttest2(X1,X2);
    result_large_4=stats.tstat;
    result_large_p_4=p;

end



%%%%%

set(0,'defaultAxesFontSize',30);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',30);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])
f2 = figure('NumberTitle','off','WindowState', 'maximized');

subplot(2,2,4);

errorbar(1.4,mean(RRO_max_C_A_large_4),std(RRO_max_C_A_large_4),'*k','Linewidth',3);

hold on;
grid on;

errorbar(2.1,mean(DG_max_C_A_large_4),std(DG_max_C_A_large_4),'*r','Linewidth',3);

xlim([1 2.5]);
ylim([0.87 0.89]);
ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'})

if (result_large_p_4>=0.05)
    title({"{\it t=" + num2str(result_large_4) + " (p=" + num2str(result_large_p_4) + ")}"; ...
        "A_s = " + num2str(A_list(st_pos(4)))});
elseif (result_large_p_4>=0.001)
    title({"{\it t=" + num2str(result_large_4) + " (p=" + num2str(result_large_p_4) + ")} " + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(4)))});
else
    title({"{\it t=" + num2str(result_large_4) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(4)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});


subplot(2,2,3);

errorbar(1.4,mean(RRO_max_C_A_large_3),std(RRO_max_C_A_large_3),'*k','Linewidth',3);

hold on;
grid on;

errorbar(2.1,mean(DG_max_C_A_large_3),std(DG_max_C_A_large_3),'*r','Linewidth',3);

xlim([1 2.5]);

if A(i_a) == 12
ylim([0.4 0.9]);
else
ylim([0.84 0.87]);
end

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'})

if (result_large_p_3>=0.05)
    title({"{\it t=" + num2str(result_large_3) + " (p=" + num2str(result_large_p_3) + ")}"; ...
        "A_s = " + num2str(A_list(st_pos(3)))});
elseif (result_large_p_3>=0.001)
    title({"{\it t=" + num2str(result_large_3) + " (p=" + num2str(result_large_p_3) + ")} " + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(3)))});
else
    title({"{\it t=" + num2str(result_large_3) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(3)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});


subplot(2,2,2);

errorbar(1.4,mean(RRO_max_C_A_large_2),std(RRO_max_C_A_large_2),'*k','Linewidth',3);

hold on;
grid on;

errorbar(2.1,mean(DG_max_C_A_large_2),std(DG_max_C_A_large_2),'*r','Linewidth',3);

xlim([1 2.5]);

if A(i_a) == 12 || Kcoef(i_a) == 0.91
ylim([0.0 0.5]);
else
ylim([0.0 0.8]);
end

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'})

if (result_large_p_2>=0.05)
    title({"{\it t=" + num2str(result_large_2) + " (p=" + num2str(result_large_p_2) + ")}"; ...
        "A_s = " + num2str(A_list(st_pos(2)))});
elseif (result_large_p_2>=0.001)
    title({"{\it t=" + num2str(result_large_2) + " (p=" + num2str(result_large_p_2) + ")} " + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(2)))});
else
    title({"{\it t=" + num2str(result_large_2) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(2)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});



subplot(2,2,1);

errorbar(1.4,mean(RRO_max_C_A_large_1),std(RRO_max_C_A_large_1),'*k','Linewidth',3);


hold on;
grid on;

errorbar(2.1,mean(DG_max_C_A_large_1),std(DG_max_C_A_large_1),'*r','Linewidth',3);

xlim([1 2.5]);

if Kcoef(i_a) == 0.89
ylim([0.0 0.25]);
else
ylim([0.0 0.15]);
end

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'});

if (result_large_p_1>=0.05)
    title({"{\it t=" + num2str(result_large_1) + " (p=" + num2str(result_large_p_1) + ")}"; ...
        "A_s = " + num2str(A_list(st_pos(1)))});
elseif (result_large_p_1>=0.001)
    title({"{\it t=" + num2str(result_large_1) + " (p=" + num2str(result_large_p_1) + ")} " + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(1)))});
else
    title({"{\it t=" + num2str(result_large_1) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}A_s = " + num2str(A_list(st_pos(1)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});

exportgraphics(f2,".\Results2\Compare\As\"+num2str(divide)+"\signal_response_K_"+num2str(Kcoef(i_a))+ ...
    "_As_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
close(f2)

end
end