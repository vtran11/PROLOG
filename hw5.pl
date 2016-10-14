
% gprolog
% consult('part1Facts.pl').
% consult('hw5.pl').
% consult('test.pl').

%*******************Part1***********************
%1-ok
year_1953_1996_novels(X) :- novel(X,Y), 
                            (Y=1953; Y=1996).


%2-ok
period_1800_1900_novels(X) :- novel(X,Y),
                              Y >= 1800,
                              Y =< 1900.


%3-ok
lotr_fans(F) :- fan(F, N), 
                member(the_lord_of_the_rings,N).


%4-ok
authors(N) :- fan(chandler,L1),
              author(N,L2),
              member(M,L1),
              member(M,L2), !. 

author_names(N) :- author(N,L), authors(N). 


%5-ok
fans(N) :- fan(N,L1),
           author(brandon_sanderson,L2),
           member(M,L1),
           member(M,L2), !.

fans_names(N) :- fan(N,L), fans(N).


%6-ok
mutual_novels(N) :- fan(ross, L1),
                    fan(monica, L2),
                    member(N, L1),
                    member(N, L2).
                    
mutual_novels(N) :- fan(phoebe, L1),
                    fan(monica, L2),
                    member(N, L1),
                    member(N, L2).
                    
mutual_novels(N) :- fan(phoebe, L1),
                    fan(ross, L2),
                    member(N, L1),
                    member(N, L2).




%*******************Part2***********************
%1-ok
isMember(X,[X|Y]).
isMember(X,[L|R]) :- isMember(X,R).


%2-ok
isUnion([],[],[]).
isUnion([],[L|R],[L|R]).
isUnion([L|R],[],[L|R]).

isUnion([L1|R1], Y, Z) :- isMember(L1,Y),!,
                          isUnion(R1,Y, Z).
                          
isUnion([L1|R1], Y, [L1|R2]) :- \+(isMember(L1,Y)),
                                isUnion(R1,Y,R2).


%3-ok
isIntersection([],[],[]).
isIntersection([],[L|R],[]).
isIntersection([L|R],[],[]).

isIntersection([L1|R1],Y,[L1|R2]) :- isMember(L1,Y), !, 
                                     isIntersection(R1,Y,R2).
    
isIntersection([L1|R1], Y, Z) :- \+(isMember(L1,Y)),
                                    isIntersection(R1,Y,Z).


%4-ok
isEqual([],[]).
isEqual([L1|R1],[L2|R2]) :- L1 == L2,!,
                            select(L1,[L1|R1],R1),
                            isEqual(R1,R2).


isEqual([L1|R1],[L2|R2]) :- \+ (L1 == L2), !,
                            isMember(L1,R2),
                            select(L1,[L1|R1],R1),
                            select(L1,[L2|R2],R3),
                            isEqual(R1,R3).


%5- ok
%powerSet([_|R], P) :- powerSet(R,P).
%powerSet([L1|R1],[L2|R2]) :- append([L2|R2],_,[L1|R1]).
%powerSet([],[]).

powerSet(R,P) :- findall( S, sub(S,R), P).
 

sub( [R|Q], [R|W] ) :- sub(Q, W).
sub( [R|Q], [_|W] ) :- append(_, [R|Z], W), sub(Q, Z).
sub( [], []).
sub( [], [_|_]).



%*******************Part3**ok*********************
solve :- go(state(left, left, left, left), state(right, right, right, right),Moves), writeh(Moves).

writeh([]).
writeh([M|Moves]):- write(M),nl, writeh(Moves).

go(Bank1, Bank2,Moves) :- path(Bank1, Bank2, [],Moves).

path(Bank2,Bank2, _,[]).
path(Bank1,Bank2, Path,[M|Moves]) :- arc(M,Bank1,Next),
                                            \+ member(Next,[Bank1|Path]),
                                            path(Next,Bank2, [Bank1|Path], Moves),!.     
opposite(left,right).
opposite(right,left).

unsafe(state(Bank1,Bank2,Bank2,C)) :- opposite(Bank1,Bank2).        %wolf & goat together
unsafe(state(Bank1,W,Bank2,Bank2)) :- opposite(Bank1,Bank2).        %goat & cabbage together

safe(S):- \+ unsafe(S).

arc(take(none,Bank1,Bank2), state(Bank1,W,G,C), state(Bank2,W,G,C)) :- opposite(Bank1,Bank2), 
                                                                       safe(state(Bank2,W,G,C)).

arc(take(goat,Bank1,Bank2), state(Bank1,W,Bank1,C), state(Bank2,W,Bank2,C)) :- opposite(Bank1,Bank2), 
                                                                               safe(state(Bank2,W,Bank2,C)).

arc(take(wolf,Bank1,Bank2), state(Bank1,Bank1,G,C), state(Bank2,Bank2,G,C)) :- opposite(Bank1,Bank2), 
                                                                                safe(state(Bank2,Bank2,G,C)).
                                                                                
arc(take(cabbage,Bank1,Bank2), state(Bank1,W,G,Bank1), state(Bank2,W,G,Bank2)) :- opposite(Bank1,Bank2), 
                                                                                  safe(state(Bank2,W,G,Bank2)).
                  
                 
