x=load("originSignal.mat").x;
xx=load("orbitSignal.mat").xx;
Lambda=load("lambda.mat").Lambda;
A=zeros(1,size(x,1));

set(0,'defaultAxesFontSize',10);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',8);
set(0,'defaultTextFontName','Arial');

step=0.05;
for i=0:size(x,1)-1
    A(i+1)=i*step;
    for j=1:size(x,2)
        time(j)=j;
    end
    figure(i+1);
    hold on;
    plot(time(2:end),x(i+1,2:end))
    plot(time(2:end),xx(i+1,2:end))
    plot(time(2:end),abs(x(i+1,2:end)-xx(i+1,2:end)))
    grid on;
    legend('x origin','xx orbit','absDiff');
    title("lyapunov exponent of A="+num2str(A(i+1)) ...
        +" with Lambda="+num2str(Lambda(i+1)))
    xlim([1 400])
    xlabel('step') 
    ylabel('x(n)')
    exportgraphics(figure(i+1),"./LE/lyapunov_exponent_of_A="+num2str(A(i+1)) ...
        +"_with_Lambda="+num2str(Lambda(i+1))+".png",'Resolution',400)
    close(figure(i+1))
end