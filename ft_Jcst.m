function J = ft_Jcst(gauss_param, c_tilde_vec, ft_vec )
%TAU_JCST Summary of this function goes here
%   Detailed explanation goes here

ft_pred = zeros(size(ft_vec));

for i = 1:length(ft_pred)
   
    ft_pred(i) = ft_model( c_tilde_vec(i), gauss_param );
    
end

J = (1/length(ft_vec)) * sum(  (ft_vec - ft_pred).^2  );

end

