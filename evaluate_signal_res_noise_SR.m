

b=10.;
k=1.3811;

%K=0.05;

A1=1e-3:1e-4:1e-2-1e-3;
A2=1e-2:1e-3:0.1;
D=horzcat(A1,A2)
A=0.005;
omega=0.005;

K_list=[0.05 0.07 0.09];
a_list=[2.82 2.825 2.83];


trial_N=10;
for trial_i=1:1:trial_N
    trial_i
    rng(trial_i);
    init_z=0.001*rand()+0.15;

    for a_i=1:1:3
        for A_i=1:1:size(D,2)
            A_i
            z(1)=init_z;
            count=1;

            K=0;
            
            a=a_list(a_i);
            sigma=0.6;
            
            f=@(x)cubic_map(x,a,b,0,0,K,sigma,0);
            f_min=fminbnd(f,-2,0);
            f_max=-f_min;
            fmax=cubic_map(f_max,a,b,0,0,K,sigma,0);
            
            con_f_am_max(a_i,A_i)=cubic_map(fmax,a,b,0,0,K,sigma,0);


            fmin=-fmax;
            con_f_am_min(a_i,A_i)=-con_f_am_max(a_i,A_i);

            rng default;
            
            %K=0;
            for i=1:1:5000
                z(i+1)=cubic_map(z(i),a,b,A,omega,K,sigma,i)+D(A_i)*normrnd(0,1);
                input_signal(i)=A*sin(omega*i);
                
                if z(i)>0
                    Z(i)=1;
                else
                    Z(i)=-1;
                end
                
            end
            
            
            for shift_i=1:1:1500
                R=corrcoef(circshift(Z(100:5000),shift_i), ...
                           input_signal(100:5000));
                R_s(shift_i)=abs(R(1,2));
            end
            
            
            corr(trial_i,a_i,A_i)=max(R_s);
            max(R_s)
        end
    end    
end

save('results_evaluate_signal_res_D_SR.mat');
