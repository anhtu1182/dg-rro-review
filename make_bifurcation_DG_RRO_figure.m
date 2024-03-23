clear;

x_lim=0.25;
N=400;
step=x_lim/N;

K=zeros(1,N);

% Calculate 100 values of map function
valNum=100;
% But only take 50 values
takeNum=50;
x_p=zeros(valNum,N);
x_n=zeros(valNum,N);

As=0;
Omega=0.005;

set(0,'defaultAxesFontSize',40);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',40);
set(0,'defaultTextFontName','Arial');

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

for divide=2:2
sigma=1/divide;

for i_a=1:size(A,2)
    fig(i_a)=figure('WindowState', 'maximized');
    wb = waitbar(0, 'Starting');

    hold on;
    grid on;

    for i=0:N     
        K(1,i+1)=i*step; 
        Fx=@(x) baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
        xmin(i+1)=fminbnd(Fx,-3,0);
        xmax(i+1)=-xmin(i+1);

        f=@(x) baghdadi_DGRRO_map_func(x,A(i_a),Kcoef(i_a),K(1,i+1),sigma,As,Omega,i,xmin(i+1));
        fmin(i+1)=f(xmin(i+1));
        fmax(i+1)=f(xmax(i+1));
        F_fmin(i+1)=f(fmin(i+1));
        F_fmax(i+1)=f(fmax(i+1));
    end

    yyaxis right
    ylim([-4 4]);
    fminplot = plot(K,F_fmin,"r-",'Linewidth',3);
    fmaxplot = plot(K,F_fmax,"b-",'Linewidth',3);
%     ylabel('F(f_{min,max})+Ku(f_{min,max})')
%     legend('F(f_{min})+Ku(f_{min})','F(f_{max})+Ku(f_{max})');

    yyaxis left;

    xlim([0 x_lim]);
    ylim([-4 4]);
%     xlabel('DG-RRO feedback signal strength: K') 
%     ylabel('x')

    for i=1:N
        K(1,i+1)=i*step;
        x_p(:,i+1)=bifurcationValue_ADHD_DGRRO(A(i_a),Kcoef(i_a),K(i+1),As,sigma,Omega,1);
        x_n(:,i+1)=bifurcationValue_ADHD_DGRRO(A(i_a),Kcoef(i_a),K(i+1),As,sigma,Omega,-1);
        for j=1:size(x_p(:,N),2)
            bifurp = scatter(K(1,i+1),x_p(end-takeNum+1:end,i+1),'r.');

            bifurn = scatter(K(1,i+1),x_n(end-takeNum+1:end,i+1),'b.');
        end
        try
            waitbar((i)/(N), wb, sprintf('Progress: %d %%', floor((i)/(N)*100)));
        catch
            close(wb)
        end
%         pause(0.01);
    end 
    
    hold off 
    legend([fminplot,fmaxplot,bifurp,bifurn], 'F(f_{min})+Ku(f_{min})','F(f_{max})+Ku(f_{max})', ...
        'x(n) when inital value > 0','x(n) when inital value < 0','Location','Best','NumColumns', 2)

%     L = legend;
%     L.AutoUpdate = 'off';
    
%     save('BifurDGRROPos.mat','x_p');
%     save('BifurDGRRONeg.mat','x_n');

    save("BifurDGRRO"+num2str(i_a)+".mat");
    exportgraphics(fig(i_a),".\Results2\DG\Bifurcation\"+num2str(divide)+"\BifurcationDG_A_"+num2str(A(i_a)) ...
        +"_K_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
    savefig(fig(i_a),".\Results2\DG\Bifurcation\"+num2str(divide)+"\BifurcationDG_A_"+num2str(A(i_a)) ...
        +"_K_"+num2str(Kcoef(i_a))+".fig")
    close(fig(i_a));
    close(wb)
end
end
