clear;

N=400;
step=10/N;

A=zeros(1,N);
valNum=100;
takeNum=50;
x_p=zeros(valNum,N);
x_n=zeros(valNum,N);

K=0;
As=0;
Kcoef=1;
sigma=1;
Omega=0.005;

wb = waitbar(0, 'Starting');

f=figure('WindowState', 'maximized');
set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Arial');

hold on;
grid on;

% ------------------------------
% For Hadaeghi map function only

xlim([5 15]);
ylim([-6 6]);
yticks(-6:3:6);
xlabel('Inhibitory synaptic strength: A') 
ylabel('x(n)')

    bifurp = plot(nan, nan,'r.','MarkerSize', 25);
    bifurn = plot(nan, nan,'b.','MarkerSize', 25);
    legend([bifurp(1),bifurn(1)], 'x(n) when initial value > 0', 'x(n) when initial value < 0',...
        'NumColumns', 2,"FontSize", 35)
    L=legend;
    L.AutoUpdate = 'off';

for i=1:N
    A(1,i)=(i+200)*step;
    x_p(:,i)=bifurcationValue_ADHD(A(1,i),Kcoef,K,As,sigma,Omega,1);
    x_n(:,i)=bifurcationValue_ADHD(A(1,i),Kcoef,K,As,sigma,Omega,-1);

    for j=1:size(x_p(:,N),2)
        plot(A(1,i),x_p(end-takeNum+1:end,i),'r.');
        plot(A(1,i),x_n(end-takeNum+1:end,i),'b.');
    end

    try
        waitbar(i/N, wb, sprintf('Progress: %d %%', floor(i/N*100)));
    catch
        close(wb)
    end
    pause(0.01);
end

% For Hadaeghi map function only
% ------------------------------

% legend([bifurp(1),bifurn(1)], 'x(n) when initial value > 0', 'x(n) when initial value < 0',...
%         'NumColumns', 2,"FontSize", 35)
% [~,b]=legend;
% set(findobj(b,'-property','MarkerSize'),'MarkerSize',25);
hold off 
% savefig(f,'Results2\WithoutRRO\Bifurcation.fig')
exportgraphics(f,".\Results2\WithoutRRO\Bifurcation\Bifurcation.png",'Resolution',400,"Append",false)
