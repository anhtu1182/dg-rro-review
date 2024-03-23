

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
duration=10300;

d_trans=300;

for trial_i=1:1:2
    for K_i=1:1:100
        K=-K_i*delta_K;
        K_v(K_i)=K;
        
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
        
        max_C(trial_i,K_i)=max(tau_rho);

        clear tau_rho;
        
    end
end

save('signal_response_dG.mat');