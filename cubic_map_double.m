function [c,Ku] = cubic_map_double(x,a,b,A,Omega,K,sigma,i,f_min)
    u=-(a*x-x^3)*exp(-x^2/b)*(exp(-(x-f_min).^2/(2.*sigma^2))+exp(-(x+f_min).^2/(2.*sigma^2)));
    Ku=K*u;
    c=(a*x-x^3)*exp(-x^2/b)+K*u+A*sin(Omega*i);
end

