#!/usr/bin/env bash

JQ_DIR="src/dss_mapping/jq"
INPUT_DIR="data/download"
# INPUT_DIR="data/source-sample"
OUTPUT_DIR="data/rdf"
#MAPPING_DIR="config/mappings"
#JSONLD_OUTPUT_DIR="$OUTPUT_DIR/jsonld"
JSONLD_OUTPUT="$OUTPUT_DIR/all.jsonld"
# NQ_OUTPUT_DIR="$OUTPUT_DIR/nt"
# NQ_GLOBAL_OUTPUT="$OUTPUT_DIR/all.nt"
# LOG_PERIOD=50

#JSONLD_CONTEXT=`cat $JSONLD_CONTEXT_PATH | jq '.' --compact-output`
#JSONLD_CONTEXT=`jq -f $JSONLD_CONTEXT_GEN_PATH --null-input --compact-output`
#echo $JSONLD_CONTEXT

mkdir -p "$OUTPUT_DIR"
for INPUT in $INPUT_DIR/*.json; do
    jq -L "$JQ_DIR" 'include "map"; .[] | map' --compact-output  <$INPUT
done | jq -L "$JQ_DIR" --slurp 'include "context"; {"@context": context, "@graph": .}' >$JSONLD_OUTPUT

