%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projecting on a hyperbolicty cone using DDS.
%% Comparing DDS and Frank-Wolf

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% By running this function, the code solves the projection problem as
% describes in the function hyper_proj_DDS using DDS. The hyperbolic
% polynomials are created using the Vamos like metroids.


clearvars Z A b cons;



  NK=[   20;
         50;
         100;
         200;
         500;
         1000;
         2000;
         3000;
     ];

  if exist('short_version', 'var')
    if short_version
        NK = NK(1:5,:);
    end
  end

 if ~exist('scriptDir_table', 'var')
    scriptDir_table = fileparts(mfilename('fullpath'));   
 end

outfile = fullfile(scriptDir_table, 'Table-3.txt');
fid = fopen(outfile,'a');  % open file in append mode
fprintf(fid, '\n');


n_test = 10;

for it=1:size(NK,1)
    n = NK(it);
    deg = 4; 
    iter_c = [];
    time_DDS = [];

    scriptDir = fileparts(mfilename('fullpath'));
    filename = fullfile(scriptDir, sprintf('c_%d.mat', n));
    load(filename, 'C');

    for it2=1:n_test
        
        x_p = C{it2};
    
    
        poly = generate_vamos_like_slp(n/2);
        e_dir = ones(n,1);
        [x,y,info] = hyper_proj_DDS(x_p,poly,e_dir,n,deg);
    
    
        % cons{1,1}='HB';
        % 
        % %%% here we set the parameters of the polynomial. 
        % num_var= n; % The number of variables in the polynomial.
        % degree=deg; % degree of polynomials. 
        % 
        % 
        % cons{1,2}=[num_var]; 
        % % cons{1,4}='monomial'; % shows the format of the polynomial
        % cons{1,4}='straight_line';
        % % cons{1,3} =  generate_ek_slp(num_var, degree);   
        % cons{1,3} = generate_vamos_like_slp(num_var/2);
        % % cons{1,3} = generate_ek_slp(num_var, degree); 
        % % cons{1,3} = generate_comp_char(rand(num_var_out,num_var), ones(num_var,1), poly);   % lin2slp(rand(5,num_var));
        % cons{1,5}=ones(num_var,1); % a vector in the interior on the hyperbolicity cone defined by p(x) >= 0. 
        % 
        % 
        % A{1,1}=[speye(num_var) zeros(num_var,1)];
        % b{1,1}=zeros(num_var,1); 
        % 
        % 
        % cons{2,1}='SOCP';
        % cons{2,2}=[num_var];
        % 
        % 
        % A{2,1}=[zeros(1,num_var)  1;   speye(num_var)  zeros(num_var,1)];
        % % b{2,1}=[0;randn(num_var,1)];
        % b{2,1}=[0;-x_p];
        % c=[zeros(num_var,1); 1];
        % 
        % [x,y,info]=DDS(c,A,b,cons);
        
      
        iter_c = [iter_c info.iter];
        time_DDS = [time_DDS info.time];
        
    end

  
        fprintf(fid, '  %d  & %d  &  %d    &  %.1f$\\pm$%.1f &  %.2f$\\pm$%.2f   \\\\ \\hline\n', ...
        n/2, n, nchoosek(n,4) - n-2,   ...
               mean(iter_c),std(iter_c), mean(time_DDS), std(time_DDS));


  
end
fclose(fid);