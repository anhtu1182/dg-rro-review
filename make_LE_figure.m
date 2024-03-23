clear;

omega1=0.2223; 
omega2=1.487;
B=5.82;

stepA=0.1;
stepK=0.01;
limx=20;
limy=1;
N=round(limx/stepA);
M=round(limy/stepK);
A=zeros(1,N);
Lambda=zeros(M,N);
valNum=50;

sigma=1/2;
Omega=0.005;

% No RRO feedback (K=0)
K=0;
% No external signal (As=0)
As=0;

delta=0.001;
tau=10;
Tran=100;

wb = waitbar(0, 'Starting');

load("BifurPos.mat","x_p")
cci=1;

for i=0:N
    for ik=0:M
        A(1,i+1)=i*stepA;
        Kcoef(1,ik+1)=ik*stepK;
        x(i+1,1)=0.15;
        xx(i+1,1)=x(i+1,1)+delta;
    
        count=1;
    
        for j=1:5000
            [x(i+1,j+1),~,~]=baghdadi_map_func(x(i+1,j),A(i+1),Kcoef(ik+1),K,sigma,As,Omega,j);
            [xx(i+1,j+1),~,~]=baghdadi_map_func(xx(i+1,j),A(i+1),Kcoef(ik+1),K,sigma,As,Omega,j);
    
%             Get vulue after "tau" times update
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
            Lambda(ik+1,i+1)=mean(lambda);
        catch
        end
     
        f=@(u) baghdadi_map_func(u,A(i+1),Kcoef(ik+1),K,sigma,As,Omega,i);
        xmin(ik+1,i+1)=fminbnd(f,-4,0);
        fmin(ik+1,i+1)=f(xmin(ik+1,i+1));
        F_fmin(ik+1,i+1)=f(fmin(ik+1,i+1));

        try
            waitbar(i/N, wb, sprintf('Progress: %d %%', floor(i/N*100)));
        catch
        end
        pause(0.01);
    end
end

pause(1)
close(wb)

% f=figure('WindowState', 'maximized');
% set(0,'defaultAxesFontSize',20);
% set(0,'defaultAxesFontName','Arial');
% set(0,'defaultTextFontSize',20);
% set(0,'defaultTextFontName','Arial');
% 
% hold on;
% grid on;
% 
% % plot(A,Lambda(ik+1,:),'k','Linewidth',2);
% 
% 
% contourf(A,0:limy/M:1,Lambda);
% % caxis([-1, 1]);
% colormap("jet")
% xlim([6 15]);
% ylim([0.5 1]);
% c = colorbar;
% c.Label.String = 'Lyapunov exponent: \lambda';
% 
% for i=0:N
%     ycci(i+1)=interp1(F_fmin(60:end,i+1),Kcoef(60:end),0);
% end
% plot(A,ycci,'k--', "LineWidth", 2)
% 
% xlabel('Inhibitory synaptic streangth: A') 
% ylabel('Attenuation coefficient: K')
% 
% % close(wb)
% 
% % ylim([-10 2]);
% 
% hold off;
% save('results_Lyapunov_exponent.mat',"Lambda");
% save('originSignal',"x");
% save('orbitSignal',"xx");
% save('lambda','Lambda');
% exportgraphics(f,".\WithoutRRO\ADHD\LE\lyapunov_exponent.png",'Resolution',400,"Append",false)
% % savefig(f,".\WithoutRRO\ADHD\Figure\lyapunov_exponent.fig")
% % close(f);