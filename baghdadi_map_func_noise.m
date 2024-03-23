function [c,noise,Kg,Fx] = baghdadi_map_func_noise(x,A,Kcoef,K,Dc,sigma,As,Omega,i)
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

%     f=@(x)(B*tanh(omega2*x)-A*tanh(omega1*x));
%     xmin=fminbnd(f,-3,0);
%     xmax=-xmin;
    
%    sigma=sigma(dg)=sigma(rro)/2=0.6/2=0.3;

%     g=-Fx*(exp(-(x-xmin)^2/(2*sigma^2))+exp(-(x-xmax)^2/(2*sigma^2)));
    noise=Dc*randn;
    g=-x*exp(-(x^2+noise)/(2*sigma^2));
    Kg=g*K;
    
    S=As*sin(Omega*i);

    c=Fx+Kg+S;
end