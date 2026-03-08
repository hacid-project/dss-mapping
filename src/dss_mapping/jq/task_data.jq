import "time" as TIME;
import "utils" as UTILS;

def unsupported:
    debug("Unsupported task data type: \(.data) for \(.task_uri)") | {};

def subannual_period:
    if . | not then
        .
    elif .kind == "day_range" then
        [
            .begin, .end |
            .[1:] | .[index("-")+1:]
        ] as [$start, $end] |
        {
            "@id": @uri "annualdayrange:\($start)-\($end)",
            "@type": ["data:TemporalRegion", "data:PeriodicRegion"],
            period: "P1Y",
            start_datetime: "0000-\($start)",
            end_datetime: "000\(if $end >= $start then "0" else "1" end)-\($end)"
        }
    elif .kind == "single_month" then
        .value.start.month as $month |
        {
            "@id": @uri "annualmonth:\($month)",
            "@type": ["data:TemporalRegion", "data:PeriodicRegion"],
            period: "P1Y",
            start_datetime: "0000-\($month | UTILS::lpad(2; "0"))-01T00:00:00.000Z",
            end_datetime: "000\(if $month == 12 then "1" else "0" end)-\(($month % 12 + 1) | UTILS::lpad(2; "0"))-01T00:00:00.000Z"
        }
    elif .kind == "months_block" or .kind == "month_range" then
        .value.start.month as $start_month |
        .value.end.month as $end_month |
        {
            "@id": @uri "annualmonthrange:\($start_month)-\($end_month)",
            "@type": ["data:TemporalRegion", "data:PeriodicRegion"],
            period: "P1Y",
            start_datetime: "0000-\($start_month | UTILS::lpad(2; "0"))-01T00:00:00.000Z",
            end_datetime: "000\(if $end_month == 12 or $end_month < $start_month then "1" else "0" end)-\(($end_month % 12 + 1) | UTILS::lpad(2; "0"))-01T00:00:00.000Z",
            components: [
                if $end_month >= $start_month then
                    range($start_month; $end_month + 1)
                else
                    range($start_month; 13),
                    range(1; $end_month + 1)
                end |
                {
                    kind: "single_month",
                    value: {start: {month: .}}
                } | subannual_period
            ]
        }
    else
        debug("Unsupported subannual period: \(.)") | {}
    end;

def task_data: 
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
        .task_value | subannual_period
#        unsupported
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
