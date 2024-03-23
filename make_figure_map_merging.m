

a=2.83;
b=10.;
k=1.3811;

sigma=0.6;
K=0.;
D=0.03;

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');

for i_z=1:1:500
    dz=0.01;
    z(i_z)=-2.5+i_z*dz;
   
    %zout(i_z)=func_cnn(z(i_z),a,b,k,0,sigma,0,0,0);
    %zout_K(i_z)=func_cnn(z(i_z),a,b,k,-0.1,sigma,0,0,0);

    zout(i_z)=cubic_map(z(i_z),a,b,0,0,0,sigma,i_z);
    zout_K(i_z)=cubic_map(z(i_z),a,b,0,0,-0.3,sigma,i_z);
    
%     zout_n(i_z)=cubic_map(z(i_z),a,b,0,0,0,sigma,i_z)+D*normrnd(0,1.0);
    
    %z_a(i_z)=func_a(z(i_z),a);
    %z_b(i_z)=func_a(z(i_z),b);
    
end


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

z_o=0.2;
count=1;
for i=1:1:500
    
    z_o=cubic_map(z_o,a,b,0,0,0,sigma,1);
    
    if i>100
        z_orbit_x(count)=z_o;
        z_orbit_y(count)=z_o;
        count=count+1;
        z_orbit_x(count)=z_o;
        z_orbit_y(count)=cubic_map(z_o,a,b,0,0,0,sigma,1);
        count=count+1;

    end
    
end

z_o=0.2;
count=1;
for i=1:1:500
    
    z_o=cubic_map(z_o,a,b,0,0,-0.3,sigma,1);
    
    if i>100
        zk_orbit_x(count)=z_o;
        zk_orbit_y(count)=z_o;
        count=count+1;
        zk_orbit_x(count)=z_o;
        zk_orbit_y(count)=cubic_map(z_o,a,b,0,0,-0.3,sigma,1);
        count=count+1;

    end
    
end

z_o=0.2;
count=1;
for i=1:1:500
    
    z_o=cubic_map(z_o,a,b,0,0,0,sigma,1)+D*normrnd(0,1.0);
    
    if i>100
        zn_orbit_x(count)=z_o;
        zn_orbit_y(count)=z_o;
        count=count+1;
        zn_orbit_x(count)=z_o;
        zn_orbit_y(count)=cubic_map(z_o,a,b,0,0,0,sigma,1)+D*normrnd(0,1.0);
        count=count+1;

    end
    
end



subplot(1,3,1);
plot(z_orbit_x,z_orbit_y,'k');
hold on;
plot(z,zout,'b','LineWidth',2);

xticks([-2.5:0.5:2.5]);
yticks([-2.5:0.5:2.5]);
xlim([-2.5 2.5]);
ylim([-2.5 2.5]);

ylabel('\it x(t+1)');
xlabel('\it x(t)');
plot(-2.5:0.01:2.5,-2.5:0.01:2.5,'.k');

grid on;
pbaspect([1 1 1]);

title('Case without feedback');

text(fk_max+0.1,ffk_max+0.2,'\it f_{\rm max}');
text(fk_min-0.2,ffk_min-0.2,'\it f_{\rm min}');


plot(ff_max,fff_max,'ro','MarkerSize',10);
plot(ff_min,fff_min,'go','MarkerSize',10);


subplot(1,3,2);
plot(zk_orbit_x,zk_orbit_y,'k');
hold on;
plot(z,zout_K,'b','LineWidth',3);

plot(z,zout,'-.r','LineWidth',1.5);

xticks([-2.5:0.5:2.5]);
yticks([-2.5:0.5:2.5]);
xlim([-2.5 2.5]);
ylim([-2.5 2.5]);


text(fk_max+0.2,ffk_max+0.3,'\it f_{\rm max}');
text(fk_min-0.3,ffk_min-0.3,'\it f_{\rm min}');

plot(ffk_max,fffk_max,'ro','MarkerSize',10);
plot(ffk_min,fffk_min,'go','MarkerSize',10);
plot(-2.5:0.01:2.5,-2.5:0.01:2.5,'.k');


%legend('orbit','map function (K=-0.3)','map function (K=0)','Location','Southeast');
legend('orbit','map function with RRO feedback signal','map function without RRO feedback signal','Location','Southeast');

grid on;
pbaspect([1 1 1]);

ylabel('\it x(t+1)');
xlabel('\it x(t)');
title('Case with feedback');




subplot(1,3,3);

plot(zk_orbit_x,zk_orbit_y,'k');
hold on;
plot(z,zout_K,'b','LineWidth',3);

plot(z,zout,'-.r','LineWidth',1.5);

%xticks([-2.5:0.5:2.5]);
%yticks([-2.5:0.5:2.5]);
%xlim([-2.5 2.5]);
%ylim([-2.5 2.5]);

xlim([0.8 1.2]);
ylim([1.4 1.8]);


%text(fk_max+0.2,ffk_max+0.3,'\it f_{\rm max}');
%text(fk_min-0.3,ffk_min-0.3,'\it f_{\rm min}');

plot(ffk_max,fffk_max,'ro','MarkerSize',10);
plot(ffk_min,fffk_min,'go','MarkerSize',10);
plot(-2.5:0.01:2.5,-2.5:0.01:2.5,'.k');


legend('orbit','map function with RRO feedback signal','map function without RRO feedback signal','Location','Southeast');

grid on;
pbaspect([1 1 1]);

ylabel('\it x(t+1)');
xlabel('\it x(t)');

%close all;

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');

subplot(1,2,1);

plot(z_orbit_x,'k','Linewidth',2);

hold on;

ylabel('\it x(t)');
xlabel('\it t');

ylim([-2 2]);
xticks([0  200  400 600 800])
yticks([-2  -1 0 1 2])
grid on;

pbaspect([2 1 1]);

subplot(1,2,2);

plot(zk_orbit_x,'k','Linewidth',2);

hold on;

ylabel('\it x(t)');
xlabel('\it t');

ylim([-2 2]);
xticks([0  200  400 600 800])
yticks([-2  -1 0 1 2])
grid on;

pbaspect([2 1 1])

%subplot(1,3,3);

%plot(zn_orbit_x,'k','Linewidth',2);

%hold on;

%ylabel('\it x(t)');
%xlabel('\it t');

%ylim([-2 2]);
%xticks([0  200  400 600 800])
%yticks([-2  -1 0 1 2])
%grid on;

%pbaspect([2 1 1])