

a=5.96;
b=3.42;
k=1.3811;

sigma=1/a;
K=0.;

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Times');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Times');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off');

for i_z=1:1:1000
    dz=0.001;
    z(i_z)=-0.5+i_z*dz;
   
    zout(i_z)=func_cnn(z(i_z),a,b,k,0,sigma,0,0,0);
    zout_K(i_z)=func_cnn(z(i_z),a,b,k,0,sigma,0,0,0);
    
    %z_a(i_z)=func_a(z(i_z),a);
    %z_b(i_z)=func_a(z(i_z),b);
    
end

z_fmax=func_cnn(1/a,a,b,k,0,sigma,0,0,0);
z_ffmax=func_cnn(z_fmax,a,b,k,0,sigma,0,0,0);
zk_fmax=func_cnn(1/a,a,b,k,0,sigma,0,0,0);
zk_ffmax=func_cnn(zk_fmax,a,b,k,0,sigma,0,0,0);

z_o=0.2;
count=1;
for i=1:1:500
    
    z_o=func_cnn(z_o,a,b,k,0,sigma,0,0,0);
    
    if i>100
        z_orbit_x(count)=z_o;
        z_orbit_y(count)=z_o;
        count=count+1;
        z_orbit_x(count)=z_o;
        z_orbit_y(count)=func_cnn(z_o,a,b,k,0,sigma,0,0,0);
        count=count+1;

    end
    
end

z_o=0.2;
count=1;
D=0.01;
for i=1:1:500
    
    z_o=func_cnn_noise(z_o,a,b,k,0,sigma,0,0,0,D);
    
    if i>100
        zk_orbit_x(count)=z_o;
        zk_orbit_y(count)=z_o;
        count=count+1;
        zk_orbit_x(count)=z_o;
        zk_orbit_y(count)=func_cnn_noise(z_o,a,b,k,0,sigma,0,0,0,D);;
        count=count+1;

    end
    
end




subplot(1,2,1);
plot(z_orbit_x,z_orbit_y,'k');
hold on;
plot(z,zout,'b','LineWidth',2);

xticks([-0.5:0.1:0.5]);
yticks([-0.5:0.1:0.5]);
xlim([-0.3 0.3]);
ylim([-0.3 0.3]);

ylabel('Effective neural potential z(t+1)');
xlabel('Effective neural potential z(t)');
plot(-0.3:0.01:0.3,-0.3:0.01:0.3,'.k');

grid on;
pbaspect([1 1 1]);

title('Noise strength D=0.0');
text(0.175,0.23,'f_{max}');
text(-0.175,-0.23,'f_{min}');

plot(z_fmax,z_ffmax,'ro','MarkerSize',10);
plot(-z_fmax,-z_ffmax,'go','MarkerSize',10);


subplot(1,2,2);
plot(zk_orbit_x,zk_orbit_y,'k');
hold on;
plot(z,zout_K,'b','LineWidth',2);

xticks([-0.5:0.1:0.5]);
yticks([-0.5:0.1:0.5]);
xlim([-0.3 0.3]);
ylim([-0.3 0.3]);



text(0.175,0.23,'f_{max}');
text(-0.175,-0.23,'f_{min}');


plot(zk_fmax,zk_ffmax,'ro','MarkerSize',10);
plot(-zk_fmax,-zk_ffmax,'go','MarkerSize',10);
plot(-0.3:0.01:0.3,-0.3:0.01:0.3,'.k');

grid on;
pbaspect([1 1 1]);

ylabel('Effective neural potential z(t+1)');
xlabel('Effective neural potential z(t)');
title('Noise strength D=0.01');

legend('orbit','map function');