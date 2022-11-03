#! /bin/sh
cat catalogs[0-3].sgml > catalogs.sgml
patch -p0 -R catalogs.sgml <<EOF
diff --git a/doc/src/sgml/catalogs.sgml b/doc/src/sgml/catalogs.sgml
index 68d065541b..a4c8fdd50a 100644
--- a/doc/src/sgml/catalogs.sgml
+++ b/doc/src/sgml/catalogs.sgml
@@ -1,3 +1,11 @@
+<!-- 警告：このファイルは直接編集しないでください！
+1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+2. するとcatalogs[0-4].sgmlが生成されます。
+3. catalogs.sgmlとともにcatalogs[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+4. レビューはcatalogs[0-4].sgmlに対して行います。
+5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+-->
 <!-- doc/src/sgml/catalogs.sgml -->
 <!--
  Documentation of the system catalogs, directed toward PostgreSQL developers
@@ -4066,7 +4074,19 @@ nullの場合、参照しているすべての列が更新されます。
   </note>
  </sect1>
 
+&catalogs1;
+&catalogs2;
+&catalogs3;
+&catalogs4;
 <!-- split-catalogs0-end -->
+<!-- 警告：このファイルは直接編集しないでください！
+1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+2. するとcatalogs[0-4].sgmlが生成されます。
+3. catalogs.sgmlとともにcatalogs[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+4. レビューはcatalogs[0-4].sgmlに対して行います。
+5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+-->
 <!-- split-catalogs1-start -->
 
  <sect1 id="catalog-pg-conversion">
@@ -7927,6 +7947,14 @@ trueの場合、NULL値は等しいものとみなします(インデックス
  </sect1>
 
 <!-- split-catalogs1-end -->
+<!-- 警告：このファイルは直接編集しないでください！
+1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+2. するとcatalogs[0-4].sgmlが生成されます。
+3. catalogs.sgmlとともにcatalogs[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+4. レビューはcatalogs[0-4].sgmlに対して行います。
+5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+-->
 <!-- split-catalogs2-start -->
 
  <sect1 id="catalog-pg-parameter-acl">
@@ -12354,6 +12382,14 @@ NULLは<literal>NONE</literal>を表します。
  </sect1>
 
 <!-- split-catalogs2-end -->
+<!-- 警告：このファイルは直接編集しないでください！
+1. catalogs.sgmlを編集したら、split-catalogs.shを起動します。
+2. するとcatalogs[0-4].sgmlが生成されます。
+3. catalogs.sgmlとともにcatalogs[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
+4. レビューはcatalogs[0-4].sgmlに対して行います。
+5. 指摘された点があればcatalogs.sgmlに反映し、1に戻ります。
+6. catalogs.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
+-->
 <!-- split-catalogs3-start -->
 
  <sect1 id="catalog-pg-ts-config-map">
