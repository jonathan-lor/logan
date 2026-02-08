import os
from dotenv import dotenv_values
from google import genai
from question_schemas import *
import random
import sys
from prompt_creator import PromptCreator
from llm import llm
from database import connect_to_client



config = dotenv_values(".env")


SYSTEM_PROMPT_PATH = "./systemprompt.txt"

args = sys.argv

if len(args) < 2:
    print(f"Help menu")
    print("1st arg: user prompt")
    print("2nd arg: number of questions to generate")
    sys.exit()

prompt = args[1]
num = 1 if len(args) < 3 else int(args[2])


# get gemini instance
llm = llm(config["GOOGLE_API_KEY"])



# connect to atlas
client = connect_to_client(config["MONGO_DB_CONNECTION_STRING"])
db = client["modules"]
collection = db["questions"]


p = PromptCreator()

# query and return results from gemini
results = llm.get_question_json(p.generate_prompt(prompt, num))



print(results.model_dump_json(indent=4))


#result = collection.insert_many([q.model_dump() for q in results.Questions])

#print(f"INSERTED: {result.inserted_ids}")
