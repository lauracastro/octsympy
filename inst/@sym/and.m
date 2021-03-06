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
%% @deftypefn {Function File} {@var{z} =} and (@var{x}, @var{y})
%% Logical and of symbolic arrays.
%%
%% @seealso{or, not, xor, eq, ne, logical, isAlways, isequal}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function r = and(x, y)

    r = binop_helper(x, y, 'lambda a,b: And(a, b)');

end


%!shared t, f
%! t = sym(true);
%! f = sym(false);

%!test
%! % simple
%! assert (isequal (t & f, f))
%! assert (isequal (t & t, t))

%!test
%! % mix wih nonsym
%! assert (isequal (t & false, f))
%! assert (isequal (t & true, t))
%! assert (isequal (t & 0, f))
%! assert (isequal (t & 6, t))
%! assert (isa (t & false, 'sym'))
%! assert (isa (t & 6, 'sym'))

%!test
%! % array
%! w = [t t f f];
%! z = [t f t f];
%! assert (isequal (w & z, [t f f f]))

%!test
%! % number
%! assert (isequal( sym(5) & t, t))
%! assert (isequal( sym(0) & t, f))

%!xtest
%! % output is sym even for scalar t/f
%! % ₣IXME: should match other bool fcns
%! assert (isa (t & f, 'sym'))

%!test
%! % eqns, exclusive
%! syms x
%! e = (x == 3) & (x^2 == 9);
%! assert (isequal (subs(e, x, [-3 0 3]), [f f t]))

