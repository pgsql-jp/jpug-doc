#! /bin/sh
# This script splits catalogs.sgml into 4 files: namely catalogs[0-4].sgml.
# catalogs.sgml remains untouched. catalogs0.sgml should be included by
# postgres.sgml instead of catalogs.sgml.
# "<!-- split-catalogs1-start --> and <!-- split-catalogs1-end --> etc. must be in catalogs.sgml
# in order to get this script working.

comment='
<!-- 警告：このファイルは直接編集しないでください！
1. catalogs.sgmlを編集したら、split.shを起動します。
2. するとcatalogs[0-4].sgmlが生成されます。
3. catalogs.sgmlとともにcatalogs[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
4. レビューはcatalogs[0-4].sgmlに対して行います。
5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
-->
'

echo "$comment"|sed -e '/^$/d'  > catalogs0.sgml
sed -e '/^<!-- split-catalogs1-start -->$/,/^<!-- split-catalogs4-end -->$/d' \
    -e '/<!-- split-catalogs0-end -->/i&catalogs1;\n&catalogs2;\n&catalogs3;\n&catalogs4;' \
    catalogs.sgml >> catalogs0.sgml
echo "$comment"|sed -e '/^$/d' > catalogs1.sgml
sed -n -e '/^<!-- split-catalogs1-start -->$/,/^<!-- split-catalogs1-end -->$/p' catalogs.sgml >> catalogs1.sgml
echo "$comment"|sed -e '/^$/d' > catalogs2.sgml
sed -n -e '/^<!-- split-catalogs2-start -->$/,/^<!-- split-catalogs2-end -->$/p' catalogs.sgml >> catalogs2.sgml
echo "$comment"|sed -e '/^$/d' > catalogs3.sgml
sed -n -e '/^<!-- split-catalogs3-start -->$/,/^<!-- split-catalogs3-end -->$/p' catalogs.sgml >> catalogs3.sgml
echo "$comment"|sed -e '/^$/d' > catalogs4.sgml
sed -n -e '/^<!-- split-catalogs4-start -->$/,/^<!-- split-catalogs4-end -->$/p' catalogs.sgml >> catalogs4.sgml

