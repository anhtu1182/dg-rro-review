clear;

omega1=0.2223; 
omega2=1.487;
B=5.82;
sigma=1;

step=0.005;
x_lim=0.25;
N=round(x_lim/step);
K=zeros(1,N);
LE=zeros(1,N);
valNum=50;

% No external signal (As=0)
As=0;

delta=0.0005;
tau=25;
Tran=100;

wb = waitbar(0, 'Starting');

% load("BifurPos.mat","x_p")

A=[9.8 12];
for i_a=1:size(A,2)
    for i=0:N
        K(i+1)=i*step;
        x(i+1,1)=0.15;
        xx(i+1,1)=x(i+1,1)+delta;
    
        count=1;
    
        for j=1:50000
            [x(i+1,j+1),~,~]=hadaeghi_DGRRO_map_func(x(i+1,j),A(i_a),K(i+1),sigma/2,As,0.005,j);
            [xx(i+1,j+1),~,~]=hadaeghi_DGRRO_map_func(xx(i+1,j),A(i_a),K(i+1),sigma/2,As,0.005,j);
    
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
        
        Lambda(i+1)=mean(lambda);

        try
            waitbar(i/N, wb, sprintf('Progress: %d %%', floor(i/N*100)));
        catch
        end
        pause(0.01);
    end
    
    
    f(i_a)=figure('WindowState', 'maximized');
    set(0,'defaultAxesFontSize',20);
    set(0,'defaultAxesFontName','Arial');
    set(0,'defaultTextFontSize',20);
    set(0,'defaultTextFontName','Arial');
    
    hold on;
    grid on;
    
    plot(K,Lambda,'k','Linewidth',2);
    
    xlim([0 x_lim]);
    ylim([-5 1.5]);
    xlabel('K') 
    ylabel('\lambda')
    
    % close(wb)
    
    hold off;
    save('results_Lyapunov_exponent.mat',"Lambda");
    save('originSignal',"x");
    save('orbitSignal',"xx");
    save('lambda','Lambda');
    exportgraphics(f(i_a),".\DGRRO\ADHD\lyapunov_exponent_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    savefig(f(i_a),".\DGRRO\BD\Figure\lyapunov_exponent_A_"+num2str(A(i_a))+".fig")
    close(f(i_a));
end