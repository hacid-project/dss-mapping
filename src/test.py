from pydantic import BaseModel
from dss_mapping.map import map

class Case(BaseModel):
    id: int
    title: str


# this will record details of a successful validation to logfire
c = Case(id=1, title='Should I?')

print(map(c))
