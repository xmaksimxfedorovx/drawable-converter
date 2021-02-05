# drawable-converter
This is a simple shell script that will automate creating banch of images with different resolutions routine for mobile platforms such as iOS and Android.
It's a fork of [Kishanjvaghela/drawable-converter](https://github.com/Kishanjvaghela/drawable-converter) repo.

## Requirements:
- <b>ImageMagick</b> - you must install this software because script uses it <i>convert</i> command
- Tool with command shell functions. For instance, Terminal in Mac/Linux or Cygwin in Windows
- High resolution source image (xxxhdpi for Android and @3x for iOS)
- Basic shell knowledges

## How to use:
- Clone it
- Copy source images into repository folder or alternatively you can simply copy converter.sh script into folder with source images
- Open terminal or another tool with command shell functions
- Move to folder with this script
- Execute command
```sh
sh converter.sh [platform] [image_name]
```
- Move created images to you target folder

## Options
- <b>[platform]</b> - optional parameter. Specify images target platform. Value can be <b>ios</ios> or <b>android</b>. If value not specified folders for both platforms will be created.
- <b>[image_name]</b> - source image name

## Examples:
```sh
sh converter.sh foo.png
```
Will create two folders(ios and android) with banch of target images

```sh
sh converter.sh ios foo.png
```
Will create only folder with images for iOS

```sh
sh converter.sh android foo.png
```
Will create only folder with subfolders and images for Android

## Links:
- [ImageMagick](https://imagemagick.org/)
- [Image Size and Resolution - iOS - Apple Developer](https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/image-size-and-resolution/)
- [Support different pixel densities | Android Developers](https://developer.android.com/training/multiscreen/screendensities)
- [Stack Overflow](https://stackoverflow.com/)
