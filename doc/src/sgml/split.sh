#! /bin/sh
# This script splits func.sgml into 4 files: namely func[0-4].sgml.
# func.sgml remains untouched. func0.sgml should be included by
# postgres.sgml instead of func.sgml.
# "<!-- split-func1-start --> and <!-- split-func1-end --> etc. must be in func.sgml
# in order to get this script working.

sed -e '/^<!-- split-func1-start -->$/,/^<!-- split-func4-end -->$/d' \
    -e '/<!-- split-func0-end -->/i&func1;\n&func2;\n&func3;\n&func4;' \
    func.sgml > func0.sgml
sed -n -e '/^<!-- split-func1-start -->$/,/^<!-- split-func1-end -->$/p' func.sgml > func1.sgml
sed -n -e '/^<!-- split-func2-start -->$/,/^<!-- split-func2-end -->$/p' func.sgml > func2.sgml
sed -n -e '/^<!-- split-func3-start -->$/,/^<!-- split-func3-end -->$/p' func.sgml > func3.sgml
sed -n -e '/^<!-- split-func4-start -->$/,/^<!-- split-func4-end -->$/p' func.sgml > func4.sgml

