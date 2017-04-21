# libsilly
A silly test library for playing around with continuous integration things:
* cmake
* google test framework (included in test/lib/)
* LCOV coverage analysis (included in test/lib/)
* uncrustify (must be on path)

## How to use
* I wanted to keep all the "extra" files hidden away in the test/ directory.
* Go into the test/ directory and run the ./make_test_cover.sh script
* It does all the building and running in a build/ directory.
* It writes log files in the build/ directory.
* It writes the results into an easy-to-parse file called "the_status" like this:
```
build: pass
tests: pass
cover_line: 98.4%
cover_func: 100.0%
formatting: pass
```

## Things to modify for your project:
* test/CMakeLists.tx
    * Change project() line
    * Change name of executable in add_executable line
    * Add test and code c/cpp files to add_executable line
    * Change executable name in set_target_properties line
    * Change executable name in target_link_libraries
    * Change project name and coverage output string in final line
* test_silly.cpp
    * Rename and duplicate. Probably want one test file per source c/cpp file
* uncrustify.cfg.txt
    * Change settings in here to match what you want your code to look like.
    * Uncrustify is set to only report pass/fail for each file, it won't reformat.
