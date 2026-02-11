from pydantic import BaseModel
from dss_mapping.map import model_to_jsonld

class Case(BaseModel):
    id: int
    title: str


# this will record details of a successful validation to logfire
c = Case(id=1, title='Should I?')

print(model_to_jsonld(c))
