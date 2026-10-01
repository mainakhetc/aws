import json

def lambda_handler(event, context):

    response = {
        "message": "Hello from AWS Lambda!",
        "environment": "AWS Serverless",
        "status": "success"
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response)
    }
