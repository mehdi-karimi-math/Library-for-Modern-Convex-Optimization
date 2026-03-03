%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparing DDS with the homotopy method and SDP relaxations for the problem
%% introduced in Klingler-Netzer (2025)
%%  max  f(x)
%%  s.t.   x in Lambda(p,e)+[e+{x: e^t*x = 0}]
%% where p is an elementary symmetric polynomial. 

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('scriptDir_table', 'var')
    scriptDir_table = fileparts(mfilename('fullpath'));   
end


n_trial = 10;
x_DDS = 3:20;
y_DDS=[];
for n = x_DDS
    y_DDS = [y_DDS DDS_time_rec(n,n-1,n_trial)];
end
x_hom = 2:11;
y_hom = [0.55 .6 1 2 7 18 22 40 55 110] ;   % Data extracted from Figure 5 in Klingler-Netzer (2025)
x_SDP = 2:5;
y_SDP = [.017 .023 .09 100];
clf;
semilogy(x_hom, y_hom, '-o','linewidth',2);
hold on;
semilogy(x_SDP, y_SDP, '--','linewidth',2);
semilogy(x_DDS, y_DDS, 'linewidth',2);
xlabel('Dimension n');
ylabel('Runetime in s');
legend('Homptopy', 'SDP relax', 'DDS')
grid on;
saveas(gcf,fullfile(scriptDir_table, 'Homo-1.png'))


x_DDS = 3:20;
y_DDS=[];
for n = x_DDS
    y_DDS = [y_DDS DDS_time_rec(n,floor((n+1)/2),n_trial)];
end
x_hom = 3:9;
y_hom = [0.55 1.1 3 7 21 50 150] ;  % Data extracted from Figure 5 in Klingler-Netzer (2025)
x_SDP = 3:6;
ySDP = [.07 .055 .17 .45];
clf;
semilogy(x_hom, y_hom, '-o','linewidth',2);
hold on;
semilogy(x_SDP, y_SDP, '--','linewidth',2);
semilogy(x_DDS, y_DDS, 'linewidth',2);
ylim([.01 200])
xlim([3 20])
xlabel('Dimension n');
ylabel('Runetime in s');
legend('Homptopy', 'SDP relax', 'DDS')
grid on;
saveas(gcf,fullfile(scriptDir_table, 'Homo-2.png'))



function t=DDS_time_rec(n,k,n_trial)
    clearvars Z A b cons;
    
    
    %%% here we set the parameters of the polynomial. 
    num_var= n; % The number of variables in the polynomial.
    degree=k; % degree of polynomials. 
    
    
    cons{1,1}='HB';
    cons{1,2}=[num_var]; 
    cons{1,4}='straight_line';
    cons{1,3} = generate_ek_slp(num_var, degree); 
    cons{1,5}=ones(num_var,1); % a vector in the interior on the hyperbolicity cone defined by p(x) >= 0. 
    
    A{1,1}=[speye(num_var-1); -ones(1,num_var-1)];
    b{1,1}=ones(num_var,1); 
    
    time = 0;
    for i=1:n_trial
        c=[randn(num_var-1,1)];
        [x,y,info]=DDS(c,A,b,cons);
        time = time+info.time;
    end

    t = time/n_trial;
    
end