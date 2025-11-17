FROM ruby:3.4-alpine

COPY . /root/issuer

WORKDIR /root/issuer

RUN bundle

EXPOSE 5000

CMD ["ruby", "server.rb"]
