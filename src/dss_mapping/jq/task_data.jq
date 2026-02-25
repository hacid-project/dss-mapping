import "time" as TIME;

def task_data: 
    def unsupported:
        debug("Unsupported task data type: \(.data) for \(.task_uri)") | {};

    if .data | not then
        null
    elif .data == "number_range" and .task_uri == "https://w3id.org/hacid/data/cs/wf/ops/DefineRelevantSpatialResolutions" then
        .task_value |
        if .kind == "single" then
            {
                "@id": @uri "lengthvalues:km/\(.value)",
                "@type": "top:Region",
                decimal_value: .value
            }
        elif .kind == "range_upto" then
            {
                "@id": @uri "lengthintervals:km/-\(.end)",
                "@type": "top:Region",
                decimal_max: .end
            }
        else 
            {
                "@id": @uri "lengthintervals:km/\(.start)-\(.end)",
                "@type": "top:Region",
                decimal_min: .start,
                decimal_max: .end
            }
        end
    elif .data == "duration_range" then
        "http://www.w3.org/2001/XMLSchema#" as $xsd_ns |
        .task_value |
        if .kind == "single" then
            {
                "@id": @uri "datavalues:\($xsd_ns)duration/\(.value)",
                "@type": "top:Region",
                duration_value: .value
            }
        elif .kind == "range_upto" then
            {
                "@id": @uri "dataintervals:\($xsd_ns)duration/-\(.end)",
                "@type": "top:Region",
                duration_max: .end
            }
        else 
            {
                "@id": @uri "dataintervals:\($xsd_ns)duration/\(.start)-\(.end)",
                "@type": "top:Region",
                duration_min: .start,
                duration_max: .end
            }
        end

    elif .data == "date_range" then
        .task_value |
        [.start,.end] |
        TIME::strings_to_interval
    elif .data == "subannual_period" then
        unsupported
    elif .data == "single_entity" then
        .task_value?.classInstance?.value
    elif .data == "entity_range" and .task_uri == "https://w3id.org/hacid/data/cs/wf/ops/ChooseGlobalWarmingLevel" then
        .task_value |
        [
            range(
                .start?.label? // "GWL1.5" | .[3:] | tonumber;
                .end?.label? // "GWL6.0" | .[3:] | tonumber;
                0.5
            ) | @uri "https://w3id.org/hacid/data/cs/wf/schemes/GlobalWarmingLevel/GWL\(.)"
        ]
        # {
        #     "@id": "https://w3id.org/hacid/data/cs/wf/schemes/GlobalWarmingLevelInterval/\(.task_value.start?.label?)-\(.task_value.end?.label?)"
        # }
    else
        error("Unrecognized task data type: \(.data) for \(.task_uri)")
    end;
