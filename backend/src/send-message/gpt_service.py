import anthropic
from anthropic.types import Message
from prompts import prompt_factory


class GPTService:

    def __init__(self, api_key: str):
        key = api_key
        self.client = anthropic.Anthropic(
            api_key=key,
        )

    def call_gpt_serivce(self, tone: str, message: str):
        prompt = prompt_factory(tone, message)
        try:
            message: Message = self.client.messages.create(
                model="claude-3-5-haiku-20241022",
                max_tokens=200,
                temperature=1,
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": prompt
                            }
                        ]
                    }
                ]
            )
            return message.content[0].text
        except Exception as e:
            return message




