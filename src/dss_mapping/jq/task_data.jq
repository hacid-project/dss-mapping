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
        debug("Unsupported task data type: \(.data)") |
        {}
    else
        error("Unrecognized task data type: \(.data)")
    end;
