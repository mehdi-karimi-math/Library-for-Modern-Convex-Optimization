%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A file for creating Table 1 of the paper

%% Copyright (c) 2025, by 
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars Z A b cons;


NK=[  20   5;  
      20   10;
      20   15;
      50   10;
      50   25;
      50   30;
      100  10;
      100  20;
      100  30;
      200  10;
      200  20;
      200  30;
      500  10;
      500  20;
      500  30;
      1000 10;
      1000 20;
      1000 30;
      2000 10];

 if exist('short_version', 'var')
    if short_version
        NK = NK(1:10,:);
    end
 end

 if ~exist('scriptDir_table', 'var')
    scriptDir_table = fileparts(mfilename('fullpath'));   
 end

 outfile = fullfile(scriptDir_table, 'Table-1.txt');
 fid = fopen(outfile,'a');  % open file in append mode
 fprintf(fid, '\n\n');
 
 for it=1:size(NK,1)
    num_var = NK(it,1);
    degree = NK(it,2);
    scriptDir = fileparts(mfilename('fullpath'));
    filename = fullfile(scriptDir, sprintf('data_%d_%d.mat', num_var, degree));
    load(filename, 'A', 'c', 'b', 'cons');
     
     
    [x,y,info]=DDS(c,A,b,cons);
     
    size_c = length(c)-1;

    fprintf(fid, '(%d,%d)  & %d  & %.1e & 0.5   &  & &  %d  &  %.2f   \\\\ \\hline\n', ...
        num_var, degree, size_c,nchoosek(num_var,degree),   ...
               info.iter, info.time);
   
 end

 fclose(fid);


