FROM python:3.10-buster AS builder-image 

COPY ./requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple/ --upgrade -r /app/requirements.txt 


FROM python:3.10-slim-buster
COPY --from=builder-image /usr/local/bin /usr/local/bin
COPY --from=builder-image /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY ./ ./

ENV PYTHONPATH "${PYTHONPATH}:/app"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY ./serialization.py /usr/local/lib/python3.10/site-packages/torch/

EXPOSE 8000
CMD ./run_server.sh
