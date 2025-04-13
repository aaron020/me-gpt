from boto3.dynamodb.conditions import Key


class DatabaseHelper:

    def __init__(self, table_connection):
        self.table_connection = table_connection

    def get_chat_id_by_connection_id(self, connection_id) -> str:
        response = self.table_connection.query(
            IndexName='ConnectionIdIndex',
            KeyConditionExpression='connectionId = :value',
            ExpressionAttributeValues={
                ':value': connection_id
            }
        )
        return response.get('Items', [{}])[0].get('chatId')

    def put_connection_id_and_chat_id_and_user(self, chat_id: str, connection_id: str, user: str):
        return self.table_connection.put_item(
            Item={
                'chatId': chat_id,
                'connectionId': connection_id,
                'user': user
            }
        )

    def delete_connection_id_and_chat_id(self, chat_id: str, connection_id: str):
        return self.table_connection.delete_item(
            Key={
                'chatId': chat_id,
                'connectionId': connection_id
            }
        )

    def get_connections_by_chat_id(self, chat_id: str) -> list:
        response = self.table_connection.query(KeyConditionExpression=Key('chatId').eq(chat_id))
        return response.get('Items')
