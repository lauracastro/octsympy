%% Copyright (C) 2014 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @deftypefn  {Function File} {@var{Lambda} =} eig (@var{A})
%% @deftypefnx {Function File} {@var{V}, @var{D} =} eig (@var{A})
%% Symbolic eigenvales/eigenvectors of a matrix.
%%
%% FIXME; generalized eigrnvalue problem not supported, check
%% SymPy.
%%
%% @seealso{svd}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function [V, D] = eig(A, B)

  if (nargin >= 2)
    error('eig: generalized eigenvalue problem not implemented')
  end

  if (nargout <= 1)
    cmd = { '(A,) = _ins'
            'if not A.is_Matrix:'
            '    A = sp.Matrix([A])'
            'd = A.eigenvals()'
            'L = []'
            'for (e, m) in d.iteritems():'
            '    L.extend([e]*m)'
            'L = sympy.Matrix(L)'
            'return L,' };

    V = python_cmd (cmd, sym(A));

  else
    % careful, geometric vs algebraic mult, use m
    cmd = { '(A,) = _ins'
            'if not A.is_Matrix:'
            '    A = sp.Matrix([A])'
            'd = A.eigenvects()'
            'V = sp.zeros(A.shape[0], 0)'  % empty
            'L = []'
            'for (e, m, bas) in d:'
            '    L.extend([e]*m)'
            '    if len(bas) < m:'
            '        bas.extend([bas[0]]*(m-len(bas)))'
            '    for v in bas:'
            '        V = V.row_join(v)'
            'D = diag(*L)'
            'return V, D' };

   [V, D] = python_cmd (cmd, sym(A));

  end
end


%!test
%! % basic
%! A = [1 2; 3 4];
%! B = sym(A);
%! sd = eig(A);
%! s = eig(B);
%! s2 = double(s);
%! assert (norm(sort(s2) - sort(sd)) <= 10*eps)

%!test
%! % scalars
%! syms x
%! a = sym(-10);
%! assert (isequal (eig(a), a))
%! assert (isequal (eig(x), x))

%!test
%! % diag, multiplicity
%! A = diag([6 6 7]);
%! B = sym(A);
%! e = eig(B);
%! assert (isequal (size (e), [3 1]))
%! assert (sum(logical(e == 6)) == 2)
%! assert (sum(logical(e == 7)) == 1)

%!test
%! % matrix with symbols
%! syms x y positive
%! A = [x+9 y; sym(0) 6];
%! s = eig(A);
%! s = simplify(s);
%! assert (isequal (s, [x+9; 6]) || isequal (s, [6; x+9]))


%!test
%! % eigenvects
%! e = sym([5 5 5 6 7]);
%! A = diag(e);
%! [V, D] = eig(A);
%! assert (isequal (diag(D), e.'))
%! assert (isequal (V, diag(sym([1 1 1 1 1]))))

%!test
%! % alg/geom mult, eigenvects
%! e = sym([5 5 5 6]);
%! A = diag(e);
%! A(1,2) = 1;
%! [V, D] = eig(A);
%! assert (isequal (diag(D), e.'))
%! assert (sum(logical(V(1,:) ~= 0)) == 2)
%! assert (sum(logical(V(2,:) ~= 0)) == 0)
%! assert (sum(logical(V(3,:) ~= 0)) == 1)
%! assert (sum(logical(V(4,:) ~= 0)) == 1)
