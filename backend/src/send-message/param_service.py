import json
import logging
import os

import boto3
import urllib3
logger = logging.getLogger()
logger.setLevel(logging.INFO)

class ParamService:

    @staticmethod
    def get_param(name):
        try:
            return ParamService._retrieve_extension_value(name)
        except Exception as e:
            logger.error(f'Unable to pull param from extension, using boto3: {e}')
            return ParamService._retrieve_params_boto(name)

    @staticmethod
    def _retrieve_extension_value(name):
        url = f'/systemsmanager/parameters/get/?name={name}&withDecryption=true'
        http = urllib3.PoolManager()
        url = ('http://localhost:' + "2773" + url)
        headers = {"X-Aws-Parameters-Secrets-Token": os.environ.get('AWS_SESSION_TOKEN')}
        response = http.request("GET", url, headers=headers)
        response = json.loads(response.data)
        return response.get('Parameter', {}).get('Value')

    @staticmethod
    def _retrieve_params_boto(name: str):
        param = boto3.client('ssm')
        response = param.get_parameter(
            Name=name,
            WithDecryption=True
        )
        return response.get('Parameter', {}).get('Value')