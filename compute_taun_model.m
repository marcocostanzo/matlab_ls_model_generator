function gauss_param = compute_taun_model( c_tilde_vec, taun_norm, num_gauss, radius_decim, debug )

if nargin < 5
    debug = false;
end
if debug
    time_plot = 10; 
    c_tilde_vec_in = c_tilde_vec;
    taun_norm_in = taun_norm;
else
    time_plot = inf;
end

%%Preprocess the data
targets = [c_tilde_vec(:)'/max(c_tilde_vec(:)); taun_norm(:)'/max(taun_norm(:))];
[ targets, mask_mantieni ] = gpu_decim_norm( targets, radius_decim, time_plot );
c_tilde_vec = c_tilde_vec(mask_mantieni);
taun_norm = taun_norm(mask_mantieni);

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
    plot( c_tilde_vec_in,taun_norm_in,'-o' )
    hold on
    plot( c_tilde_vec,taun_norm,'r-o' )
    tau_pred = tau_model( c_tilde_vec_in,gauss_param);
    plot( c_tilde_vec_in,tau_pred )
    subplot(2,1,2)
    plot( c_tilde_vec_in,taun_norm_in - tau_pred )

end

end

