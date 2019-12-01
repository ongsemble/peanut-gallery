:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

:- dynamic(known/2).

open_notify_url("https://api.yelp.com/v3/businesses/search?term=food&location=6200+University+Blvd%2C+Vancouver%2C+BC+V6T+1Z4&radius=3000&limit=50").
%! yelp_data(-Data) is det.
%  get Yelp API restaurant data and read in as dict
yelp_data(Data) :-
    open_notify_url(URL),
    setup_call_cleanup(
        http_open(URL, In, [request_header('Accept'='application/json'), authorization(bearer('X2iKeittNKi6CiMBuB1LAkx2dBkdoJk7HcDZZHTU49HjXNvtgyO0VoLD3bG_h1N79RkpVGKqBAFvFmJ3HuE8uqjLBPmobtVPHPvS741aWMADaDUWDFY5-p4PwLLVXXYx'))]),
        json_read_dict(In, Data),
        close(In)
    ).

%! cached_yelp_data(-Data) is det.
%  get cached data, else make a fresh request, useful during development.
cached_yelp_data(Data) :-
    known(data, Data) ;
    yelp_data(Data),
    assert(known(data, Data)).

%! yelp_names(+Data, -Names) is det.
%  extract all business names from the list of businesses from the data.
yelp_names(Data, Names) :-
    Businesses = Data.get(businesses),
    yelp_name_helper(Businesses, Names).

yelp_name_helper([], []).
yelp_name_helper(Businesses, AllNames) :-
    [X|Xs] = Businesses,
    yelp_name_helper(Xs, Names),
    AllNames = [X.name|Names].

yelp_address(X, Address) :-
    yelp_location(X, Location),
    yelp_address1(Location, Address1),
    yelp_city(Location, City),
    yelp_state(Location, State),
    yelp_zip(Location, Zip_code),
    atomic_list_concat([Address1, City, State, Zip_code], ' ', Address).

yelp_location(X, Location) :-
    Location = X.get(location).

yelp_address1(Location, Address1) :-
    Address1 = Location.get(address1).

yelp_city(Location, City) :-
    City = Location.get(city).

yelp_state(Location, State) :-
    State = Location.get(state).

yelp_zip(Location, Zip_code) :-
    Zip_code = Location.get(zip_code).