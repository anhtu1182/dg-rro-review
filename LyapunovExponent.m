function LE = LyapunovExponent(x)
    lyapunovs = [];
    eps = 0.0001;
    N=size(x);
    for i=1:N
        for j=i+1:N
%             if abs(x(i)-x(j)) < eps
                for k=1:min(N-i,N-j)
%                     disp(x(i)+"  "+x(j))
                    a = x(i)-x(j);
                    d0 = abs(x(i)-x(j));
                    dn = abs(x(i+k)-x(j+k));   
                    if (d0~=0&&dn~=0)
                        x=log(dn)-log(d0);
                        lyapunovs=[lyapunovs x];       
                    end
                end
%             end
        end
    end

    LE=mean(lyapunovs);
    
end