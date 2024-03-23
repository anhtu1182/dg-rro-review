clear;

step=0.05;
x_lim=3;
y_lim=0.4;
N=round(x_lim/step);

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + RRO

x=-x_lim:step:x_lim;
A=[9.8 12];

omega1=0.2223; 
omega2=1.487;
B=5.82;
sigma=1/2;
Omega=0.005;
As=0;

for i_a=1:size(A,2)

    f=@(x)(B*tanh(omega2*x)-A(i_a)*tanh(omega1*x));
    xmin=fminbnd(f,-3,0);
    xmax=-xmin;

    fig(i_a)=figure('WindowState', 'maximized');
    for i=-N:N
        [~,y(N+i+1),~]=hadaeghi_map_func(x(N+i+1),A(i_a),1,sigma,As,Omega,i);
    end
    hold on
    plot(x,y,'k');
    xline(xmin,'--r');
    xline(xmax,'--b');
    hold off
    grid on
    legend("u(x)","x_{min}","x_{max}")
    xlabel('x') 
    ylabel('RRO feedback signal: u(x)')
    xlim([-x_lim x_lim])
    ylim([-y_lim y_lim])
    
    exportgraphics(fig(i_a),".\RRO\BD\MapFunctionProfile_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    savefig(fig(i_a),".\RRO\BD\Figure\MapFunctionProfile_A_"+num2str(A(i_a))+".fig")
    close(fig(i_a));
end
