FROM ubuntu:20.04

RUN sed -i -E 's/http:\/\/(.*\.)?(archive\.ubuntu\.com)/http:\/\/tw\.\2/g' /etc/apt/sources.list && \
echo "tzdata tzdata/Areas select Asia" | debconf-set-selections && \
echo "tzdata tzdata/Zones/Asia select Taipei" | debconf-set-selections && \
echo "locales locales/default_environment_locale select zh_TW.UTF-8" | debconf-set-selections && \
echo "locales locales/locales_to_be_generated multiselect zh_TW.UTF-8 UTF-8" | debconf-set-selections && \
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen vim wget curl screen sudo && \
apt-get -y install jq git apt-utils software-properties-common sudo tzdata locales language-pack-zh-hant language-pack-zh-hant-base apt-transport-https ca-certificates gnupg-agent build-essential pkg-config libmagickwand-dev gcc-multilib dkms make gcc g++ && \
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
dpkg-reconfigure --frontend noninteractive tzdata && \
rm -f "/etc/locale.gen" && \
dpkg-reconfigure --frontend noninteractive locales && \
locale-gen en_US.UTF-8 && \
export LANG=zh_TW.UTF-8 && \
export LC_ALL=zh_TW.UTF-8 && \
echo "export LANG=zh_TW.UTF-8" >> ~/.bashrc && \
echo "export LC_ALL=zh_TW.UTF-8" >> ~/.bashrc && \
echo "export TZ=Asia/Taipei" >> ~/.bashrc && \
add-apt-repository -y ppa:ondrej/php && \
apt-get update && \
apt-get install -y php7.4 php7.4-common php7.4-json php7.4-opcache php-uploadprogress php-memcache php7.4-zip php7.4-mysql php7.4-phpdbg php7.4-gd php7.4-imap php7.4-ldap php7.4-pgsql php7.4-pspell php7.4-tidy php7.4-dev php7.4-intl php7.4-curl php7.4-xmlrpc php7.4-xsl php7.4-bz2 php7.4-mbstring imagemagick mysql-client && \
echo 'autodetect'|pecl install imagick && \
echo "extension=imagick.so" | tee /etc/php/7.4/mods-available/imagick.ini && \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer && \
composer global require drush/drush:8.4.8 --prefer-dist && \
echo "export PATH=$HOME/.config/composer/vendor/bin:$PATH" >> ~/.bashrc 

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
