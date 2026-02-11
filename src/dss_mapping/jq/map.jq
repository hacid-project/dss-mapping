import "cases" as CASES;
#import "contributions" as CONTRIBUTIONS {search: "./"};

def map:
    if .type == "Case" then
        CASES::case
    elif .type == "Contribution" then
    #    CONTRIBUTIONS::contribution
        .
    elif .type == "Contribution" then
    #    RATINGS::rating
        .
    end;