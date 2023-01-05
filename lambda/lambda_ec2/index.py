import boto3
import os


def put_parameter():
    ssm_client = boto3.client('ssm')
    ssm_client.put_parameter(Name="/countscript/run", Value="parameter_value", Type="String")

def lambda_handler(event, context):
    put_parameter()

    


    
