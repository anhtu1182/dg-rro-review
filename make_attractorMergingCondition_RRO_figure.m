clear;

step=0.005;
N=round(1/step);
K=zeros(1,N);
As=0;
sigma=1;
Omega=0.005;

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];
x_min=[-1 1];
x_lim=[-0.5 1.5];

% % K =[0.105793851332952,0.679607279249295,0.284042780819440]

for i_a=1:size(A,2)
    for i=0:N
        K(1,i+1)=i*step; 
        Fx=@(x) baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
        xmin(i+1)=fminbnd(Fx,-3,0);
        xmax(i+1)=-xmin(i+1);

        f=@(x) baghdadi_map_func(x,A(i_a),Kcoef(i_a),K(1,i+1),sigma,As,Omega,i);
        fmin(i+1)=f(xmin(i+1));
        fmax(i+1)=f(xmax(i+1));
        F_fmin(i+1)=f(fmin(i+1));
        F_fmax(i+1)=f(fmax(i+1));
    end
    
    fig(i_a)=figure('WindowState', 'maximized');
    set(0,'defaultAxesFontSize',20);
    set(0,'defaultAxesFontName','Arial');
    set(0,'defaultTextFontSize',20);
    set(0,'defaultTextFontName','Arial');
    
    hold on;
    grid on;
    
    plot(K,F_fmin,'Linewidth',2);
    plot(K,F_fmax,'Linewidth',2);
    xmin_at_y0(i_a) = interp1(F_fmin,K,0);
    xmax_at_y0(i_a) = interp1(F_fmax,K,0);
    
    xlim([0 1]);
%     xlim([2 3])
    ylim([-1.5 1.5]);
    xlabel('RRO feedback signal strength: K') 
    ylabel('F(f_{min,max})+Ku(f_{min,max})')
    legend('F(f_{min})+Ku(f_{min})','F(f_{max})+Ku(f_{max})');
    
    exportgraphics(fig(i_a),".\Results2\RRO\AttractorMerging\AttractorMergingCondition_Kcoef_"+num2str(Kcoef(i_a))+"_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
%     savefig(fig(i_a),".\RRO\ADHD\Figure\AttractorMergingCondition_Kcoef_"+num2str(Kcoef)+"_A_"+num2str(A(i_a))+".fig")
    close(fig(i_a));
end

writematrix(xmin_at_y0,".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt",'Delimiter',',')  




