:- use_module(ubc_restaurants).

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

r_name(X, Name) :-
    rest(X),
    split_string(X, "|", "", [Name|_]).

% r_total_if is true if the restaurant of name Name has I total food safety infractions
r_total_if(Name, I) :-
    rest(X),
    split_string(X, "|", "", [Name, _, _, I|_]).

% r_all_critical_if is true if the restaurant of name Name has I outstanding critical food safety infractions
r_all_critical_if(Name, I) :-
    rest(X),
    split_string(X, "|", "", [Name, _, _, _, I|_]).

r_address(Name, A) :-
    rest(X),
    split_string(X, "|", "", [Name, A|_]).

% r_equals(R1,R2) is true if R1 (taken from Yelp) is contained within R2 (Hedgehog) as a name.
r_equals(R1, R2) :-
    r_name(R2, R2_Name),
    r_address(R2_Name, A2),
    A1 = yelp_address(R1, A1),
    A1 = A2.
    
r_equals(r_name(X), yelp_query).

/*_42240{alias:"the-corner-kitchen-ubc-vancouver", 
    categories:[_41952{alias:"korean", title:"Korean"}], 
    coordinates:_42012{latitude:49.2660156, longitude: -123.2423069}, 
    display_phone:"+1 604-428-5045", 
    distance:607.2136869285189, 
    id:"KJIly45Ziq4XtMSGx31dlQ", 
    image_url:"https://s3-media1.fl.yelpcdn.com/bphoto/lMiIWoSXKodCX6D1S1XvFw/o.jpg", 
    is_closed:false, 
    location:_42168{
        address1:"5743 Dalhousie Road", 
        address2:"Suite 115", 
        address3:null, 
        city:"Vancouver", 
        country:"CA", 
        display_address:["5743 Dalhousie Road", "Suite 115", "Vancouver, BC V6T 2H9", "Canada"], 
        state:"BC", 
        zip_code:"V6T 2H9"}, 
    name:"The Corner Kitchen UBC", 
    phone:"+16044285045",
    rating:4.0, 
    review_count:7, 
    transactions:[], 
    url:"https://www.yelp.com/biz/the-corner-kitchen-ubc-vancouver?adjust_creative=sg5ZSCMjYVPZP8i4gO9big&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=sg5ZSCMjYVPZP8i4gO9big"}
    */