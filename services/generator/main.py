import os
from dotenv import load_dotenv
from google import genai
from question_schemas import *
import random
import sys
from prompt_creator import PromptCreator
from llm import llm





SYSTEM_PROMPT_PATH = "./systemprompt.txt"

args = sys.argv

if len(args) < 2:
    print(f"Help menu")
    print("1st arg: user prompt")
    print("2nd arg: number of questions to generate")
    sys.exit()

prompt = args[1]
num = 1 if len(args) < 3 else int(args[2])




load_dotenv()

llm = llm(os.getenv("GOOGLE_API_KEY"))
p = PromptCreator()

results = llm.get_question_json(p.generate_prompt(prompt, num))



print(results.model_dump_json(indent=4))


