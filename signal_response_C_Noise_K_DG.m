clear; 

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];

for divide=2:2
    divide
for a_value=1:length(A)
    a_value
K=0;
sigma=1/divide;
As=0;
Omega=0;
i=1;

f=@(x)baghdadi_map_func(x,A(a_value),Kcoef(a_value),K,sigma,As,Omega,i);
f_min=abs(fminbnd(f,-3,0));

K_dgrro = fscanf(fopen(".\Results2\DG\AttractorMerging\"+num2str(divide)+"\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");
% delta_K=fix(K_dgrro*200)/50000;

delta_a=5e-4;

duration=40500;

d_trans=500;

rng(1);

A_list=[1e-4:1e-4:9e-4 1e-3:1e-3:9e-3 1e-2:1e-2:9e-2 1e-1];

As=0.01;
Omega=0.005;
p=fix((2.*pi)/Omega);
    
for trial_i=1:1:10
    trial_i
    for A_i=1:1:length(A_list)
%         for K_i=1:1:500
%             K=K_i*delta_K(a_value);
%             K_v(A_i,K_i)=K;
%             A_v(A_i,K_i)=A_list(A_i);
            
%             As=A_v(A_i,K_i);

            Da=0;
            Dc=A_list(A_i);

%             Da=A_list(A_i);
%             Dc=0;
            
            count=1;

            x_t(1)=-0.7+0.1*randn;
            for t_i=1:1:duration
                noiseA=Da*randn;
                [x_t(t_i+1),noiseC,~,~]=baghdadi_DGRRO_map_func_noise(x_t(t_i),A(a_value),Kcoef(a_value), ...
                    K_dgrro(a_value),Dc,sigma,As,Omega,t_i,f_min);
                x_t(t_i+1) = x_t(t_i+1) + noiseA;
                if t_i>d_trans
                    ex_st(t_i)=As*sin(Omega*t_i);
                end
            end    

            for tau=1:1:p
                rho=corrcoef(sign(circshift(x_t(d_trans:end-1),tau)),ex_st(d_trans:end));
                tau_rho(tau)=rho(1,2);
            end    
            
%             max_C(trial_i,A_i,K_i)=max(tau_rho);
            max_C(trial_i,A_i)=max(tau_rho);

            clear tau_rho;
            
%         end
    end
end

% save('signal_response_As_K_DG.mat');
if (Da==0)
    save(".\Results2\DG\signalResponse\"+num2str(divide)+"\Noise\signal_response_NoiseC_K_"+num2str(Kcoef(a_value))+"_DG_"+num2str(A(a_value))+".mat");
elseif (Dc==0)
    save(".\Results2\DG\signalResponse\"+num2str(divide)+"\Noise\signal_response_NoiseA_K_"+num2str(Kcoef(a_value))+"_DG_"+num2str(A(a_value))+".mat");
else
    disp("Check noise strength");
end
% save(".\Results2\DG\signalResponse\"+num2str(divide)+"\Noise\signal_response_As_K_"+num2str(Kcoef(a_value))+"_DG_"+num2str(A(a_value))+".mat");
end
end