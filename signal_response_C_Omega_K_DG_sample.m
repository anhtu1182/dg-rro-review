

a=2.82;
b=10.;


sigma=0.3;
K=0.;
D=0.03;

f=@(x)cubic_map(x,a,b,0,0,0,0,0);
cubic_f_min=abs(fminbnd(f,-2,0));


As=0.001;
Omega_s=0.005;
p=fix((2.*pi)/Omega_s);

delta_K=0.0001;
delta_a=5e-4;

duration=10300;

d_trans=300;

rng(1);

A_list=[1e-4:1e-4:9e-4 1e-3:1e-3:9e-3 1e-2:1e-2:9e-2 1e-1:1e-1:9e-1 ...
       1];

for trial_i=1:1:10
    trial_i
    for A_i=1:1:length(A_list)
        for K_i=1:1:200

            a=2.82;
            K=-K_i*delta_K;

            K_v(A_i,K_i)=K;
            A_v(A_i,K_i)=A_list(A_i);
            
            Omega_s=A_v(A_i,K_i);
            
            count=1;

            x_t(1)=-0.7+0.1*randn(1);
            for t_i=1:1:duration
                [x_t(t_i+1),u]=cubic_map_double(x_t(t_i),a,b,As,Omega_s,K,sigma,t_i,cubic_f_min);
                if t_i>d_trans
                    ex_st(t_i)=As*sin(Omega_s*t_i);
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

save('signal_response_Omega_K_DG.mat');