#!/usr/bin/env bash

#####################################################################
### \brief      Prepends a timestamp and a few carriage returns to 
###             the file specified as a parameter, and then opens 
###             the file in gvim for editing.
### \since      19 Jul 2019     
### \details    Adapted from https://stackoverflow.com/a/3272296

#####################################################################
# CONSTANTS
### https://unix.stackexchange.com/a/198926
#readonly THIS_FILE=`basename -- "$0"`;
### https://unix.stackexchange.com/a/198931
readonly THIS_FILE=`printf '%s\n' "${0##*/}"`;

readonly PASTEBIN_FILE="$HOME/personal/pastebin";
readonly SYMLINK_TO_PASTEBIN_FILE="$HOME/desktop/pastebin";

### Follow the C/C++ conventions
readonly FALSE=0;
### This should be called as,  `[[ ! "${FALSE}" ]]` 
### ...b/c in C a "non-zero value" == TRUE
readonly TRUE=1;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Exit Codes
readonly EXIT_SUCCESS=0;
readonly EXIT_BAD_ARG=1;
readonly EXIT_MISSING_REQUIREMENT=2;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Script variables
timestamp_args='-z';
interactive_mode="${TRUE}";
suffix_mode="${FALSE}";
exit_msg="";



#####################################################################
# FUNCTIONS

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
### Sets the exit code and/or error message
### \param  <int>
function    exit_script()   {
    if [[ "${EXIT_SUCCESS}" == "${1}" ]]; then
        # First: if all is good, bail out.
        exit "${EXIT_SUCCESS}";
    fi
    
    # Well, something went wrong :-( 
    if [[ "${interactive_mode}" != "${FALSE}" ]]; then
        if [[  ]]
        fi
    else

    fi
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
### Makes sure that script requirements are met
function    sanity_check()  {
# Make sure shit exists
    if [[ ! -f ${PASTEBIN_FILE} ]]; then
        touch ${PASTEBIN_FILE};
    fi

    if [[ ! -L ${SYMLINK_TO_PASTEBIN_FILE} ]]; then
        ln -s "${PASTEBIN_FILE}"  "${SYMLINK_TO_PASTEBIN_FILE}";
    fi

    ## Good GAWD. `ed` wasn't installed by default on SLE_15
    which ed > /dev/null 2>&1;
    if [[ 0 -ne "$?" ]]; then
        exit_msg="Believe it or not, 'ed' is not installed.\n\n`cnf ed`\n\n";
        exit_script "${EXIT_MISSING_REQUIREMENT}" "${exit_msg}";
    fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
### The menu that appears when needed
function    lumberjack_help()   {
    cat << EOF

  ...A Lumberjack makes logs!

  USAGE:
    ${THIS_FILE} [-hgnSUuy] [-f /path/to/logfile] [/path/to/logfile]

  Option    Description
  --------- ---------------------------------------------
  -f 'file' Explicit call to '/path/to/logfile'
              If 'logfile' does not exist, you will be 
              prompted if you would like to create it
              (use "-y" to disable nag mode).
    -h      Display (this) help message.
    -g      Timestamp (whatever format) in UTC (GMT). 
              "-UTC-" will always appended unless UNIX
              epoch is used.
    -n      Append nanoseconds to timestamp.
    -S      Suffix mode 
                Put the timestamp at the bottom (end)
                of the log file.
                The default is to put the timestamp 
                at the top (beginning) of the
                log file.
    -U      Use the UNIX epoch only for the timestamp
                (nanoseconds MAY be appended)
    -u      Suffix timestamp with UNIX epoch; e.g.:
                2019-07-23_13-02-24_-0700_1563912144
    -y      Non-interactive mode; answer 'yes' to prompts.

EOF
}




#####################################################################
# EXECUTION
sanity_check;

while getopts   "f:hgSUuy" arg;    do
    case    "$arg" in
        f)  ;;
        h)  lumberjack_help;
            exit_script 0;
            ;;
        g)  timestamp_args="${timestamp_args}g"
            ;;
        n)  timestamp_args="${timestamp_args}n"
            ;;
        S)  suffix_mode="${TRUE}"
            ;;
        U)  timestamp_args="${timestamp_args}U"
            ;;
        u)  timestamp_args="${timestamp_args}u"
            ;;
        y)  interactive_mode="${FALSE}";
            ;;
        *)  lumberjack_help;
            exit_msg="  ERROR: '${OPTARG}' is invalid :-(";
            exit_script "${EXIT_BAD_ARG}" "${exit_msg}";
            ;;
    esac
done

## Make sure shit exists
#if [[ ! -f ${PASTEBIN_FILE} ]]; then
#    touch ${PASTEBIN_FILE};
#fi
#
#if [[ ! -L ${SYMLINK_TO_PASTEBIN_FILE} ]]; then
#    ln -s "${PASTEBIN_FILE}"  "${SYMLINK_TO_PASTEBIN_FILE}";
#fi
#
### Good GAWD. `ed` wasn't installed by default on SLE_15
#which ed > /dev/null 2>&1;
#if [[ 0 -ne "$?" ]]; then
#    echo -e "\n\tBelieve it or not, 'ed' is not installed."
#    echo -e "\tInstall 'ed' and try again "'¯\_(ツ)_/¯'"\n"
#    exit 1;
#fi
#
#echo -e "0a
## `timestamp`\n\n\n
#.
#w" | ed "${PASTEBIN_FILE}" ;
#
### vim notes:
###     -p      Open vim files in a tabbed interface.
###     +n      Open file and place cursor at line n
#
#/usr/bin/gvim -p +2 "${PASTEBIN_FILE}" &

