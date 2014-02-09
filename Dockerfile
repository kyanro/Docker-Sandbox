FROM ubuntu:13.04

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install ssh git build-essential libssl-dev curl

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN /bin/bash -c ". ~/.bashrc; rbenv install 2.0.0-p353"
RUN /bin/bash -c ". ~/.bashrc; rbenv global 2.0.0-p353"
RUN /bin/bash -c ". ~/.bashrc; rbenv rehash"

RUN /bin/bash -c ". ~/.bashrc; gem install bundler rubygems-bundler --no-rdoc --no-ri"
RUN /bin/bash -c ". ~/.bashrc; gem regenerate_binstubs"
RUN /bin/bash -c ". ~/.bashrc; bundle config --global path 'vendor/bundle'"

RUN mkdir -p /apps/myapi
RUN cd /apps/myapi
RUN /bin/bash -c ". ~/.bashrc; bundle init"
RUN echo 'gem "sinatra"' >> Gemfile 
RUN /bin/bash -c ". ~/.bashrc; bundle install"

RUN echo "require 'sinatra'" > /apps/myapi/myapp.rb
RUN echo "get '/' do" >> /apps/myapi/myapp.rb
RUN echo "  'Hello world'" >> /apps/myapi/myapp.rb
RUN echo "end" >> /apps/myapi/myapp.rb

RUN mkdir /apps/myapi/public
RUN echo "this is test" > /apps/myapi/public/test.txt

EXPOSE 4567
 
# ENV BUNDLE_GEMFILE /apps/myapi/Gemfile
 
CMD ["/bin/bash", "-c", ". ~/.bashrc; cd /apps/myapi; bundle exec ruby myapp.rb -e production"]
