function [c,Kg,Fx] = baghdadi_DGRRO_map_func(x,A,Kcoef,K,sigma,As,Omega,i,xmin)
% function [Fx] = hadaeghi_map_func(x,A,K,sigma,As,Omega,i)
    
%     sigma=0.3;
%     A=1;
%     K=0.05;
%     x=0.15;
%     Omega=0.005;
%     i=1;

    omega1=0.2223; 
    omega2=1.487;
    if Kcoef==1.0
        B=5.82;
    else
        B=5.821;
    end
    
    Fx=Kcoef*(B*tanh(omega2*x)-A*tanh(omega1*x));

    xmax=-xmin;

    g=-Fx*(exp(-(x-xmin)^2/(2*sigma^2))+exp(-(x-xmax)^2/(2*sigma^2)));
    Kg=K*g;
    
    S=As*sin(Omega*i);

    c=Fx+Kg+S;
end