function [attractors] = bifurcationValue_ADHD(A,Kcoef,K,As,sigma,Omega,sign)
    loopTime=100;
%     t=loopTime;
%     valNum=50;
    attractor=zeros(size(loopTime));
    attractor(1)=0.8*sign;
    for i=2:1:loopTime
        [attractor(i),~,~]=baghdadi_map_func(attractor(i-1),A,Kcoef,K,sigma,As,Omega,i);
    end
    attractors = attractor(1:end)';
end
