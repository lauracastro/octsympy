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
%% @deftypefn  {Function File} {@var{y} =} end (@var{x})
%% Overloaded end for sym arrays.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function r = end (obj, index_pos, num_indices)

  if ~(isscalar(index_pos))
    error('can this happen?')
  end

  if (num_indices == 1)
    r = numel(obj);
  elseif (num_indices == 2)
    d = size(obj);
    r = d(index_pos);
  else
    obj
    index_pos
    num_indices
    error('now whut?');
  end

end


%!test
%! % scalar
%! syms x
%! y = x(1:end);
%! assert (isequal (x, y))

%!test
%! % vector
%! syms x
%! A = [1 2 x 4];
%! y = A(end-1:end);
%! assert (isequal (y, [x 4]))

%!test
%! % subset of matrix
%! syms x
%! A = [1 2 x; x 3 9; 4 x*x 6];
%! y = A(end,1:end-1);
%! assert (isequal (y, [4 x*x]))

%!test
%! % linear index of matrix
%! syms x
%! A = [1 2 x; x 3 9];
%! y = A(end);
%! assert (isequal (y, sym(9)))
