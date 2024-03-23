% 
% 
% a=2.83;
% b=10.;
% k=1.3811;

x_lim=5;

A=12;
sigma=1;
As=0;
Omega=0.005;
K=0.7;
% K=1.0;
D=0.03;

set(0,'defaultAxesFontSize',40);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',40);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off','WindowState', 'maximized');

for i=1:1:1000
    step=0.01;
    x(i)=-5.0+i*step;

%     zout(i)=cubic_map(z(i_z),a,b,0,0,0,sigma,i_z);
    xout(i)=baghdadi_map_func(x(i),A,1,0,sigma,As,Omega,i);

%     zout_K(i)=cubic_map(z(i_z),a,b,0,0,-0.3,sigma,i_z);
    xout_K(i)=baghdadi_map_func(x(i),A,1,K,sigma,As,Omega,i);
    
%     zout_n(i)=cubic_map(z(i_z),a,b,0,0,0,sigma,i_z)+D*normrnd(0,1.0);
    
    %z_a(i_z)=func_a(z(i_z),a);
    %z_b(i_z)=func_a(z(i_z),b);
    
end


% f=@(x)cubic_map(x,a,b,0,0,0,sigma,1);
f=@(x)baghdadi_map_func(x,A,1,0,sigma,As,Omega,1);
f_min=fminbnd(f,-3,0);
f_max=-f_min;

% ff_min=cubic_map(f_min,a,b,0,0,0,sigma,1);
% fff_min=cubic_map(ff_min,a,b,0,0,0,sigma,1);
% ff_max=cubic_map(f_max,a,b,0,0,0,sigma,1);
% fff_max=cubic_map(ff_max,a,b,0,0,0,sigma,1);

ff_min=baghdadi_map_func(f_min,A,1,0,sigma,As,Omega,1);
fff_min=baghdadi_map_func(ff_min,A,1,0,sigma,As,Omega,1);
ff_max=baghdadi_map_func(f_max,A,1,0,sigma,As,Omega,1);
fff_max=baghdadi_map_func(ff_max,A,1,0,sigma,As,Omega,1);

% f=@(x)cubic_map(x,a,b,0,0,-0.3,sigma,1);
f=@(x)baghdadi_map_func(x,A,1,K,sigma,As,Omega,1);
fk_min=fminbnd(f,-3,0);
fk_max=-f_min;

% ffk_min=cubic_map(fk_min,a,b,0,0,-0.3,sigma,1);
% fffk_min=cubic_map(ffk_min,a,b,0,0,-0.3,sigma,1);
% ffk_max=cubic_map(fk_max,a,b,0,0,-0.3,sigma,1);
% fffk_max=cubic_map(ffk_max,a,b,0,0,-0.3,sigma,1);

ffk_min=baghdadi_map_func(fk_min,A,1,K,sigma,As,Omega,1);
fffk_min=baghdadi_map_func(ffk_min,A,1,K,sigma,As,Omega,1);
ffk_max=baghdadi_map_func(fk_max,A,1,K,sigma,As,Omega,1);
fffk_max=baghdadi_map_func(ffk_max,A,1,K,sigma,As,Omega,1);


x0=0.15;
count=1;
for i=1:1:1000
    
%     x0=cubic_map(x0,a,b,0,0,0,sigma,1);
    x0=baghdadi_map_func(x0,A,1,0,sigma,As,Omega,1);
    
    if i>100
        x_orbit_x(count)=x0;
        x_orbit_y(count)=x0;
        count=count+1;
        x_orbit_x(count)=x0;
%         x_orbit_y(count)=cubic_map(x0,a,b,0,0,0,sigma,1);
        x_orbit_y(count)=baghdadi_map_func(x0,A,1,0,sigma,As,Omega,1);
        count=count+1;
    end
    
end

x0=0.15;
count=1;
for i=1:1:1000
    
%     x0=cubic_map(x0,a,b,0,0,-0.3,sigma,1);
    x0=baghdadi_map_func(x0,A,1,K,sigma,As,Omega,1);
    
    if i>100
        xk_orbit_x(count)=x0;
        xk_orbit_y(count)=x0;
        count=count+1;
        xk_orbit_x(count)=x0;
%         xk_orbit_y(count)=cubic_map(x0,a,b,0,0,-0.3,sigma,1);
        xk_orbit_y(count)=baghdadi_map_func(x0,A,1,K,sigma,As,Omega,1);
        count=count+1;

    end
    
end

% x0=0.2;
% count=1;
% for i=1:1:1000
%     
%     x0=cubic_map(x0,a,b,0,0,0,sigma,1)+D*normrnd(0,1.0);
%     
%     if i>100
%         zn_orbit_x(count)=x0;
%         zn_orbit_y(count)=x0;
%         count=count+1;
%         zn_orbit_x(count)=x0;
%         zn_orbit_y(count)=cubic_map(x0,a,b,0,0,0,sigma,1)+D*normrnd(0,1.0);
%         count=count+1;
% 
%     end
%     
% end

subplot(1,2,1);
plot(x_orbit_x,x_orbit_y,'k');
hold on;
plot(x,xout,'b','LineWidth',2);

xticks(-4:2:4);
yticks(-4:2:4);
xlim([-x_lim x_lim]);
ylim([-x_lim x_lim]);


ylabel('\it x(t+1)');
xlabel('\it x(t)');
plot(-5.0:0.01:5.0,-5.0:0.01:5.0,'.k');

legend('orbit','map function','Location','Southeast','AutoUpdate','off','FontSize',20);

grid on;
pbaspect([1 1 1]);

title('Case without feedback','FontSize',35);

text(fk_max-0.6,ffk_max+1.1,'\it f_{\rm max}');
text(fk_min-0.6,ffk_min-1.1,'\it f_{\rm min}');


plot(ff_max,fff_max,'ro','MarkerSize',10);
plot(ff_min,fff_min,'go','MarkerSize',10);


subplot(1,2,2);
plot(xk_orbit_x,xk_orbit_y,'k');
hold on;
plot(x,xout_K,'b','LineWidth',3);

plot(x,xout,'-.r','LineWidth',1.5);

xticks(-4:2:4);
yticks(-4:2:4);
xlim([-x_lim x_lim]);
ylim([-x_lim x_lim]);


text(fk_max-0.6,ffk_max+1.1,'\it f_{\rm max}');
text(fk_min+0.1,ffk_min+0.1,'\it f_{\rm min}');

plot(ffk_max,fffk_max,'ro','MarkerSize',10);
plot(ffk_min,fffk_min,'go','MarkerSize',10);
plot(-5.0:0.01:5.0,-5.0:0.01:5.0,'.k');


legend("orbit","map function (K="+num2str(K)+")",'map function (K=0)','Location','Southeast','FontSize',20);
% legend('orbit','map function with RRO feedback signal','map function without RRO feedback signal','Location','Southeast');

grid on;
pbaspect([1 1 1]);

ylabel('\it x(t+1)');
xlabel('\it x(t)');
title("Case with feedback (K="+num2str(K)+")",'FontSize',35);

% 
% sgt = sgtitle("A = " +num2str(A));
% sgt.FontSize = 25;

exportgraphics(f1,".\Results2\WithoutRRO\MapFunctionProfile_A_"+num2str(A)+"WithNWithoutRRO.png",'Resolution',400,"Append",false)

% suptitle()
% subplot(1,3,3);
% 
% plot(xk_orbit_x,xk_orbit_y,'k');
% hold on;
% plot(x,xout_K,'b','LineWidth',3);
% 
% plot(x,xout,'-.r','LineWidth',1.5);
% 
% %xticks([-5.0:0.5:5.0]);
% %yticks([-5.0:0.5:5.0]);
% %xlim([-5.0 5.0]);
% %ylim([-5.0 5.0]);
% 
% xlim([0.6 1.4]);
% ylim([2.8 3.3]);
% 
% 
% %text(fk_max+0.2,ffk_max+0.3,'\it f_{\rm max}');
% %text(fk_min-0.3,ffk_min-0.3,'\it f_{\rm min}');
% 
% plot(ffk_max,fffk_max,'ro','MarkerSize',10);
% plot(ffk_min,fffk_min,'go','MarkerSize',10);
% plot(-5.0:0.01:5.0,-5.0:0.01:5.0,'.k');
% 
% 
% legend('orbit','map function with RRO feedback signal','map function without RRO feedback signal','Location','Southeast');
% 
% grid on;
% pbaspect([1 1 1]);
% 
% ylabel('\it x(t+1)');
% xlabel('\it x(t)');


% -----------------------------------------------
% % %close all;
% % 
% set(0,'defaultAxesFontSize',20);
% set(0,'defaultAxesFontName','Arial');
% set(0,'defaultTextFontSize',20);
% set(0,'defaultTextFontName','Arial');
% set(gca,'color',[1 1 1])
% f1 = figure('NumberTitle','off');
% 
% subplot(1,2,1);
% 
% plot(x_orbit_x,'k','Linewidth',2);
% 
% hold on;
% 
% ylabel('\it x(t)');
% xlabel('\it t');
% 
% ylim([-3.5 3.5]);
% xticks([0  200  400 600 800])
% yticks([-3.5 -3 -2  -1 0 1 2 3 3.5])
% grid on;
% 
% pbaspect([2 1 1]);
% 
% subplot(1,2,2);
% 
% plot(xk_orbit_x,'k','Linewidth',2);
% 
% hold on;
% 
% ylabel('\it x(t)');
% xlabel('\it t');
% 
% ylim([-3.5 3.5]);
% xticks([0  200  400 600 800])
% yticks([-3.5 -3 -2  -1 0 1 2 3 3.5])
% grid on;
% 
% pbaspect([2 1 1])
% 
% %subplot(1,3,3);
% 
% %plot(zn_orbit_x,'k','Linewidth',2);
% 
% %hold on;
% 
% %ylabel('\it x(t)');
% %xlabel('\it t');
% 
% %ylim([-2 2]);
% %xticks([0  200  400 600 800])
% %yticks([-2  -1 0 1 2])
% %grid on;
% 
% %pbaspect([2 1 1])