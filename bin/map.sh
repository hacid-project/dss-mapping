#!/usr/bin/env bash

jq -f 'mapping/cases.jq' <data/cases.json >rdf/cases.jsonld
