% User query for restaurant recommendations

% pricing(Input, End, ToFilter, Filtered) is true if Filtered is a list of restaurants filtered by Input from ToFilter
pricing([], Res, Res).
pricing(_, [], []).
pricing(P, [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    pricing(P, Rs, R2),
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
pricing(P1, [restaurant(_,_,P2,_,_,_,_) | Rs], Res) :-
    dif(P1, P2),
    pricing(P1, Rs, Res).

% rating()
rating([], Res, Res).
rating(_, [], []).
rating((L-U), [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    R >= L,
    R =< U,
    rating((L-U), Rs, R2),
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
rating((L-U), [restaurant(_,_,_,_,R,_,_) | Rs], Res) :-
    (R < L;
    R > U),
    rating((L-U), Rs, Res).

% total_ifs()
total_ifs([], Res, Res).
total_ifs(_, [], []).
total_ifs(TI, [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    total_ifs(TI, Rs, R2),
    T =< TI,
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
total_ifs(TI, [restaurant(_,_,_,_,_,T,_) | Rs], Res) :-
    T > TI,
    total_ifs(TI, Rs, Res).

% crit_ifs()
crit_ifs([], Res, Res).
crit_ifs(_, [], []).
crit_ifs(CI, [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    crit_ifs(CI, Rs, R2),
    C =< CI,
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
crit_ifs(CI, [restaurant(_,_,_,_,_,_,C) | Rs], Res) :-
    C > CI,
    crit_ifs(CI, Rs, Res).

% query(pricing, rating, total_ifs, crit_ifs) is true when ...
query(Pricing, Rating, Total_ifs, Crit_ifs, A) :-
    cached_yelp_data(Data),
    Businesses = Data.get(businesses),
    r_update_all_ifs(Businesses, MyRs),
    pricing(Pricing, MyRs, A1),
    rating(Rating, A1, A2),
    total_ifs(Total_ifs, A2, A3),
    crit_ifs(Crit_ifs, A3, A).

% To get the input from a line:

q(Ans) :-
    writeln("Restaurant recommender in the UBC area."),
    writeln("What is your critera? Press enter if you do not wish to filter by the given critera."),

    flush_output(current_output),

    writeln("Pricing? ($ - $$$)"), 
    readln(Ln_pricing),

    writeln("Please give rating (0.0-5.0, in 0.5 increments) lower and upper bounds, eg. 1.5-4.0"), 
    readln(Ln_rating),

    writeln("Maximum number of total safety infractions?"), 
    readln(Ln_total_ifs),

    writeln("Maximum number of critical safety infractions?"), 
    readln(Ln_crit_ifs),

    query(Ln_pricing, Ln_rating, Ln_total_ifs, Ln_crit_ifs, Ans).
    %member(End,[[],['?'],['.']]).