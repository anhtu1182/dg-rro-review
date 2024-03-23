clear;

% x_lim=0.3;
x_lim=1;
step=0.002;
% N=round(x_lim/step);
N=500;
step=x_lim/N;
loopTime=2300;
K=zeros(1,N+1);
% Calculate 100 values of map function
valNum=100;
% But only take 50 values
takeNum=50;

rng('default')
x_rand = randn(1,20,'double');

sigma=1;
% As=0.15;
% Omega=2.*pi/32;

set(0,'defaultAxesFontSize',40);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',40);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + RRO

% A=[9.8 12];
% K_rro1=[0.105825142911035 0.684580422277283];
% K_dgrro1=[0.019586810998317 0.909510684521774];

% K_rro0.9=[-0.434948567822753 0.144430922892665];
% K_dgrro0.9=[-0.089211569622163 0.029605738455147];
% x_plot=[0.03,0.2,0.2,0.8];
% lim_y=[5e-3 0.3];

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];
divide=2;

K_rro = fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");
K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

K_rro_max=1;
K_dgrro_max=0.25;

% for i_a=1:size(A,2)
% A_list=[0.01 0.15 0.3];
% A_list=0.01:0.02:0.3;
A_list=[1e-3:1e-3:9e-3 1e-2:1e-2:9e-2 1e-1:1e-1:9e-1 1];

% period=[4, 8, 16, 32];

Omega=0.005;
p=fix((2.*pi)/Omega);
  
sumKu=zeros(size(x_rand,2),length(A_list),N+1);
sumKg=zeros(size(x_rand,2),length(A_list),N+1);
% theta_rro=zeros(size(x_rand,2),N+1);
% theta_dgrro=zeros(size(x_rand,2),N+1);
for i_a=1:size(A,2)    
    for i=0:N
        K(1,i+1)=i*step;
        
        for as_i=1:length(A_list)
            As=A_list(as_i);
            f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,0,Omega,i);
            f_min=abs(fminbnd(f,-3,0));
%             As=A_list(as_i);
        
            theta_rro=zeros(size(x_rand,2),N+1);
            theta_dgrro=zeros(size(x_rand,2),N+1);
            
            for trial=1:size(x_rand,2)
                attractorRRO(1)=x_rand(trial)*0.1-0.7;
                attractorDGRRO(1)=x_rand(trial)*0.1-0.7;

                count=0;
                for l=2:1:loopTime
                    [attractorRRO(l),kuRRO(l),~]= ...
                    baghdadi_map_func(attractorRRO(l-1),A(i_a),Kcoef(i_a),K(i+1),sigma,As,Omega,l);
                    [attractorDGRRO(l),kgDGRRO(l),~]= ...
                    baghdadi_DGRRO_map_func(attractorDGRRO(l-1),A(i_a),Kcoef(i_a),K(i+1),sigma/4,As,Omega,l,f_min);
                    if loopTime>300
%                         sumKu(trial,i+1)=sumKu(trial,i+1)+(kuRRO(l)^2)+((As*sin(Omega*i_a))^2);
%                         sumKg(trial,i+1)=sumKg(trial,i+1)+(kgDGRRO(l)^2)+((As*sin(Omega*i_a))^2);

                        sumKu(trial,as_i,i+1)=sumKu(trial,as_i,i+1)+(kuRRO(l)^2)+((As*sin(Omega*i_a))^2);
                        sumKg(trial,as_i,i+1)=sumKg(trial,as_i,i+1)+(kgDGRRO(l)^2)+((As*sin(Omega*i_a))^2);

%                         sumKu(trial,as_i,i+1)=sumKu(trial,as_i,i+1)+(kuRRO(l)^2);
%                         sumKg(trial,as_i,i+1)=sumKg(trial,as_i,i+1)+(kgDGRRO(l)^2);
                        count=count+1;
                    end
                end
                meanSumKu(trial,as_i,i+1)=sumKu(trial,as_i,i+1)/count;
                meanSumKg(trial,as_i,i+1)=sumKg(trial,as_i,i+1)/count;
            end
        end
%         theta_rro(trial,i+1)= mean(sumKu,2);
%         theta_dgrro(trial,i+1)= mean(sumKg,2);
        theta_rro=reshape(mean(meanSumKu,2),[size(meanSumKu,1),size(meanSumKu,3)]);
        theta_dgrro=reshape(mean(meanSumKg,2),[size(meanSumKg,1),size(meanSumKg,3)]);
    end
    Theta_RRO=mean(theta_rro,1);
    Theta_RRO_std=std(theta_rro,0,1);
    Theta_DGRRO=mean(theta_dgrro,1);
    Theta_DGRRO_std=std(theta_dgrro,0,1);
        

        fig(i_a)=figure('WindowState', 'maximized');
    %     y_at_x_rro(i_a) = interp1(K,Theta_RRO,K_rro(i_a));
        hold on;
        grid on;
        xlim([0 K_rro_max]);
        ylim([1e-4 1e-0]);
        xlabel('RRO feedback signal strength: K','FontSize', 50) 
%         ylabel('Perturbation: \Theta')
% % % %         title(["Perturbation of RRO"; ...
% % % %             "A = " + num2str(A(i_a)) + ", C = " + num2str(Kcoef(i_a))])
% % % %         legend("A=0.01", "A=0.15", "0.3");
% % % %         plot(K,Theta_RRO,'Linewidth',2);
% % % %         plot(K,Theta_RRO+Theta_RRO_std,':k','Linewidth',2);
% % % %         plot(K,Theta_RRO-Theta_RRO_std,':k','Linewidth',2);
        errorbar(K,(Theta_RRO),Theta_RRO_std,"k",'Linewidth',2,"DisplayName","Perturbation")
        xline(K_rro(i_a),"r-",'Linewidth',4,"DisplayName","Attractor merging bifurcation point")
        y_at_x_RRO(i_a) = interp1(K,Theta_DGRRO,K_rro(i_a));
        yline(y_at_x_RRO(i_a),"b-",'Linewidth',3)
        legend("Perturbation","Attractor-merging bifurcation point",'Location','southoutside','NumColumns', 2)
        pbaspect([4 1 1])
        yRRO_at_x0(i_a) = interp1(K,Theta_RRO,K_rro(i_a));
        

    %     scatter(K_rro(i_a),y_at_x_rro(i_a),'Linewidth',2,'MarkerFaceColor','k');
        set(gca, 'YScale', 'log')
        hold off;
    
        fig(i_a+size(A,2))=figure('WindowState', 'maximized');
    %     y_at_x_dgrro(i_a) = interp1(K,Theta_DGRRO,K_dgrro(i_a));
        hold on;
        grid on;
        xlim([0 K_dgrro_max]);
        ylim([1e-4 1e-0]);
        
        xlabel('DG-RRO feedback signal strength: K','FontSize', 50) 
%         ylabel('Perturbation: \Theta')
% % % %         title(["Perturbation of DG-RRO"; ...
% % % %             "A = " + num2str(A(i_a)) + ", C = " + num2str(Kcoef(i_a))])
% % % %         legend("A=0.01", "A=0.15", "0.3");
% % % %         plot(K,Theta_DGRRO,'Linewidth',2);
% % % %         plot(K,Theta_DGRRO+Theta_DGRRO_std,':k','Linewidth',2);
% % % %         plot(K,Theta_DGRRO-Theta_DGRRO_std,':k','Linewidth',2);
        errorbar(K,(Theta_DGRRO),Theta_DGRRO_std,"k",'Linewidth',2,"DisplayName","Perturbation")
        xline(K_dgrro(i_a),"r-",'Linewidth',4,"DisplayName","Attractor merging bifurcation point")
        y_at_x_DG(i_a) = interp1(K,Theta_DGRRO,K_dgrro(i_a));
        yline(y_at_x_DG(i_a),"b-",'Linewidth',3)
        legend("Perturbation","Attractor-merging bifurcation point",'Location','southoutside','NumColumns', 2)
        pbaspect([4 1 1])
        yDG_at_x0(i_a) = interp1(K,Theta_DGRRO,K_dgrro(i_a));
    %     scatter(K_dgrro(i_a),y_at_x_dgrro(i_a),'Linewidth',2,'MarkerFaceColor','k');
        set(gca, 'YScale', 'log')
        hold off;
    
        exportgraphics(fig(i_a),".\Results2\RRO\Perturbation\PerturbationRRO_Kcoef_"+ ...
            num2str(Kcoef(i_a))+"_A_"+ num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    %     savefig(fig(i_a),".\Perturbation2\PerturbationRRO_A_"+ ...
    %         num2str(A(i_a))+".fig")
        close(fig(i_a));
    
        exportgraphics(fig(i_a+size(A,2)),".\Results2\DG\Perturbation\PerturbationDGRRO_Kcoef_"+ ...
            num2str(Kcoef(i_a))+"_A_"+num2str(A(i_a))+".png",'Resolution',400,"Append",false)
    %     savefig(fig(i_a+size(A,2)),".\Perturbation2\PerturbationRRO_A_"+ ...
    %         num2str(A(i_a))+".fig")
        close(fig(i_a+size(A,2)));
    
        
end

writematrix(yRRO_at_x0,".\Results2\RRO\Perturbation\PerturbationaAtAttractorMergingPoint.txt",'Delimiter',',') 
writematrix(yDG_at_x0,".\Results2\DG\Perturbation\PerturbationaAtAttractorMergingPoint.txt",'Delimiter',',')  
