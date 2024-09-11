fxy = @(x,y) 1 + y/x;

x0 = 1; xf = 6; h = 0.5; n = round((xb-xa)/h);
y0 = 1;

x = x0 + [0:n]*h;
y = zeros(size(x));   % space to store the solution

y(1) = y0;
for i=2:n+1
  x_current = x(i-1); y_current = y(i-1);
  fprintf("x(%d) = %d and y(%d) = %d",i-2,x_current,i-2,y_current);
  % perform RK2 stages02
  k1 = h*feval(fxy,x_current,y_current);   % use feval at x_current and y_current

  % intermediae stage
  x_interm = x_current + h;
  y_interm = y_current + k1;
  k2 = h*feval(fxy,x_interm,y_interm);   % use feval x_interm and y_interm
  
  % update to the next step
  y_next = y_current + 0.5*(k1+k2);
  y(i) = y_next;    % store in the array
  fprintf("After iteration %d : ",i-1);
  fprintf("y(%d) = %d",i-1,y_current);
end

