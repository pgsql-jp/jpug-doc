#! /bin/sh
# This script splits config.sgml into 4 files: namely config[0-3].sgml.
# config.sgml remains untouched. config0.sgml should be included by
# postgres.sgml instead of config.sgml.
# "<!-- split-config1-start --> and <!-- split-config1-end --> etc. must be in config.sgml
# in order to get this script working.

comment='
<!-- 警告：このファイルは直接編集しないでください！
1. config.sgmlを編集したら、split-config.shを起動します。
2. するとconfig[0-3].sgmlが生成されます。
3. config.sgmlとともにconfig[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
4. レビューはconfig[0-3].sgmlに対して行います。
5. 指摘された点があればconfig.sgmlに反映し、1に戻ります。
6. config.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
-->
'

echo "$comment"|sed -e '/^$/d'  > config0.sgml
sed -e '/^<!-- split-config1-start -->$/,/^<!-- split-config3-end -->$/d' \
    -e '/<!-- split-config0-end -->/i&config1;\n&config2;\n&config3;' \
    config.sgml >> config0.sgml
echo "$comment"|sed -e '/^$/d' > config1.sgml
sed -n -e '/^<!-- split-config1-start -->$/,/^<!-- split-config1-end -->$/p' config.sgml >> config1.sgml
echo "$comment"|sed -e '/^$/d' > config2.sgml
sed -n -e '/^<!-- split-config2-start -->$/,/^<!-- split-config2-end -->$/p' config.sgml >> config2.sgml
echo "$comment"|sed -e '/^$/d' > config3.sgml
sed -n -e '/^<!-- split-config3-start -->$/,/^<!-- split-config3-end -->$/p' config.sgml >> config3.sgml

