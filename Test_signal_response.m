clear; 

A=9.8;
% A=12;
Kcoef=1;
K=0;
sigma=1;
As=0;
Omega=0;
i=1;

f=@(x)baghdadi_map_func(x,A,Kcoef,K,sigma,As,Omega,i);
f_min=abs(fminbnd(f,-3,0));

delta_K=0.001;
% delta_K=0.004;
 
delta_a=5e-4;

duration=100300;

d_trans=300;

rng(1);

A_list=[0.01, 0.15, 0.3];
% A_list=0.01:0.02:0.3;
% period=[4, 8, 16, 32];

Omega=2.*pi/8;
p=fix((2.*pi)/Omega);
    
for trial_i=1:1:10
    trial_i
    for A_i=1:1:length(A_list)
        for K_i=1:1:200
            K=161*delta_K;            
            As=A_list(8);
            
            count=1;

            x_t(1)=-0.6+0.1*randn(1);
            for t_i=1:1:duration
                [x_t(t_i+1),u]=baghdadi_map_func(x_t(t_i),A,Kcoef,K,sigma,As,Omega,t_i);
                if t_i>d_trans
                    ex_st(t_i)=As*sin(Omega*t_i);
                end
            end    

            for tau=1:1:p
                rho=corrcoef(sign(circshift(x_t(d_trans:end-1),tau)),ex_st(d_trans:end));
                tau_rho(trial_i,tau)=rho(1,2);
            end 
            
            max_C(trial_i)=max(tau_rho(trial_i,:));

%             clear tau_rho;
            
        end
    end
end

% save('signal_response_As_K_RRO.mat');