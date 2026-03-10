import "utils" as UTILS;

def day_after:
    .year |= if not then 0 end |
    [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][.month] as $num_days_in_month |
    .day |= . + 1 |
    if .day > $num_days_in_month then
        .day = 1 |
        .month |= . + 1 |
        if .month > 12 then
            .month = 1 |
            .year |= . + 1 
        end
    end;

def is_before($day_month):
    .month < $day_month.month or (
        .month == $day_month.month and
        .day < $day_month.day
    );

def season:
    {
        spring: {label: "Spring (NH) / Autumn (SH)", day_range: {start: {day: 20, month: 3}, end: {day: 20, month: 6}}},
        summer: {label: "Summer (NH) / Winter (SH)", day_range: {start: {day: 21, month: 6}, end: {day: 21, month: 9}}},
        autumn: {label: "Autumn (NH) / Spring (SH)", day_range: {start: {day: 22, month: 9}, end: {day: 20, month: 12}}},
        winter: {label: "Winter (NH) / Summer (SH)", day_range: {start: {day: 21, month: 12}, end: {day: 19, month: 3}}},
        wet_JJASO: {label: "Wet season JJASO (North and Central Indian)", day_range: {start: {day: 1, month: 6}, end: {day: 31, month: 10}}},
        wet_MJJASO: {label: "Wet season MJJASO (SE Asian)", day_range: {start: {day: 1, month: 5}, end: {day: 31, month: 10}}},
        wet_JAS: {label: "Wet season JAS (North American)", day_range: {start: {day: 1, month: 6}, end: {day: 30, month: 9}}},
        wet_JJASOND: {label: "Wet season JJASOND (South Indian)", day_range: {start: {day: 1, month: 6}, end: {day: 31, month: 12}}},
        wet_JFM: {label: "Wet season JFM (East African)", day_range: {start: {day: 1, month: 1}, end: {day: 31, month: 3}}},
        dry_MJJAS: {label: "Dry season MJJAS (Australia)", day_range: {start: {day: 1, month: 5}, end: {day: 30, month: 9}}},
        dry_OND: {label: "Dry season OND (North India)", day_range: {start: {day: 1, month: 10}, end: {day: 31, month: 12}}}
    } as $seasons |

    (
        $seasons | to_entries |
        group_by(.value.day_range.start.month) |
        map({
            key: "\(.[0].value.day_range.start.month)",
            value: (
                group_by(.value.day_range.start.day) |
                map({
                    key: "\(.[0].value.day_range.start.day)",
                    value: (
                        group_by(.value.day_range.end.month) |
                        map({
                            key: "\(.[0].value.day_range.end.month)",
                            value: (
                                map({
                                    key: "\(.value.day_range.end.day)",
                                    value: .value + {id: .key}
                                }) | from_entries
                            )
                        }) | from_entries
                    )
                }) | from_entries
            )
        }) | from_entries
    ) as $seasons_by_dates |

    $seasons_by_dates."\(.start.month)"?."\(.start.day)"?."\(.end.month)"?."\(.end.day)"? as $season |

    if $season then {
        "@id": @uri "season:\($season.id)",
        label: $season.label
    }
    else {
        "@id": @uri "annualdayrange:\([.start.month, .start.day, .end.month, .end.day | UTILS::lpad(2; "0")] | join("-"))"
    }
    end + {
        "@type": ["data:TemporalRegion", "data:PeriodicRegion"],
        period: "P1Y",
        start_datetime: (
            .start |
            "0000-\([.month, .day | UTILS::lpad(2; "0")] | join("-"))-01T00:00:00.000Z"
        ),
        end_datetime: (
            .start as $start | .end | if is_before($start) then .year = 1 end | day_after |  
            "00\([.year, .month, .day | UTILS::lpad(2; "0")] | join("-"))-01T00:00:00.000Z"
        )
    };

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
    elif .kind == "season" then
        .value | season
    else
        debug("Unsupported subannual period: \(.)") | {}
    end;
