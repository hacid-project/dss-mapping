# dss-mapping

Mapping and synchronisation code to populate the Climate Services KG with data from the DSS platform.

The mapping is implemented in [jq](https://jqlang.org/) and can be used from a variety of environments and languages.

Here we describe its usage in two ways:
- from the shell, for the batch process used to map the existing data;
- from Python (specifically, using [pydantic](https://docs.pydantic.dev/) models), for real-time synchronization. 

## Mapping Current DSS Data

This section describes the batch process able to convert the existing data to RDF to update the knowledge graph.

It can be used either on its own, for ad-hoc off-line synchronization, or as one-time initial synchronization if real-time synchronization (described below) is enabled on an already populated back-end.

### Requirements

- a recent version of [jq](https://jqlang.org/)
- read access to [the HACID DSS backend API](https://hacid-backend.istc.cnr.it/hacid-dss-api/docs) or compatible service;
- write access to (part of) the HACID Climate Services Knowledge Graph or other knwoledge graph.

### Download

Download all the relevant existing data from the HACID DSS backend API: namely cases, contributions, ratings, and users:

```shell
./bin/download.sh
```

The downloaded data are in the `data/download` folder, with a JSON file for each resource type.

Note: pagination is not currently supported, which is an issue if there are more than 100 cases or contributions.

### Map

Map the downloaded JSON files to JSON-LD:

```shell
./bin/map-all.sh
```

The result is in `data/rdf/all.jsonld`

### Upload

Find and select (e.g., _Setup_ -> _Repositories_ -> _connect_ command in GraphDB UI) the repository dedicated to storing climate cases (e.g., `hacid-cs-write`) in the reference triple store (e.g., GraphDB at http://keng.istc.cnr.it:7200/).

Clear repository (e.g., _Explore_ -> _Graphs overview_ -> _Clear Repository_, in GraphDB).

Upload  (e.g., _Import_ -> _User data_ -> _Upload RDF files_, in GraphDB) JSON-LD with the new version (`data/rdf/all.jsonld`).


## Real-time Synchronization

This section describes how to perform real-time mapping of data from the back-end, assuming data is modelled using [pydantic](https://docs.pydantic.dev/).

### Requirements

- Python 3
- [pydantic](https://docs.pydantic.dev/) already installed and used for the data

### Install

Locally install the dss-mapping library directly from the repository:

```shell
pip install git+https://github.com/hacid-project/dss-mapping.git
```

### Use

Map a Python object, instance of pydantic.BaseModel and representing one of the supported type of resources (e.g., a case).

```python
from dss_mapping import model_to_jsonld

# retrieve object case
# ...

# map object to JSON-LD
case_as_jsonld = model_to_jsonld(case)

# write case_as_jsonld to knowledge graph
# ...
```
