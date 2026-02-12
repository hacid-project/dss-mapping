def contribution: {
    "@id": @uri "contributions:\(.id)",
    "@type": "ccso:Assessment",
    judge: @uri "users:\(.owner?.id)",
    label: "Contribution #\(.id)",
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
                            prev_task:
                                if .order_value > $order_values[0] then
                                    @uri "contributions:\($contribution_id)/wf/tasks/\($order_values[$task_position - 1])"
                                else null
                                end,
                            next_task:
                                if .order_value < $order_values[-1] then
                                    @uri "contributions:\($contribution_id)/wf/tasks/\($order_values[$task_position + 1])"
                                else null
                                end
                        }
                    ]
                )
            }
        end
    ),
    rest: (
        del(.id) | 
        del(.owner) |
        .
    )
};
