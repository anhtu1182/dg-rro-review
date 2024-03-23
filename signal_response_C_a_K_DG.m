A=9.8;
Kcoef=1;
K=0;
sigma=1;
As=0;
Omega=2.*pi/4;
i=1;

f=@(x)baghdadi_map_func(x,A,Kcoef,K,sigma,As,Omega,i);
f_min=abs(fminbnd(f,-3,0));

As=0.001;
p=fix((2.*pi)/Omega);

delta_K=0.0005;

delta_A=4e-4;

duration=10300;

d_trans=300;

rng(1);

for trial_i=1:1:10

    for a_i=1:1:50
        for K_i=1:1:100
            A=9.8+delta_A*a_i;
            K=K_i*delta_K;
            K_v(a_i,K_i)=K;
            a_v(a_i,K_i)=A;
            
            count=1;

            x_t(1)=-0.8+0.1*randn(1);
            for t_i=1:1:duration
                [x_t(t_i+1),u]=baghdadi_map_func(x_t(t_i),A,Kcoef,K,sigma,As,Omega,t_i);
                if t_i>d_trans
                    ex_st(t_i)=As*sin(Omega*t_i);
                end
            end    

            for tau=1:1:p
                rho=corrcoef(sign(circshift(x_t(d_trans:end-1),tau)),ex_st(d_trans:end));
                tau_rho(tau)=rho(1,2);
            end    
            
            max_C(trial_i,a_i,K_i)=max(tau_rho);

            clear tau_rho;
            
        end
    end
end

save('signal_response_a_K_DG.mat');