%% Params

k = 4;

num_sigm = 10; %<- num of sigm function to use (ft_model)
num_gauss = 10; %<- num of gauss function to use (taun_model)

b_assume_simmetry = true;

%% DBG Params

close all  %<-- Comment here to not close figures
b_plot_ls = true;
debug_fmin = true;


%% Params2

file_name_precision = 6;
tmp_folder_str = 'tmp/';
out_folder_str = 'out/';

if~isfolder(tmp_folder_str)
    mkdir(tmp_folder_str);
end
if~isfolder(out_folder_str)
    mkdir(out_folder_str);
end

%% Path
addpath('matlab_limit_surface\LS_lib')

%% Compute Integrals

file_tmp_str = [tmp_folder_str,'integrals_tmp_k' num2str(k,file_name_precision)];
file_tmp_str = strrep(file_tmp_str,'.','_');
if ~isfile([file_tmp_str '.mat'])
    
    %tmp_file does not exist
    disp('computing integrals')
    c_tilde_vec = [linspace(0, 3, 2000) linspace(3, 10, 1000) linspace(10, 20, 1000) linspace(20, 100, 10) ];
    if(b_assume_simmetry)
        
    else
        c_tilde_vec = [ -fliplr(c_tilde_vec) c_tilde_vec];
    end
    
    int_points = 6000;
    [ ft_norm , taun_norm ] = calculateLimitSurfaceNorm( ...
                                                    c_tilde_vec,...
                                                    k,...
                                                    int_points,...
                                                    10 ...
                                                   );
   
    ft_norm=ft_norm(:);
    taun_norm=taun_norm(:);
    c_tilde_vec=c_tilde_vec(:);
   
    if(b_assume_simmetry)
        ft_norm = [-flipud(ft_norm); ft_norm];
        taun_norm = [flipud(taun_norm); taun_norm];
        c_tilde_vec = [ -flipud(c_tilde_vec); c_tilde_vec];
    else
        
    end
                                              
   save(file_tmp_str,'ft_norm','taun_norm','c_tilde_vec');
    
else
    %tmp file exist
    warning('using temp file for integrals')
    l = load( file_tmp_str, 'ft_norm','taun_norm','c_tilde_vec');
    ft_norm = l.ft_norm;
    taun_norm = l.taun_norm;
    c_tilde_vec = l.c_tilde_vec;
    
end

if(b_plot_ls)
    if(~exist('fig_ls','var') || ~isvalid(fig_ls) )
        fig_ls = figure;
    else
       figure(fig_ls);
    end
    plot(ft_norm, taun_norm, '-o')
end

%% Compute ft_model

file_tmp_str = [tmp_folder_str,'ft_model_tmp_k' num2str(k,file_name_precision)];
file_tmp_str = strrep(file_tmp_str,'.','_');
if ~isfile([file_tmp_str '.mat'])
    
    sigm_params = compute_ft_model( c_tilde_vec, ft_norm, num_sigm, debug_fmin );
    
    save(file_tmp_str, 'sigm_params');
    
else
    warning('using temp file for ft_model')
    l = load( file_tmp_str, 'sigm_params');
    sigm_params = l.sigm_params;
    
end

%% Compute taun_model

file_tmp_str = [tmp_folder_str,'taun_model_tmp_k' num2str(k,file_name_precision)];
file_tmp_str = strrep(file_tmp_str,'.','_');
if ~isfile([file_tmp_str '.mat'])
    
    gauss_params = compute_taun_model( c_tilde_vec, taun_norm, num_gauss, debug_fmin );
    
    save(file_tmp_str, 'gauss_params');
    
else
    
    warning('using temp file for taun_model')
    l = load( file_tmp_str, 'gauss_params');
    gauss_params = l.gauss_params;
    
end

if(b_plot_ls)
    c_tilde_dbg = c_tilde_vec(1):0.0001:c_tilde_vec(end);
    ft_norm_dbg = ft_model( c_tilde_dbg, sigm_params);
    taun_norm_dbg = tau_model( c_tilde_dbg, gauss_params);
    figure(fig_ls);
    hold on
    plot(ft_norm_dbg, taun_norm_dbg)
    hold off
end

%% Write files
outname = num2str(floor(k));
decim_str = num2str(mod(k,1));
if(numel(decim_str) >= 4)
    outname = [outname, '_' decim_str([3 4])];
elseif(numel(decim_str) == 3)
    outname = [outname, '_' decim_str(3), '0'];
else
    outname = [outname, '_00'];
end
file_out_str = [out_folder_str, outname '.txt'];

%fileID = fopen(file_out_str,'w');

out_matrix = k;

%fprintf(fileID, '%f\n', k);

%fprintf(fileID, '%f\n', size(sigm_params,1));
out_matrix = [out_matrix; size(sigm_params,1)];
for i=1:size(sigm_params,1)
    %fprintf(fileID, '%f\n', sigm_params(i,1));
    out_matrix = [out_matrix; sigm_params(i,1)];
    %fprintf(fileID, '%f\n', sigm_params(i,2));
    out_matrix = [out_matrix; sigm_params(i,2)];
    %fprintf(fileID, '%f\n', sigm_params(i,3));
    out_matrix = [out_matrix; sigm_params(i,3)];
end

%fprintf(fileID, '%f\n', size(gauss_params,1));
out_matrix = [out_matrix; size(gauss_params,1)];
for i=1:size(gauss_params,1)
    %fprintf(fileID, '%f\n', gauss_params(i,1));
    out_matrix = [out_matrix; gauss_params(i,1)];
    %fprintf(fileID, '%f\n', gauss_params(i,2));
    out_matrix = [out_matrix; gauss_params(i,2)];
    %fprintf(fileID, '%f\n', gauss_params(i,3));
    out_matrix = [out_matrix; gauss_params(i,3)];
end

eval(['save -ascii -double ' file_out_str ' out_matrix'])

%fclose(fileID);