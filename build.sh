# config:
package="org.peertest.app"
label="peerTest"

# script:
echo "Android: 1/3: running plugins"
flutter pub get
dart run flutter_launcher_icons
dart run change_app_package_name:main $package


echo "Android: 2/3: building release apk"
flutter build apk --release

echo "Android: 3/3: copying apk"
rm -rf ./dist
mkdir ./dist
cp ./build/app/outputs/flutter-apk/app-release.apk ./dist/$label.apk
open ./dist
