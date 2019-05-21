function ft = ft_model(c_tilde, sigm_param)
%TAU_MODEL Summary of this function goes here
%   Detailed explanation goes here


ft = 0;

for i=1:size(sigm_param,1)
   
    %ft = ft + gauss_param(i,1)*gauss_fun( c_tilde, gauss_param(i,2), gauss_param(i,3) );
    ft = ft + sigm_param(i,1)*sigm_fun( c_tilde, sigm_param(i,2), sigm_param(i,3) );
    
end


end

