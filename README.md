# android-build

Docker image to build android apps on [Drone Ci](https://github.com/drone/drone)

It also includes the following python libs (python)

- google-api-python-client (to be able to automatically upload APKs to Google Play)
- onesky-python (to upload the `strings.xml` files to OneSky to get translations)
- tinys3 (to upload mappings.txt to S3)
- trollop (to upload to Trello release notes)

The `.drone.yml` (build part) could be something like:

```
build:
  apk:
    image: comptel/android:sdk2441-sup2330
    environment:
      - ENDPOINT_OVERRIDE=true
    commands:
      - ./gradlew assemble
```
