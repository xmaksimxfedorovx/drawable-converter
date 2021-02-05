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
	mkdir -p drawable-xxxhdpi
	mkdir -p drawable-xxhdpi
	mkdir -p drawable-xhdpi
	mkdir -p drawable-hdpi
	mkdir -p drawable-mdpi

	if [ $1 = "ic_launcher.png" ]; then
		echo "  App icon detected"
		convert ic_launcher.png -resize 192x192 drawable-xxxhdpi/ic_launcher.png
		convert ic_launcher.png -resize 144x144 drawable-xxhdpi/ic_launcher.png
		convert ic_launcher.png -resize 96x96 drawable-xhdpi/ic_launcher.png
		convert ic_launcher.png -resize 72x72 drawable-hdpi/ic_launcher.png
		convert ic_launcher.png -resize 48x48 drawable-mdpi/ic_launcher.png
		rm -i ic_launcher.png
	else
		convert $1 -resize 75% drawable-xxhdpi/$1
		convert $1 -resize 67% drawable-xhdpi/$1
		convert $1 -resize 50% drawable-hdpi/$1
		convert $1 -resize 33% drawable-mdpi/$1
		cp $1 drawable-xxxhdpi/$1
	fi
}

create_ios_assets() {
	echo " Processing ios assets of $1 ..."
	file_argument=$1
	full_file_name="${file_argument##*/}"
	file_extension="${full_file_name##*.}"
	file_name="${full_file_name%.*}"
	mkdir -p ios
	convert $1 -resize 67% ios/$file_name@2x.$file_extension
	convert $1 -resize 33% ios/$full_file_name
	cp $1 ios/$file_name@3x.$file_extension
}

# Main script
readonly MAX_NUMBER_OF_ARGUMENTS=2
readonly IOS_PLATFORM_KEY="ios"
readonly ANDROID_PLATFORM_KEY="android"

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
