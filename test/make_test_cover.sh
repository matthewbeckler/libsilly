#!/bin/bash
#
# Builds and runs tests
# Writes status like "build: fail" or "tests: pass" to $STATUSFILE
STATUSFILE=$(pwd)/the_status

# Complain if we try to use unset variables
set -o nounset

# Add lcov to path so cmake can find it
export PATH=$(pwd)/lib/lcov-1.13-2-g25f5d38/bin:$PATH

mkdir -p build
cd build


echo "PHASE ZERO - BUILD"
# First we use cmake to create the actual Makefiles:
LOG00="log_00_build.txt"
cmake -DCMAKE_BUILD_TYPE=Debug .. > $LOG00 2>&1
if [ "$?" -ne 0 ]; then
    echo "Error during CMAKE to build Makefiles"
    echo "build: fail" > $STATUSFILE
    exit 1
fi
# Then uses those Makefiles to actually build the code:
cmake --build . >> $LOG00 2>&1
if [ "$?" -ne 0 ]; then
    echo "Error while building code and tests"
    echo "build: fail" > $STATUSFILE
    exit 1
fi

echo "build: pass" > $STATUSFILE


echo "--------------------------------------------------------------------------------"
echo "PHASE ONE - UNIT TESTS"
# This runs the tests, collects code coverage, and makes the HTML output
LOG01="log_01_coverage.txt"
make coverage > $LOG01 2>&1
if [ "$?" -ne 0 ]; then
    echo "Error while running unit tests"
    echo "tests: fail" >> $STATUSFILE
else
    echo "tests: pass" >> $STATUSFILE
    # parse out lines and function coverage values
    COVER_LINE=`cat $LOG01 | sed -n -e '/Overall coverage rate:/,$p' | grep "lines"     | cut -d':' -f2 | cut -d' ' -f2`
    COVER_FUNC=`cat $LOG01 | sed -n -e '/Overall coverage rate:/,$p' | grep "functions" | cut -d':' -f2 | cut -d' ' -f2`
    echo "line/func coverage: $COVER_LINE / $COVER_FUNC"
    echo "cover_line: $COVER_LINE" >> $STATUSFILE
    echo "cover_func: $COVER_FUNC" >> $STATUSFILE
    cat $LOG01 | grep index.html
fi


echo "--------------------------------------------------------------------------------"
echo "PHASE TWO - UNCRUSTIFY"
LOG02="log_02_uncrustify.txt"
hash uncrustify 2> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Unable to find uncrustify tool, add it to your path"
    echo "formatting: fail" >> $STATUSFILE
else
    CHFILES=`find ../../ -type f -not -path "../../test/*" | grep 'c$\|h$'`
    uncrustify -l C -c ../uncrustify.cfg.txt --check $CHFILES > $LOG02 2>&1
    if [ "$?" -ne 0 ]; then
        echo "File formatting failure"
        echo "formatting: fail" >> $STATUSFILE
    else
        echo "formatting: pass" >> $STATUSFILE
    fi
fi


# TODO lint / valgrind / etc


echo "--------------------------------------------------------------------------------"
echo "Summary:"
echo ""
cat $STATUSFILE

