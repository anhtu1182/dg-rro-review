

a=5.96;
b=3.42;
k=1.3811;

sigma=1/a;

A=0.02;
%A=0.1;
omega=1/1000;
rng(1);

z_K0(1)=0.15;
for i=1:1:10000
    z_K0(i+1)=func_cnn_noise(z_K0(i),a,b,k,0.0,sigma,A,omega,i,0);
end

z_K001(1)=0.15;
for i=1:1:10000
    z_K001(i+1)=func_cnn_noise(z_K001(i),a,b,k,0.0,sigma,A,omega,i,1.5e-3);
end

z_K005(1)=0.15;
for i=1:1:10000
    z_K005(i+1)=func_cnn_noise(z_K005(i),a,b,k,0.0,sigma,A,omega,i,4e-3);
end

z_K01(1)=0.15;
for i=1:1:10000
    z_K01(i+1)=func_cnn_noise(z_K01(i),a,b,k,0.0,sigma,A,omega,i,2e-2);
end

set(0,'defaultAxesFontSize',18);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',18);
set(0,'defaultTextFontName','Times');


subplot(2,2,1);
plot(z_K0,'k');
hold on;
plot(0.2*sin(2.*pi*omega*(1:1:10000)),'r','Linewidth',1);
grid on;
ylim([-0.3 0.3]);
xlim([0 10000]);
ylabel('z(t)');
title('D=0.0');

subplot(2,2,2);
plot(z_K001,'k');
hold on;
plot(0.2*sin(2.*pi*omega*(1:1:10000)),'r','Linewidth',1);
grid on;
ylim([-0.3 0.3]);
xlim([0 10000]);
ylabel('z(t)');
title('D=1.5\times10^{-3}');

subplot(2,2,3);
plot(z_K005,'k');
hold on;
plot(0.2*sin(2.*pi*omega*(1:1:10000)),'r','Linewidth',1);
grid on;

ylim([-0.3 0.3]);
xlim([0 10000]);
ylabel('z(t)');
xlabel('t');
title('D= 4.0\times10^{-3}');


subplot(2,2,4);
plot(z_K01,'k');
hold on;
plot(0.2*sin(2.*pi*omega*(1:1:10000)),'r','Linewidth',1);
grid on;

ylim([-0.3 0.3]);
xlim([0 10000]);
ylabel('z(t)');
xlabel('t');
title('D=2.0\times10^{-2}');


saveas(gca,'time_series_D_signal_noise.eps','epsc');