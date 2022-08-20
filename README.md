# Test project info

The task is to sync call list item timestamp with worldtimeapi service on every account screen appearence.

# Compilation Guide

1. Install Xcode (directly from https://developer.apple.com/download/more or using the App Store).
2. Clone the project from GitHub:

```
git clone --recursive -j8 https://github.com/Denis-S/TelegramTestProject.git
```

3. Adjust configuration parameters

```
mkdir -p $HOME/telegram-configuration
cp -R build-system/example-configuration/* $HOME/telegram-configuration/
```

- Modify the values in `variables.bzl`
- Replace the provisioning profiles in `provisioning` with valid files

4. (Optional) Create a build cache directory to speed up rebuilds

```
mkdir -p "$HOME/telegram-bazel-cache"
```

5. Build the app

```
python3 build-system/Make/Make.py \
    --cacheDir="$HOME/telegram-bazel-cache" \
    build \
    --configurationPath="$HOME/telegram-configuration" \
    --buildNumber=100001 \
    --configuration=release_universal
```

6. (Optional) Generate an Xcode project

```
python3 build-system/Make/Make.py \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="$HOME/telegram-configuration" \
    --disableExtensions
```

It is possible to generate a project that does not require any codesigning certificates to be installed: add `--disableProvisioningProfiles` flag:
```
python3 build-system/Make/Make.py \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="$HOME/telegram-configuration" \
    --disableExtensions \
    --disableProvisioningProfiles
```


Tip: use `--disableExtensions` when developing to speed up development by not building application extensions and the WatchOS app.
