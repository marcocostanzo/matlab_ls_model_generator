function y = sigm_fun(x,mu,a)
%SIGM_FUN Summary of this function goes here
%   Detailed explanation goes here

y = 2./(1 + exp(-a*(x-mu))) - 1;

end

