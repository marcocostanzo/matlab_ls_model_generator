function y = gauss_fun(x,mu,sigma)
%GAUSS_FUN Summary of this function goes here
%   Detailed explanation goes here

y = exp(-(x - mu).^2/(2*sigma^2));

end

