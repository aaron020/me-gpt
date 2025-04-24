import logging

import anthropic
from anthropic.types import Message
from prompts import prompt_factory, SYSTEM
logger = logging.getLogger()
logger.setLevel(logging.INFO)

class GPTService:

    def __init__(self, api_key: str):
        key = api_key
        self.client = anthropic.Anthropic(
            api_key=key,
        )

    def call_gpt_serivce(self, tone: str, message: str):
        prompt = prompt_factory(tone, message)
        try:
            logger.info(f'Sending the following prompt: {prompt}')
            message: Message = self.client.messages.create(
                model="claude-3-5-haiku-20241022",
                max_tokens=200,
                temperature=1,
                system=SYSTEM,
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




