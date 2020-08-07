#!/bin/bash
echo "Switching your gnome DE theme to a macOS-like look :)"
# source script params
echo "loading script inforamtion..."
source ./params.bash &&

# theme logging
echo "downloading and installing appearance theme..." &&
 
# create user themes directory, also works if already exist because of the -p fleg
mkdir -p ~/.themes &&

# change current directory to user themes directory
cd ~/.themes &&

# download theme xz compressed file
wget -q $THEME_URL &&

# xz decompress file
xz -d `basename $THEME_URL` &&

# untar the directory
tar -xf `basename $THEME_URL | cut -d "." -f 1,2` &&

# change gnome desktop theme configuration
dconf write $THEME_KEY "'$THEME_NAME'" &&

# icons logging
echo "downloading and installing icons..." &&

# create user icons directory, also works if already exist because of the -p fleg
mkdir -p ~/.icons &&

# change current directory to user icons directory
cd ~/.icons &&

# git cloneing the icons repo from github
git clone --quiet $ICONS_REPO_URL &&

# change gnome desktop icons configuration
dconf write $ICONS_KEY "'$ICONS_NAME'" && 

# logging fonts
echo "downloading and installing fonts..." &&
# create user fonts directory, also works if already exist because of the -p fleg
mkdir -p ~/.fonts &&

# change current directory to user fonts directory
cd ~/.fonts &&

# download San Francisco font
wget -q "$FONT_URL" -O $FONT_FILE_NAME &&

# save interface font size
INTERFACE_FONT_SIZE=`echo /org/gnome/desktop/interface/font-name | rev | cut -d " " -f 1 | rev` &&

# save window title font size
WINDOW_TITLE_FONT_SIZE=`echo /org/gnome/desktop/wm/preferences/titlebar-font | rev | cut -d " " -f 1 | rev` &&

# config interface font
dconf write $WINDOW_TITLE_FONT_KEY "'$FONT_NAME $INTERFACE_FONT_SIZE'" &&

# config window title font
dconf write $WINDOW_TITLE_FONT_KEY "'$FONT_NAME $WINDOW_TITLE_FONT_SIZE'" &&

# dash to dock extension logging
echo "downloading and installing dash-to-dock extension..." &&
# create user extensions directory, also works if already exist because of the -p fleg
mkdir -p ~/.extensions &&

# change current directory to user extensions directory
cd ~/.extensions &&

# git cloneing the dash repo from github
git clone --quiet $DASH_REPO_URL &&

# change current directory to dash extension repo directory
cd `basename $DASH_REPO_URL | cut -d "." -f 1` &&
make > /dev/null &&
make install > /dev/null &&

# get extensions list
EXTENSIONS=`dconf read $EXTENSIONS_KEY` &&

if [[ $EXTENSIONS == *"$EXTENSION_NAME"* ]];
then
  echo "dash extension is already on, so we are done"
else
    # enabling the dash extension
    gnome-extensions enable $EXTENSION_NAME &&
    echo "Select position 'Bottom' and you are done." &&
    gnome-extensions prefs $EXTENSION_NAME &&

    # if got here, there was an error
    echo "ERROR"
fi 