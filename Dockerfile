# This is httpd static web service web page

FROM centos:7 
MAINTAINER Rakesh <jangidrakesh71@gmail.com>
LABEL image=baseos

# Install necessary packages
RUN yum -y install httpd unzip

# Set up the project directory
RUN mkdir /project

# Download and extract the zip file
ADD https://www.free-css.com/assets/files/free-css-templates/download/page293/hexashop.zip /project
RUN unzip /project/hexashop.zip 
WORKDIR /project
COPY /project/templatemo_571_hexashop/* /var/www/html/ 

# Set the working directory
WORKDIR /var/www/html/

# Expose port 80
EXPOSE 80

# Start the httpd web service
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

