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
%% @deftypefn {Function File}  {@var{s} =} priv_disp_name (@var{x})
%% A string appropriate for representing the name of this sym.
%%
%% Private method: this is not the method you are looking for.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function s = priv_disp_name(x, input_name)

  s = input_name;
  % (subclasses might do something more interesting)

end


%!test
%! syms x
%! s = priv_disp_name(x, 'x');
%! assert (strcmp (s, 'x'))