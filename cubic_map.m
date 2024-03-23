function [c,Ku] = cubic_map(x,a,b,A,Omega,K,sigma,i)
    Ku=K*(-x*exp(-x^2/(2.*sigma^2)));
    c=(a*x-x^3)*exp(-x^2/b)+K*(-x*exp(-x^2/(2.*sigma^2)))+A*sin(Omega*i);
end
