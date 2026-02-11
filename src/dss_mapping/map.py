import jq
from pydantic import BaseModel
import pathlib

def model_to_jsonld(
    model: BaseModel,
    include_context: bool = True
):
    print(pathlib.Path(__file__).parent.resolve())
    return jq.compile(
        'include "map"; ' +
        ('include "context"; ' if include_context else '') +
        '.type = $type | map' +
        (' | ."@context" = context' if include_context else ''),
        args={"type": type(model).__name__},
        library_search_path=[f'{pathlib.Path(__file__).parent.resolve()}/jq']
    ).input_value(model.model_dump()).first()
    
