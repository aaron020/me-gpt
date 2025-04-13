import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

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



