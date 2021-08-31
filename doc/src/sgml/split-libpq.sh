#! /bin/sh
# This script splits libpq.sgml into 4 files: namely libpq[0-3].sgml.
# libpq.sgml remains untouched. libpq0.sgml should be included by
# postgres.sgml instead of libpq.sgml.
# "<!-- split-libpq1-start --> and <!-- split-libpq1-end --> etc. must be in libpq.sgml
# in order to get this script working.

comment='
<!-- 警告：このファイルは直接編集しないでください！
1. libpq.sgmlを編集したら、split.shを起動します。
2. するとlibpq[0-3].sgmlが生成されます。
3. libpq.sgmlとともにlibpq[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
4. レビューはlibpq[0-3].sgmlに対して行います。
5. 指摘された点があればlibpq.sgmlに反映し、1に戻ります。
6. libpq.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
-->
'

echo "$comment"|sed -e '/^$/d'  > libpq0.sgml
sed -e '/^<!-- split-libpq1-start -->$/,/^<!-- split-libpq4-end -->$/d' \
    -e '/<!-- split-libpq0-end -->/i&libpq1;\n&libpq2;\n&libpq3;\n&libpq4;' \
    libpq.sgml >> libpq0.sgml
echo "$comment"|sed -e '/^$/d' > libpq1.sgml
sed -n -e '/^<!-- split-libpq1-start -->$/,/^<!-- split-libpq1-end -->$/p' libpq.sgml >> libpq1.sgml
echo "$comment"|sed -e '/^$/d' > libpq2.sgml
sed -n -e '/^<!-- split-libpq2-start -->$/,/^<!-- split-libpq2-end -->$/p' libpq.sgml >> libpq2.sgml
echo "$comment"|sed -e '/^$/d' > libpq3.sgml
sed -n -e '/^<!-- split-libpq3-start -->$/,/^<!-- split-libpq3-end -->$/p' libpq.sgml >> libpq3.sgml
