function [attractors] = bifurcationValue_ADHD_DGRRO(A,Kcoef,K,As,sigma,Omega,sign)

    f0=@(x) baghdadi_map_func(x,A,Kcoef,K,sigma,As,Omega,0);
    xmin=fminbnd(f0,-3,0);
    xmax=-xmin;

    loopTime=100;
%     t=loopTime;
%     valNum=50;
    attractor=zeros(size(loopTime));
    attractor(1)=0.8*sign;
    for i=2:1:loopTime
        [attractor(i),~,~]=baghdadi_DGRRO_map_func(attractor(i-1),A,Kcoef,K,sigma,As,Omega,i,xmin);
    end
    attractors = attractor(1:end)';
end
