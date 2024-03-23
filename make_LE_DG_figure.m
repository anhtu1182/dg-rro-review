clear;

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

for a_value=1:length(A)
K=0;
sigma=1;
As=0;
Omega=0;
i=1;

f=@(x)baghdadi_map_func(x,A(a_value),Kcoef(a_value),K,sigma,As,Omega,i);
f_min(a_value)=abs(fminbnd(f,-3,0));
end

x_lim=0.25;
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

% load("BifurPos.mat","x_p")
for divide=2:2
    K_rro = fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");
    K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

    sigma=1/divide;
    for i_a=1:size(A,2)
        wb = waitbar(0, 'Starting');
        for i=0:N
            K(i+1)=i*step;
            x(i+1,1)=0.15;
            xx(i+1,1)=x(i+1,1)+delta;
        
            count=1;
        
            for j=1:50000
                [x(i+1,j+1),~,~]=baghdadi_DGRRO_map_func(x(i+1,j),A(i_a),Kcoef(i_a),K(i+1),sigma,As,Omega,j,f_min(i_a));
                [xx(i+1,j+1),~,~]=baghdadi_DGRRO_map_func(xx(i+1,j),A(i_a),Kcoef(i_a),K(i+1),sigma,As,Omega,j,f_min(i_a));
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
        
        
        fig(i_a)=figure('WindowState', 'maximized');
        set(0,'defaultAxesFontSize',40);
        set(0,'defaultAxesFontName','Arial');
        set(0,'defaultTextFontSize',40);
        set(0,'defaultTextFontName','Arial');
        
        hold on;
        grid on;
        
        plot(K,Lambda,'k','Linewidth',2);
        xline(K_dgrro(i_a),"r-",'Linewidth',3)
        legend("Lyapunov exponent","Attractor-merging bifurcation point",'Location','southoutside','NumColumns', 2)

        pbaspect([4 1 1])
        
        xlim([0 x_lim]);
        ylim([-4 2]);
        xlabel('DG-RRO feedback signal strength: K','FontSize', 50) 
%         ylabel('Lyapunov exponent: \lambda')
        
        % close(wb)
        
        hold off;
        save('results_Lyapunov_exponent.mat',"Lambda");
        save('originSignal',"x");
        save('orbitSignal',"xx");
        save('lambda','Lambda');
    %     exportgraphics(f(i_a),".\RRO\lyapunov_exponent_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
        exportgraphics(fig(i_a),".\Results2\DG\LE\"+num2str(divide)+"\lyapunov_exponent_RRO_A_"+num2str(A(i_a)) ...
            +"_K_"+num2str(Kcoef(i_a))+".png",'Resolution',400,"Append",false)
    %     savefig(f(i_a),".\RRO\BD\Figure\lyapunov_exponent_A_"+num2str(A(i_a))+".fig")
        close(fig(i_a));
        close(wb)
    end
end