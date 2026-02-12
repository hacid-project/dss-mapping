def rating: {
    "@id": @uri "contributions:\(.contribution_id)/ratings/\(.id)",
    "@type": "jdg:RelevanceAssignmentOnJudgement",
    judges_on: @uri "contributions:\(.contribution_id)",
    judge: @uri "users:\(.user_id)",
    rest: (
        del(.id) | 
        del(.contribution_id) |
        del(.user_id) |
        .
    )
};
