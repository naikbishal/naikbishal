clear all
clc
format short E
size = [8 5]; %size of table
varNames = {'h','n','I','Error','e_2h/e_h'}; %Column names of the table
varTypes = {'double','double','double','double','double'};  %Memorytype for the variable
T2 = table('Size',size,'VariableTypes',varTypes,'VariableNames',varNames); %Definition of table
f = @sin; %Given function
xa = 0; xb = pi; %Given limits
I_exact = 2; %Exact solution 
n = [1,2,4,8,16,32,64,128]; %Given n row vector
z = length(n); %Storing the size of n
for i=1:z 
    h = (xb-xa)/n(i); 
    x = xa + [0:n(i)]*h; %Creating x vector for data points
    % if n(i)= m then x has m+1 elements
   
    % Trapezoidal Rule
    integ_trapz(i) = feval(f, x(1)); % I = h/2 *(f(x0) + ... )
    if (n(i)>2) 
        for j=2:n(i)
            integ_trapz(i) = integ_trapz(i) + 2*feval(f, x(j));
        end
        integ_trapz(i) = integ_trapz(i) + feval(f, x(n(i)+1)); 
        integ_trapz(i) = integ_trapz(i)*h*0.5;
    elseif (n(i)==2) % I = h/2 *(f(x0) + 2*f(x1) + f(x2=xn))
        integ_trapz(i) = integ_trapz(i) + feval(f, x(n(i)+1)) + 2*feval(f, x(2));
        integ_trapz(i) = integ_trapz(i)*h*0.5;
    else %When n(i)=1; I = h/2 *(f(x0) + f(x1=xn))
        integ_trapz(i) = integ_trapz(i) + feval(f, x(n(i)+1));
        integ_trapz(i) = integ_trapz(i)*h*0.5;
    end
    
    if (i>1)
        T2(i,:)={h n(i) integ_trapz(i) abs(I_exact-integ_trapz(i)) abs(I_exact-integ_trapz(i))/abs(I_exact-integ_trapz(i-1))};
    else 
        T2(i,:)={h, n(i), integ_trapz(i), abs(I_exact-integ_trapz(i)), NaN}; % NaN here refers to '--' not 'inf'
    end
end
T2
