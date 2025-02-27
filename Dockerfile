FROM public.ecr.aws/lambda/python:3.9
COPY lambda_function.py ${LAMBDA_TASK_ROOT}
RUN pip install boto3 pymysql --target "${LAMBDA_TASK_ROOT}"
CMD ["lambda_function.lambda_handler"]
 
#  The  Dockerfile  is used to build the Lambda function image. The  FROM  statement specifies the base image to use, which is the  public.ecr.aws/lambda/python:3.9  image. The  COPY  statement copies the  lambda_function.py  file to the  LAMBDA_TASK_ROOT  directory. The  RUN  statement installs the  boto3  and  pymysql  packages to the  LAMBDA_TASK_ROOT  directory. The  CMD  statement specifies the entry point for the Lambda function. 
#  Step 3: Build the Docker image 
#  To build the Docker image, run the following command: 
#  docker build -t s3-to-rds-lambda .
 
#  Step 4: Run the Docker container 
#  To run the Docker container, run the following command: 
#  docker run -p 9000:8080 s3-to-rds-lambda
 
#  The  -p 9000:8080  option maps port 9000 on the host to port 8080 in the container. 
#  Step 5: Invoke the Lambda function 
#  To invoke the Lambda function, run the following command: 
#  curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
 
#  The Lambda function is invoked and the output is displayed in the terminal. 
#  Conclusion 
#  In this post, I showed you how to build and run a Lambda function image locally using Docker. You can use this approach to test your Lambda function locally before deploying it to AWS. 
#  To learn more about building Lambda function images, see the following resources: 
 
#  AWS Lambda now supports container images
#  Building Lambda functions with container images
#  AWS Lambda container image support documentation
 
#  If you have questions or feedback, please leave a comment. 
#  About the author 
#  Sajith Jayaprakash is a Solutions Architect at Amazon Web Services. He works with customers to help them build secure, scalable, and cost-effective solutions on AWS. In his spare time, he enjoys playing cricket and watching movies.