#! /bin/sh
# This script splits func.sgml into 4 files: namely func[0-4].sgml.
# func.sgml remains untouched. func0.sgml should be included by
# postgres.sgml instead of func.sgml.
# "<!-- split-func1-start --> and <!-- split-func1-end --> etc. must be in func.sgml
# in order to get this script working.

comment='
<!-- 警告：このファイルは直接編集しないでください！\n
1. func.sgmlを編集したら、split.shを起動します。\n
2. するとfunc[0-4].sgmlが生成されます。\n
3. func.sgmlとともにfunc[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。\n
4. レビューはfunc[0-4].sgmlに対して行います。\n
5. 指摘された点があればfunc.sgmlに反映し、1に戻ります。\n
6. func.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！\n
-->
'

echo $comment > func0.sgml
sed -e '/^<!-- split-func1-start -->$/,/^<!-- split-func4-end -->$/d' \
    -e '/<!-- split-func0-end -->/i&func1;\n&func2;\n&func3;\n&func4;' \
    func.sgml >> func0.sgml
echo $comment > func1.sgml
sed -n -e '/^<!-- split-func1-start -->$/,/^<!-- split-func1-end -->$/p' func.sgml >> func1.sgml
echo $comment > func2.sgml
sed -n -e '/^<!-- split-func2-start -->$/,/^<!-- split-func2-end -->$/p' func.sgml >> func2.sgml
echo $comment > func3.sgml
sed -n -e '/^<!-- split-func3-start -->$/,/^<!-- split-func3-end -->$/p' func.sgml >> func3.sgml
echo $comment > func4.sgml
sed -n -e '/^<!-- split-func4-start -->$/,/^<!-- split-func4-end -->$/p' func.sgml >> func4.sgml

