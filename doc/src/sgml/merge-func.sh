#! /bin/sh
# split.shで分割されたfunc[0-4].sgmlを結合し、再びfunc.sgmlに戻すスクリプト。
# func[0-4].sgmlにレビュー結果を反映させた後、func.sgmlに反映するために使用する。
cat func[0-4].sgml > func.sgml
patch -p0 func.sgml <<EOF
*** func_cat.sgml	2021-11-14 13:43:07.291773381 +0900
--- func.sgml	2021-11-14 13:16:08.727182620 +0900
***************
*** 1,11 ****
- <!-- 警告：このファイルは直接編集しないでください！
- 1. func.sgmlを編集したら、split.shを起動します。
- 2. するとfunc[0-4].sgmlが生成されます。
- 3. func.sgmlとともにfunc[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはfunc[0-4].sgmlに対して行います。
- 5. 指摘された点があればfunc.sgmlに反映し、1に戻ります。
- 6. func.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- doc/src/sgml/func.sgml -->
  
   <chapter id="functions">
--- 1,3 ----
***************
*** 82,100 ****
  この拡張機能のいくつかは、他の<acronym>SQL</acronym>データベース管理システムにも備わっており、多くの場合この機能には各種実装間で互換性と整合性があります。
    </para>
  
- &func1;
- &func2;
- &func3;
- &func4;
  <!-- split-func0-end -->
- <!-- 警告：このファイルは直接編集しないでください！
- 1. func.sgmlを編集したら、split.shを起動します。
- 2. するとfunc[0-4].sgmlが生成されます。
- 3. func.sgmlとともにfunc[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはfunc[0-4].sgmlに対して行います。
- 5. 指摘された点があればfunc.sgmlに反映し、1に戻ります。
- 6. func.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-func1-start -->
  
    <sect1 id="functions-logical">
--- 74,80 ----
***************
*** 9413,9426 ****
   </sect1>
  
  <!-- split-func1-end -->
- <!-- 警告：このファイルは直接編集しないでください！
- 1. func.sgmlを編集したら、split.shを起動します。
- 2. するとfunc[0-4].sgmlが生成されます。
- 3. func.sgmlとともにfunc[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはfunc[0-4].sgmlに対して行います。
- 5. 指摘された点があればfunc.sgmlに反映し、1に戻ります。
- 6. func.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-func2-start -->
    <sect1 id="functions-formatting">
  <!--
--- 9393,9398 ----
***************
*** 19178,19191 ****
   </sect1>
  
  <!-- split-func2-end -->
- <!-- 警告：このファイルは直接編集しないでください！
- 1. func.sgmlを編集したら、split.shを起動します。
- 2. するとfunc[0-4].sgmlが生成されます。
- 3. func.sgmlとともにfunc[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはfunc[0-4].sgmlに対して行います。
- 5. 指摘された点があればfunc.sgmlに反映し、1に戻ります。
- 6. func.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-func3-start -->
   <sect1 id="functions-json">
  <!--
--- 19150,19155 ----
***************
*** 26835,26848 ****
   </sect1>
  
  <!-- split-func3-end -->
- <!-- 警告：このファイルは直接編集しないでください！
- 1. func.sgmlを編集したら、split.shを起動します。
- 2. するとfunc[0-4].sgmlが生成されます。
- 3. func.sgmlとともにfunc[0-4].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはfunc[0-4].sgmlに対して行います。
- 5. 指摘された点があればfunc.sgmlに反映し、1に戻ります。
- 6. func.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-func4-start -->
   <sect1 id="functions-subquery">
  <!--
--- 26799,26804 ----
EOF
