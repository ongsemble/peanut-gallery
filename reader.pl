:- module(reader, [r_total_inf/2, r_all_critical_inf/2]).

:- use_module(ubc_restaurants).
:- use_module(rest).

read_restaurants :-
    open('ubc-restaurants.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    print(Lines), nl.

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

r_name(rest(X), Name) :-
    split_string(X, "|", "", [Name|_]).

% r_total_inf is true if the restaurant of name Name has I total food safety infractions
r_total_inf(rest(X), I) :-
    split_string(X, "|", "", [_, _, _, I|_]).

% r_all_critical_inf is true if the restaurant of name Name has I outstanding critical food safety infractions
r_all_critical_inf(rest(X), I) :-
    split_string(X, "|", "", [_, _, _, _, I|_]).

r_address(rest(X), A) :-
    split_string(X, "|", "", [_, A|_]).

% restaurant(Name, Address, Phone, Price, Rating, TotalInf, CritInf).

build_restaurant(Yelp_business, Ubc_business, restaurant(Name, Address, Phone, Price, Rating, TotalInf, CritInf)) :-
    Name = Yelp_business.name,
    yelp_address(Yelp_business, Address),
    Phone = Yelp_business.phone,
    Price = Yelp_business.price,
    Rating = Yelp_business.rating,
    r_total_inf(Ubc_business, TotalInf),
    r_all_critical_inf(Ubc_business, CritInf).

% r_equals(R1,R2) is true if json object R1 (taken from Yelp) is contained within R2 (Hedgehog) as a name.
r_equals(R1, R2) :-
    r_address(R2, A2),
    yelp_address(R1, A1),
    atom_string(Atom_A2, A2),
    A1 == Atom_A2.

r_all_equals(Businesses, Rs) :-
    [X|Xs] = Businesses,
    [Y|Ys] = Rs,
    r_equals(X, Y),
    r_all_equals(Xs, Ys).
r_all_equals([X|Xs], [Y,Ys|R]) :-
    \+ r_equals(X, Y),
    r_equals([X|Xs], [Ys|R]).



/*_10850{
    alias:"loafe-cafe-vancouver", 
    categories:[_11158{alias:"cafes", title:"Cafes"}], 
    coordinates:_11188{latitude:49.2660229, longitude: -123.2491421}, 
    display_phone:"", 
    distance:119.65906091990973, 
    id:"D02tg_m6dxwgz0473aYDfA", 
    image_url:"https://s3-media4.fl.yelpcdn.com/bphoto/hhbG2TLRXxhINw9caFJrYQ/o.jpg", 
    is_closed:false, 
    location:_10996{address1:"6163 University Boulevard", address2:"", address3:"", city:"Vancouver", country:"CA", 
    display_address:["6163 University Blvd", "Vancouver, BC V6T 1Z1", "Canada"], state:"BC", zip_code:"V6T 1Z1"}, name:"Loafe Cafe", phone:"", price:"$", rating:4.0, review_count:36, transactions:[], url:"https://www.yelp.com/biz/loafe-cafe-vancouver?adjust_creative=sg5ZSCMjYVPZP8i4gO9big&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=sg5ZSCMjYVPZP8i4gO9big"}*/