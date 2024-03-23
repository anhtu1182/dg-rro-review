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
% Baghdadi model with attenuation coefficient C=1
Kcoef=1;
% Sigma and omega from previous reseach
sigma=1;
Omega=0.005;

% Omega and B from previous study
omega1=0.2223; 
omega2=1.487;
B=5.82;

% delta=0.001;
% tau=1;
% Tran=100;

wb = waitbar(0, 'Starting');

% load("BifurPos.mat","x_p")
sum=0;

for i=0:N
    A(1,i+1)=(i+N/2)*step;
    f=@(x) baghdadi_map_func(x,A,Kcoef(1,i+1),K,sigma,As,Omega,i);
%     Ranmon initial value of x(0) 
    x(i+1,1)=0.15;
%     xx(i+1,1)=x(i+1,1)+delta;

    count=1;

%     Base on formular x goto inf so I choose a huge number (5000)
%     This for loop calculate sum of (Fx)' for x(j) with j=1:5000
    for j=1:5000
        [x(i+1,j+1),~,~]=baghdadi_map_func(x(i+1,j),A(i+1),Kcoef,K,sigma,As,Omega,j);
%         [xx(i+1,j+1),~,~]=baghdadi_map_func(xx(i+1,j),A(i+1),Kcoef,K,sigma,As,Omega,j);

%     Our return map is Fx=Kcoef*(B*tanh(omega2*x)-A*tanh(omega1*x));
%     I use diff function to find derivative of Fx respect to x

        lambda(count)= log(Kcoef*(A(i+1)*omega1*(tanh(omega1*x(i+1,j))^2 - 1) - B*omega2*(tanh(omega2*x(i+1,j))^2 - 1)));
        count=count+1;

% %         Get vulue after "tau" times update
%         if mod(j,tau)==0        
%             delta_tau=abs(xx(i+1,j+1)-x(i+1,j+1));
%             if j>Tran
%                 lambda(count)=log(delta_tau/delta);
%                 count=count+1;
%             end
%         end
%         xx(i+1,j+1)=x(i+1,j+1)+delta;


    end
    
%     Calculate mean of sum
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
% save('results_Lyapunov_exponent.mat',"Lambda");
% save('originSignal',"x");
% save('orbitSignal',"xx");
% save('lambda','Lambda');
exportgraphics(f,".\Results2\WithoutRRO\LE\lyapunov_exponent_trial.png",'Resolution',400,"Append",false)
% savefig(f,".\Results2\WithoutRRO\Figure\lyapunov_exponent.fig")
close(f);