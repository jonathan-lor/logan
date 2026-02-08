from pydantic import BaseModel, Field
from typing import List

class Topic(BaseModel):
    topic: str = Field(description="The topic")
    used: bool

class Topics(BaseModel):
    topics: List[Topic] = Field(description="List of topics")
