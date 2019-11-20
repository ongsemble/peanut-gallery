:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

:- dynamic(known/2).

open_notify_url("https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972").
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
    Names = yelp_name_helper(Businesses).

yelp_name_helper([], []).
yelp_name_helper(Businesses, AllNames) :-
    [X|Xs] = Businesses,
    yelp_name_helper(Xs, Names),
    AllNames = [X.name|Names].