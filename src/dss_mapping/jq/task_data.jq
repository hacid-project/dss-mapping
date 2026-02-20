import "time" as TIME;

def task_data: 
    if .data | not then
        null
    elif .data == "number_range" then
        debug("Unsupported task data type: \(.data)") |
        {}
    elif .data == "duration_range" then
        debug("Unsupported task data type: \(.data)") |
        {}
    elif .data == "date_range" then
        .task_value |
        [.start,.end] |
        TIME::strings_to_interval
    elif .data == "subannual_period" then
        debug("Unsupported task data type: \(.data)") |
        {}
    elif .data == "single_entity" then
        .task_value?.classInstance?.value
    elif .data == "entity_range" then
        if .task_uri == "https://w3id.org/hacid/data/cs/wf/ops/ChooseGlobalWarmingLevel" then
            .task_value |
            [
                range(
                    .start?.label? // "GWL1.5" | .[3:] | tonumber;
                    .end?.label? // "GWL6.0" | .[3:] | tonumber;
                    0.5
                ) | @uri "https://w3id.org/hacid/data/cs/wf/schemes/GlobalWarmingLevel/GWL\(.)"
            ]
        else
            debug("Unsupported task data type: \(.data) for \(.task_uri)")
        end
        # {
        #     "@id": "https://w3id.org/hacid/data/cs/wf/schemes/GlobalWarmingLevelInterval/\(.task_value.start?.label?)-\(.task_value.end?.label?)"
        # }
    else
        error("Unrecognized task data type: \(.data)")
    end;
