FROM ruby:3.2

WORKDIR /app
COPY . .
RUN gem install bundler && bundle install
RUN chmod +x bin/shiftcare

CMD ["./bin/shiftcare"]