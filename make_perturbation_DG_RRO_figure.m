clear;

step=0.002;
% x_lim=0.3;
x_lim=0.8;
N=round(x_lim/step);
loopTime=1000;
K=zeros(1,N+1);
% Calculate 100 values of map function
valNum=100;
% But only take 50 values
takeNum=50;

rng('default')
x_rand = rand(1,10,'double');

Kcoef=1;
sigma=1/4;
As=0.15;
% Omega=2.*pi/32;

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + RRO

A=[9.8 12];
K_rro=[0.105825142911035	0.684580422277283];
K_dgrro=[0.0195560308656910	0.126166594684946];
x_plot=[0.03,0.2,0.2,0.8];
y_lim=[1e-1 10];
% for i_a=1:size(A,2)
% A_list=[0.01 0.15 0.3];
A_list=0.01:0.02:0.3;

% period=[4, 8, 16, 32];

Omega=2.*pi/16;
p=fix((2.*pi)/Omega);
    
sumKu=zeros(size(x_rand,2),N+1);
sumKg=zeros(size(x_rand,2),N+1);
for i_a=1:size(A,2)
    for as_i=1:length(A_list)
        As=0;
        f=@(x)baghdadi_map_func(x,A(i_a),Kcoef,0,sigma,As,Omega,i);
        f_min=abs(fminbnd(f,-3,0));
    %         wb = waitbar(0, 'Starting');
        As=A_list(as_i);
        
        theta_rro=zeros(size(x_rand,2),N+1);
        theta_dgrro=zeros(size(x_rand,2),N+1);
        
        for i=0:N
            K(1,i+1)=i*step;
            for i_x=1:size(x_rand,2)
                attractorRRO(1)=x_rand(i_x);
                attractorDGRRO(1)=x_rand(i_x);
    
    %             figure(i_x);
    %             hold on;
                count=0;
                for l=2:1:loopTime
                    [attractorRRO(l),kuRRO(l),~]= ...
                    baghdadi_map_func(attractorRRO(l-1),A(i_a),Kcoef,K(i+1),sigma,As,Omega,i);
                    [attractorDGRRO(l),kgDGRRO(l),~]= ...
                    baghdadi_DGRRO_map_func(attractorDGRRO(l-1),A(i_a),Kcoef,K(i+1),sigma/2,As,Omega,i,f_min);
%                     if loopTime>300
%                         sumKu(i_x,i+1)=sumKu(i_x,i+1)+(kuRRO(l)^2)+((As*sin(Omega*i_a))^2);
%                         sumKg(i_x,i+1)=sumKg(i_x,i+1)+(kgDGRRO(l)^2)+((As*sin(Omega*i_a))^2);
                        sumKu(i_x,i+1)=sumKu(i_x,i+1)+(kuRRO(l)^2);
                        sumKg(i_x,i+1)=sumKg(i_x,i+1)+(kgDGRRO(l)^2);
                        count=count+1;
%                     end
                end
                
    %             for j=1:size(attractorRRO,2)
    %                 scatter(K(1,i+1),attractorRRO(j),'r.')
    %                 scatter(K(1,i+1),-attractorRRO(j),'b.')
    %             end
    
                theta_rro(i_x,i+1)= sumKu(i_x,i+1)/count;
                theta_dgrro(i_x,i+1)= sumKu(i_x,i+1)/count;
            end
            Theta_RRO(i+1)=mean(theta_rro(:,i+1));
            Theta_RRO_std(i+1)=std(theta_rro(:,i+1));
            Theta_DGRRO(i+1)=mean(theta_dgrro(:,i+1));
            Theta_DGRRO_std(i+1)=std(theta_dgrro(:,i+1));
%         %             try
%         %                 waitbar((i)/(N), wb, sprintf('Progress: %d %%', floor((i)/(N)*100)));
%         %             catch
%         %     %             close(wb)T
%         %             end
%         %             pause(0.01);
%         %     % 
%         %     %         figure('WindowState', 'maximized');
%         %     %         hold on;
%         %     %         grid on;
%         %     %     %     xlim([0 x_lim]);
%         %     %     %     ylim([0 30]);
%         %     %         xlabel('T') 
%         %     %         ylabel('Ku')
%         %     %     %     plot(K,Theta_RRO,'Linewidth',2);
%         %     %     %     plot(K,Theta_DGRRO,'Linewidth',2);
%         %     %     
%         %     %         plot(1:size(kuRRO,2),kuRRO,'Linewidth',2);
%         %     %         plot(1:size(kgDGRRO,2),kgDGRRO,'Linewidth',2);
%         %     %         title("K="+num2str(K(i+1)) )
%         %     %         
%         %     %         
%         %     %         legend("RRO", "DGRRO")
        end
% % 
% %         Theta_RRO(as_i,:)=mean(Theta_RRO_p,2);
% %         Theta_DGRRO(as_i,:)=mean(Theta_DGRRO_p,2);
    end
        

        fig(i_a)=figure('WindowState', 'maximized');
    %     y_at_x_rro(i_a) = interp1(K,Theta_RRO,K_rro(i_a));
        hold on;
        grid on;
        xlim([0 x_plot(i_a+size(A,2))]);
        ylim([1e-7 1e-1]);
        xlabel('K') 
        ylabel('\Theta')
        title("RRO pertubation at A = " + num2str(A(i_a)))
%         legend("A=0.01", "A=0.15", "0.3");
        plot(K,Theta_RRO,'Linewidth',2);
        plot(K,Theta_RRO+Theta_RRO_std,':k','Linewidth',2);
        plot(K,Theta_RRO-Theta_RRO_std,':k','Linewidth',2);

    %     scatter(K_rro(i_a),y_at_x_rro(i_a),'Linewidth',2,'MarkerFaceColor','k');
        set(gca, 'YScale', 'log')
        hold off;
    
        fig(i_a+size(A,2))=figure('WindowState', 'maximized');
    %     y_at_x_dgrro(i_a) = interp1(K,Theta_DGRRO,K_dgrro(i_a));
        hold on;
        grid on;
        xlim([0 x_plot(i_a)]);
        ylim([1e-7 1e-1]);
        xlabel('K') 
        ylabel('\Theta')
        title("DGRRO pertubation at A = " + num2str(A(i_a)))
%         legend("A=0.01", "A=0.15", "0.3");
        plot(K,Theta_DGRRO,'Linewidth',2);
        plot(K,Theta_DGRRO+Theta_DGRRO_std,':k','Linewidth',2);
        plot(K,Theta_DGRRO-Theta_DGRRO_std,':k','Linewidth',2);
    %     scatter(K_dgrro(i_a),y_at_x_dgrro(i_a),'Linewidth',2,'MarkerFaceColor','k');
        set(gca, 'YScale', 'log')
        hold off;
    
        exportgraphics(fig(i_a),".\Perturbation2\PerturbationRRO_A_"+ ...
            num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    %     savefig(fig(i_a),".\Perturbation2\PerturbationRRO_A_"+ ...
    %         num2str(A(i_a))+".fig")
        close(fig(i_a));
    
        exportgraphics(fig(i_a+size(A,2)),".\Perturbation2\PerturbationDGRRO_A_"+ ...
            num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    %     savefig(fig(i_a+size(A,2)),".\Perturbation2\PerturbationRRO_A_"+ ...
    %         num2str(A(i_a))+".fig")
        close(fig(i_a+size(A,2)));
    
        
end
