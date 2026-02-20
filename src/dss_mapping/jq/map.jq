import "request" as REQUEST;
import "judgement" as JUDGEMENT;

def map:
    if .type | contains("Case") then
        REQUEST::case
    elif .type | contains("Contribution") then
        JUDGEMENT::contribution
    elif .type | contains("Rating") then
        JUDGEMENT::rating
    elif .type | contains("User") then
        {}
    else
        error("Unsupported type: \(.type)")
    end;