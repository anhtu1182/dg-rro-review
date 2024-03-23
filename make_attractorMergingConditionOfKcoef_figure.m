clear;

N=400;
step=0.5/N;
K=0;
A=13;
As=0;
sigma=1;
Omega=0.005;
% omega1=0.2223; 
% omega2=1.487;
% B=5.82;

% Kcoef=0.847845790280530;
for i=0:N
    Kcoef(1,i+1)=(i+400)*step; 
    f=@(x) baghdadi_map_func(x,A,Kcoef(1,i+1),K,sigma,As,Omega,i);
    xmin(i+1)=fminbnd(f,-3,0);
    xmax(i+1)=-xmin(i+1);
    fmin(i+1)=f(xmin(i+1));
    fmax(i+1)=f(xmax(i+1));
    F_fmin(i+1)=f(fmin(i+1));
    F_fmax(i+1)=f(fmax(i+1));
end

f=figure('WindowState', 'maximized');
set(0,'defaultAxesFontSize',50);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',50);
set(0,'defaultTextFontName','Arial');

hold on;
grid on;

plot(Kcoef,F_fmin,'Linewidth',2);
plot(Kcoef,F_fmax,'Linewidth',2);
xmin_at_y0=interp1(F_fmin(end/2:end),Kcoef(end/2:end),0);
xmax_at_y0=interp1(F_fmax(end/2:end),Kcoef(end/2:end),0);

xlim([0.5 1]);
ylim([-2 2]);
xlabel('Attenuation coefficient: {\it C}') 
ylabel('F(f_{min,max})')
legend('F(f_{min})','F(f_{max})','NumColumns', 2);

exportgraphics(f,".\Results2\WithoutRRO\AttractorMerging\AttractorMergingConditionOfKcoef.png",'Resolution',400,"Append",false)
% savefig(f,".\WithoutRRO\ADHD\Figure\AttractorMergingConditionOfKcoef.fig")
% close(f);




