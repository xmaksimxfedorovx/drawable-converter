check_number_of_arguments()
{
	if [ $# -eq 0 ]; then
		echo "No arguments supplied"
		exit
	fi

	if [ $# -lt $MIN_NUMBER_OF_ARGUMENTS ]; then
		echo "Must specify at least $MIN_NUMBER_OF_ARGUMENTS arguments"
		exit
	fi

	if [ $# -gt $MAX_NUMBER_OF_ARGUMENTS ]; then
		echo "Can't specify more than $MAX_NUMBER_OF_ARGUMENTS arguments"
		exit
	fi
}

create_android_drawable()
{
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
		mv $1 drawable-xxxhdpi/$1
	fi
}

# Main script
readonly MIN_NUMBER_OF_ARGUMENTS=2
readonly MAX_NUMBER_OF_ARGUMENTS=3
readonly IOS_PLATFORM_KEY="ios"
readonly ANDROID_PLATFORM_KEY="android"

check_number_of_arguments "$@"

if ! [ -f "$1" ]; then
	echo "$1 not found"
	exit
fi

if [ -z "$2" ]; then
	echo "No platform required argument supplied"
	exit
fi

case $2 in
	"android")
		echo " Creating different dimensions (dips) of "$1" ..."
		create_android_drawable $1
		;;
	"ios")
		echo " Processing ios assets"
		;;
	*)
		echo " Only [android|ios] value allowed"
		exit
		;;
esac

echo " Done"
