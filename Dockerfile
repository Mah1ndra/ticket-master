#Grab the latest alpine image
FROM alpine:latest

# Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash procps gcc python3-dev git openssh-client jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers \
    && pip install Pillow 
ADD ./requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD . /opt/webapp/
WORKDIR /opt/webapp
	
# Run the image as a non-root user
RUN adduser -D mah1ndra
USER mah1ndra

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD gunicorn --bind 0.0.0.0:$PORT wsgi 
