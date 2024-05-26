sudo apt update -y
sudo apt install docker.io -y
sudo usermod -a -G docker $USER
sudo snap install microk8s --classic
sudo snap install kubectl --classic
sudo apt install git -y
sudo usermod -a -G microk8s $USER
sudo microk8s.enable registry
git clone https://github.com/alhumaw/Big-Deployment
cd Big-Deployment/src
sudo docker build -t localhost:32000/flask:k8s .
sudo docker push localhost:32000/flask:k8s
cd ~/Big-Deployment/kube/demo
sudo microk8s.kubectl apply -f .

sudo apt install nginx -y
sudo cp ~/Big-Deployment/proxy.conf /etc/nginx/conf.d/
NEW_IP=$(microk8s.kubectl get services | grep flask | awk '{print $3}')
sudo sed -i "s/10\.152\.183\.93/$NEW_IP/g" /etc/nginx/conf.d/proxy.conf
sudo apt-get update -y
sudo apt-get install -y bison build-essential ca-certificates curl dh-autoreconf doxygen flex gawk git iputils-ping libcurl4-gnutls-dev libexpat1-dev libgeoip-dev liblmdb-dev libpcre3-dev libssl-dev libtool libxml2 libxml2-dev libyajl-dev locales lua5.3-dev pkg-config wget zlib1g-dev libgd-dev m4 automake g++ libperl-dev libxml2-dev libxslt1-dev 
cd /opt && sudo git clone https://github.com/SpiderLabs/ModSecurity
cd ModSecurity
sudo git submodule init; sudo git submodule update
sudo ./build.sh
sudo ./configure
sudo make
sudo make install
cd /opt && sudo git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
cd /opt && sudo curl http://nginx.org/download/nginx-1.24.0.tar.gz -o nginx-1.24.0.tar.gz
sudo tar xvzmf nginx-1.24.0.tar.gz
cd nginx-1.24.0
sudo ./configure --add-dynamic-module=../ModSecurity-nginx  --with-cc-opt='-g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/nginx-uqDps2/nginx-1.24.0=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection -fdebug-prefix-map=/build/nginx-uqDps2/nginx-1.24.0=/usr/src/nginx-1.24.0-2ubuntu7 -fPIC -Wdate-time -D_FORTIFY_SOURCE=3' --with-ld-opt='-Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=stderr --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-compat --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_sub_module --with-mail_ssl_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_perl_module=dynamic --with-http_xslt_module=dynamic --with-mail=dynamic --with-stream=dynamic --with-stream_geoip_module=dynamic
sudo make modules
sudo mkdir /etc/nginx/modules
sudo cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
sudo sed -i '/include \/etc\/nginx\/modules-enabled\/\*.conf;/a load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;' /etc/nginx/nginx.conf
sudo rm -rf /usr/share/modsecurity-crs
sudo git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs
sudo mv /usr/local/modsecurity-crs/crs-setup.conf.example /usr/local/modsecurity-crs/crs-setup.conf
sudo mv /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
sudo mkdir -p /etc/nginx/modsec
sudo cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec
sudo cp /opt/ModSecurity/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
sudo sed -i 's/^SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf
sudo touch /etc/nginx/modsec/main.conf
sudo sh -c 'echo "Include /etc/nginx/modsec/modsecurity.conf\nInclude /usr/local/modsecurity-crs/crs-setup.conf\nInclude /usr/local/modsecurity-crs/rules/*.conf" > /etc/nginx/modsec/main.conf'
sudo systemctl restart nginx

