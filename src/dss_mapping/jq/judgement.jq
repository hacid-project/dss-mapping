include "task_data";

def judgment: {
    created_at: (
        .created_at |
        if . then {
            "@id": @uri "after:\(.)",
            date: .
        } end
    ),
};

def contribution: judgment + {
    "@id": @uri "contributions:\(.id)",
    "@type": "ccso:Assessment",
    judge: @uri "users:\(.owner_id)",
    label: "Contribution #\(.id)",
    comment: .comment,
    components: (
        .id as $contribution_id |
        .tasks |
        if . and length > 0 then
            {
                "@id": @uri "contributions:\($contribution_id)/wf",
                "@type": "top:Workflow",
                tasks: (
                    sort_by(.order_value) |
                    map(.order_value) as $order_values |
                    # $order_values[0] as $min_order_value |
                    # $order_values[-1] as $max_order_value |
                    . as $tasks |
                    [
                        range(length) |
                        . as $task_position |
                        $tasks[$task_position] |
                        {
                            "@id": @uri "contributions:\($contribution_id)/wf/tasks/\(.order_value)",
                            "@type": "top:Task",
                            order_value: .order_value,
                            prev_task:
                                if .order_value > $order_values[0] then
                                    @uri "contributions:\($contribution_id)/wf/tasks/\($order_values[$task_position - 1])"
                                else null
                                end,
                            next_task:
                                if .order_value < $order_values[-1] then
                                    @uri "contributions:\($contribution_id)/wf/tasks/\($order_values[$task_position + 1])"
                                else null
                                end,
                            comment: .description,
                            operation: .task_uri,
                            costant_default_input: task_data,
                            input_from_tasks: (
                                .parent_tasks // [] |
                                map(@uri "contributions:\($contribution_id)/wf/tasks/\(.order_value)")
                            ),
                            rationale:
                                if .rationale_description then {
                                    "@id": @uri "contributions:\($contribution_id)/wf/tasks/\(.order_value)/rationale",
                                    type: "top:Description",
                                    comment: .rationale_description
                                } else null
                                end
                        }
                    ]
                )
            }
        end
    ),
    rest: (
        del(.id) | 
        del(.type) | 
        del(.owner_id) |
        del(.question) |
        del(.question_id) |
        del(.comment) |
        del(.created_at) |
        del(.tasks) |
        .
    )
};

def rating:
    [
        "accuracy",
        "relevance",
        "specificity",
        "completeness",
        "credibility",
        "clarity",
        "actionability"
    ] as $components |
    judgment + {
        "@id": @uri "contributions:\(.contribution_id)/ratings/\(.id)",
        "@type": "jdg:RelevanceAssignmentOnJudgement",
        judges_on: @uri "contributions:\(.contribution_id)",
        judge: @uri "users:\(.user_id)",
        obj_value: {
            "@id": @uri "likert:\(.rate)",
            value: .rate
        },
        comment: .comment,
        components: (
            . as $rating |
            $components |
            map({
                "@id": @uri "contributions:\($rating.contribution_id)/ratings/\($rating.id)/\(.)",
                "@type": "jdg:RelevanceAssignmentOnJudgement",
                judges_on: @uri "contributions:\($rating.contribution_id)",
                judge: @uri "users:\($rating.user_id)",
                obj_value: {
                    "@id": @uri "likert:\($rating[.])",
                    value: $rating[.]
                },
                classified_by: {
                    "@id": @uri "ratingdims:\(.)",
                    value: .
                }
            })
        )
    };
