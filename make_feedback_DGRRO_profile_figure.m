clear;

step=0.05;
x_lim=5;
y_lim=3.5;
N=round(x_lim/step);

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + DGRRO

x=-x_lim:step:x_lim;

omega1=0.2223; 
omega2=1.487;
B=5.82;
sigma=1/2;
Omega=0.005;
As=0;

A=[9.8 12];
for i_a=1:size(A,2)

    fig(i_a)=figure('WindowState', 'maximized');
    for i=-N:N
        Fx=(B*tanh(omega2*x(N+i+1))-A(i_a)*tanh(omega1*x(N+i+1)));

%         Fx= (A(i_a)*x(N+i+1)-x(N+i+1)^3)*exp(-x(N+i+1)^2/B);

        f=@(x)(B*tanh(omega2*x)-A(i_a)*tanh(omega1*x));

%         f=@(x)(A(i_a)*x-x^3)*exp(-x^2/B);
        xmin=fminbnd(f,-3,0);
        xmax=-xmin;

        [~,y(N+i+1),~]=hadaeghi_DGRRO_map_func(x(N+i+1),A(i_a),1,sigma,As,Omega,i);
        y(N+i+1)=-Fx*(exp(-(x(N+i+1)-xmin)^2/(2*sigma^2))+exp(-(x(N+i+1)-xmax)^2/(2*sigma^2)));

%         y(N+i+1)=-x(N+i+1)*exp(-(x(N+i+1)^2)/(2*sigma^2));
    end
    hold on
    plot(x,y,'k');
    xline(xmin,'--r');
    xline(xmax,'--b');
    hold off
    grid on
    legend("G(x)","x_{min}","x_{max}")
    xlabel('x') 
    ylabel('DGRRO feedback signal: g(x)')
    xlim([-x_lim x_lim])
    ylim([-y_lim y_lim])
    
    exportgraphics(fig(i_a),".\DGRRO\BD\FeedbackProfile_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    savefig(fig(i_a),".\DGRRO\BD\Figure\FeedbackProfile_A_"+num2str(A(i_a))+".fig")
    close(fig(i_a));
end
