FROM markllama/cd-jenkins-agent

# Include YUM repos (in container?)

# Install Packages
ARG PYTHON_PACKAGES="python-devel python-pip"
ARG RUBY_PACKAGES="ruby ruby-devel bundler"
ARG JS_PACKAGES="npm"
ARG CPP_PACKAGES="gcc-c++"
ARG LIBRARY_PACKAGES="zlib-devel libyaml-devel libffi-devel openssl-devel \
iconv-devel libxml2-devel libxslt-devel ImageMagick-devel"
ARG BUILD_PACKAGES="make autoconf automake patch bison libtool tito"

ARG PACKAGES="go atomic $PYTHON_PACKAGES $RUBY_PACKAGES $JS_PACKAGES \
$CPP_PACKAGES $LIBRARY_PACKAGES $BUILD_PACKAGES"

ARG PACKAGES_SAVE="golang atomic tito npm python-devel gcc-c++ patch \
readline readline-devel zlib zlib-devel libyaml-devel libffi-devel \
openssl-devel make bzip2 autoconf automake libtool bison iconv-devel \
ruby ruby-devel bundler libxml2 libxml2-devel libxslt libxslt-devel \
ImageMagick ImageMagick-devel python-pip"

RUN yum install -y epel-release ; yum -y clean all
RUN yum install -y $PACKAGES ; yum -y clean all
