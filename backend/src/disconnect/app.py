import boto3

from common.database_helper import DatabaseHelper
from common.response_helper import ResponseHelper
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chat-app-connections')
database_helper = DatabaseHelper(table)

def disconnect(event, context):
    logger.info(f'event: {event}')
    logger.info(f'context: {context}')

    connection_id: str = event.get('requestContext', {}).get('connectionId')

    try:
        chat_id: str = database_helper.get_chat_id_by_connection_id(connection_id)
    except Exception as e:
        print(f'Error getting chatId: {e}')
        return ResponseHelper.the_status_code

    if connection_id is None or chat_id is None:
        print(f'Error for the following values, chatId: {chat_id} connectionId {connection_id}')
        return ResponseHelper.the_status_code

    try:
        response = database_helper.delete_connection_id_and_chat_id(chat_id, connection_id)
        return ResponseHelper.the_status_code(response['ResponseMetadata']['HTTPStatusCode'])
    except Exception as e:
        print(f'Error deleting from database: {e}')
        return ResponseHelper.the_status_code(500)
