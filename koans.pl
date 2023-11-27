# Last element
last(X, [X]).
last(X, [_|Xs]) :-
  last(X, Xs).

p01_test :-
  last(1, [1]),
  last(3, [1,2,3]).

last_but_one(X, [X,_]).
last_but_one(X, [_|Xs]) :-
  last_but_one(X, Xs).

p02_test :-
  last_but_one(1, [1,2]),
  last_but_one(3, [1,2,3,4]).

nth(X, [X|_], 0).
nth(X, [_|Xs], N) :-
  N_ is N - 1,
  nth(X, Xs, N_).

p03_test :-
  nth(1, [1,2,3], 0),
  nth(3, [1,2,3], 2).

count(0, []).
count(N, [_|Xs]) :-
  count(N1, Xs),
  N is N1 + 1.

p04_test :-
  count(0, []),
  count(1, [1]),
  count(3, [1,2,3]).

concat(Xs, [], Xs).
concat([], Ys, Ys).
concat([X|Xs], Ys, R) :-
  concat(Xs, Ys, Rs),
  R = [X|Rs].

concat_test :-
  concat([], [], []),
  concat([1], [], [1]),
  concat([], [1], [1]),
  concat([1], [2], [1,2]),
  concat([1,2,3], [4,5,6], [1,2,3,4,5,6]).

append(Xs, Y, R) :-
  concat(Xs, [Y], R).

append_test :-
  append([], 1, [1]),
  append([1,2], 3, [1,2,3]).

reverse([], []).
reverse([X|Xs], Ys) :-
  reverse(Xs, R),
  append(R, X, Ys).

p05_test :-
  reverse([], []),
  reverse([1], [1]),
  reverse([1,2,3], [3,2,1]).

is_palindrome(X) :-
  reverse(X, Y),
  X = Y.

p06_test :-
  is_palindrome([1]),
  is_palindrome([1,2,3,2,1]),
  \+ is_palindrome([1,2]).

flatten([], []).
flatten([X|Xs], Ys) :-
  is_list(X),
  flatten(X, R),
  flatten(Xs, Rs),
  concat(R, Rs, Ys).
flatten([X|Xs], Ys) :-
  flatten(Xs, R),
  concat([X], R, Ys).

p07_test :-
  flatten([], []),
  flatten([1], [1]),
  flatten([1,2,3], [1,2,3]),
  flatten([[[[[1]]]]], [1]),
  flatten([1,[2],[[3]]], [1,2,3]),
  flatten([[[[[1,[2],[[3]]]]],[4],5]], [1,2,3,4,5]).

compress([], []).
compress([X], [X]).
compress([X,X|Xs], Ys) :-
  compress([X|Xs], Ys).
compress([X|Xs], Ys) :-
  compress(Xs, R),
  concat([X], R, Ys).

p08_test :-
  compress([], []),
  compress([1], [1]),
  compress([1,2,3], [1,2,3]),
  compress([1,1,2,3], [1,2,3]),
  compress([1,2,3,3,3], [1,2,3]),
  compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [a,b,c,a,d,e]).

transfer(X, [], [], [X]). % append to "return"
transfer(X, [Y|Ys], [Y|Ys], [X]) :- % "append" Y to "return"
  X \= Y.
transfer(X, [X|Xs], Ys, [X|Zs]) :- % "prepend" X to "return", loop
  transfer(X, Xs, Ys, Zs).

pack_consecutive([], []).
pack_consecutive([X|Xs], [Z|Zs]) :-
  transfer(X, Xs, Ys, Z),
  pack_consecutive(Ys, Zs).

p09_test :-
  pack_consecutive([], []),
  pack_consecutive([1], [[1]]),
  pack_consecutive([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]).

head([X|_], X).

packed_run_length([], []).
packed_run_length([X|Xs], R) :-
  packed_run_length(Xs, Rs),
  length(X, L),
  head(X, H),
  concat([[L, H]], Rs, R).

run_length(X, Z) :-
  pack_consecutive(X, Y),
  packed_run_length(Y, Z).

p10_test :-
  run_length([], []),
  run_length([a,a,a,a,b,c,c,a,a,d,e,e,e,e], [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e]]).

packed_strictpos_head([1,X], X).
packed_strictpos_head(X, X).

packed_strictpos_run_length([], []).
packed_strictpos_run_length([X|Xs], Rs) :-
  packed_strictpos_head(X, R),
  packed_strictpos_run_length(Xs, Ys),
  concat([R], Ys, Rs).

strictpos_run_length(X, Z) :-
  run_length(X, Y),
  packed_strictpos_run_length(Y, Z).

p11_test :-
  strictpos_run_length([], []),
  strictpos_run_length([a], [a]),
  strictpos_run_length([a,a], [[2,a]]),
  strictpos_run_length([a,a,a,a], [[4,a]]).

decode_run_length([], []).
decode_run_length([[1,X]|Xs], Rs) :-
  decode_run_length(Xs, R),
  concat([X], R, Rs).
decode_run_length([[N,X]|Xs], Rs) :-
  N > 1,
  Ns is N - 1,
  decode_run_length([[Ns,X]|Xs], R),
  concat([X], R, Rs).

p12_test :-
  decode_run_length([], []),
  decode_run_length([[1,a]], [a]),
  decode_run_length([[4,a]], [a,a,a,a]).
  % TODO more tests
  % TODO why does `decode_run_length([[2,a]], X)` give 3 different `X` values?

p13_test. % TODO

duplicate([], []).
duplicate([X|Xs], R) :-
  duplicate(Xs, Ys),
  concat([X,X], Ys, R).

p14_test :-
  duplicate([], []),
  duplicate([a], [a,a]),
  duplicate([a,b,c], [a,a,b,b,c,c]).

p15_test.
p16_test.
p17_test.
p18_test.
p19_test.
p20_test.
p21_test.
p22_test.
p23_test.
p24_test.
p25_test.
p26_test.
p27_test.
p28_test.
p29_test.
p30_test.
p31_test.
p32_test.
p33_test.
p34_test.
p35_test.
p36_test.
p37_test.
p38_test.
p39_test.
p40_test.
p41_test.
p42_test.
p43_test.
p44_test.
p45_test.
p46_test.
p47_test.
p48_test.
p49_test.
p50_test.

all :-
  concat_test,
  append_test,
  p01_test,
  p02_test,
  p03_test,
  p04_test,
  p05_test,
  p06_test,
  p07_test,
  p08_test,
  p09_test,
  p10_test,
  p11_test,
  p12_test,
  p13_test,
  p14_test,
  p15_test,
  p16_test,
  p17_test,
  p18_test,
  p19_test,
  p20_test,
  p21_test,
  p22_test,
  p23_test,
  p24_test,
  p25_test,
  p26_test,
  p27_test,
  p28_test,
  p29_test,
  p30_test,
  p31_test,
  p32_test,
  p33_test,
  p34_test,
  p35_test,
  p36_test,
  p37_test,
  p38_test,
  p39_test,
  p40_test,
  p41_test,
  p42_test,
  p43_test,
  p44_test,
  p45_test,
  p46_test,
  p47_test,
  p48_test,
  p49_test,
  p50_test.
