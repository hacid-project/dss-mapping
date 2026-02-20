import "request" as REQUEST;
import "judgement" as JUDGEMENT;

def map:
    if .type | contains("Case") then
        REQUEST::case
    elif .type | contains("Contribution") then
        JUDGEMENT::contribution
    elif .type | contains("Rating") then
        JUDGEMENT::rating
    end;