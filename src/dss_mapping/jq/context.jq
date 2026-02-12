import "jsonld" as JSONLD;

def context: {
    rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    rdfs: "http://www.w3.org/2000/01/rdf-schema#",
    top: "https://w3id.org/hacid/onto/top-level/",
    ccso: "https://w3id.org/hacid/onto/ccso/",
    data: "https://w3id.org/hacid/onto/data/",
    jdg: "https://w3id.org/hacid/onto/core/judgement/",
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
        "@reverse": "jdg:isJudgementOn"
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

                specialization_on: "data:isSpecializationOn",
                selected_region: "data:hasSelectedRegion",
                start_datetime: "data:hasStartDateTime",
                end_datetime: "data:hasEndDateTime",
                based_on_ds: "data:basedOnDimensionalSpace",
                discretization: "data:hasDiscretization",
                exact_bounding_region: "data:hasExactBoundingRegion",
            },
            "http://www.w3.org/2001/XMLSchema#duration": {
                resolution_value: "data:hasResolutionValue",
                period_value: "data:hasPeriodValue",
                in_period_resolution_value: "data:hasInPeriodResolutionValue"
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