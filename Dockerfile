FROM ruby:3.4

COPY . /root/issuer

WORKDIR /root/issuer

RUN bundle

EXPOSE 5000

#CMD ["puma", "-C", "puma_config.rb", "server.rb"]
CMD ["ruby", "server.rb"]
