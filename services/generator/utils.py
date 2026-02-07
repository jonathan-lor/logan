import random
from typing import List


# return system prompt given from a file
def load_system_prompt(file_path: str) -> str:

    try:
        with open(file_path, 'r') as file:
            system_prompt = file.read()
        print("Successfully read system prompt file")
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return system_prompt


# generate a random seed from 0 to 1000000
def generate_seed() -> int:
    return random.randint(0,1_000_000)

# generate n random seeds returning list of seeds
def generate_seeds(n: int) -> List[int]:
    return [generate_seed() for i in range(n)]
