function x_max = interp_p(y,x)
%This function fits a parabola to three points
%Returns the position (x_max) and value (y_max) of the 
%interpolated critical point(peak or trough).
%y = a*x^2 +b*x +c

%i learn it from MathWork

d = (x(1) - x(2)) * (x(1) - x(3)) * (x(2) - x(3));%denominator
a = (x(3) * (y(2) - y(1)) + x(2) * (y(1) - y(3)) + x(1) * (y(3) - y(2))) / d;
b = (x(3)*x(3) * (y(1) - y(2)) + x(2)*x(2) * (y(3) - y(1)) + x(1)*x(1) * (y(2) - y(3))) / d;

x_max=-b/(2*a);%critical point position

end

