
function [nodes, final_id] = generate_ek_slp(n, k)
% Generate a DAG-style SLP for the elementary symmetric polynomial e_k(x1,...,xn).
% FORMAT (struct array):
%   nodes(t).id    : unique id of the node (> n)
%   nodes(t).op    : 'add' | 'mul'   (only these are needed for e_k)
%   nodes(t).in    : [u, v]          operand ids (0 is the constant one)
%   nodes(t).coef  : scalar          multiplicative coefficient (usually 1)
%
% CONVENTIONS:
%   id = 0 is the constant 1 (f0 = 1), variables x_i have ids 1..n.
%
% OUTPUT:
%   nodes    : struct array encoding the SLP as a DAG
%   final_id : id of the node representing e_k^{(n)} (or a “zero” node if k>n)

    % Running id for new intermediate nodes
    next_id = n;

    % Storage for nodes
    nodes = struct('id', {}, 'op', {}, 'in', {}, 'coef', {});
    function id = add_node(opstr, a, b, coef)
        next_id = next_id + 1;
        nodes(end+1).id   = next_id; %#ok<AGROW>
        nodes(end).op     = opstr;
        nodes(end).in     = [a, b];
        nodes(end).coef   = coef;
        id = next_id;
    end

    % Map (i,k) -> node id for e_k^{(i)}; keys as 'i_k'
    idx_map = containers.Map('KeyType','char','ValueType','int32');

    % Base: e_0^{(i)} = 1 for all i uses id=0 (constant one)
    idx_map("0_0") = 0;
    for i = 1:n
        idx_map(sprintf('%d_%d', i, 0)) = 0;
    end
    % IMPORTANT: we do NOT insert (0,ki) for ki>=1 (those are zero and left absent)

    % Dynamic program over i = 1..n and j = 1..min(k,i)
    for i = 1:n
        for j = 1:min(k, i)
            key = sprintf('%d_%d', i, j);

            if j == 1
                % e_1^{(i)} = x_1 + ... + x_i
                if i == 1
                    idx_map(key) = 1;      % x1
                else
                    prev = idx_map(sprintf('%d_%d', i-1, 1)); % exists
                    xi   = i;                                   % x_i
                    sum_id = add_node('add', prev, xi, 1);
                    idx_map(key) = sum_id;
                end

            else
                % e_j^{(i)} = e_j^{(i-1)} + x_i * e_{j-1}^{(i-1)}
                k1  = sprintf('%d_%d', i-1, j);     % e_j^{(i-1)}
                k2  = sprintf('%d_%d', i-1, j-1);   % e_{j-1}^{(i-1)}
                has1 = isKey(idx_map, k1);
                has2 = isKey(idx_map, k2);

                if ~has1 && ~has2
                    % e_j^{(i)} = 0 (no node stored)
                    continue
                elseif has1 && ~has2
                    % Just carry e_j^{(i-1)}
                    idx_map(key) = idx_map(k1);
                elseif ~has1 && has2
                    % Only product term: x_i * e_{j-1}^{(i-1)}
                    id2    = idx_map(k2);
                    mul_id = add_node('mul', i, id2, 1);
                    idx_map(key) = mul_id;
                else
                    % Both terms present
                    id1    = idx_map(k1);
                    id2    = idx_map(k2);
                    mul_id = add_node('mul', i, id2, 1);
                    sum_id = add_node('add', id1, mul_id, 1);
                    idx_map(key) = sum_id;
                end
            end
        end
    end

    % Return final id (handle zero when k>n)
    fkey = sprintf('%d_%d', n, k);
    if isKey(idx_map, fkey)
        final_id = idx_map(fkey);
    else
        % Build an explicit zero node: 0 * 1  (mul of constant 1 with coef 0)
        % (optional; you can also choose to return final_id = -1 to denote “zero”)
        zero_id = add_node('mul', 0, 0, 0);   % equals 0
        final_id = zero_id;
    end
end


% This part is the code for generating the SLP using the old format. It can
% be used for running with DDS 2.2. 

% function poly = generate_ek_slp(n, k)
% % Generates SLP for e_k(x1,...,xn)
% % Output: poly — each row is [coef, i, j, op] in SLP format
% 
%     % Variable indices: 1 to n for x_1 to x_n
%     next_idx = n;  % indices 1..n are variables
%     poly = [];
% 
%     % Initialize map to store computed e_k^{(i)} at each (i,k)
%     idx_map = containers.Map();
% 
%     % Constant 1 is f_0 (index 0)
%     idx_map("0_0") = 0;
%     for ki = 1:k
%         key = sprintf('%d_%d', 0, ki);
%         idx_map(key) = 0;
%     end
%     for ni = 1:n
%         for ki = 0:min(k, ni)
%             key = sprintf('%d_%d', ni, ki);
%             if ki == 0
%                 idx_map(key) = 0;  % constant 1
%             elseif ki == 1
%                 if ni == 1
%                     idx_map(key) = 1;  % e_1^{(1)} = x_1
%                 else
%                     % e_1^{(ni)} = e_1^{(ni-1)} + x_ni
%                     idx1 = idx_map(sprintf('%d_%d', ni-1, 1));
%                     idx2 = ni;  % x_ni
%                     poly = [poly; 1 idx1 idx2 11];
%                     next_idx = next_idx + 1;
%                     idx_map(key) = next_idx;
%                 end
%             else
%                 % General case: e_k^{(n)} = e_k^{(n-1)} + x_n * e_{k-1}^{(n-1)}
%                 if ni-1 < ki
%                     idx1 = 0;
%                 else
%                     key1 = sprintf('%d_%d', ni-1, ki);
%                     idx1 = idx_map(key1);
%                 end
% 
%                 key2 = sprintf('%d_%d', ni-1, ki-1);
% 
% 
%                 idx2 = idx_map(key2);
% 
%                 % Multiply x_n (index ni) and idx2
%                 poly = [poly; 1 ni idx2 33];
%                 next_idx  = next_idx + 1;
% 
%                 if ni-1  >= ki
%                     poly = [poly; 1 idx1 next_idx 11];
%                     next_idx  = next_idx + 1;
%                 end
%                 idx_map(key) = next_idx;
%             end
%         end
%     end
% end
