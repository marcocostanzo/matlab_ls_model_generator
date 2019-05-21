function tau = tau_model(c_tilde, gauss_param)
%TAU_MODEL Summary of this function goes here
%   Detailed explanation goes here


tau = 0;

for i=1:size(gauss_param,1)
   
    %tau = tau + gauss_param(i,1)*normpdf( c_tilde, gauss_param(i,2), gauss_param(i,3) );
    %tau = tau + gauss_param(i,1)*gaussmf( c_tilde, [gauss_param(i,3), gauss_param(i,2)] );
    tau = tau + gauss_param(i,1)*gauss_fun( c_tilde, gauss_param(i,2), gauss_param(i,3) );
    
end


end

