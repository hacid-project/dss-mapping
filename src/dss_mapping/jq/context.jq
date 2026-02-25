import "jsonld" as JSONLD;

def context: {
    rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    rdfs: "http://www.w3.org/2000/01/rdf-schema#",
    owl: "http://www.w3.org/2002/07/owl#",
    xsd: "http://www.w3.org/2001/XMLSchema#",
    top: "https://w3id.org/hacid/onto/top-level/",
    ccso: "https://w3id.org/hacid/onto/ccso/",
    data: "https://w3id.org/hacid/onto/data/",
    jdg: "https://w3id.org/hacid/onto/core/judgement/",
    geo: "http://www.opengis.net/ont/geosparql#",
    timeintervals: "https://w3id.org/hacid/data/cs/dimensions/time/reference-frames/gregorian/regions/",
    datavalues: "https://w3id.org/hacid/data/cs/data-values/",
    dataintervals: "https://w3id.org/hacid/data/cs/data-intervals/",
    lengthvalues: "https://w3id.org/hacid/data/cs/length-values/",
    lengthintervals: "https://w3id.org/hacid/data/cs/length-intervals/",

    likert: "https://w3id.org/hacid/data/cs/likert-5/",
    ratingdims: "https://w3id.org/hacid/data/cs/contribution-rating-dims/",

    users: "https://w3id.org/hacid/data/cs/dss/users/",
    cases: "https://w3id.org/hacid/data/cs/dss/cases/",
    questions: "https://w3id.org/hacid/data/cs/dss/questions/",
    contributions: "https://w3id.org/hacid/data/cs/dss/contributions/",
    tolerances:  "https://w3id.org/hacid/data/cs/risk-tolerance/",
    sectors:  "https://w3id.org/hacid/data/cs/dss/sectors/",

    index: "https://w3id.org/hacid/data/cs/climdex/indices/",
    sector: "https://w3id.org/hacid/data/cs/climdex/sectors/",
    parameter: "https://w3id.org/hacid/data/cs/climdex/parameters/",
    variable: "https://w3id.org/hacid/data/cs/variables/mip/",
    unit: "https://w3id.org/hacid/data/cs/unitsofmeasure/",
    dimension: "https://w3id.org/hacid/data/cs/dimensions/",
    aggregation: "https://w3id.org/hacid/data/cs/climdex/index-time-aggregations/",
    temporalgrid: "https://w3id.org/hacid/data/cs/dimensions/time/reference-frames/gregorian/quantizations/",
    time: "https://w3id.org/hacid/data/cs/dimensions/time/reference-frames/",
    geodetic: "https://w3id.org/hacid/data/cs/dimensions/geodetic/reference-frames/",
    ensemble: {
        "@reverse": "ccso:hasMemberSimulation"
    },
    answers: {
        "@reverse": "jdg:isJudgementOn",
        "@type": "@id"
    },
    value: {
        "@id": "top:value"
    },
    order_value: {
        "@id": "top:orderValue"
    }
} +
(
    {
        "@type": {
            "@id": {
                parts: "top:hasPart",
                maintained_by: "ccso:isMaintainedBy",
                components: "top:hasComponent",
                hazard: "ccso:isPotentialImpactTypeOf",
                # answers: "ccso:hasAssessment",
                impacts: "top:isClassifiedBy",
                industry: "top:isClassifiedBy",
                tasks: "top:definesTask",
                judge: "jdg:hasJudge",
                judges_on: "jdg:isJudgementOn",
                created_at: "top:isObservableAt",
                obj_value: "top:hasValue",
                classified_by: "top:classifiedBy",
                operation: "top:executedThroughOperation",
                costant_default_input: "top:hasCostantDefaultInput",
                prev_task: "top:directlyFollows",
                input_from_tasks: "top:getsInputFromTask",
                rationale: "top:rartionale",
                stakeholder: "ccso:hasStakeholder",
                location: "top:hasRegion",
                time_scale: "top:hasRegion",
                risk_tolerance: "top:classifiedBy",


                specialization_on: "data:isSpecializationOn",
                selected_region: "data:hasSelectedRegion",
                start_datetime: "data:hasStartDateTime",
                end_datetime: "data:hasEndDateTime",
                based_on_ds: "data:basedOnDimensionalSpace",
                discretization: "data:hasDiscretization",
                exact_bounding_region: "data:hasExactBoundingRegion",
            },
            "http://www.w3.org/2001/XMLSchema#dateTime": {
                date: "top:hasIntervalDate"
            },
            "http://www.w3.org/2001/XMLSchema#duration": {
                resolution_value: "data:hasResolutionValue",
                period_value: "data:hasPeriodValue",
                in_period_resolution_value: "data:hasInPeriodResolutionValue",
                duration_value: "top:hasDataValue",
                duration_min: "top:hasMinimumValue",
                duration_max: "top:hasMaximumValue",
            },
            "http://www.w3.org/2001/XMLSchema#decimal": {
                decimal_min: "top:hasMinimumValue",
                decimal_max: "top:hasMaximumValue",
            },
            "geo:wktLiteral": {
                wkt: "geo:asWKT"
            }
        },
        "@language": {
            en: {
                label: "rdfs:label",
                comment: "rdfs:comment"
            }
        }

    } | JSONLD::unpack
);