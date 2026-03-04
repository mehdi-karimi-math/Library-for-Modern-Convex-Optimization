%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Table 7 of the manuscript.

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


file_list={
     'VL-Entr-1',
     'VL-Entr-2',
     'HPLin-Entr-1',
     'HPLinDer-Entr-1',
     'HPLinDer-pn-1',
     'Elem-Entr-10-2'
};

if ~exist('scriptDir_table', 'var')
    scriptDir_table = fileparts(mfilename('fullpath'));   
 end

outfile = fullfile(scriptDir_table, 'Table-7.txt');
fid = fopen(outfile,'a');  % open file in append mode
fprintf(fid, '\n');

for it=1:size(file_list,1)
    scriptDir= fileparts(mfilename('fullpath'))
    outputFile = fullfile(scriptDir, 'mat-files', file_list{it});
    load(outputFile);
    
    for k=1:size(cons,1)
        if strcmp(cons{k,1},'HB')
           if strcmp(cons{k,4},'straight_line')
              cons{k,3} = slp_old2new(cons{k,3}, length(cons{k,5}))
           end
        end
    end
    
    
    [x,y,info]=DDS(c,A,b,cons);

    fprintf(fid, '%s   &  &   &  &  %d/   %.1f   \\\\ \\hline\n', ...
           file_list{it} , info.iter, info.time);

end

fclose(fid);


function polyS = slp_old2new(polyM, n)
% Convert old DDS SLP matrix [coef i j op] into new DDS struct format.
%
% INPUTS:
%   polyM : (m x 4) numeric matrix, each row [coef, i, j, op]
%   n     : number of variables (node ids 1..n are variables)
%
% OUTPUT:
%   polyS : struct array with fields: id, op, in, coef
%
% NOTES:
%   - Variables keep ids 1..n.
%   - The output node id of row k is n+k.
%   - This matches your helper:
%       poly(end+1).id = length(poly)+n;
%       idx = n + length(poly);

    if size(polyM,2) ~= 4
        error('polyM must be an m-by-4 matrix: [coef i j op].');
    end

    m = size(polyM,1);

    % Preallocate struct array (important for speed)
    polyS(m,1) = struct('id', [], 'op', '', 'in', [0 0], 'coef', []);

    for k = 1:m
        coef = polyM(k,1);
        i    = polyM(k,2);
        j    = polyM(k,3);
        opc  = polyM(k,4);

        % Map opcode numbers to strings
        switch opc
            case 11
                opstr = 'add';
            case 22
                opstr = 'sub';
            case 33
                opstr = 'mul';
            otherwise
                error('Unsupported opcode %g at row %d (expected 11/22/33).', opc, k);
        end

        polyS(k).id   = n + k;      % row k produces node id n+k
        polyS(k).op   = opstr;
        polyS(k).in   = [i, j];     % same ids as old format
        polyS(k).coef = coef;       % scalar coefficient
    end
end