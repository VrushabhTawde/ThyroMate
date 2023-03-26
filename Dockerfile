FROM google/dart

WORKDIR C:\Users\Vrushabh\Downloads\ThyroCare-Application-main\ThyroCare-Application-main

ADD pubspec.* /app/
RUN pub get
ADD . /app
RUN pub get --offline

CMD []
ENTRYPOINT ["/usr/bin/dart", "main.dart"]