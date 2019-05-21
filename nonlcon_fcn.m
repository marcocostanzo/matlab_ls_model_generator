function [c, ceq] = nonlcon_fcn(x)
%NONLCON_FCN Summary of this function goes here
%   Detailed explanation goes here

ceq = sum( x(:,1) .* sign(x(:,2)) ) + 1;

c = [];

end

