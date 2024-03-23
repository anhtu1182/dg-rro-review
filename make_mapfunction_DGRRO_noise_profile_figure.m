clear;

step=0.05;
x_lim=3;
y_lim=4;
N=round(x_lim/step);

set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');



% ------------------------------
% For Hadaeghi map function + RRO

x=-x_lim:step:x_lim;
A=[9.8 12 13];
Kcoef=[1.0 1.0 0.9];
Dc=[0 1e-2 1e-1 1];
Da=0:0.1:1;

omega1=0.2223; 
omega2=1.487;

Omega=0.005;
As=0;
K=1;
for i_dc=1:length(Dc)
    for i_da=1:length(Da)

        for divide=2:2:4
            sigma=1/divide;
        
            for i_a=1:size(A,2)
                f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
                xmin=fminbnd(f,-3,0);
                xmax=-xmin;
            
                fig(i_a)=figure('WindowState', 'maximized');
                for i=-N:N
                    [~,y(N+i+1),~]=baghdadi_DGRRO_map_func_noise(x(N+i+1),A(i_a),Kcoef(i_a),K,Dc(i_dc),sigma,As,Omega,i,xmin);
                end
                hold on
                plot(x,y,'k',"LineWidth",3);
                xline(xmin,'--r',"LineWidth",2);
                xline(xmax,'--b',"LineWidth",2);
                hold off
                grid on
                legend("g(x)","x_{min}","x_{max}")
                xlabel('x') 
                ylabel('DGRRO feedback signal: g(x)')
                xlim([-x_lim x_lim])
                ylim([-y_lim y_lim])
            %     set(gca,'yticklabel',num2str(get(gca,'xtick')','%.1f'))
                
                exportgraphics(fig(i_a),".\Results2\DG\Feedback\Noise\"+num2str(divide)+"\FeedbackProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a)) ...
                    +"_Dc_"+num2str(Dc(i_dc))+"_Da_"+num2str(Da(i_da))+".png",'Resolution',400,"Append",false)
            %     savefig(fig(i_a),".\DGRRO\ADHD\Figure\MapFunctionDGProfile_A_"+num2str(A(i_a))+".fig")
                close(fig(i_a));
            end
            
            for i_a=1:size(A,2)
                f=@(x)baghdadi_map_func(x,A(i_a),Kcoef(i_a),0,sigma,As,Omega,i);
                xmin=fminbnd(f,-3,0);
                xmax=-xmin;
            
                fig(i_a)=figure('WindowState', 'maximized');
                for i=-N:N
                    [z(N+i+1),~,~]=baghdadi_DGRRO_map_func(x(N+i+1),A(i_a),Kcoef(i_a),0,sigma,As,Omega,i,xmin);
                    
                end
                hold on
                plot(x,z,'k',"LineWidth",2);
                hold off
                grid on
            %     legend("g(x)","x_{min}","x_{max}")
                xlabel('x(n)') 
                ylabel('x(n+1)')
                xlim([-x_lim x_lim])
                ylim([-y_lim y_lim])
            %     set(gca,'yticklabel',num2str(get(gca,'xtick')','%.1f'))
                
                exportgraphics(fig(i_a),".\Results2\DG\ReturnMap\Noise\"+num2str(divide)+"\MapFunctionDGProfile_A_"+num2str(A(i_a))+"_Kcoef_"+num2str(Kcoef(i_a)) ...
                    +"_Dc_"+num2str(Dc(i_dc))+"_Da_"+num2str(Da(i_da))+".png",'Resolution',400,"Append",false)
            %     savefig(fig(i_a),".\DGRRO\ADHD\Figure\MapFunctionDGProfile_A_"+num2str(A(i_a))+".fig")
                close(fig(i_a));
            end
        end

    end
end
