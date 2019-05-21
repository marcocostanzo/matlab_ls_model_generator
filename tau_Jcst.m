function J = tau_Jcst(gauss_param, c_tilde_vec, tau_vec )
%TAU_JCST Summary of this function goes here
%   Detailed explanation goes here

tau_pred = zeros(size(tau_vec));

for i = 1:length(tau_pred)
   
    tau_pred(i) = tau_model( c_tilde_vec(i), gauss_param );
    
end

J = (1/length(tau_vec)) * sum(  (tau_vec - tau_pred).^2  );

end

