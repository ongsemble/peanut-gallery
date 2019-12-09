:- use_module(rest).
:- use_module(reader).

% User query for restaurant recommendations

% pricing(Input, ToFilter, Filtered) is true if Filtered is a list of restaurants such that ToFilter is filtered by Input
pricing([], Res, Res).
pricing("N/A", Res, Res).
pricing(_, [], []).
pricing(PR, [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    pricing(PR, Rs, R2),
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
pricing(PR1, [restaurant(_,_,_,PR2,_,_,_) | Rs], Res) :-
    dif(PR1, PR2),
    pricing(PR1, Rs, Res).

% rating(Input, ToFilter, Filtered) is true if Filtered is a list of restaurants such that ToFilter is filtered by Input
rating([], Res, Res).
rating("N/A", Res, Res).
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

% total_ifs(Input, ToFilter, Filtered) is true if Filtered is a list of restaurants such that ToFilter is filtered by Input
total_ifs([], Res, Res).
total_ifs("N/A", Res, Res).
total_ifs(_, [], []).
total_ifs(TI, [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    number_string(TIN,TI),
    number_string(TN, T),
    total_ifs(TI, Rs, R2),
    TN =< TIN,
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
total_ifs(TI, [restaurant(_,_,_,_,_,T,_) | Rs], Res) :-
    number_string(TIN, TI),
    number_string(TN, T),
    TN > TIN,
    total_ifs(TI, Rs, Res).

% crit_ifs(Input, ToFilter, Filtered) is true if Filtered is a list of restaurants such that ToFilter is filtered by Input
crit_ifs([], Res, Res).
crit_ifs("N/A", Res, Res).
crit_ifs(_, [], []).
crit_ifs(CI, [restaurant(N,A,P,PR,R,T,C) | Rs], Res) :-
    number_string(CIN, CI),
    number_string(CN, C),
    crit_ifs(CI, Rs, R2),
    CN =< CIN,
    append(R2, [restaurant(N,A,P,PR,R,T,C)], Res).
crit_ifs(CI, [restaurant(_,_,_,_,_,_,C) | Rs], Res) :-
    number_string(CIN, CI),
    number_string(CN, C),
    CN > CIN,
    crit_ifs(CI, Rs, Res).

% query(pricing, rating, total_ifs, crit_ifs, A) is true when A is the resultant of applying all given filters to restaurant data
query(Pricing, Rating, Total_ifs, Crit_ifs, A) :-
    cached_yelp_data(Data),
    Businesses = Data.get(businesses),
    r_update_all_ifs(Businesses, MyRs),
    pricing(Pricing, MyRs, A1),
    rating(Rating, A1, A2),
    total_ifs(Total_ifs, A2, A3),
    crit_ifs(Crit_ifs, A3, A).