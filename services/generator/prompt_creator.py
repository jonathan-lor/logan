from typing import List, Optional
from config import SYSTEM_PROMPT_PATH
from utils import generate_seeds

class PromptCreator:
    system_prompt: Optional[str]

    def __init__(self):
        self._load_system_prompt(SYSTEM_PROMPT_PATH)

    def _load_system_prompt(self, file_path: str) -> None:
        try:
            with open(file_path, 'r') as file:
                system_prompt = file.read()
                print("Successfully read system prompt file")

        except FileNotFoundError:
            print(f"Error: The file '{file_path}' was not found.")
        except Exception as e:
            print(f"An error occurred: {e}")

        self.system_prompt = system_prompt

    def generate_prompt(self, user_prompt: str, num_questions: int) -> str:
        seeds = generate_seeds(num_questions)

        return f"Random seed(s): {seeds}\n Generate {num_questions} question(s) about {user_prompt}. Each question, choice, and wording must be strongly influenced by their relative seed."




