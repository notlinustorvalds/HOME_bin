#!/usr/bin/env bash

## Prepends a timestamp and a few carriage returns to /home/richw/desktop/pastebin
## and then opens the file in gvim for editing.
##
## NOTES on expected symlink structure:
##      $HOME/desktop/pastebin  ->  $HOME/personal/pastebin
##      $HOME/personal          ->  /data/personal/$USER
##      /data/personal          ->  /data/$HOST/personal
##
## Borrowed and adapted from https://stackoverflow.com/a/3272296

readonly PASTEBIN_FILE="$HOME/personal/pastebin";
readonly SYMLINK_TO_PASTEBIN_FILE="$HOME/desktop/pastebin";


## Make sure shit exists
if [[ ! -f ${PASTEBIN_FILE} ]]; then
    touch ${PASTEBIN_FILE};
fi

if [[ ! -L ${SYMLINK_TO_PASTEBIN_FILE} ]]; then
    ln -s "${PASTEBIN_FILE}"  "${SYMLINK_TO_PASTEBIN_FILE}";
fi

## Good GAWD. `ed` wasn't installed by default on SLE_15
which ed > /dev/null 2>&1;
if [[ 0 -ne "$?" ]]; then
    echo -e "\n\tBelieve it or not, 'ed' is not installed."
    echo -e "\tInstall 'ed' and try again "'¯\_(ツ)_/¯'"\n"
    exit 1;
fi

echo -e "0a
# `timestamp`\n\n\n
.
w" | ed "${PASTEBIN_FILE}" ;

### vim notes:
###     -p      Open vim files in a tabbed interface.
###     +n      Open file and place cursor at line n

/usr/bin/gvim -p +2 "${PASTEBIN_FILE}" &

