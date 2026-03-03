%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projecting on a hyperbolicty cone using DDS.
%% Comparing DDS and Frank-Wolf

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% By running this function, the code solves the projection problem as
% describes in the function hyper_proj_DDS using DDS. The hyperbolic
% polynomials are created using the composition operation.

clearvars Z A b cons;



 NK=[  
      20   10 5;
      50   10 5;
      50   25 5;
      50   30 10;
      100  10 10;
      100  20 10;
      100  30 10;
      200  10 10 ;
      200  20 10 ;
      200  30 10;
      500  10 10;
      500  20 10;
      500  30 20;
      1000 10 10;
      1000 20 10;
      2000 10 10;
      2000 20 10;
      3000 10 10;
      3000 20 10;
      4000 10 10;
      4000 20 10
     ];

 if exist('short_version', 'var')
    if short_version
        NK = NK(1:15,:);
    end
 end

 if ~exist('scriptDir_table', 'var')
    scriptDir_table = fileparts(mfilename('fullpath'));   
 end

outfile = fullfile(scriptDir_table, 'Table-4.txt');
fid = fopen(outfile,'a');  % open file in append mode
fprintf(fid, '\n');


for it=1:size(NK,1)

        n = NK(it,1);
        deg = NK(it,2); 
        m = NK(it,3);

        scriptDir = fileparts(mfilename('fullpath'));
        filename = fullfile(scriptDir, sprintf('data_%d_%d_%d.mat', n, deg, m));
        load(filename, 'c','A','b','cons');

    
        [x,y,info]=DDS(c,A,b,cons);
    
    
        fprintf(fid, '(%d,%d)  &   %.1e    &    (%d,%d)  &  %d & %.2f  \\\\ \\hline\n', ...
        n, deg, nchoosek(n,deg),   n, m,  ...
               info.iter, info.time);
    
end
fclose(fid);