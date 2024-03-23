

a=2.82;
b=10.;


sigma=0.3;
K=0.;
D=0.03;

f=@(x)cubic_map(x,a,b,0,0,0,0,0);
cubic_f_min=abs(fminbnd(f,-2,0));



set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');


x=[-2:0.1:2];

K=0;
for i_x=1:1:length(x)
    fxK0(i_x)=cubic_map_double(x(i_x),a,b,0,0,K,sigma,0,cubic_f_min);
end

K=-0.1;
for i_x=1:1:length(x)
    fxK01(i_x)=cubic_map_double(x(i_x),a,b,0,0,K,sigma,0,cubic_f_min);
end

K=-0.2;
for i_x=1:1:length(x)
    fxK02(i_x)=cubic_map_double(x(i_x),a,b,0,0,K,sigma,0,cubic_f_min);
end

plot(x,fxK0);

hold on;

plot(x,fxK01);
plot(x,fxK02);


delta_K=0.00001;

t_size=500;


figure;
for trial_i=1:1:10
    for K_i=1:1:1000
        K=-K_i*delta_K;
        K_v(K_i)=K;
        
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

        mean_pert_abs(K_i,trial_i)=mean(temp_pert_abs);
        clear x_t temp_pert_abs;

        x_t(1)=0.7+0.1*randn(1);
        count=1;
        for t_i=1:1:t_size
            x_t(t_i+1)=cubic_map_double(x_t(t_i),a,b,0,0,K,sigma,0,cubic_f_min);
            if t_i>300
                biff(K_i,count)=x_t(t_i);
                count=count+1;
            end
        end    
        
        clear x_t;

        f=@(x)cubic_map_double(x,a,b,0,0,K,sigma,0,cubic_f_min);
        f_min=(fminbnd(f,-2,0));

        ff_min=cubic_map_double(f_min,a,b,0,0,K,sigma,0,cubic_f_min);
        double_fff_min(K_i)=cubic_map_double(ff_min,a,b,0,0,K,sigma,0,cubic_f_min);

        
        
    end
end


subplot(3,1,1);

plot(K_v,biff,'.r','MarkerSize',0.1);
hold on;

grid on;

xlabel('Feedback strength: {\it K}');
ylabel('x');

plot(K_v,biff_n,'.b','MarkerSize',0.1);

subplot(3,1,2);

plot(K_v,smooth(mean(mean_pert_abs')),'k','Linewidth',2);
hold on;
plot(K_v,smooth(mean(mean_pert_abs')+std(mean_pert_abs')),':k','Linewidth',2);
plot(K_v,smooth(mean(mean_pert_abs')-std(mean_pert_abs')),':k','Linewidth',2);

grid on;

ylim([0 5*10^(-5)]);

xlabel('Feedback strength: {\it K}');
ylabel('Perturbation: \Theta');


subplot(3,1,3);

plot(K_v,double_fff_min,'b','Linewidth',2);

hold on;

plot(K_v,-double_fff_min,'r','Linewidth',2);

grid on;

xlabel('Feedback strength: {\it K}');
ylabel('Attractor merging condition');

legend('F(f_{min})+Kg(f_{min})','F(f_{max})+Kg(f_{max})')

yticks([-0.05:0.01:0.05]);

%%%%%%%%

figure;

sigma=0.6;
delta_K=0.00005
for trial_i=1:1:10
    for K_i=1:1:1000
        K=-K_i*delta_K;
        K_v(K_i)=K;
        
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

        mean_o_pert_abs(K_i,trial_i)=mean(temp_pert_abs);
        clear x_t temp_pert_abs;

        x_t(1)=0.7+0.1*randn(1);
        count=1;
        for t_i=1:1:t_size
            x_t(t_i+1)=cubic_map(x_t(t_i),a,b,0,0,K,sigma,0);
            if t_i>300
                o_biff(K_i,count)=x_t(t_i);
                count=count+1;
            end
        end    
        
        clear x_t;

        f=@(x)cubic_map(x,a,b,0,0,K,sigma,0);
        f_min=(fminbnd(f,-2,0));

        ff_min=cubic_map(f_min,a,b,0,0,K,sigma,0);
        fff_min(K_i)=cubic_map(ff_min,a,b,0,0,K,sigma,0);

        
    end
end

    
subplot(3,1,1);

plot(K_v,o_biff,'.r','MarkerSize',0.1);
hold on;

grid on;

xlabel('Feedback strength: {\it K}');
ylabel('x');


plot(K_v,o_biff_n,'.b','MarkerSize',0.1);

subplot(3,1,2);

std(mean_o_pert_abs')

plot(K_v,smooth(mean(mean_o_pert_abs')),'k','Linewidth',2);
hold on;
plot(K_v,smooth(mean(mean_o_pert_abs')+std(mean_o_pert_abs')),':k','Linewidth',2);
plot(K_v,smooth(mean(mean_o_pert_abs')-std(mean_o_pert_abs')),':k','Linewidth',2);


grid on;

ylim([0 5*10^(-5)]);

xlabel('Feedback strength: {\it K}');
ylabel('Perturbation: \Theta');

subplot(3,1,3);

plot(K_v,fff_min,'b','Linewidth',2);

hold on;

plot(K_v,-fff_min,'r','Linewidth',2);

grid on;

xlabel('Feedback strength: {\it K}');
ylabel('Attractor merging condition');

legend('{\it F(f_{min})+Ku(f_{min})}','{\it F(f_{max})+Ku(f_{max})}')

yticks([-0.05:0.01:0.05]);


%{

f=@(x)cubic_map(x,a,b,0,0,0,sigma,1);
f_min=fminbnd(f,-2,0);
f_max=-f_min;


ff_min=cubic_map(f_min,a,b,0,0,0,sigma,1);
fff_min=cubic_map(ff_min,a,b,0,0,0,sigma,1);
ff_max=cubic_map(f_max,a,b,0,0,0,sigma,1);
fff_max=cubic_map(ff_max,a,b,0,0,0,sigma,1);

f=@(x)cubic_map(x,a,b,0,0,-0.3,sigma,1);
fk_min=fminbnd(f,-2,0);
fk_max=-f_min;

ffk_min=cubic_map(fk_min,a,b,0,0,-0.3,sigma,1);
ffk_max=cubic_map(fk_max,a,b,0,0,-0.3,sigma,1);

fffk_min=cubic_map(ffk_min,a,b,0,0,-0.3,sigma,1);
fffk_max=cubic_map(ffk_max,a,b,0,0,-0.3,sigma,1);



%z_fmax=func_cnn(1/a,a,b,k,0,sigma,0,0,0);
%z_ffmax=func_cnn(z_fmax,a,b,k,0,sigma,0,0,0);
%zk_fmax=func_cnn(1/a,a,b,k,-0.1,sigma,0,0,0);
%zk_ffmax=func_cnn(zk_fmax,a,b,k,-0.1,sigma,0,0,0);

%}


set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');




x=[-2:0.1:2];

K=1;
sigma=0.3;
for i_x=1:1:length(x)
    [c map_double(i_x)]=cubic_map_double(x(i_x),a,b,0,0,K,sigma,0,cubic_f_min);
end

sigma=0.6;
K=1;
for i_x=1:1:length(x)
    [c map_single(i_x)]=cubic_map(x(i_x),a,b,0,0,K,sigma,0);
end


subplot(2,1,1);
plot(x,map_single,'k','Linewidth',2);
hold on;
grid on;
xlabel('x');
ylabel('RRO feedback signal: u(x)')
plot([f_min f_min],[-0.4 0.4],':r','Linewidth',2);
plot([-f_min -f_min],[-0.4 0.4],':b','Linewidth',2);

legend('u(x)','x_{min}','x_{max}');


subplot(2,1,2);
plot(x,map_double,'k','Linewidth',2);
hold on;
grid on;
xlabel('x');
ylabel('DG-RRO feedback signal: g(x)')

plot([f_min f_min],[-2 2],':r','Linewidth',2);
plot([-f_min -f_min],[-2 2],':b','Linewidth',2);

legend('g(x)','x_{min}','x_{max}');


%%%%%%

load('signal_response_RRO.mat');

RRO_max_C=max_C;
RRO_K_v=K_v;

load('signal_response_dG.mat');

DG_max_C=max_C;
DG_K_v=K_v;



set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');

subplot(2,1,1)
p_rro=plot(RRO_K_v,(mean(RRO_max_C)),'k','Linewidth',2);
hold on;
plot(RRO_K_v,(mean(RRO_max_C)+std(RRO_max_C)),':k','Linewidth',2);
plot(RRO_K_v,(mean(RRO_max_C)-std(RRO_max_C)),':k','Linewidth',2);

grid on;

xlim([-0.044 -0.036]);
ylim([0 1]);


xlabel('Feedback signal strength: K');
ylabel('max_\tau C(\tau)');

title('RRO method')

subplot(2,1,2);

p_dg=plot(DG_K_v,(mean(DG_max_C)),'k','Linewidth',2);
hold on;
plot(DG_K_v,(mean(DG_max_C)+std(DG_max_C)),':k','Linewidth',2);
plot(DG_K_v,(mean(DG_max_C)-std(DG_max_C)),':k','Linewidth',2);

%legend([p_rro p_dg],{'RRO','DG-RRO'});

grid on;

xlabel('Feedback signal strength: K');
ylabel('max_\tau C(\tau)');

xlim([-0.007 -0.006]);
ylim([0 1]);
title('DG-RRO method');
