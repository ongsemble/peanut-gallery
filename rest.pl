:- module(rest, [cached_yelp_data/1, yelp_address/2]).
:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

:- dynamic(known/2).

open_notify_url("https://api.yelp.com/v3/businesses/search?term=food&location=6200+University+Blvd%2C+Vancouver%2C+BC+V6T+1Z4&radius=3000&limit=50").
% yelp_data(Data) - get Yelp API restaurant data and read in as dict
yelp_data(Data) :-
    open_notify_url(URL),
    setup_call_cleanup(
        http_open(URL, In, [request_header('Accept'='application/json'), authorization(bearer('X2iKeittNKi6CiMBuB1LAkx2dBkdoJk7HcDZZHTU49HjXNvtgyO0VoLD3bG_h1N79RkpVGKqBAFvFmJ3HuE8uqjLBPmobtVPHPvS741aWMADaDUWDFY5-p4PwLLVXXYx'))]),
        json_read_dict(In, Data),
        close(In)
    ).

% cached_yelp_data(Data) - get cached data, else make a fresh request, useful during development
cached_yelp_data(Data) :-
    known(data, Data) ;
    yelp_data(Data),
    assert(known(data, Data)).

%! yelp_names(Data, Names) - extract all business names from the list of businesses from the data
yelp_names(Data, Names) :-
    Businesses = Data.get(businesses),
    yelp_name_helper(Businesses, Names).

% yelp_name_helper(B, N) - worker to actually extract all business names
yelp_name_helper([], []).
yelp_name_helper(Businesses, AllNames) :-
    [X|Xs] = Businesses,
    yelp_name_helper(Xs, Names),
    AllNames = [X.name|Names].

% yelp_address(X, Address) is true when Address contains the all the address information from X
yelp_address(X, Address) :-
    Location = X.get(location),
    Address1 = Location.get(address1),
    City = Location.get(city),
    State = Location.get(state),
    Zip_code = Location.get(zip_code),
    atomic_list_concat([Address1, City, State, Zip_code], ' ', Address).