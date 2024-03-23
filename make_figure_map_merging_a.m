% a=2.83;
% a_m=2.85;
% b=10.;
% k=1.3811;
% 
% sigma=0.6;
% K=0.;
% D=0.03;
clear all;

x_lim=5;

AHC=13;
ABD1=9.8;
ABD2=12;

sigma=1;
As=0;
Omega=0.005;
K=0.3;
D=0.03;


set(0,'defaultAxesFontSize',40);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',40);
set(0,'defaultTextFontName','Arial');
set(gca,'color',[1 1 1])
f1 = figure('NumberTitle','off','WindowState', 'maximized');

for i=1:1:x_lim*200
    step=0.01;
    x(i)=-x_lim+i*step;
   
%     zout(i_z)=cubic_map(z(i_z),a,b,0,0,0,sigma,i_z);
%     zout_K(i_z)=cubic_map(z(i_z),a_m,b,0,0,0.,sigma,i_z);
        
    xout(i)=baghdadi_map_func(x(i),AHC,1,0,sigma,As,Omega,i);
    xout_K1(i)=baghdadi_map_func(x(i),ABD1,1,0,sigma,As,Omega,i);
    xout_K2(i)=baghdadi_map_func(x(i),ABD2,1,0,sigma,As,Omega,i);
    
end


% f=@(x)cubic_map(x,a,b,0,0,0,sigma,1);
f=@(x)baghdadi_map_func(x,AHC,1,0,sigma,As,Omega,1);
f_min=fminbnd(f,-2,0);
f_max=-f_min;

% ff_min=cubic_map(f_min,a,b,0,0,0,sigma,1);
% fff_min=cubic_map(ff_min,a,b,0,0,0,sigma,1);
% ff_max=cubic_map(f_max,a,b,0,0,0,sigma,1);
% fff_max=cubic_map(ff_max,a,b,0,0,0,sigma,1);

ff_min=baghdadi_map_func(f_min,AHC,1,0,sigma,As,Omega,1);
fff_min=baghdadi_map_func(ff_min,AHC,1,0,sigma,As,Omega,1);
ff_max=baghdadi_map_func(f_max,AHC,1,0,sigma,As,Omega,1);
fff_max=baghdadi_map_func(ff_max,AHC,1,0,sigma,As,Omega,1);

% f=@(x)cubic_map(x,a_m,b,0,0,0.,sigma,1);
f=@(x)baghdadi_map_func(x,ABD1,1,0,sigma,As,Omega,1);
fk1_min=fminbnd(f,-2,0);
fk1_max=-f_min;
% 
% ffk1_min=cubic_map(fk1_min,a_m,b,0,0,0.,sigma,1);
% ffk1_max=cubic_map(fk2_max,a_m,b,0,0,0.,sigma,1);
% fffk1_min=cubic_map(ffk1_min,a_m,b,0,0,0.,sigma,1);
% fffk1_max=cubic_map(ffk1_max,a_m,b,0,0,0.,sigma,1);

ffk1_min=baghdadi_map_func(fk1_min,ABD1,1,0,sigma,As,Omega,1);
fffk1_min=baghdadi_map_func(ffk1_min,ABD1,1,0,sigma,As,Omega,1);
ffk1_max=baghdadi_map_func(fk1_max,ABD1,1,0,sigma,As,Omega,1);
fffk1_max=baghdadi_map_func(ffk1_max,ABD1,1,0,sigma,As,Omega,1);

f=@(x)baghdadi_map_func(x,ABD2,1,0,sigma,As,Omega,1);
fk2_min=fminbnd(f,-2,0);
fk2_max=-f_min;


ffk2_min=baghdadi_map_func(fk2_min,ABD2,1,0,sigma,As,Omega,1);
fffk2_min=baghdadi_map_func(ffk2_min,ABD2,1,0,sigma,As,Omega,1);
ffk2_max=baghdadi_map_func(fk2_max,ABD2,1,0,sigma,As,Omega,1);
fffk2_max=baghdadi_map_func(ffk2_max,ABD2,1,0,sigma,As,Omega,1);


x0=0.2;
count=1;
for i=1:1:x_lim*200
    
%     x0=cubic_map(x0,a,b,0,0,0,sigma,1);
    x0=baghdadi_map_func(x0,AHC,1,0,sigma,As,Omega,1);
    
    if i>100
        x_orbit_x(count)=x0;
        x_orbit_y(count)=x0;
        count=count+1;
        x_orbit_x(count)=x0;
        x_orbit_y(count)=baghdadi_map_func(x0,AHC,1,0,sigma,As,Omega,1);
        count=count+1;
    end
   
end

x0=0.2;
count=1;
for i=1:1:x_lim*200
    
%     x0=cubic_map(x0,a_m,b,0,0,0.,sigma,1);
    x0=baghdadi_map_func(x0,ABD1,1,0,sigma,As,Omega,1);
    
    if i>100
        xk1_orbit_x(count)=x0;
        xk1_orbit_y(count)=x0;
        count=count+1;
        xk1_orbit_x(count)=x0;
        xk1_orbit_y(count)=baghdadi_map_func(x0,ABD1,1,0,sigma,As,Omega,1);
        count=count+1;
    end
    
end

x0=0.2;
count=1;
for i=1:1:x_lim*200
    
%     x0=cubic_map(x0,a_m,b,0,0,0.,sigma,1);
    x0=baghdadi_map_func(x0,ABD2,1,0,sigma,As,Omega,1);
    
    if i>100
        xk2_orbit_x(count)=x0;
        xk2_orbit_y(count)=x0;
        count=count+1;
        xk2_orbit_x(count)=x0;
        xk2_orbit_y(count)=baghdadi_map_func(x0,ABD2,1,0,sigma,As,Omega,1);
        count=count+1;
    end
    
end




subplot(1,2,1);
% fig = figure('NumberTitle','off','WindowState', 'maximized');
plot(x_orbit_x,x_orbit_y,'k');
hold on;
plot(x,xout,'b','LineWidth',2);

xticks(-4:2:4);
yticks(-4:2:4);
xlim([-x_lim x_lim]);
ylim([-x_lim x_lim]);

ylabel('\it x(n+1)');
xlabel('\it x(n)');
plot(-x_lim:0.01:x_lim,-x_lim:0.01:x_lim,'.k');

legend('orbit','map function','Location','Southeast','AutoUpdate','off','FontSize',25);
grid on;
pbaspect([1 1 1]);

title("HC case (A="+num2str(AHC)+")",'FontSize',35);

text(f_max-0.5,ff_max+0.8,'\it f_{\rm max}');
text(f_min-1.5,ff_min-0.8,'\it f_{\rm min}');


plot(ff_max,fff_max,'ro','MarkerSize',10);
plot(ff_min,fff_min,'go','MarkerSize',10);

% exportgraphics(fig,".\Results2\WithoutRRO\MapFunction_HC_ProfileWithoutRRO.png",'Resolution',1000,"Append",false)
% close(fig);

% 
% % subplot(1,2,1);
% fig = figure('NumberTitle','off','WindowState', 'maximized');
% plot(xk1_orbit_x,xk1_orbit_y,'k');
% hold on;
% plot(x,xout_K1,'b','LineWidth',3);
% 
% % plot(x,xout,'-.r','LineWidth',1.5);
% 
% xticks(-4:2:4);
% yticks(-4:2:4);
% xlim([-x_lim x_lim]);
% ylim([-x_lim x_lim]);
% 
% 
% text(fk1_max-0.5,ffk1_max+0.8,'\it f_{\rm max}');
% text(fk1_min-1.5,ffk1_min-0.8,'\it f_{\rm min}');
% 
% plot(ffk1_max,fffk1_max,'ro','MarkerSize',10);
% plot(ffk1_min,fffk1_min,'go','MarkerSize',10);
% plot(-x_lim:0.01:x_lim,-x_lim:0.01:x_lim,'.k');
% 
% 
% % legend('orbit','map function (a=2.85)','map function (a=2.83)','Location','Southeast');
% legend('orbit','map function','Location','Southeast','FontSize',25);
% 
% grid on;
% pbaspect([1 1 1]);
% 
% ylabel('\it x(n+1)');
% xlabel('\it x(n)');
% title("BD case (A="+num2str(ABD1)+")",'FontSize',35);
% exportgraphics(fig,".\Results2\WithoutRRO\MapFunction_BD98_ProfileWithoutRRO.png",'Resolution',1000,"Append",false)
% close(fig);

% 

subplot(1,2,2);
% fig = figure('NumberTitle','off','WindowState', 'maximized');

plot(xk2_orbit_x,xk2_orbit_y,'k');
hold on;
plot(x,xout_K2,'b','LineWidth',3);

% plot(x,xout,'-.r','LineWidth',1.5);

xticks(-4:2:4);
yticks(-4:2:4);
xlim([-x_lim x_lim]);
ylim([-x_lim x_lim]);


text(fk2_max-0.5,ffk2_max+0.8,'\it f_{\rm max}');
text(fk2_min-1.5,ffk2_min-0.8,'\it f_{\rm min}');

plot(ffk2_max,fffk2_max,'ro','MarkerSize',10);
plot(ffk2_min,fffk2_min,'go','MarkerSize',10);
plot(-x_lim:0.01:x_lim,-x_lim:0.01:x_lim,'.k');


% legend('orbit','map function (a=2.85)','map function (a=2.83)','Location','Southeast');
legend('orbit','map function','Location','Southeast','FontSize',25);

grid on;
pbaspect([1 1 1]);

ylabel('\it x(n+1)');
xlabel('\it x(n)');
title("Disturbance case (A="+num2str(ABD2)+")",'FontSize',35);

% exportgraphics(fig,".\Results2\WithoutRRO\MapFunction_BD12_ProfileWithoutRRO.png",'Resolution',1000,"Append",false)
% close(fig);

% pause(5);

exportgraphics(f1,".\Results2\WithoutRRO\MapFunctionProfileWithoutRRO.png",'Resolution',1000,"Append",false)
close(f1);

% % plot(xk1_orbit_x,xk1_orbit_y,'k');
% % hold on;
% % plot(z,zout_K,'b','LineWidth',3);
% % 
% % plot(z,zout,'-.r','LineWidth',1.5);
% % 
% % %xticks([0.5:0.5:2.5]);
% % %yticks([0.5:0.5:2.5]);
% % xlim([0.8 1.2]);
% % ylim([1.4 1.8]);
% % 
% % 
% % %text(fk_max+0.2,ffk_max+0.3,'\it f_{\rm max}');
% % %text(fk_min-0.3,ffk_min-0.3,'\it f_{\rm min}');
% % 
% % plot(ffk1_max,fffk1_max,'ro','MarkerSize',10);
% % plot(ffk1_min,fffk1_min,'go','MarkerSize',10);
% % plot(-2.5:0.01:2.5,-2.5:0.01:2.5,'.k');
% % 
% % 
% % legend('orbit','map function (a=2.85)','map function (a=2.83)','Location','Southeast');
% % 
% % grid on;
% % pbaspect([1 1 1]);
% % 
% % ylabel('\it x(t+1)');
% % xlabel('\it x(t)');


% --------------------------------------------


% set(0,'defaultAxesFontSize',20);
% set(0,'defaultAxesFontName','Arial');
% set(0,'defaultTextFontSize',20);
% set(0,'defaultTextFontName','Arial');
% set(gca,'color',[1 1 1])
% f1 = figure('NumberTitle','off','WindowState', 'maximized');
% 
% subplot(1,3,1);
% 
% plot(x_orbit_x(1:120),'k','Linewidth',2);
% 
% hold on;
% 
% ylabel('\it x(t)');
% xlabel('\it t');
% 
% ylim([-5 5]);
% xticks([0  20  40 60 80 100])
% yticks([-5 -4 -3  -2  -1 0 1 2 3 4 5])
% grid on;
% 
% pbaspect([1 1 1]);
% 
% subplot(1,3,2);
% 
% plot(xk1_orbit_x(1:120),'k','Linewidth',2);
% 
% hold on;
% 
% ylabel('\it x(t)');
% xlabel('\it t');
% 
% ylim([-5 5]);
% xticks([0  20  40 60 80 100])
% yticks([-5 -4 -3  -2  -1 0 1 2 3 4 5])
% grid on;
% 
% pbaspect([1 1 1])
% 
% subplot(1,3,3);
% 
% plot(xk2_orbit_x(1:120),'k','Linewidth',2);
% 
% hold on;
% 
% ylabel('\it x(t)');
% xlabel('\it t');
% 
% ylim([-5 5]);
% xticks([0  20  40 60 80 100])
% yticks([-5 -4 -3  -2  -1 0 1 2 3 4 5])
% grid on;
% 
% pbaspect([1 1 1])


