%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solving an optimization problem subject to two hyperbolic constraints.
%% Specifically:
%%                min  sum(x-y)  or sum(x+y)
%%                          x in Lambda(p_1,e_1),
%%                          y in Lambda(p_2,e_2),
%% The problem is unbounded for min  sum(x-y) and has an optimal solution for 
%% min  sum(x+y)

%% Copyright (c) 2025, by 
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 clearvars c A b cons;

NK=[  20   5  3;  
      20   10 5;
      20   15  10;
      50   10  5;
      50   25 10;
      50   30 20;
      100  10 5;
      100  20 10;
      100  30 20;
      200  10 5;
      200  20 10;
      200  30 20;
      500  10 5;
      500  20 10;
      500  30 20;
      ];

 if exist('short_version', 'var')
    if short_version
        NK = NK(1:12,:);
    end
 end

 if ~exist('scriptDir_table', 'var')
       scriptDir_table = fileparts(mfilename('fullpath')); 
 end
 

 outfile = fullfile(scriptDir_table, 'Table-6.txt');
 fid = fopen(outfile,'a');  % open file in append mode
 fprintf(fid, '\n\n');
 
 for it=1:size(NK,1)
     for cas = 1:2
        num_var = NK(it,1);
        degree = NK(it,2);
        degree2 = NK(it,3);
        n = num_var;           % number of variables of the hyperbolic polynomial
       
         
        A_HB = eye(num_var,num_var); 
        b_HB = zeros(n,1);                
        
        
        % Defining the first HB constraint 
        cons{1,1}='HB';
        cons{1,2}=[n]; 
        cons{1,4}='straight_line';
        cons{1,3} =  generate_ek_slp(n, degree);
        cons{1,5}=ones(n,1); % a vector in the interior on the hyperbolicity cone defined by p(x) >= 0. 
        
        
        A{1,1}=[A_HB zeros(n,n)];
        b{1,1}=b_HB; %round(rand(n,1));
        
        % Defining the second HB constraint 
        cons{2,1}='HB';
        cons{2,2}=[n]; 
        cons{2,4}='straight_line';
        cons{2,3} =  generate_ek_slp(n, degree2);
        cons{2,5}=ones(n,1); % a vector in the interior on the hyperbolicity cone defined by p(x) >= 0. 
        
        
        A{2,1}=[zeros(n,n) A_HB]; % zeros(n,1)];
        b{2,1}=b_HB; %round(rand(n,1));
        
  
    
        
        % c=[zeros(num_var,1); -1];
        if cas == 1
            c=[ones(num_var,1) ; ones(num_var,1)];
        else
            c=[ones(num_var,1) ; -ones(num_var,1)];
        end
        [x,y,info]=DDS(c,A,b,cons);
     
       
        if cas == 1
          fprintf(fid, ' %d & %d  & %d    & Opt Soln   &    %d  &  %.2f   \\\\ \\hline\n', ...
            num_var, degree, degree2,    ...
                   info.iter, info.time);
        else
           
         fprintf(fid, ' %d & %d  & %d    & Unbounded   &    %d  &  %.2f   \\\\ \\hline\n', ...
            num_var, degree, degree2,    ...
                   info.iter, info.time);
        end
     end
   
 end

 fclose(fid);