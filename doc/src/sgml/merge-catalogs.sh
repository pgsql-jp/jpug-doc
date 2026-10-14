#! /bin/sh
cat catalogs[0-3].sgml > catalogs.sgml
patch -p0 -R catalogs.sgml <<EOF
*** catalogs.sgml	2022-11-05 13:25:08.638458571 +0900
--- /tmp/catalogs-merged.sgml	2022-11-05 13:29:20.289287807 +0900
***************
*** 1,3 ****
--- 1,11 ----
+ <!-- 警告：このファイルは直接編集しないでください！
+ 1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+ 2. するとcatalogs[0-3].sgmlが生成されます。
+ 3. catalogs.sgmlとともにcatalogs[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+ 4. レビューはcatalogs[0-3].sgmlに対して行います。
+ 5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+ 6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+ -->
  <!-- doc/src/sgml/catalogs.sgml -->
  <!--
   Documentation of the system catalogs, directed toward PostgreSQL developers
***************
*** 4066,4072 ****
--- 4074,4092 ----
    </note>
   </sect1>
  
+ &catalogs1;
+ &catalogs2;
+ &catalogs3;
+ &catalogs4;
  <!-- split-catalogs0-end -->
+ <!-- 警告：このファイルは直接編集しないでください！
+ 1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+ 2. するとcatalogs[0-3].sgmlが生成されます。
+ 3. catalogs.sgmlとともにcatalogs[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+ 4. レビューはcatalogs[0-3].sgmlに対して行います。
+ 5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+ 6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+ -->
  <!-- split-catalogs1-start -->
  
   <sect1 id="catalog-pg-conversion">
***************
*** 7927,7932 ****
--- 7947,7960 ----
   </sect1>
  
  <!-- split-catalogs1-end -->
+ <!-- 警告：このファイルは直接編集しないでください！
+ 1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+ 2. するとcatalogs[0-3].sgmlが生成されます。
+ 3. catalogs.sgmlとともにcatalogs[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+ 4. レビューはcatalogs[0-3].sgmlに対して行います。
+ 5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+ 6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+ -->
  <!-- split-catalogs2-start -->
  
   <sect1 id="catalog-pg-parameter-acl">
***************
*** 12354,12359 ****
--- 12382,12395 ----
   </sect1>
  
  <!-- split-catalogs2-end -->
+ <!-- 警告：このファイルは直接編集しないでください！
+ 1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+ 2. するとcatalogs[0-3].sgmlが生成されます。
+ 3. catalogs.sgmlとともにcatalogs[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+ 4. レビューはcatalogs[0-3].sgmlに対して行います。
+ 5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+ 6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+ -->
  <!-- split-catalogs3-start -->
  
   <sect1 id="catalog-pg-ts-config-map">
EOF
