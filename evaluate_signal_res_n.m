%{
a=6.00;
b=10.;


A=0.005;
omega=0.005;

trial_N=10;
for trial_i=1:1:trial_N
    rng(trial_i);
    init_z=0.001*rand()+0.15;
    for a_i=1:1:3
        for k_i=1:1:100
            trial_i
            a_i
            z(1)=init_z;
            count=1;
            K=0.-0.5e-3*k_i
            K_v(k_i)=K;
            a=2.82+(a_i-1)*0.005;
            sigma=0.6;
            
            f=@(x)cubic_map(x,a,b,0,0,K,sigma,0);
            f_min=fminbnd(f,-2,0);
            f_max=-f_min;
            fmax=cubic_map(f_max,a,b,0,0,K,sigma,0);
            
            con_f_am_max(a_i,k_i)=cubic_map(fmax,a,b,0,0,K,sigma,0);


            fmin=-fmax;
            con_f_am_min(a_i,k_i)=-fmin;

            
            
            %K=0;
            for i=1:1:5000
                z(i+1)=cubic_map(z(i),a,b,A,omega,K,sigma,i);
                input_signal(i)=A*sin(omega*i);
                
                if z(i)>0
                    Z(i)=1;
                else
                    Z(i)=-1;
                end
                
            end
            
            
            for shift_i=1:1:1500
                R=corrcoef(circshift(Z(100:5000),shift_i), ...
                           input_signal(100:5000));
                R_s(shift_i)=abs(R(1,2));
            end
            
            max(R_s)
            corr(trial_i,a_i,k_i)=max(R_s);
            clear z Z;
        end    
    end
end
%}
load('results_evaluate_signal_res_n.mat');

smooth_w=10;

corr_m(1,:)=smooth(mean(corr(:,1,:),1),smooth_w);
corr_m(2,:)=smooth(mean(corr(:,2,:),1),smooth_w);
corr_m(3,:)=smooth(mean(corr(:,3,:),1),smooth_w);

corr_std(1,:)=smooth(std(corr(:,1,:)),smooth_w);
corr_std(2,:)=smooth(std(corr(:,2,:)),smooth_w);
corr_std(3,:)=smooth(std(corr(:,3,:)),smooth_w);


K_conf1=[K_v K_v(end:-1:1)];
corr_conf1=[corr_m(1,:)+corr_std(1,:) corr_m(1,end:-1:1)-corr_std(1,end:-1:1)]

K_conf2=[K_v K_v(end:-1:1)];
corr_conf2=[corr_m(2,:)+corr_std(2,:) corr_m(2,end:-1:1)-corr_std(2,end:-1:1)]

K_conf3=[K_v K_v(end:-1:1)];
corr_conf3=[corr_m(3,:)+corr_std(3,:) corr_m(3,end:-1:1)-corr_std(3,end:-1:1)]

set(0,'defaultAxesFontSize',18);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',18);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])

hold on;
plot(K_v,corr_m(1,:),'blue','LineWidth',2);
plot(K_v,corr_m(2,:),'red','LineWidth',2);
plot(K_v,corr_m(3,:),'green','LineWidth',2);

ylim([0 1.0]);
xlabel('RRO feedback strength K');
ylabel('max_\tau C( \tau)');


%{
fi_1=fill(K_conf1,corr_conf1,'blue');
fi_2=fill(K_conf2,corr_conf2,'red');
fi_3=fill(K_conf3,corr_conf3,'green');

fi_1.FaceColor = [0.8 0.8 1];       % make the filled area  blue
fi_1.EdgeColor = 'none';            % remove the line around the filled area
fi_1.FaceAlpha = 0.5;

fi_2.FaceColor = [1.0 0.8 0.8];       % make the filled area  blue
fi_2.EdgeColor = 'none';            % remove the line around the filled area
fi_2.FaceAlpha = 0.5;

fi_3.FaceColor = [0.8 1.0 0.8];       % make the filled area  blue
fi_3.EdgeColor = 'none';            % remove the line around the filled area
fi_3.FaceAlpha = 0.5;
%}
grid on;

legend('a=2.82','a=2.825','a=2.83','Location','southeast');

xticks(-0.05:0.01:0);

saveas(gca,'corr_n.eps','epsc');






set(0,'defaultAxesFontSize',18);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',18);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])


smooth_w=10;

corr_m(1,:)=smooth(mean(corr(:,1,:),1),smooth_w);
corr_m(2,:)=smooth(mean(corr(:,2,:),1),smooth_w);
corr_m(3,:)=smooth(mean(corr(:,3,:),1),smooth_w);

corr_std(1,:)=smooth(std(corr(:,1,:)),smooth_w);
corr_std(2,:)=smooth(std(corr(:,2,:)),smooth_w);
corr_std(3,:)=smooth(std(corr(:,3,:)),smooth_w);



subplot(2,1,1);


K_conf1=[con_f_am_max(1,:) con_f_am_max(1,end:-1:1)];
corr_conf1=[corr_m(1,:)+corr_std(1,:) corr_m(1,end:-1:1)-corr_std(1,end:-1:1)]

K_conf2=[con_f_am_max(2,:) con_f_am_max(2,end:-1:1)];
corr_conf2=[corr_m(2,:)+corr_std(2,:) corr_m(2,end:-1:1)-corr_std(2,end:-1:1)]

K_conf3=[con_f_am_max(3,:) con_f_am_max(3,end:-1:1)];
corr_conf3=[corr_m(3,:)+corr_std(3,:) corr_m(3,end:-1:1)-corr_std(3,end:-1:1)]







plot(con_f_am_max(1,:),corr_m(1,:),'blue','LineWidth',2);
hold on;
plot(con_f_am_max(2,:),corr_m(2,:),'red','LineWidth',2);
plot(con_f_am_max(3,:),corr_m(3,:),'green','LineWidth',2);
grid on;
ylim([0 1.0]);
xlabel('F(f_{max})+Ku(f_{max})');
ylabel('max_\tau C( \tau)');



fi_1=fill(K_conf1,corr_conf1,'blue');
fi_2=fill(K_conf2,corr_conf2,'red');
fi_3=fill(K_conf3,corr_conf3,'green');

fi_1.FaceColor = [0.8 0.8 1];       % make the filled area  blue
fi_1.EdgeColor = 'none';            % remove the line around the filled area
fi_1.FaceAlpha = 0.5;

fi_2.FaceColor = [1.0 0.8 0.8];       % make the filled area  blue
fi_2.EdgeColor = 'none';            % remove the line around the filled area
fi_2.FaceAlpha = 0.5;

fi_3.FaceColor = [0.8 1.0 0.8];       % make the filled area  blue
fi_3.EdgeColor = 'none';            % remove the line around the filled area
fi_3.FaceAlpha = 0.5;




legend('a=2.82','a=2.825','a=2.83','Location','Northeast');

subplot(2,1,2);

K_conf1=[con_f_am_min(1,:) con_f_am_min(1,end:-1:1)];
corr_conf1=[corr_m(1,:)+corr_std(1,:) corr_m(1,end:-1:1)-corr_std(1,end:-1:1)]

K_conf2=[con_f_am_min(2,:) con_f_am_min(2,end:-1:1)];
corr_conf2=[corr_m(2,:)+corr_std(2,:) corr_m(2,end:-1:1)-corr_std(2,end:-1:1)]

K_conf3=[con_f_am_min(3,:) con_f_am_min(3,end:-1:1)];
corr_conf3=[corr_m(3,:)+corr_std(3,:) corr_m(3,end:-1:1)-corr_std(3,end:-1:1)]







plot(con_f_am_min(1,:),corr_m(1,:),'blue','LineWidth',2);
hold on;
plot(con_f_am_min(2,:),corr_m(2,:),'red','LineWidth',2);
plot(con_f_am_min(3,:),corr_m(3,:),'green','LineWidth',2);
grid on;
ylim([0 1.0]);
xlabel('F(f_{min})+Ku(f_{min})');
ylabel('max_\tau C( \tau)');



fi_1=fill(K_conf1,corr_conf1,'blue');
fi_2=fill(K_conf2,corr_conf2,'red');
fi_3=fill(K_conf3,corr_conf3,'green');

fi_1.FaceColor = [0.8 0.8 1];       % make the filled area  blue
fi_1.EdgeColor = 'none';            % remove the line around the filled area
fi_1.FaceAlpha = 0.5;

fi_2.FaceColor = [1.0 0.8 0.8];       % make the filled area  blue
fi_2.EdgeColor = 'none';            % remove the line around the filled area
fi_2.FaceAlpha = 0.5;

fi_3.FaceColor = [0.8 1.0 0.8];       % make the filled area  blue
fi_3.EdgeColor = 'none';            % remove the line around the filled area
fi_3.FaceAlpha = 0.5;



legend('a=2.82','a=2.825','a=2.83','Location','Northeast');








saveas(gca,'corr_am_n.eps','epsc');

save('results_evaluate_signal_res_n.mat');