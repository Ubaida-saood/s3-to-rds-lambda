FROM public.ecr.aws/lambda/python:3.9
COPY lambda_function.py ${LAMBDA_TASK_ROOT}
RUN pip install boto3 pymysql --target "${LAMBDA_TASK_ROOT}"
CMD ["lambda_function.lambda_handler"]
