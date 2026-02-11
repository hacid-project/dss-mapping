import jq
from pydantic import BaseModel
import pathlib

def map(
    model: BaseModel
):
    print(pathlib.Path(__file__).parent.resolve())
    return jq.compile(
        'include "map"; .type = $type | map',
        args={"type": type(model).__name__},
        library_search_path=[f'{pathlib.Path(__file__).parent.resolve()}/jq']
    ).input_value(model.model_dump()).first()
    
