clear;


N=400;
step=10/N;

A=zeros(1,N);
LE=zeros(1,N);
valNum=50;

% No RRO feedback (K=0)
K=0;
% No external signal (As=0)
As=0;

Kcoef=1;
sigma=1;
Omega=0.005;

delta=0.001;
tau=1;
Tran=100;

wb = waitbar(0, 'Starting');

% load("BifurPos.mat","x_p")

for i=0:N
    A(1,i+1)=(i+N/2)*step;
    x(i+1,1)=0.15;
    xx(i+1,1)=x(i+1,1)+delta;

    count=1;

    for j=1:5000
        [x(i+1,j+1),~,~]=baghdadi_map_func(x(i+1,j),A(i+1),Kcoef,K,sigma,As,Omega,j);
        [xx(i+1,j+1),~,~]=baghdadi_map_func(xx(i+1,j),A(i+1),Kcoef,K,sigma,As,Omega,j);

%         Get vulue after "tau" times update
        if mod(j,tau)==0        
            delta_tau=abs(xx(i+1,j+1)-x(i+1,j+1));
            if j>Tran
                lambda(count)=log(delta_tau/delta);
                count=count+1;
            end
        end
        xx(i+1,j+1)=x(i+1,j+1)+delta;
    end
    
    try
        Lambda(i+1)=mean(lambda);
    catch
    end

    try
        waitbar(i/N, wb, sprintf('Progress: %d %%', floor(i/N*100)));
    catch
    end
    pause(0.01);
end


f=figure('WindowState', 'maximized');
set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Arial');

hold on;
grid on;

plot(A,Lambda,'k','Linewidth',2);

xlim([5 15]);
% ylim([-2.2 1]);
xlabel('Inhibitory synaptic strength: A') 
ylabel('\lambda')

% close(wb)

hold off;
save('results_Lyapunov_exponent.mat',"Lambda");
save('originSignal',"x");
save('orbitSignal',"xx");
save('lambda','Lambda');
exportgraphics(f,".\Results2\WithoutRRO\LE\lyapunov_exponent.png",'Resolution',400,"Append",false)
% savefig(f,".\Results2\WithoutRRO\Figure\lyapunov_exponent.fig")
close(f);