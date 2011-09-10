#/bin/sh

# quick hack to automate local user bleeding-edge chromium build installs

# how do you like to call this program? (chrome-linux, chrome, chromium, google-chrome?)
APPNAME="chromium"
# get the latest build number (JSON)
VERSION=$(wget -qO- http://build.chromium.org/f/chromium/snapshots/chromium-linux-reliability/LATEST)
# get some extra metadata to display on the command line
LOGURL="http://build.chromium.org/f/chromium/snapshots/chromium-linux-reliability/"$VERSION"/REVISIONS"
LOG=$(wget -qO- $LOGURL)
# build the URL of the file we'll be downloading
DOWNLOADURL="http://build.chromium.org/f/chromium/snapshots/chromium-linux-reliability/"$VERSION"/chrome-linux.zip"



# Here's some command line output ...
echo -e "\r\n-------------------------"
echo "BUILD: "$VERSION
echo $LOGURL
echo $LOG
echo -e "-------------------------\r\n"

# if this was already downloaded, then it would either need to be deleted or aborted

# where should we put this 37MB download?
tempfile="/tmp/chrome-linux-"$VERSION".zip"
tempdir="/tmp/chrome-linux/"$VERSION
# just putting this in my home directory now because i'm lazy
permdir=~/$APPNAME"/"$VERSION

# get the large download ...
wget $DOWNLOADURL -O $tempfile
mkdir -p $permdir
unzip $tempfile -d $permdir

# if the symlink exists it needs to be removed now
# actually, this should be linked to the user's personal bin space and sudo/password wouldn't be needed ... 
# (so for time being it's needing password :(
sudo rm "/usr/local/bin/"$APPNAME
sudo ln -s $permdir"/chrome-linux/chrome" "/usr/local/bin/"$APPNAME

echo "All done! ...."

# you forgot to delete the tempdir stuff after the unzipping :(
# although it's in /tmp and should be wiped next reboot
