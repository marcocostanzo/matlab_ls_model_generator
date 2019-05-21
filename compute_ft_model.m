function sigm_param = compute_ft_model( c_tilde_vec, ft_norm, num_sigm, debug )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    debug = false;
end

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
    plot( c_tilde_vec,ft_norm,'-o' )
    hold on
    ft_pred = ft_model( c_tilde_vec,sigm_param);
    plot( c_tilde_vec,ft_pred )
    subplot(2,1,2)
    plot( c_tilde_vec,ft_norm - ft_pred )

end

end

