# Create Docker Image for terraform to run; instead of using terraform public image from Docker Hub

FROM --platform=amd64 ubuntu:20.04

# prep base ubuntu image with package updates and tools needed
RUN apt-get update
RUN apt -y install curl gnupg software-properties-common

# install tfenv, terraform, unzip, and git
RUN apt update && apt install -y git unzip
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
RUN ln -s ~/.tfenv/bin/* /usr/local/bin
RUN tfenv install 0.12.29
RUN tfenv use 0.12.29

# install the terraform source (save a git clone)
ADD ./app-resources/tf-src/ /root/tf-app-rsrcs/
ADD ./app-resources/run.sh /root/

CMD /root/run.sh