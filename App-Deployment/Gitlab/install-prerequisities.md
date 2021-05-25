## Install MRI ruby2.7.0
```
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
```

To use RVM tool, you have to source the script:
```
source ~/.rvm/scripts/rvm
```

List available versions:
```
rvm list known|more
```

For GitLab purposes, you have to install MRI Rubies version >= 2.6.x:
```
rvm install 2.6
rvm use 2.6 default
```

## Install Go1.15.3 language
```
wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz
echo "PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
```

## Install Git
1. Install Git prerequisites
```
sudo yum install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel gcc aut curl-devel asciidoc xmlto
sudo yum --enablerepo=PowerTools -y install docbook2X
sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
wget https://github.com/libexpat/libexpat/releases/download/R_2_2_10/expat-2.2.10.tar.gz
tar -zxf expat-2.2.10.tar.gz
cd expat-2.2.10
./configure
sudo make
sudo make install
```
2. Install git2.9.5
```
sudo yum remove -y git
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
tar -zxf git-2.9.5.tar.gz
cd git-2.9.5
make prefix=/usr all doc info
sudo make prefix=/usr install install-doc install-html install-info
```

## Install NodeJS14.15.0
```
sudo yum install -y python3
wget https://nodejs.org/dist/v14.15.0/node-v14.15.0.tar.gz
tar -zxf node-v14.15.0.tar.gz
cd node-v14.15.0
make -j4
sudo make install
```

## Install Redis6.0.9
```
sudo yum install -y tcl
wget https://download.redis.io/releases/redis-6.0.9.tar.gz?_ga=2.152608761.1579904925.1604243476-842524019.1604243476
tar -zxf redis-6.0.9.tar.gz?_ga=2.152608761.1579904925.1604243476-842524019.1604243476
cd redis-6.0.9
make
make test
sudo make install
```
