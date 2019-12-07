% User query for restaurant recommendations

% pricing(Input, End, ToFilter, Filtered) is true if Filtered is a list of restaurants filtered by Input from ToFilter
pricing([],_,R,R).
pricing(['$'| End],End,L2,R) :-
    some_filter_fn(L2,R).
pricing(['$$'| End],End,L1, R) :-
    mp(L,L1,R).
answer(['$$$'| End],End,L1,R) :-
    noun_phrase(L,L1,R).

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

    writeln("Rating? (0.0 - 5.0)"), 
    readln(Ln_rating),

    writeln("Maximum number of total safety infractions?"), 
    readln(Ln_total_ifs),

    writeln("Maximum number of critical safety infractions?"), 
    readln(Ln_crit_ifs),

    query(Ln_pricing, Ln_rating, Ln_total_ifs, Ln_crit_ifs, Ans),
    member(End,[[],['?'],['.']]).