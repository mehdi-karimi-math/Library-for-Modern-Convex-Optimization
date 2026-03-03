%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Minimizing quantum relative entropy subject to hyperbolic and linear constraints.

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This code solve the following optimization problem
%       min    qre(I+x_1*A_1+...+x_m*A_m, I+y_1*B_1+...+y_m*B_m)
%       s.t.   x \in Lambda(p,e)
%              x >= gamma
% where qre(X,Y) is the quantum relative entropy of two symmetric
% functions, and Lambda(p,e) is the hyperbolicity cone created by 
% p in the direction of e. In this file, p is the elementray symmetric
% polynoial with parametr (m,k). 

 clearvars Z A b cons;

 NK=[10 10 5 .1;
     10 10 5 1;
     20 10 5 .1;
     20 10 5 1;
     30 50 10 .1;
     30 50 10 1;
     30 100 10 .1;
     30 100 10 1;
     50 50 10 .1;
     50 50 10 1;
     50 200 10 .1;
     50 200 10 1;
     100 50 10 .1;
     100 50 10 1;
     100 500 10 .1;
     100 500 10 1;
     100 1000 10 .1;
     100 1000 10 1;
 ];
 
 if exist('short_version', 'var')
    if short_version
        NK = NK(1:14,:);
    end
 end

 if ~exist('scriptDir_table', 'var')
    scriptDir_table = fileparts(mfilename('fullpath'));   
 end

outfile = fullfile(scriptDir_table, 'Table-5.txt');
fid = fopen(outfile,'a');  % open file in append mode
fprintf(fid, '\n');


 for it=1:size(NK,1)
     
     k = NK(it,1);
     num_var = NK(it,2); % The number of variables in the polynomial.
     degree = NK(it,3);  % degree of polynomials. 
     gamma = NK(it,4);
     
    
     scriptDir = fileparts(mfilename('fullpath'));
     if gamma == .1
          filename = fullfile(scriptDir, sprintf('data_%d_%d_%d.mat', k, num_var, degree));
     elseif gamma == 1
         filename = fullfile(scriptDir, sprintf('data_%d_%d_%d_infea.mat', k, num_var, degree));
     end
     load(filename, 'c','A','b','cons');
    
    
     [x,y,info]=DDS(c,A,b,cons);
     

     if info.status == 1
         fprintf(fid, '%d   &  %d   &   %d  &   %.1f & Opt Soln & %d   &   %.1f   \\\\ \\hline\n', ...
            k, num_var, degree, gamma, info.iter, info.time);
     else 
         fprintf(fid, '%d   &  %d   &   %d  &   %.1f & Infeasible & %d   &   %.1f   \\\\ \\hline\n', ...
            k, num_var, degree, gamma, info.iter, info.time);
     end



 end

 fclose(fid);