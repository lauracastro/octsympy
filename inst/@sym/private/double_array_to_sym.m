function z = double_array_to_sym(A)
%private helper for sym ctor
%   convert an array to syms, currently on 1D, 2D.

  [n, m] = size(A);

  if (n == 0 || m == 0)
    cmd = { sprintf('return sp.Matrix(%d, %d, []),', n, m) };
    z = python_cmd (cmd);
    return
  end

  Ac = cell(n,1);
  for i=1:n
    % we want all sym creation to go through the ctor.
    Ac{i} = cell(m,1);
    for j=1:m
      Ac{i}{j} = sym(A(i,j));
    end
  end

  %Ac = {{x 2}; {3 4}; {8 9}};

  d = size(A);
  if (length(d) > 2)
    error('conversion not supported for arrays of dim > 2');
  end

  cmd = { 'L = _ins[0]'
          'M = sp.Matrix(L)'
          'return M,' };
  z = python_cmd (cmd, Ac);

