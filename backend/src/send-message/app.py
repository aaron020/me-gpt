import json
import logging
import time

from param_service import ParamService
from gpt_service import GPTService
import boto3

from common.database_helper import DatabaseHelper
from common.response_helper import ResponseHelper

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chat-app-connections')
database_helper = DatabaseHelper(table)



def send_message(event, context):
    logger.info(f'event: {event}')
    logger.info(f'context: {context}')

    domain = event.get("requestContext", {}).get("domainName")
    stage = event.get("requestContext", {}).get("stage")

    apig_management_client = boto3.client(
        "apigatewaymanagementapi", endpoint_url=f"https://{domain}/{stage}"
    )

    body = event.get("body")
    body = json.loads(body if body is not None else '{"msg": ""}')
    message_from_input = body.get('message')
    tone_from_input = body.get('tone')
    connection_id: str = event.get('requestContext', {}).get('connectionId')

    #Get Params
    try:
        api_key: str = ParamService.get_param('claude_api_token')
    except Exception as e:
        logger.error(f'Unable to retrieve param: {e}')
        api_key = ''

    text: str = GPTService(api_key).call_gpt_serivce(tone_from_input, message_from_input)


    try:
        chat_id: str = database_helper.get_chat_id_by_connection_id(connection_id)
        connections: list = database_helper.get_connections_by_chat_id(chat_id)
    except Exception as e:
        print(f'Error getting chat connection ids: {e}')
        return ResponseHelper.the_status_code



    for connection in connections:
        send = {
            "user": connection.get('user'),
            "message": text,
            "time": int(time.time()),
            "tone": tone_from_input
        }
        apig_management_client.post_to_connection(
            Data=json.dumps(send), ConnectionId=connection.get('connectionId')
        )
    return ResponseHelper.the_status_code(200)