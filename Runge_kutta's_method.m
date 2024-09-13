clear all
clc 
format short E
fxy = @(x,y) 1 + y/x;%Given ODE y'(x) = 1 + y/x
fexactsol= @(x) x + x*log (x); %Exact solution of the ODE

size = [5 5]; %Size of table
varNames = {'h','n','ynum(6)','Error','e_2h/e_h'}; %Column titles
varTypes = {'double','double','double','double','double'}; %Varibale types
T2 = table('Size',size,'VariableTypes',varTypes,'VariableNames',varNames);
x0 = 1; xf = 6; %Given 
h = [0.0625, 0.125, 0.25, 0.5, 1];  %Given h row vector
n = round((xf-x0)./h); 
z = length(n);
y0 = 1; %Given condition for the IVP
Y = zeros(z); %To store the final y(6) values for each element in row vector h.
Error = zeros(z); %%To store the error for each element in row vector h.
for j=1:z
    x = x0 + [0:n(j)]*h(j); 
    y = zeros(length(x));   % space to store the solution
    y(1) = y0;
    for i=2:n(j)+1
        x_current = x(i-1); y_current = y(i-1); %Creating x vector for data points
        % if n(i)= m then x has m+1 elements
    
        % perform RK2 stages02
        f1 = feval(fxy,x_current,y_current);   %feval at x_current and y_current
        % intermediate stage
        x_interm = x_current + 0.5*h(j);
        x_intermcheck = x_current + h(j);
        y_interm = y_current + 0.5*f1*h(j);
        f2 = feval(fxy,x_interm,y_interm);   %feval at x_interm and y_interm
        % update to the next step
        y_next = y_current + h(j)*f2;
        y(i) = y_next;    % store in the array
        error = abs(y_next - feval(fexactsol,x_intermcheck));
    end
    Y(j) = y_next; %Storing y(6)for each element in h[]
    Error(j) = error; %Storing error 9ynum-yexact) for each element in h[]
end
%Display of table output
for j=1:z
    if (j>1)
        T2(j,:)={h(j), n(j), Y(j), Error(j), Error(j-1)/Error(j)};
    else
        T2(j,:)={h(j), n(j), Y(j), Error(j), NaN}; %Here NaN refers to '--' not 'inf'.
    end
end
T2
