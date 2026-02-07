from typing import List, Optional, Union, Literal
from enum import Enum
from pydantic import BaseModel, Field


class AnswerChoice(BaseModel):
    content: str
    correct: bool

# multiple choice
class MultipleChoice(BaseModel):
    question: str
    answer: List[AnswerChoice]

# true or false
class TrueOrFalse(BaseModel):
    question: str
    answer: bool

# two truths lie
class TwoTruthsAndLie(BaseModel):
    answer: List[AnswerChoice]

class GuessWord(BaseModel):
    question: str
    answer: str

class WhichCameFirst(BaseModel):
    question: str
    answer: List[AnswerChoice]


class Question(BaseModel):
    type: Literal["MultipleChoice", "TrueOrFalse", "TwoTruthsAndLie", "GuessWord"]
    tags: List[str]
    data: Union[MultipleChoice, TrueOrFalse]

class QuestionChunk(BaseModel):
    Questions: List[Question]



