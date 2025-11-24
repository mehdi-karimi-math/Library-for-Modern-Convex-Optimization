%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating the straight-line program of a hyperbolic polyonoial that is the 
%% composition of one hyperbolic polynomial and the characterisitc map of another 
%% one. 

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [nodes, out_id, lambda_ids] = generate_comp_char(M, d, poly)
% GENERATE_COMP_CHAR
% Compose a target SLP q(y1,...,yk) with the characteristic map of
% p(x) = prod_i ell_i(x), where ell_i(x) = sum_j M(i,j) x_j.
%
% INPUTS
%   M    : k-by-n, rows are coefficients of linear forms ell_i(x)
%   d    : n-by-1 direction, must satisfy ell_i(d) ~= 0 for all i
%   poly : struct SLP for q(y_1,...,y_k) in variables y_i (indices 1..k)
%
% OUTPUTS
%   nodes      : struct SLP over x-variables (indices 1..n), then new nodes
%                implementing lambda_i(x) and the copied q block with y_i
%                substituted by lambda_i(x).
%   out_id     : id of the output node of the composed SLP q(lambda(x))
%   lambda_ids : k-by-1 ids of the nodes computing lambda_i(x)
%
% NOTES
% - Variables x_j are addressed by ids 1..n. Constant f0=1 is id 0.
% - We DO NOT multiply the ell_i together. We keep the lambda_i nodes and
%   then concatenate a relabeled copy of 'poly' that uses lambda_i inputs.

    [k, n] = size(M);
    if numel(d) ~= n || size(d,2) ~= 1
        error('d must be n-by-1, with n = size(M,2).');
    end

    if k ~= poly(1).id-1
       error('The number variables in the outer function must be size(M,1).');
    end

    % Precompute denominators ell_i(d) and their inverses.
    ell_d = M * d;                 % k-by-1
    if any(ell_d == 0)
        error('generate_comp_char: ell_i(d) = 0 for some i; composition undefined.');
    end
    cinv = 1 ./ ell_d;             % c_i = 1 / ell_i(d)

    % --- SLP storage and id management ---
    nodes = struct('id', {}, 'op', {}, 'in', {}, 'coef', {});
    next_id = n;  % variables x_1..x_n occupy ids 1..n

    % Helper: append one node, return its new id
    function nid = add_node(opstr, a, b, coef)
        next_id = next_id + 1;
        nodes(end+1).id   = next_id;
        nodes(end  ).op   = opstr;
        nodes(end  ).in   = uint32([a, b]);
        nodes(end  ).coef = coef;
        nid = next_id;
    end

    % Helper: balanced reduction by pairwise 'add' over a list of ids
    function out = reduce_sum(ids)
        if isempty(ids)
            % Return a "zero" node safely: 0 * f0
            out = add_node('mul', 0, 0, 0);
            return;
        end
        cur = ids(:);
        while numel(cur) > 1
            nxt = [];
            if mod(numel(cur),2) == 1
                carry = cur(end);
                cur(end) = [];
            else
                carry = [];
            end
            for t = 1:2:numel(cur)
                left  = cur(t);
                right = cur(t+1);
                nid = add_node('add', left, right, 1);
                nxt = [nxt; nid]; %#ok<AGROW>
            end
            if ~isempty(carry), nxt = [nxt; carry]; end %#ok<AGROW>
            cur = nxt;
        end
        out = cur(1);
    end

    % =============================
    % Phase 1: build ell_i(x)
    % =============================
    L_ids = zeros(k,1);
    for i = 1:k
        term_ids = [];
        for j = 1:n
            a = M(i,j);
            if a ~= 0
                % term = a * x_j  (mul with [x_j, f0], coef=a)
                tid = add_node('mul', j, 0, a);
                term_ids(end+1,1) = tid; %#ok<AGROW>
            end
        end
        L_ids(i) = reduce_sum(term_ids);  % L_i = sum_j M(i,j) x_j
    end

    % =============================
    % Phase 2: build lambda_i(x) = L_i / ell_i(d) = (1/ell_i(d)) * L_i
    % =============================
    lambda_ids = zeros(k,1);
    for i = 1:k
        lambda_ids(i) = add_node('mul', L_ids(i), 0, cinv(i));
    end

    % =============================
    % Phase 3: substitute q(y) with y_i := lambda_i(x)
    % =============================
    %
    % 'poly' is an SLP over variables y_1..y_k (ids 1..k). We copy it,
    % remapping inputs:
    %   input a==0        -> 0
    %   input 1<=a<=k     -> lambda_ids(a)
    %   input a>k (old internal node) -> remapped via old->new map as we go.
    %
    old2new = containers.Map('KeyType','uint32','ValueType','uint32');

    for r = 1:numel(poly)
        a = uint32(poly(r).in(1));
        b = uint32(poly(r).in(2));

        % map input a
        if a == 0
            na = 0;
        elseif a <= k
            na = lambda_ids(double(a));
        else
            if ~isKey(old2new, a)
                error('generate_comp_char: reference to future node (non-topological SLP).');
            end
            na = old2new(a);
        end

        % map input b
        if b == 0
            nb = 0;
        elseif b <= k
            nb = lambda_ids(double(b));
        else
            if ~isKey(old2new, b)
                error('generate_comp_char: reference to future node (non-topological SLP).');
            end
            nb = old2new(b);
        end

        % append copied node with mapped inputs
        new_id = add_node(poly(r).op, na, nb, poly(r).coef);
        old2new(uint32(poly(r).id)) = uint32(new_id);
    end

    % Output id is the id of the last copied node
    out_id = nodes(end).id;

end
