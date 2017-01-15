function numgrad = computeNumericalGradient(F, theta)
% numgrad = computeNumericalGradient(F, theta)
% theta: a vector of parameters
% F: a function that outputs a real-number. Calling y = F(theta) will return the
% function value at theta. 
  
% Initialize numgrad with zeros
numgrad = double(zeros(size(theta)));

EPSILON = 1e-4;
for i=1:length(numgrad)
    e_i = zeros(size(theta));
    e_i(i) = EPSILON;
    numgrad(i) = (F(theta + e_i) - F(theta - e_i))/(2*EPSILON);
end

end
