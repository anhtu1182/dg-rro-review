clear;

step=0.0005;
x_lim=0.25;
N=round(x_lim/step);
K=zeros(1,N);
As=0;
% divide=1;
Omega=0.005;

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

for divide=2:2:4
sigma=1/divide;

% x_min=[0 0.5];
% x_lim=[0.03 1];
% K = [0.019587548325084 0.126968903257451 0.057949278726383]
for i_a=1:size(A,2)
    for i=0:N
        K(1,i+1)=i*step; 
        Fx=@(x) baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
        xmin(i+1)=fminbnd(Fx,-3,0);
        xmax(i+1)=-xmin(i+1);

        f=@(x) baghdadi_DGRRO_map_func(x,A(i_a),Kcoef(i_a),K(1,i+1),sigma,As,Omega,i,xmin(i+1));
%         xmin(i+1)=fminbnd(f,-3,0);
%         xmax(i+1)=-xmin(i+1);
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
    
%     xlim([x_min(i_a) x_lim(i_a)]);
    xlim([0 x_lim]);
    ylim([-1.5 1.5]);
    xlabel('DG-RRO feedback signal strength: K') 
    ylabel('F(f_{min,max})+Ku(f_{min,max})')
    legend('F(f_{min})+Ku(f_{min})','F(f_{max})+Ku(f_{max})');
    
    exportgraphics(fig(i_a),".\Results2\DG\AttractorMerging\"+num2str(divide)+"\AttractorMergingCondition_Kcoef_" ...
        +num2str(Kcoef(i_a))+"_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
%     savefig(fig(i_a),".\DGRRO\ADHD\Figure\AttractorMergingCondition_Kcoef_"+num2str(Kcoef)+"_A_"+num2str(A(i_a))+".fig")
    close(fig(i_a));

end

writematrix(xmin_at_y0,".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt",'Delimiter',',')  
end




