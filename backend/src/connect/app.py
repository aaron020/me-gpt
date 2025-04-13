import boto3

from common.database_helper import DatabaseHelper
from common.response_helper import ResponseHelper
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chat-app-connections')
database_helper = DatabaseHelper(table)

def connect(event, context):
    logger.info(f'event: {event}')
    logger.info(f'context: {context}')


    connection_id: str = event.get('requestContext', {}).get('connectionId')
    user = event.get("queryStringParameters", {"name": "guest"}).get("user")
    chat_id = event.get("queryStringParameters", {}).get("chatId")

    if connection_id is None or chat_id is None:
        print(f'Error for the following values, chatId: {chat_id} connectionId {connection_id}')
        return ResponseHelper.the_status_code(400)


    try:
        response = database_helper.put_connection_id_and_chat_id_and_user(chat_id, connection_id, user)
        return ResponseHelper.the_status_code(response['ResponseMetadata']['HTTPStatusCode'])
    except Exception as e:
        print(f'Error adding to database: {e}')
        return ResponseHelper.the_status_code(500)



