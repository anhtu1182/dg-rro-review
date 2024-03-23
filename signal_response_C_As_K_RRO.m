clear; 

A=[12 13 13 13];
Kcoef=[1.0 0.89 0.90 0.91];
% K_rro = [0.679607279249295,0.229676719802654,0.284042780819440,0.338366945825251];
K_rro =fscanf(fopen(".\Results2\RRO\AttractorMerging\attractorMergingPoint.txt","r"),"%f,%f,%f,%f");

for a_value=1:length(A)
K=0;
sigma=1;
As=0;
Omega=0;
i=1;

f=@(x)baghdadi_map_func(x,A(a_value),Kcoef(a_value),K,sigma,As,Omega,i);
f_min=abs(fminbnd(f,-3,0));

delta_K=fix(K_rro*200)/50000;
 
delta_a=5e-4;

duration=40400;

d_trans=400;

rng(1);

A_list=[1e-4:1e-4:9e-4 1e-3:1e-3:9e-3 1e-2:1e-2:9e-2 1e-1:1e-1:9e-1 1];

% A_list=[0.01, 0.15, 0.3];
% A_list=0.01:0.02:0.3;
% period=[4, 8, 16, 32];

Omega=0.005;
p=fix((2.*pi)/Omega);

for trial_i=1:1:10
    trial_i
    for A_i=1:1:length(A_list)
        for K_i=1:1:500
%             A_list(A_i)
            K=K_i*delta_K(a_value);
            K_v(A_i,K_i)=K;
            A_v(A_i,K_i)=A_list(A_i);
            
            As=A_v(A_i,K_i);
            
            count=1;

            x_t(1)=-0.7+0.1*randn(1);
            for t_i=1:1:duration
                [x_t(t_i+1),u]=baghdadi_map_func(x_t(t_i),A(a_value),Kcoef(a_value),K,sigma,As,Omega,t_i);
                if t_i>d_trans
                    ex_st(t_i)=A_list(A_i)*sin(Omega*t_i);
                end
            end    

            for tau=1:1:p
                rho=corrcoef(sign(circshift(x_t(d_trans:end-1),tau)),ex_st(d_trans:end));
                tau_rho(tau)=rho(1,2);
            end 
            
            max_C(trial_i,A_i,K_i)=max(tau_rho);

            clear tau_rho;
            
        end
    end
end

save("signal_response_As_K_"+num2str(Kcoef(a_value))+"_RRO_"+num2str(A(a_value))+".mat");
end