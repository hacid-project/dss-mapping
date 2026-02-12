import "cases" as CASES;
import "contributions" as CONTRIBUTIONS;
import "ratings" as RATINGS;

def map:
    if .type == "Case" then
        CASES::case
    elif .type == "Contribution" then
        CONTRIBUTIONS::contribution
    elif .type == "Rating" then
        RATINGS::rating
    end;