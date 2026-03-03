function poly = generate_vamos_like_slp(m)
% Build an SLP for:
% p(x) = e4^{(2m)}(x1,...,x_{2m})
%        - sum_{k=2}^m (x1*x2*x_{2k-1}*x_{2k})
%        - sum_{k=2}^{m-1} (x_{2k-1}*x_{2k}*x_{2k+1}*x_{2k+2})
%
% SLP row format: [coef, i, j, op] with op: 11(+), 22(-), 33(*), 44(^)
%
% Requires: generate_ek_slp(n, 4) which returns an SLP for e4^{(n)}.

    n = 2*m;                 % number of variables x1..x_{2m}

    % --- Part 1: e4^{(2m)} via your generator ---
    poly = generate_ek_slp(n, 4);
    % Index of e4 output (last row’s output index):
    e4_idx = n + length(poly);

    % Helper to append one SLP row and get its output node index
    function idx = add_row(coef, i, j, op)
        poly(end+1).id = length(poly)+1+n;
        poly(end).op = op;
        poly(end).in= [i,j];
        poly(end).coef = coef;
        idx = n + length(poly);
    end

    % --- Part 2: Precompute pair products y_k = x_{2k-1} * x_{2k} (k=1..m) ---
    y_idx = zeros(m,1);
    for k = 1:m
        i = 2*k - 1;      % x_{2k-1}
        j = 2*k;          % x_{2k}
        y_idx(k) = add_row(1, i, j, 'mul');   % y_k = x_{2k-1} * x_{2k}
    end

    % --- Part 3: First correction sum S1 = sum_{k=2}^m (x1*x2*x_{2k-1}*x_{2k})
    %           = sum_{k=2}^m (y_1 * y_k)
    if m >= 2
        % First term: y1 * y2
        term = add_row(1, y_idx(1), y_idx(2), 'mul');
        S1_idx = term;
        % Accumulate remaining: + y1*y_k for k=3..m
        for k = 3:m
            term = add_row(1, y_idx(1), y_idx(k), 'mul');
            S1_idx = add_row(1, S1_idx, term, 'add');  % S1 = S1 + term
        end
    else
        % Degenerate (m=1): sum is empty, treat as 0 by pointing to constant f0
        S1_idx = 0;  % your code treats index 0 as constant 1; here we only use it if needed
    end

    % --- Part 4: Second correction sum S2 = sum_{k=2}^{m-1} (y_k * y_{k+1}) ---
    if m >= 3
        % First term: y2 * y3
        term = add_row(1, y_idx(2), y_idx(3), 'mul');
        S2_idx = term;
        % Accumulate remaining: + y_k*y_{k+1} for k=3..m-1
        for k = 3:(m-1)
            term = add_row(1, y_idx(k), y_idx(k+1), 'mul');
            S2_idx = add_row(1, S2_idx, term, 'add');  % S2 = S2 + term
        end
    else
        % Empty sum when m<=2
        S2_idx = 0;
    end

    % --- Part 5: Combine: p = e4 - S1 - S2
    % If S1 or S2 are "empty", skip the subtraction. Otherwise, use op=22 (sub).
    out_idx = e4_idx;
    if m >= 2
        out_idx = add_row(1, out_idx, S1_idx, 'sub');   % e4 - S1
    end
    if m >= 3
        out_idx = add_row(1, out_idx, S2_idx, 'sub');   % (e4 - S1) - S2
    end

    % 'poly' now ends with the final node 'out_idx' implementing the Vámos-like polynomial.
end




% function poly = generate_vamos_like_slp(m)
% % Build an SLP for:
% % p(x) = e4^{(2m)}(x1,...,x_{2m})
% %        - sum_{k=2}^m (x1*x2*x_{2k-1}*x_{2k})
% %        - sum_{k=2}^{m-1} (x_{2k-1}*x_{2k}*x_{2k+1}*x_{2k+2})
% %
% % SLP row format: [coef, i, j, op] with op: 11(+), 22(-), 33(*), 44(^)
% %
% % Requires: generate_ek_slp(n, 4) which returns an SLP for e4^{(n)}.
% 
%     n = 2*m;                 % number of variables x1..x_{2m}
% 
%     % --- Part 1: e4^{(2m)} via your generator ---
%     poly = generate_ek_slp(n, 4);
%     % Index of e4 output (last row’s output index):
%     e4_idx = n + size(poly, 1);
% 
%     % Helper to append one SLP row and get its output node index
%     function idx = add_row(coef, i, j, op)
%         poly(end+1, :) = [coef, i, j, op];
%         idx = n + size(poly, 1);
%     end
% 
%     % --- Part 2: Precompute pair products y_k = x_{2k-1} * x_{2k} (k=1..m) ---
%     y_idx = zeros(m,1);
%     for k = 1:m
%         i = 2*k - 1;      % x_{2k-1}
%         j = 2*k;          % x_{2k}
%         y_idx(k) = add_row(1, i, j, 33);   % y_k = x_{2k-1} * x_{2k}
%     end
% 
%     % --- Part 3: First correction sum S1 = sum_{k=2}^m (x1*x2*x_{2k-1}*x_{2k})
%     %           = sum_{k=2}^m (y_1 * y_k)
%     if m >= 2
%         % First term: y1 * y2
%         term = add_row(1, y_idx(1), y_idx(2), 33);
%         S1_idx = term;
%         % Accumulate remaining: + y1*y_k for k=3..m
%         for k = 3:m
%             term = add_row(1, y_idx(1), y_idx(k), 33);
%             S1_idx = add_row(1, S1_idx, term, 11);  % S1 = S1 + term
%         end
%     else
%         % Degenerate (m=1): sum is empty, treat as 0 by pointing to constant f0
%         S1_idx = 0;  % your code treats index 0 as constant 1; here we only use it if needed
%     end
% 
%     % --- Part 4: Second correction sum S2 = sum_{k=2}^{m-1} (y_k * y_{k+1}) ---
%     if m >= 3
%         % First term: y2 * y3
%         term = add_row(1, y_idx(2), y_idx(3), 33);
%         S2_idx = term;
%         % Accumulate remaining: + y_k*y_{k+1} for k=3..m-1
%         for k = 3:(m-1)
%             term = add_row(1, y_idx(k), y_idx(k+1), 33);
%             S2_idx = add_row(1, S2_idx, term, 11);  % S2 = S2 + term
%         end
%     else
%         % Empty sum when m<=2
%         S2_idx = 0;
%     end
% 
%     % --- Part 5: Combine: p = e4 - S1 - S2
%     % If S1 or S2 are "empty", skip the subtraction. Otherwise, use op=22 (sub).
%     out_idx = e4_idx;
%     if m >= 2
%         out_idx = add_row(-1, out_idx, S1_idx, 33);   % e4 - S1
%     end
%     if m >= 3
%         out_idx = add_row(-1, out_idx, S2_idx, 33);   % (e4 - S1) - S2
%     end
% 
%     % 'poly' now ends with the final node 'out_idx' implementing the Vámos-like polynomial.
% end
