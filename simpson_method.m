clear all
clc
size = [7 5];
format short E
varNames = {'h','n','I','Error','e_2h/e_h'}; %Size of table
varTypes = {'double','double','double','double','double'}; %Table column names
T2 = table('Size',size,'VariableTypes',varTypes,'VariableNames',varNames);
f = @sin; %Given function
xa = 0; xb = pi; %Given limits
I_exact = 2; %Exact solution
n = [2,4,8,16,32,64,128]; %Given n row vector
z = length(n); %Size of n
for i=1:z
    if (rem(n(i),2)~=0) %Check for n = even fopr Simpson's rule
        fprintf("Simpson's rule is valid only for n = even number.")
        break
    end
    h = (xb-xa)/n(i); 
    x = xa + [0:n(i)]*h; %Creating x vector for data points
    % if n(i)= m then x has m+1 elements.
    
    % Simpson's Rule
    integ_trapz(i) = feval(f, x(1));
    if (n(i)>2)
        for j=2:n(i) 
            if (rem(j,2)==0)
                integ_trapz(i) = integ_trapz(i) + 4*feval(f, x(j));
            else
                integ_trapz(i) = integ_trapz(i) + 2*feval(f, x(j));
            end
        end
        integ_trapz(i) = integ_trapz(i) + feval(f, x(n(i)+1));
        integ_trapz(i) = integ_trapz(i)*h/3;
    else
        integ_trapz(i) = integ_trapz(i) + feval(f, x(n(i)+1)) + 4*feval(f, x(2));
        integ_trapz(i) = integ_trapz(i)*h/3;
    end
    if (i>1)
        T2(i,:)={h n(i) integ_trapz(i) abs(I_exact-integ_trapz(i)) abs(I_exact-integ_trapz(i))/abs(I_exact-integ_trapz(i-1))};
    else 
        T2(i,:)={h, n(i), integ_trapz(i), abs(I_exact-integ_trapz(i)), NaN}; % NaN here refers to '--' not 'inf'
    end
end
T2
