clear;

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

omega1=0.2223; 
omega2=1.487;
B=5.82;
sigma=1;

x_lim=1;
N=600;
step=x_lim/N;
K=zeros(1,N);
LE=zeros(1,N);
valNum=50;

% No external signal (As=0)
As=0;

delta=1e-4;
tau=1;
Tran=100;

Omega=0.005;

K_rro = fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");
% K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

% load("BifurPos.mat","x_p")

for i_a=1:size(A,2)
    wb = waitbar(0, 'Starting');
    for i=0:N
        K(i+1)=i*step;
        x(i+1,1)=0.15;
        xx(i+1,1)=x(i+1,1)+delta;
    
        count=1;
    
        for j=1:10000
            [x(i+1,j+1),~,~]=baghdadi_map_func(x(i+1,j),A(i_a),Kcoef(i_a),K(i+1),sigma,As,Omega,j);
            [xx(i+1,j+1),~,~]=baghdadi_map_func(xx(i+1,j),A(i_a),Kcoef(i_a),K(i+1),sigma,As,Omega,j);
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
%         pause(0.01);
    end
    
    
    f(i_a)=figure('WindowState', 'maximized');
    set(0,'defaultAxesFontSize',40);
    set(0,'defaultAxesFontName','Arial');
    set(0,'defaultTextFontSize',40);
    set(0,'defaultTextFontName','Arial');
    
    hold on;
    grid on;
    
    plot(K,Lambda,'k','Linewidth',2);
    xline(K_rro(i_a),"r-",'Linewidth',3)
    legend("Lyapunov exponent","Attractor-merging bifurcation point",'Location','southoutside','NumColumns', 2)

    pbaspect([4 1 1])
    
    xlim([0 1]);
    ylim([-4 2]);
    xlabel('RRO feedback signal strength: K','FontSize', 50) 
%     ylabel('Lyapunov exponent: \lambda')
    
    % close(wb)
    
    hold off;
    save('results_Lyapunov_exponent.mat',"Lambda");
    save('originSignal',"x");
    save('orbitSignal',"xx");
    save('lambda','Lambda');
%     exportgraphics(f(i_a),".\RRO\lyapunov_exponent_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    exportgraphics(f(i_a),".\Results2\RRO\LE\lyapunov_exponent_RRO_A_"+num2str(A(i_a)) ...
        +"_K_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
%     savefig(f(i_a),".\RRO\BD\Figure\lyapunov_exponent_A_"+num2str(A(i_a))+".fig")
    close(f(i_a));
    close(wb)
end