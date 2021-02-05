check_number_of_arguments() {
	if [ $# -eq 0 ]; then
		echo "No arguments supplied"
		exit
	fi

	if [ $# -gt $MAX_NUMBER_OF_ARGUMENTS ]; then
		echo "Can't specify more than $MAX_NUMBER_OF_ARGUMENTS arguments"
		exit
	fi
}

check_platform_argument() {
	if [ -z $1 ] || [ $1 != $IOS_PLATFORM_KEY ] && [ $1 != $ANDROID_PLATFORM_KEY ]; then
		echo "Must specify first argument with value [$ANDROID_PLATFORM_KEY|$IOS_PLATFORM_KEY]"
		exit
	fi	
}

check_file_argument() {
	if ! [ -f $1 ]; then
		echo "file $1 not found"
		exit
	fi
}

create_android_drawable() {
	echo " Creating different dimensions (dips) of $1 ..."
	mkdir -p $ANDROID_OUTPUT_FOLDER_NAME
	mkdir -p $ANDROID_OUTPUT_FOLDER_NAME/drawable-xxxhdpi
	mkdir -p $ANDROID_OUTPUT_FOLDER_NAME/drawable-xxhdpi
	mkdir -p $ANDROID_OUTPUT_FOLDER_NAME/drawable-xhdpi
	mkdir -p $ANDROID_OUTPUT_FOLDER_NAME/drawable-hdpi
	mkdir -p $ANDROID_OUTPUT_FOLDER_NAME/drawable-mdpi

	if [ $1 = "ic_launcher.png" ]; then
		echo "  App icon detected"
		convert ic_launcher.png -resize 192x192 $ANDROID_OUTPUT_FOLDER_NAME/drawable-xxxhdpi/ic_launcher.png
		convert ic_launcher.png -resize 144x144 $ANDROID_OUTPUT_FOLDER_NAME/drawable-xxhdpi/ic_launcher.png
		convert ic_launcher.png -resize 96x96 $ANDROID_OUTPUT_FOLDER_NAME/drawable-xhdpi/ic_launcher.png
		convert ic_launcher.png -resize 72x72 $ANDROID_OUTPUT_FOLDER_NAME/drawable-hdpi/ic_launcher.png
		convert ic_launcher.png -resize 48x48 $ANDROID_OUTPUT_FOLDER_NAME/drawable-mdpi/ic_launcher.png
	else
		convert $1 -resize 75% $ANDROID_OUTPUT_FOLDER_NAME/drawable-xxhdpi/$1
		convert $1 -resize 67% $ANDROID_OUTPUT_FOLDER_NAME/drawable-xhdpi/$1
		convert $1 -resize 50% $ANDROID_OUTPUT_FOLDER_NAME/drawable-hdpi/$1
		convert $1 -resize 33% $ANDROID_OUTPUT_FOLDER_NAME/drawable-mdpi/$1
		cp $1 $ANDROID_OUTPUT_FOLDER_NAME/drawable-xxxhdpi/$1
	fi
}

create_ios_assets() {
	readonly FOLDER_NAME="ios"
	echo " Processing ios assets of $1 ..."
	file_argument=$1
	full_file_name="${file_argument##*/}"
	file_extension="${full_file_name##*.}"
	file_name="${full_file_name%.*}"
	mkdir -p $FOLDER_NAME
	convert $1 -resize 67% $FOLDER_NAME/$file_name@2x.$file_extension
	convert $1 -resize 33% $FOLDER_NAME/$full_file_name
	cp $1 $FOLDER_NAME/$file_name@3x.$file_extension
}

# Main script
readonly MAX_NUMBER_OF_ARGUMENTS=2
readonly IOS_PLATFORM_KEY="ios"
readonly ANDROID_PLATFORM_KEY="android"
readonly IOS_OUTPUT_FOLDER_NAME="ios"
readonly ANDROID_OUTPUT_FOLDER_NAME="android"

check_number_of_arguments $@

if [ $# -eq 1 ] && ! [ -f $1 ]; then
	echo "Specify correct file name for command invoke without platform argument"
	exit
fi

if [ $# -eq 1 ] && [ -f $1 ]; then
	create_android_drawable $1
	create_ios_assets $1
fi

if [ $# -eq $MAX_NUMBER_OF_ARGUMENTS ]; then
	check_platform_argument $1
	check_file_argument $2

	case $1 in
		$ANDROID_PLATFORM_KEY)
			create_android_drawable $2
			;;
		$IOS_PLATFORM_KEY)
			create_ios_assets $2
			;;
		*)
			echo " Only [$ANDROID_PLATFORM_KEY|$IOS_PLATFORM_KEY] value allowed"
			exit
			;;
	esac
fi

echo " Done"
