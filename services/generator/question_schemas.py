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

# get rid of guess word
"""
class GuessWord(BaseModel):
    question: str
    answer: str
"""

class WhichCameFirst(BaseModel):
    question: str
    answer: List[AnswerChoice]

#########################################################
# WORDLE
#########################################################

"""
class WordleLetter(BaseModel):
    character: str = Field(description="A letter present in the word")
    value: int = Field(description="The value for correctness of the letter. Determining if the letter is 0 = not present in the word, 1 = misplaced in the word, or 2 = in the word and placed correctly")

class WordleWord(BaseModel):
    word: str
    values: List[WordleLetter] = Field(description="List containing ALL the letters found in the word in their order and their respective values")


class WordleInOne(BaseModel):
    incorrect_guess: WordleWord = Field(description="An incorrect guess for the user to utilize to get their answer. This word should be FIVE LETTERS include correct letters, incorrect letters, and misplaced letters so the user can give an accurate guess. Treat this like a hint to the actual word")
    answer: str = Field(description="Correct answer for the wordle. Should be FIVE LETTERS")
"""


# implement
class OrderedList(BaseModel):
    question: str = Field(description="Question leading to an answer of an 'ordered list'. Meaning sort the choices in order")
    answer: List[str] = Field(description="Answer of list string that contain the correct ordering of strings")

class MatchPairs(BaseModel):
    question: str = Field(description="Question for the user to match various words to their respective pairing")
    answer: dict[str, str] = Field(description="Dictionary of key value pairs that represent the correct pairs for the question asked")


class Question(BaseModel):
    type: Literal["MultipleChoice", 
                  "TrueOrFalse", 
                  "TwoTruthsAndLie", 
                  "WhichCameFirst", 
                  "MatchPairs", 
                  "OrderedList"]
    tags: List[str] = Field(description="List of tags relevant to the question. These should be meaningful and to the point. Do not provide vague tags. Provide spaces if there are multiple words in one tag, do not combine words into one word")
    explanation: str = Field("A brief but educational insight into the answer of the question as a factoid. 2 - 3 sentences MAX")
    data: Union[MultipleChoice, TrueOrFalse, TwoTruthsAndLie, WhichCameFirst, MatchPairs, OrderedList]
    

class QuestionChunk(BaseModel):
    Questions: List[Question]



