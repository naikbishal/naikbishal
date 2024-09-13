clear all
clc
format short E

fxy = @(x,y) 1 + y/x; %Given ODE y'(x) = 1 + y/x
fexactsol= @(x) x + x*log (x); %Exact solution of the ODE

x0 = 1; xf = 6; h = 0.5; n = round((xf-x0)/h); 
y0 = 1; %Given condition for the IVP

x = x0 + [0:n]*h; %Creating x vector for data points
% if n= m then x has m+1 elements
    
y = zeros(size(x));   % space to store the solution

%RK2 Heun's Method
y(1) = y0; 
fprintf("x(%d) = %d and y(%d) = %d\n",0,x(1),0,y(1));
for i=2:n+1
  x_current = x(i-1); y_current = y(i-1);
  fprintf("\nAfter iteration %d : ",i-1);
  % perform RK2 stages02
  k1 = h*feval(fxy,x_current,y_current);   %feval at x_current and y_current

  % intermediate stage
  x_interm = x_current + h;
  y_interm = y_current + k1;
  k2 = h*feval(fxy,x_interm,y_interm);   %feval at x_interm and y_interm
  
  % update to the next step
  y_next = y_current + 0.5*(k1+k2);
  y(i) = y_next;    % store in the array
  fprintf("\nx(%d) = %d and y(%d) = %d\n",i-1,x_interm,x_interm,y_next);
  Error = abs(y_next - feval(fexactsol,x_interm));
  fprintf("yexact = %d , Error = %d\n",feval(fexactsol,x_interm),Error);
end
