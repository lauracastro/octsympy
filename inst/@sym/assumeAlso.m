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
%% @deftypefn  {Function File} {} assumeAlso (@var{x}, @var{cond})
%% @deftypefnx {Function File} {@var{x} =} assumeAlso (@var{x}, @var{cond})
%% Add additional assumptions on a symbolic variable.
%%
%% Note: operates on the caller's workspace via evalin/assignin.
%% So if you call this from other functions, it will operate in
%% your function's  workspace (not the @code{base} workspace).
%%
%% FIXME: idea of rewriting all sym vars is a bit of a hack, not
%% well tested (for example, with global vars.)
%%
%% @seealso{assume, assumptions, sym, syms}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function varargout = assumeAlso(x, cond, varargin)

  [tilde,ca] = assumptions(x, 'dict');

  if isempty(ca)
    ca = [];
  elseif (length(ca)==1)
    ca = ca{1};
  else
    ca
    error('expected at most one dict')
  end

  ca.(cond) = true;

  xstr = x.flat;
  newx = sym(xstr, ca);

  % ---------------------------------------------
  % Muck around in the caller's namespace, replacing syms
  % that match 'xstr' (a string) with the 'newx' sym.
  %xstr =
  %newx =
  context = 'caller';
  % ---------------------------------------------
  S = evalin(context, 'whos');
  evalin(context, '[];');  % clear 'ans'
  for i = 1:numel(S)
    obj = evalin(context, S(i).name);
    [newobj, flag] = symreplace(obj, xstr, newx);
    if flag, assignin(context, S(i).name, newobj); end
  end
  % ---------------------------------------------

  if (nargout > 0)
    varargout{1} = newx;
  end
end


%!test
%! syms x
%! assumeAlso(x, 'positive')
%! a = assumptions(x);
%! assert(strcmp(a, 'x: positive'))

%!test
%! syms x positive
%! assumeAlso(x, 'integer')
%! [tilde,a] = assumptions(x, 'dict');
%! assert(a{1}.integer)
%! assert(a{1}.positive)
