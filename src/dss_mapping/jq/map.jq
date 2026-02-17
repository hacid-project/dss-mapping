import "request" as REQUEST;
import "judgement" as JUDGEMENT;

def map:
    if .type == "Case" then
        REQUEST::case
    elif .type == "Contribution" then
        JUDGEMENT::contribution
    elif .type == "Rating" then
        JUDGEMENT::rating
    end;