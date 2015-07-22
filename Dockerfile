FROM dockerfile/ubuntu
MAINTAINER Sergio Diaz <sergio@alphasquare.us>

ENV DEBIAN_FRONTEND noninteractive

# Branches and settings
ENV url = "https://github.com/mxious/mxious.git"
ENV branch = "next"

ADD . /app
WORKDIR /app

RUN apt-get update && \
	apt-get upgrade && \
	apt-get install -y src/core.txt

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 2>&1 && \
 	add-apt-repository 'deb http://dl.hhvm.com/ubuntu trusty main' 2>&1 && \
 	apt-get update -qq && \
 	apt-get install -y core/stack.txt && \
 	apt-get -y -qq clean

RUN /usr/share/hhvm/install_fastcgi.sh && \
    update-rc.d hhvm defaults && \
    service hhvm restart

RUN git clone $url /usr/share/nginx/html && \
	git checkout $branch

RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default

COPY src/default /etc/nginx/sites-enabled
COPY src/default /etc/nginx/sites-available

VOLUME ["/usr/share/nginx/html"]
VOLUME ["/etc/nginx"]

EXPOSE 80

