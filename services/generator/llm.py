
from google import genai
from question_schemas import *
from topic_schemas import *


class llm:

    def __init__(self, api_key:str):
        self.client = genai.Client(api_key=api_key)

    # returns question json from specified prompt
    def get_question_json(self, prompt: str):
        response = self.client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt,
            config={
                "response_mime_type": "application/json",
                "response_json_schema": QuestionChunk.model_json_schema(),
            },
        )

        return QuestionChunk.model_validate_json(response.text)

    def get_topic_json(self, prompt: str):
        response = self.client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt,
            config={
                "response_mime_type": "application/json",
                "response_json_schema": Topics.model_json_schema(),
            },
        )

        return Topics.model_validate_json(response.text)
