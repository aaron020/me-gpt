import json
import logging
from decimal import Decimal

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def decimal_serializer(obj):
    if isinstance(obj, Decimal):
        return float(obj)  # Or use str(obj) if you prefer strings for Decimal
    raise TypeError(f"Object of type {type(obj).__name__} is not JSON serializable")

class ResponseHelper:

    @staticmethod
    def the_status_code(code: int):
        if 200 <= code <= 299:
            logger.info(f'Returning a status code: {code}')
            return {
                'statusCode': code
            }
        elif 400 <= code <= 599:
            logger.error(f'Returning a status code: {code}')
            return {
                'statusCode': code
            }
        else:
            logger.info(f'Returning a non-standard status code: {code}')
            return {
                'statusCode': code
            }

    @staticmethod
    def cors_headers(self):
        return {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': '*',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
        }

    @staticmethod
    def build_response(body, status_code, headers) -> dict:

        if isinstance(body, str):
            body = json.dumps(body)
        elif isinstance(body, list) or isinstance(body, dict):
            body = json.dumps(body, default=decimal_serializer)
        else:
            body = body

        return {
            'statusCode': status_code,
            'headers': headers,
            'body': body
        }




