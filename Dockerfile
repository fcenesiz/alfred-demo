# Specify the Dart SDK base image version using dart<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and ADT compile it.
COPY . .

# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/main.dart -o bin/server.exe

# Build minimal serving image from ADT-compiled '/server' and required system
# libraries and configuration files stored in '/runtime/' from build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server.exe /app/bin/

# Start server.
EXPOSE 3000
CMD ["/app/bin/server.exe"]