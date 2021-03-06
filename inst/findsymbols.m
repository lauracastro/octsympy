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
%% @deftypefn  {Function File} {@var{l} =} findsymbols (@var{x})
%% Return a list (cell array) of the symbols in an expression.
%%
%% The list is sorted alphabetically.  Note the order is not the
%% same as @code{symvar} and @code{findsym}: use one of those if
%% Matlab Symbolic Math Toolbox compatibility is important.
%%
%% If two variables have the same symbol but different assumptions,
%% they will both appear in the output.  It is not well-defined
%% in what order they appear.
%%
%% @var{x} could be a sym, sym array, cell array, or struct.
%%
%% Note E, I, pi, etc are not counted as symbols.
%%
%% @seealso{symvar, findsym}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function L = findsymbols(obj, dosort)

  if nargin == 1
    dosort = true;
  end

  if isa(obj, 'sym')
    cmd = { 'x = _ins[0]'
            '#s = x.free_symbols'   % in 0.7.5-git
            'if not x.is_Matrix:'
            '    s = x.free_symbols'
            'else:'
            '    s = set()'
            '    for i in x.values():'
            '        s = s.union(i.free_symbols)'
            'l = list(s)'
            'l = sorted(l, key=str)'
            'return l,' };
    L = python_cmd (cmd, obj);
    if isa(obj, 'symfun')
      warning('FIXME: need to do anything special for symfun vars?')
    end


  elseif iscell(obj)
    %fprintf('Recursing into a cell array of numel=%d\n', numel(obj))
    L = {};
    for i=1:numel(obj)
      temp = findsymbols(obj{i}, false);
      if ~isempty(temp)
        L = {L{:} temp{:}};
      end
    end


  elseif isstruct(obj)
    %fprintf('Recursing into a struct array of numel=%d\n', numel(obj))
    L = {};
    fields = fieldnames(obj);
    for i=1:numel(obj)
      for j=1:length(fields)
        thisobj = getfield(obj, {i}, fields{j});
        temp = findsymbols(thisobj, false);
        if ~isempty(temp)
          L = {L{:} temp{:}};
        end
      end
    end

  else
    L = {};
  end


  % sort and make unique using internal representation
  if dosort
    Ls = {};
    for i=1:length(L)
      Ls{i} = char(L{i});
    end
    [tilde, I] = unique(Ls);
    L = L(I);
  end
end


%!test
%! syms x b y n a arlo
%! z = a*x + b*pi*sin (n) + exp (y) + exp (sym (1)) + arlo;
%! s = findsymbols (z);
%! assert (isequal ([s{:}], [a,arlo,b,n,x,y]))
%!test
%! syms x
%! s = findsymbols (x);
%! assert (isequal (s{1}, x))
%!test
%! syms z x y a
%! s = findsymbols ([x y; 1 a]);
%! assert (isequal ([s{:}], [a x y]))
%!assert (isempty (findsymbols (sym (1))))
%!assert (isempty (findsymbols (sym ([1 2]))))
%!assert (isempty (findsymbols (sym (nan))))
%!assert (isempty (findsymbols (sym (inf))))
%!assert (isempty (findsymbols (exp (sym (2)))))

%!test
%! % diff. assumptions make diff. symbols
%! x1 = sym('x');
%! x2 = sym('x', 'positive');
%! f = x1*x2;
%! assert (length (findsymbols (f)) == 2)

%!test
%! % symfun or sym
%! syms x f(y)
%! a = f*x;
%! b = f(y)*x;
%! c(y) = x;
%! assert (isequal (findsymbols(a), {x y}))
%! assert (isequal (findsymbols(b), {x y}))

%!xtest
%! % FIXME: symfun, yes need to do sth special or doc, see smt in symvar
%! syms a x y
%! f(x, y) = a;  % const symfun
%! assert (isequal (findsymbols(f), {a x y}))

%!test
%! % sorts lexigraphically, same as symvar *with single input*
%! % (note symvar does something different with 2 inputs).
%! syms A B a b x y X Y
%! f = A*a*B*b*y*X*Y*x;
%! assert (isequal (findsymbols(f), {A B X Y a b x y}))
%! assert (isequal (symvar(f), [A B X Y a b x y]))
