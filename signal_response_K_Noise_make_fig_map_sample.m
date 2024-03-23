clear;

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

% K_rro =fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

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
% 
    load(".\Results2\RRO\signalResponse\Noise\signal_response_NoiseC_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");
%     load(".\Results2\RRO\signalResponse\Noise\signal_response_NoiseA_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");

    map_C_RRO=mean(max_C,1);
    map_C_RRO_std=std(max_C,1);

    RRO_max(i_a)=fix(K_rro(i_a)/delta_K_rro(i_a));

    st_pos=[1 10 19 28];

    RRO_max_C_Noise_large_1=max_C(:,st_pos(1));
    RRO_max_C_Noise_large_2=max_C(:,st_pos(2));
    RRO_max_C_Noise_large_3=max_C(:,st_pos(3));
    RRO_max_C_Noise_large_4=max_C(:,st_pos(4));

    rro_line=plot(A_list,smooth(A_list,map_C_RRO),'k','Linewidth',2);

    hold on;
    grid on;

    plot(A_list(:),smooth(A_list(:),map_C_RRO(:))+map_C_RRO_std(:),':k','Linewidth',2);
    plot(A_list(:),smooth(A_list(:),map_C_RRO(:))-map_C_RRO_std(:),':k','Linewidth',2);

%     ---------------------------------

    load(".\Results2\DG\signalResponse\"+num2str(divide)+"\Noise\signal_response_NoiseC_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");
%     load(".\Results2\DG\signalResponse\"+num2str(divide)+"\Noise\signal_response_NoiseA_K_"+num2str(Kcoef(i_a))+"_DG_"+num2str(A(i_a))+".mat");   

    % map_C=reshape(mean(max_C,1),[size(max_C,2),size(max_C,3)]);

    map_C_DG=mean(max_C,1);
    map_C_DG_std=std(max_C,1);

    DG_max(i_a)=fix(K_dgrro(i_a)/delta_K_dgrro(i_a));

    DG_max_C_Noise_large_1=max_C(:,st_pos(1));
    DG_max_C_Noise_large_2=max_C(:,st_pos(2));
    DG_max_C_Noise_large_3=max_C(:,st_pos(3));
    DG_max_C_Noise_large_4=max_C(:,st_pos(4));

    dgrro_line=plot(A_list,smooth(A_list,map_C_DG),'r','Linewidth',2);

    plot(A_list(:),smooth(A_list(:),map_C_DG(:))+map_C_DG_std(:),':r','Linewidth',2);
    plot(A_list(:),smooth(A_list(:),map_C_DG(:))-map_C_DG_std(:),':r','Linewidth',2);

%     title("Signal response Noise K "+num2str(Kcoef(i_a)) +" "+num2str(A(i_a)))
    legend([rro_line dgrro_line],{'RRO','DG-RRO'},"Location","southwest")
    
    L = legend;
    L.AutoUpdate = 'off';
    
    xline(A_list(st_pos(1)),"b:",'Linewidth',4)
    xline(A_list(st_pos(2)),"b:",'Linewidth',4)
    xline(A_list(st_pos(3)),"b:",'Linewidth',4)
    xline(A_list(st_pos(4)),"b:",'Linewidth',4)
    
    xticks([A_list(st_pos(1)) A_list(st_pos(2)) A_list(st_pos(3)) A_list(st_pos(4))])

    set(gca,'XScale','log');
    ylim([0 1])
    xlim([1e-4 1e-1])
    
%     colormap('jet');
    
%     c=colorbar;
%     
%     clim([0 1]);
%     % clim([0 0.5]);
%     
%     set(h,'LineStyle','none');
%     
%     c.Label.String = 'max {\it C(\tau)}';
    
    ylabel({'Corr coef';'arg max_{\it\tau} Corr({\it\tau})'});
    if (Da==0)
        xlabel('Contaminant noise strength: {\it D_c}');
    elseif (Dc==0)
        xlabel('Additive noise strength: {\it D_a}');
    else
        disp("Check noise strength");
    end
    
    if (Da==0)
        exportgraphics(f1,".\Results2\Compare\Noise\"+num2str(divide)+"\Contaminant\signal_response_NoiseC_" ...
            +num2str(Kcoef(i_a))+"_As_DG_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    elseif (Dc==0)
        exportgraphics(f1,".\Results2\Compare\Noise\"+num2str(divide)+"\Additive\signal_response_NoiseA_" ...
            +num2str(Kcoef(i_a))+"_As_DG_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    else
        disp("Check noise strength");
    end

    close(f1);

% ---------------------

X1=DG_max_C_Noise_large_1;
X2=RRO_max_C_Noise_large_1;

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

X1=DG_max_C_Noise_large_2;
X2=RRO_max_C_Noise_large_2;

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

X1=DG_max_C_Noise_large_3;
X2=RRO_max_C_Noise_large_3;

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


X1=DG_max_C_Noise_large_4;
X2=RRO_max_C_Noise_large_4;

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

if (Da==0)
    Noise='D_c';
elseif (Dc==0)
    Noise='D_a';
else
    disp("Check noise strength");
end

subplot(2,2,1);

errorbar(1.4,mean(RRO_max_C_Noise_large_1),std(RRO_max_C_Noise_large_1),'*k','Linewidth',3);

hold on;
grid on;

errorbar(2.1,mean(DG_max_C_Noise_large_1),std(DG_max_C_Noise_large_1),'*r','Linewidth',3);

xlim([1 2.5]);

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'})

if (result_large_p_1>=0.05)
    title({"{\it t=" + num2str(result_large_1) + " (p=" + num2str(result_large_p_1) + ")}"; ...
        Noise + " = " + num2str(A_list(st_pos(1)))});
elseif (result_large_p_1>=0.001)
    title({"{\it t=" + num2str(result_large_1) + " (p=" + num2str(result_large_p_1) + ")} " + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(1)))});
else
    title({"{\it t=" + num2str(result_large_1) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(1)))});
end


xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});


subplot(2,2,2);

errorbar(1.4,mean(RRO_max_C_Noise_large_2),std(RRO_max_C_Noise_large_2),'*k','Linewidth',3);

hold on;
grid on;

errorbar(2.1,mean(DG_max_C_Noise_large_2),std(DG_max_C_Noise_large_2),'*r','Linewidth',3);

xlim([1 2.5]);

% if Kcoef(i_a) == 0.89
% ylim([0.87 0.89]);
% end

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'})

if (result_large_p_2>=0.05)
    title({"{\it t=" + num2str(result_large_2) + " (p=" + num2str(result_large_p_2) + ")}"; ...
        Noise + " = " + num2str(A_list(st_pos(2)))});
elseif (result_large_p_2>=0.001)
    title({"{\it t=" + num2str(result_large_2) + " (p=" + num2str(result_large_p_2) + ")} " + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(2)))});
else
    title({"{\it t=" + num2str(result_large_2) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(2)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});


subplot(2,2,3);

errorbar(1.4,mean(RRO_max_C_Noise_large_3),std(RRO_max_C_Noise_large_3),'*k','Linewidth',3);

hold on;
grid on;

errorbar(2.1,mean(DG_max_C_Noise_large_3),std(DG_max_C_Noise_large_3),'*r','Linewidth',3);

xlim([1 2.5]);

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'})

if (result_large_p_3>=0.05)
    title({"{\it t=" + num2str(result_large_3) + " (p=" + num2str(result_large_p_3) + ")}"; ...
        Noise + " = " + num2str(A_list(st_pos(3)))});
elseif (result_large_p_3>=0.001)
    title({"{\it t=" + num2str(result_large_3) + " (p=" + num2str(result_large_p_3) + ")} " + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(3)))});
else
    title({"{\it t=" + num2str(result_large_3) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(3)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});


subplot(2,2,4);

errorbar(1.4,mean(RRO_max_C_Noise_large_4),std(RRO_max_C_Noise_large_4),'*k','Linewidth',3);


hold on;
grid on;

errorbar(2.1,mean(DG_max_C_Noise_large_4),std(DG_max_C_Noise_large_4),'*r','Linewidth',3);

xlim([1 2.5]);

% if A(i_a) == 9.8
% ylim([0 0.4]);
% elseif A(i_a) == 12
% ylim([0 0.1]);
% elseif A(i_a) == 13
% ylim([0.0 0.3]);
% end

ylabel({'arg max_{\it\tau}'; 'Corr({\it\tau})'});

if (result_large_p_4>=0.05)
    title({"{\it t=" + num2str(result_large_4) + " (p=" + num2str(result_large_p_4) + ")}"; ...
        Noise + " = " + num2str(A_list(st_pos(4)))});
elseif (result_large_p_4>=0.001)
    title({"{\it t=" + num2str(result_large_4) + " (p=" + num2str(result_large_p_4) + ")} " + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(4)))});
else
    title({"{\it t=" + num2str(result_large_4) + " (p < 0.001)}" + "\color{red} *"; ...
        "\color{black}" + Noise + " = " + num2str(A_list(st_pos(4)))});
end

xticks([1.4 2.1])
xticklabels({'RRO','DG-RRO'});


if (Da==0)
    exportgraphics(f2,".\Results2\Compare\Noise\"+num2str(divide)+"\Contaminant\signal_response_K_" ...
        +num2str(Kcoef(i_a))+"_NoiseC_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
elseif (Dc==0)
    exportgraphics(f2,".\Results2\Compare\Noise\"+num2str(divide)+"\Additive\signal_response_K_" ...
        +num2str(Kcoef(i_a))+"_NoiseA_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
else
    disp("Check noise strength");
end

close(f2)

    end
end
