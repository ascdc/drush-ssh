FROM drush/drush

# Install packages

ADD locale.gen /etc/locale.gen
ADD locale-archive /usr/lib/locale/locale-archive	
	 
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen vim wget curl screen sudo
RUN mkdir -p /var/run/sshd &&  \
	sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
	sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
	sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
	echo "cd /app" >> /root/.profile && \
	echo "alias ll='ls -al'" >> /root/.profile && \
	apt-get install -y locales && \
	locale-gen zh_TW.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \ 
	locale-gen zh_TW.UTF-8 && \
	echo "export LANG=zh_TW.UTF-8" >> /root/.profile && \ 
	echo "export LANGUAGE=zh_TW" >> /root/.profile && \
	echo "export LC_ALL=zh_TW.UTF-8" >> /root/.profile

ENV LANG zh_TW.UTF-8  
ENV LANGUAGE zh_TW
ENV LC_ALL zh_TW.UTF-8 
	
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**

WORKDIR /app
EXPOSE 22
ENTRYPOINT ["/run.sh",""]

#CMD ["/run.sh"]
