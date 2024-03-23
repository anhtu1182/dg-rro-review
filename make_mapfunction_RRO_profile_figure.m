clear;

step=0.05;
x_lim=3.5;
y_lim=2;
N=round(x_lim/step);

% sigma=2;
% Omega=0.005;
% Calculate 100 values of map function
valNum=100;
% But only take 50 values
takeNum=50;
x_p=zeros(valNum,N);
x_n=zeros(valNum,N);

As=0;

set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + RRO

x=-x_lim:step:x_lim;
A=[12 13 13 13];
Kcoef=[1.0 0.89 0.9 0.91];

omega1=0.2223; 
omega2=1.487;
B=5.82;
sigma=1;
Omega=0.005;
As=0;
K=1;
for i_a=1:size(A,2)
%     f=@(x)Kcoef*(B*tanh(omega2*x)-A(i_a)*tanh(omega1*x));
    f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
    xmin=fminbnd(f,-3,0);
    xmax=-xmin;

    fig(i_a)=figure('WindowState', 'maximized');
    for i=-N:N
        [~,y(N+i+1),~]=baghdadi_map_func(x(N+i+1),A(i_a),Kcoef(i_a),K,sigma,As,Omega,i);
    end
    plot(x,y,"k","LineWidth",3)
    xline(0,"k-",'Linewidth',1.5)
    yline(0,"k-",'Linewidth',1.5)
%     xline(xmin,'--r',"LineWidth",2);
%     xline(xmax,'--b',"LineWidth",2);
%     grid on
%     legend("u(x)","x_{min}","x_{max}", 'FontSize', 40)
    xlabel('x') 
    ylabel('Feedback signal')
%     ylabel({'RRO feedback';'signal: u(x)'})
    xlim([-x_lim x_lim])
    ylim([-y_lim/2 y_lim/2])
    
    exportgraphics(fig(i_a),".\Results2\RRO\Feedback\FeedbackProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
    close(fig(i_a));
end

% for i_a=1:size(A,2)
%     f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
%     xmin=fminbnd(f,-3,0);
%     xmax=-xmin;
% 
%     fig(i_a)=figure('WindowState', 'maximized');
%     for i=-N:N
%         [y(N+i+1),~,~]=baghdadi_map_func(x(N+i+1),A(i_a),Kcoef(i_a),K,sigma,As,Omega,i);
%     end
%     plot(x,y,"k","LineWidth",2)
% %     xline(xmin,'--r',"LineWidth",2);
% %     xline(xmax,'--b',"LineWidth",2);
%     grid on
%     xlabel('x') 
%     ylabel('x(n+1)')
%     xlim([-x_lim x_lim])
%     ylim([-2*y_lim 2*y_lim])
%     
%     exportgraphics(fig(i_a),".\Results2\RRO\ReturnMap\MapFunctionProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
%     close(fig(i_a));
% end
