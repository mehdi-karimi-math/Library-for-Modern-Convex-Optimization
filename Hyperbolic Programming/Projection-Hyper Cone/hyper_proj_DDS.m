%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Projecting on a hyperbolicty cone using DDS.

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y,info]=hyper_proj_DDS(x_p,poly,e_dir,num_var,deg)
% This function solves the following problem using DDS
% min   t
% s.t.   ||x-c|| <= t
%            x in Lambda(p,e)
% where c is a given vector and Lambda(p,e) is the hyperbolicity cone
% defined by p in the direction e. 
% INPUT:
%   x_p:         given vector 
%   poly:        a hyperbolic polynomial given as a stright-line program
%   e_dir:       direction vector for the hyperbolic polynomial
%   num_var:     number of variables of the polynomial
%   deg:         degree of the polynoimal



    cons{1,1} = 'HB';
    cons{1,2} = [num_var]; 
    cons{1,4} = 'straight_line';
    cons{1,3} = poly;
    cons{1,5} = e_dir; % a vector in the interior on the hyperbolicity cone defined by p(x) >= 0. 
    
    
    A{1,1} = [speye(num_var) zeros(num_var,1)];
    b{1,1} = zeros(num_var,1); 
    
    
    cons{2,1} = 'SOCP';
    cons{2,2} = [num_var];
    A{2,1} = [zeros(1,num_var)  1;   speye(num_var)  zeros(num_var,1)];
    b{2,1} = [0;-x_p];
    c = [zeros(num_var,1); 1];

    [x,y,info] = DDS(c,A,b,cons);

end