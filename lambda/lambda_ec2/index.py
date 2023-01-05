import boto3
import os


def put_parameter():
    ssm_client = boto3.client('ssm')
    parameter_name = os.getenv("PARAMETER_NAME")
    ssm_client.put_parameter(Name=parameter_name, Value="parameter_value", Type="String")

def lambda_handler(event, context):
    put_parameter()

    


    
