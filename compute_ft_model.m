function sigm_param = compute_ft_model( c_tilde_vec, ft_norm, num_sigm, radius_decim, debug )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    debug = false;
end
if debug
    time_plot = 10; 
    c_tilde_vec_in = c_tilde_vec;
    ft_norm_in = ft_norm;
else
    time_plot = inf;
end

%%Preprocess the data
targets = [c_tilde_vec(:)'/max(c_tilde_vec(:)); ft_norm(:)'/max(ft_norm(:))];
[ targets, mask_mantieni ] = gpu_decim_norm( targets, radius_decim, time_plot );
c_tilde_vec = c_tilde_vec(mask_mantieni);
ft_norm = ft_norm(mask_mantieni);

x0 = [ -1/num_sigm*ones(num_sigm,1) , (rand(num_sigm,1) + rand(num_sigm,1)) ];
%fmincon
options = optimoptions('fmincon','ConstraintTolerance',1e-6,'Diagnostics','off','Display','iter','MaxFunctionEvaluations',10000 ...
            , 'MaxIterations', 20000, 'OptimalityTolerance', 1e-6, 'PlotFcn', @optimplotfval, 'StepTolerance', 1e-6 );
        
nonlcon = @nonlcon_fcn;
sigm_param = fmincon( @(x)ft_Jcst( [ x(:,1), zeros(size(x,1),1) , x(:,2) ], c_tilde_vec, ft_norm  ) ,x0,[],[],[],[],[],[],nonlcon,options);


sigm_param = [ sigm_param(:,1), zeros(size(sigm_param,1),1) , sigm_param(:,2) ];

if(debug)

    figure
    subplot(2,1,1)
    plot( c_tilde_vec_in,ft_norm_in,'-o' )
    hold on
    plot( c_tilde_vec,ft_norm,'r-o' )
    ft_pred = ft_model( c_tilde_vec_in,sigm_param);
    plot( c_tilde_vec_in,ft_pred )
    subplot(2,1,2)
    plot( c_tilde_vec_in,ft_norm_in - ft_pred )

end

end

