

b=10.;

delta_a=5e-4;

sigma=0.6;
K=0.;
D=0.03;

%f=@(x)cubic_map(x,a,b,0,0,0,0,0);
%cubic_f_min=abs(fminbnd(f,-2,0));

rng(1);

delta_K=0.0001;

t_size=1300;

for a_i=1:1:50

    a=2.81+delta_a*a_i;
    a_v(a_i)=a;

    for K_i=1:1:2000
        K=-K_i*delta_K;

        K_v(K_i)=K;
        
        f=@(x)cubic_map(x,a,b,0,0,K,sigma,0);
        f_min=(fminbnd(f,-2,0));

        ff_min=cubic_map(f_min,a,b,0,0,K,sigma,0);
        fff_min(K_i)=cubic_map(ff_min,a,b,0,0,K,sigma,0);
        
    end

    [judge_amb_zero(a_i) judge_amb(a_i)]=min(abs(fff_min));

    min_K(a_i)=K_v(judge_amb(a_i));
    K=min_K(a_i);

    for trial_i=1:1:10

        count=1;

        x_t(1)=-0.7+0.1*randn(1);
        for t_i=1:1:t_size
            [x_t(t_i+1),u]=cubic_map(x_t(t_i),a,b,0,0,K,sigma,0);
            if t_i>300
                o_biff_n(K_i,count)=x_t(t_i);
                count=count+1;
                x=x_t(t_i);
                temp_pert_abs(t_i)=u*u;
            end
        end    

        mean_o_pert_abs(a_i,trial_i)=mean(temp_pert_abs);
        
    end
    
    
end

save('RRO_pert.mat');

clear all;
%%%



b=10.;

delta_a=5e-4;

sigma=0.3;
K=0.;
D=0.03;


rng(1);

delta_K=0.0001;

t_size=1300;

for a_i=1:1:50

    a=2.81+delta_a*a_i;
    a_v(a_i)=a;

    f=@(x)cubic_map(x,a,b,0,0,0,0,0);
    cubic_f_min=abs(fminbnd(f,-2,0));

    
    for K_i=1:1:2000
        K=-K_i*delta_K;

        K_v(K_i)=K;
        
        f=@(x)cubic_map_double(x,a,b,0,0,K,sigma,0,cubic_f_min);
        f_min=(fminbnd(f,-2,0));

        ff_min=cubic_map_double(f_min,a,b,0,0,K,sigma,0,cubic_f_min);
        double_fff_min(K_i)=cubic_map_double(ff_min,a,b,0,0,K,sigma,0,cubic_f_min);

    end

    [double_judge_amb_zero(a_i) double_judge_amb(a_i)]=min(abs(double_fff_min));

    min_K(a_i)=K_v(double_judge_amb(a_i));
    K=min_K(a_i);
    
    for trial_i=1:1:10

        count=1;

        x_t(1)=-0.7+0.1*randn(1);
        for t_i=1:1:t_size
            [x_t(t_i+1),u]=cubic_map_double(x_t(t_i),a,b,0,0,K,sigma,0,cubic_f_min);
            if t_i>300
                biff_n(K_i,count)=x_t(t_i);
                count=count+1;
                x=x_t(t_i);
                temp_pert_abs(t_i)=u*u;
            end
        end    

        mean_o_pert_abs(a_i,trial_i)=mean(temp_pert_abs);
        
    end
    
    
end

save('DG_RRO_pert.mat');

clear all;



load('RRO_pert.mat');

rro_mean_o_pert_abs=mean_o_pert_abs;
rro_K=min_K;

load('DG_RRO_pert.mat');

dg_rro_mean_o_pert_abs=mean_o_pert_abs;
dg_rro_K=min_K;


set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');

subplot(2,1,1);

plot(a_v',rro_K,'k','Linewidth',2);

hold on;
grid on;


plot(a_v',dg_rro_K,'r','Linewidth',2);

legend('RRO method','DG-RRO method','Location','southeast');

xlabel('a');
ylabel('{\it K}_{am}');

subplot(2,1,2);

h1=plot(a_v',mean(rro_mean_o_pert_abs,2)','k','Linewidth',2);

hold on;

plot(a_v',mean(rro_mean_o_pert_abs,2)'+std(rro_mean_o_pert_abs'),':k','Linewidth',2);
plot(a_v',mean(rro_mean_o_pert_abs,2)'-std(rro_mean_o_pert_abs'),':k','Linewidth',2);

grid on;

h2=plot(a_v',mean(dg_rro_mean_o_pert_abs,2)','r','Linewidth',2);

plot(a_v',mean(dg_rro_mean_o_pert_abs,2)'+std(dg_rro_mean_o_pert_abs'),':r','Linewidth',2);
plot(a_v',mean(dg_rro_mean_o_pert_abs,2)'-std(dg_rro_mean_o_pert_abs'),':r','Linewidth',2);


legend([h1 h2],{'RRO method','DG-RRO method'});

xlabel('a');
ylabel('Perturbation: \Theta');

