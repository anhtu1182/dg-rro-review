clear;

N=400;
step=10/N;
% N=1000;
K=0;
Kcoef=1;
As=0;
sigma=1;
Omega=0.005;

% A=9.545628581212009;
for i=0:N
    A(1,i+1)=(i+200)*step; 
    f=@(x) baghdadi_map_func(x,A(1,i+1), Kcoef,K,sigma,As,Omega,i);
    xmin(i+1)=fminbnd(f,-2,0);
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

plot(A,F_fmin,'Linewidth',2);
plot(A,F_fmax,'Linewidth',2);
xmin_at_y0=interp1(F_fmin,A,0);
xmax_at_y0=interp1(F_fmax,A,0);

xlim([5 15]);
ylim([-2.5 2.5]);
xlabel('Inhibitory synaptic strength: A') 
ylabel('F(f_{min,max})')
legend('F(f_{min})','F(f_{max})','NumColumns', 2);

exportgraphics(f,".\Results2\WithoutRRO\AttractorMerging\AttractorMergingConditionOfA.png",'Resolution',400,"Append",false)
% savefig(f,".\WithoutRRO\ADHD\Figure\AttractorMergingConditionOfA.fig")
% close(f);

writematrix(xmin_at_y0,".\Results2\WithoutRRO\AttractorMerging\attractorMergingPoint.txt")
