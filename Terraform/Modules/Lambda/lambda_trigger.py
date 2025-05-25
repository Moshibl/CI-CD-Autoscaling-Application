import json
import urllib3
import os

def lambda_handler(event, context):
    jenkins_url = os.environ["JENKINS_URL"]
    http = urllib3.PoolManager()
    response = http.request("POST", jenkins_url)
    
    return {
        "statusCode": response.status,
        "body": "Triggered Jenkins job"
    }
