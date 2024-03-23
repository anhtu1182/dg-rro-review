clear;

step=0.05;
x_lim=3.5;
y_lim=4;
N=round(x_lim/step);

set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + RRO

x=-x_lim:step:x_lim;
A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

omega1=0.2223; 
omega2=1.487;

Omega=0.005;
As=0;
K=1;

for divide=2:2
    sigma=1/divide;

for i_a=1:size(A,2)
    f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
    xmin=fminbnd(f,-3,0);
    xmax=-xmin;

    fig(i_a)=figure('WindowState', 'maximized');
    for i=-N:N
        [~,y(N+i+1),~]=baghdadi_DGRRO_map_func(x(N+i+1),A(i_a),Kcoef(i_a),K,sigma,As,Omega,i,xmin);
    end
    hold on
    plot(x,y,'k',"LineWidth",3);
    xline(xmin,'--r',"LineWidth",2);
    xline(xmax,'--b',"LineWidth",2);
    hold off
    grid on
    legend("g(x)","x_{min}","x_{max}", 'FontSize', 40)
    xlabel('x') 
%     tix=get(gca,'ytick')';
%     set(gca,'yticklabel',num2str(tix,'%.1f'))
    ylabel({'DG-RRO feedback';'signal: g(x)'})
    xlim([-x_lim x_lim])
    ylim([-y_lim y_lim])
%     set(gca,'yticklabel',num2str(get(gca,'xtick')','%.1f'))
    
    exportgraphics(fig(i_a),".\Results2\DG\Feedback\"+num2str(divide)+"\FeedbackProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
%     savefig(fig(i_a),".\DGRRO\ADHD\Figure\MapFunctionDGProfile_A_"+num2str(A(i_a))+".fig")
    close(fig(i_a));
end

% for i_a=1:size(A,2)
%     f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
%     xmin=fminbnd(f,-3,0);
%     xmax=-xmin;
% 
%     fig(i_a)=figure('WindowState', 'maximized');
%     for i=-N:N
%         [z(N+i+1),~,~]=baghdadi_DGRRO_map_func(x(N+i+1),A(i_a),Kcoef(i_a),0,sigma,As,Omega,i,xmin);
%     end
%     hold on
%     plot(x,z,'k',"LineWidth",2);
%     hold off
%     grid on
% %     legend("g(x)","x_{min}","x_{max}")
%     xlabel('x(n)') 
%     ylabel('x(n+1)')
%     xlim([-x_lim x_lim])
%     ylim([-y_lim y_lim])
% %     set(gca,'yticklabel',num2str(get(gca,'xtick')','%.1f'))
%     
%     exportgraphics(fig(i_a),".\Results2\DG\ReturnMap\"+num2str(divide)+"\MapFunctionDGProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
% %     savefig(fig(i_a),".\DGRRO\ADHD\Figure\MapFunctionDGProfile_A_"+num2str(A(i_a))+".fig")
%     close(fig(i_a));
% end
end


















% 
% for i_a=1:size(A,2)
%     f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,0,As,Omega,i);
%     xmin=fminbnd(f,-3,0);
%     xmax=-xmin;
%     label=[];
%     fig(i_a)=figure('WindowState', 'maximized');
%     for divide=1:6
%     sigma=1/divide;
%     label=[label, "g(x)"+num2str(divide)];
%     for i=-N:N
%         [~,y(N+i+1),~]=baghdadi_DGRRO_map_func(x(N+i+1),A(i_a),Kcoef(i_a),K,sigma,As,Omega,i,xmin);
%     end
%     hold on
%     plot(x,y,"LineWidth",3);
%     end
%     xline(xmin,'--r',"LineWidth",2);
%     xline(xmax,'--b',"LineWidth",2);
%     hold off
%     grid on
%     legend([label,"x_{min}","x_{max}"])
%     xlabel('x') 
%     ylabel('DGRRO feedback signal: g(x)')
%     xlim([-x_lim x_lim])
%     ylim([-y_lim y_lim])
% %     set(gca,'yticklabel',num2str(get(gca,'xtick')','%.1f'))
%     
% %     exportgraphics(fig(i_a),".\Results2\DG\Feedback\"+num2str(divide)+"\FeedbackProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
% % %     savefig(fig(i_a),".\DGRRO\ADHD\Figure\MapFunctionDGProfile_A_"+num2str(A(i_a))+".fig")
%     exportgraphics(fig(i_a),".\Results2\DG\Feedback\FeedbackProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
%     close(fig(i_a));
% end