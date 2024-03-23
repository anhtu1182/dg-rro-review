clear;

x_lim=0.25;
y_lim=3;
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

divide = 2;
sigma=1/divide;

K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

% for i_a=1:size(A,2)
%     wb = waitbar(0, 'Starting');
% 
%     for i=0:N     
%         K(1,i+1)=i*step; 
%         Fx=@(x) baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
%         xmin(i+1)=fminbnd(Fx,-3,0);
%         xmax(i+1)=-xmin(i+1);
% 
%         f=@(x) baghdadi_DGRRO_map_func(x,A(i_a),Kcoef(i_a),K(1,i+1),sigma,As,Omega,i,xmin(i+1));
%         fmin(i+1)=f(xmin(i+1));
%         fmax(i+1)=f(xmax(i+1));
%         F_fmin(i+1)=f(fmin(i+1));
%         F_fmax(i+1)=f(fmax(i+1));
%     end
% 
%     for i=0:N
%         K(1,i+1)=i*step;
%         x_p(:,i+1)=bifurcationValue_ADHD_DGRRO(A(i_a),Kcoef(i_a),K(i+1),As,sigma,Omega,1);
%         x_n(:,i+1)=bifurcationValue_ADHD_DGRRO(A(i_a),Kcoef(i_a),K(i+1),As,sigma,Omega,-1);
%         try
%             waitbar((i)/(N), wb, sprintf('Progress: %d %%', floor((i)/(N)*100)));
%         catch
%             close(wb)
%         end
%     end 
% 
%     close(wb)
%     save("BifurDGRRO"+num2str(i_a)+".mat");  
% end

% for i_a=1:size(A,2)
for i_a=1:size(A,2)
    fig(i_a)=figure('WindowState', 'maximized');
    load("BifurDGRRO"+num2str(i_a)+".mat");
    wb = waitbar(0, 'Starting');

    hold on;
    grid on;

%     pbaspect([1 2 1])

%     yyaxis right
%     ylim([-y_lim y_lim]);
%     fminplot = plot(K,F_fmin,"r-",'Linewidth',3);
%     fmaxplot = plot(K,F_fmax,"b-",'Linewidth',3);
% %     ylabel('F(f_{min,max})+Ku(f_{min,max})')
% %     legend('F(f_{min})+Ku(f_{min})','F(f_{max})+Ku(f_{max})');

    att=xline(K_dgrro(i_a),"r-",'Linewidth',4);
    q1=quiver(K_dgrro(i_a)-0.06*x_lim, y_lim*0.9, 0.05*x_lim, 0,'Color','k','Linewidth',4);
    q1.ShowArrowHead = 'off'; q1.Marker = '<';
    q2=quiver(K_dgrro(i_a)+0.06*x_lim, y_lim*0.9, -0.05*x_lim, 0,'Color','r','Linewidth',4);
    q2.ShowArrowHead = 'off'; q2.Marker = '>';

%     yyaxis left;

    xlim([0 x_lim]);
    ylim([-y_lim y_lim]);
    xlabel('DG-RRO feedback signal strength: K','FontSize', 50) 
%     ylabel('x')

    i=0;
    bifurp = plot(nan, nan,'r.','MarkerSize', 25);
    bifurn = plot(nan, nan,'b.','MarkerSize', 25);
    nanpoint = scatter(nan, nan, "w.");

    legend([bifurp(1),bifurn(1),att,nanpoint], 'x(n) when initial value > 0', 'x(n) when initial value < 0',...
            'Attractor-merging', 'bifurcation point','Location','southoutside','NumColumns', 2);
    L=legend;
    L.AutoUpdate = 'off';

    for i=1:N
        for j=1:size(x_p(:,N),2)
            plot(K(1,i+1),x_p(end-takeNum+1:end,i+1),'r.');
            plot(K(1,i+1),x_n(end-takeNum+1:end,i+1),'b.');
        end
        try
            waitbar((i)/(N), wb, sprintf('Progress: %d %%', floor((i)/(N)*100)));
        catch
            close(wb)
        end
    end 

    hold off 

    exportgraphics(fig(i_a),".\Results2\DG\Bifurcation\"+num2str(divide)+"\BifurcationDG_A_"+num2str(A(i_a)) ...
        +"_K_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
    savefig(fig(i_a),".\Results2\DG\Bifurcation\"+num2str(divide)+"\BifurcationDG_A_"+num2str(A(i_a)) ...
        +"_K_"+num2str(Kcoef(i_a))+".fig")
    close(fig(i_a));
    close(wb)
    pause(5)
end
