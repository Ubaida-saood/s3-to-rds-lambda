import boto3
import json
import pymysql
import os

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    
    bucket = 's3-bucket-ubaida-saood'
    key = 'data.json'

    try:
        response = s3_client.get_object(Bucket=bucket, Key=key)
        data = json.loads(response['Body'].read().decode('utf-8'))
    except Exception as e:
        return {'statusCode': 500, 'body': f"Error reading S3: {str(e)}"}

    try:
        rds_host = os.environ['RDS_HOST']
        rds_user = os.environ['RDS_USER']
        rds_password = os.environ['RDS_PASSWORD']
        rds_db = os.environ['RDS_DB']

        conn = pymysql.connect(host=rds_host, user=rds_user, password=rds_password, db=rds_db)
        with conn.cursor() as cur:
            cur.execute("CREATE TABLE IF NOT EXISTS data (id INT AUTO_INCREMENT PRIMARY KEY, value VARCHAR(255))")
            for item in data:
                cur.execute("INSERT INTO data (value) VALUES (%s)", (item['value'],))
            conn.commit()
        conn.close()
        return {'statusCode': 200, 'body': 'Data pushed to RDS'}
    except Exception as e:
        return {'statusCode': 500, 'body': f"RDS failed: {str(e)}"}
