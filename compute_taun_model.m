function gauss_param = compute_taun_model( c_tilde_vec, taun_norm, num_gauss, debug )

if nargin < 4
    debug = false;
end

x0 = [ 1/num_gauss*ones(num_gauss,1) , (rand(num_gauss,1) + rand(num_gauss,1)) ];

%fmincon
options = optimoptions('fmincon','ConstraintTolerance',1e-6,'Diagnostics','off','Display','iter','MaxFunctionEvaluations',10000 ...
            , 'MaxIterations', 20000, 'OptimalityTolerance', 1e-6, 'PlotFcn', @optimplotfval, 'StepTolerance', 1e-6 );
Aeq = [ ones(1,num_gauss), zeros(1,num_gauss) ]; % [ ones(1,num_gauss), zeros(1,num_gauss) ]; %repmat([1 0], 1 , num_gauss);
beq = 1;%max(taun_norm);
gauss_param = fmincon( @(x)tau_Jcst( [ x(:,1), zeros(size(x,1),1) , x(:,2) ], c_tilde_vec, taun_norm  ) ,x0,[],[],Aeq,beq,[],[],[],options);

gauss_param = [ gauss_param(:,1), zeros(size(gauss_param,1),1) , gauss_param(:,2) ];

if(debug)
    
    figure
    subplot(2,1,1)
    plot( c_tilde_vec,taun_norm,'-o' )
    hold on
    tau_pred = tau_model( c_tilde_vec,gauss_param);
    plot( c_tilde_vec,tau_pred )
    subplot(2,1,2)
    plot( c_tilde_vec,taun_norm - tau_pred )

end

end

