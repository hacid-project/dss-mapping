import "GeoJSON" as GeoJSON;

def to_cordex_code:
    [
        "AFR",
        "ANT",
        "ARC",
        "AUS",
        "CAM",
        "CAS",
        "EAS",
        "EUR",
        "MED",
        "MNA",
        "NAM",
        "SAM",
        "SEA",
        "WAS"
    ] as $cordex_mappping |
    if . then $cordex_mappping[. - 1] end
;

def geometry:
    if . then
        GeoJSON::to_wkt | {
            "@id": @uri "geometries:\(.)",
            wkt: .
        }
    end;

def request: {
    "@type": "ccso:Request",
    impacts: ((.hazards // [])| map({
        hazard: (.value | fromjson | .hazard?.value),
        description: .description
    })),
    answers: (
        (.contributions // []) |
        map(@uri "contributions:\(.id)")
    )
};

def question: request + {
    "@id": @uri "questions:\(.id)",
    maintained_by: @uri "users:\(.owner_id)",
    label: .question,
    additional_information: .additional_information,
    comment: .description
};

def case($map_questions): request + {
    "@id": @uri "cases:\(.id)",
    maintained_by: @uri "users:\(.owner?.id)",
    label: .title,
    organization: .organization,
    industry: @uri "sectors:\(.industry?.id)",
    cordex_code: "\(.cordex?.id | to_cordex_code)",
    cordex_location: .cordex?.geometry | geometry,
    location: .location | geometry,
    time_scale: {
        start: .time_scale_start,
        end: .time_scale_end
    },
    risk_tolerance: (
        .risk_tolerance |
        if . then
            {
                "@id": @uri "tolerances:\(.name)",
                label: .name,
                value: (.id | tonumber)
            }
        end
    ),
    user_need: .user_need,
    goals: .goals,
    decision_context: .decision_context,
    components: (
        (.questions // []) | 
        map(
            if $map_questions then question
            else @uri "questions:\(.id)"
            end
        )
    ),
    rest: (
        del(.id) | 
        del(.owner) |
        del(.title) | 
        del(.organization) | 
        del(.industry) | 
        del(.cordex) |
        del(.location) |
        del(.risk_tolerance) |
        del(.user_need) |
        del(.goals) |
        del(.decision_context) |
        del(.time_scale_start) |
        del(.time_scale_end) |
        del(.questions) |
        del(.contributions) |
        del(.hazards) |
        .
    )
};

def case: case(true);