#! /bin/sh
# split-config.shで分割されたconfig[0-3].sgmlを結合し、再びconfig.sgmlに戻すスクリプト。
# config[0-3].sgmlにレビュー結果を反映させた後、config.sgmlに反映するために使用する。
cat config[0-3].sgml > config.sgml
patch -p0 config.sgml <<EOF

*** config_cat.sgml	Sun Oct 10 19:33:43 2021
--- config.sgml	Sun Oct 10 19:04:17 2021
***************
*** 1,11 ****
- <!-- 警告：このファイルは直接編集しないでください！
- 1. config.sgmlを編集したら、split-config.shを起動します。
- 2. するとconfig[0-3].sgmlが生成されます。
- 3. config.sgmlとともにconfig[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはconfig[0-3].sgmlに対して行います。
- 5. 指摘された点があればconfig.sgmlに反映し、1に戻ります。
- 6. config.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- doc/src/sgml/config.sgml -->
  
  <chapter id="runtime-config">
--- 1,3 ----
***************
*** 3905,3924 ****
         </listitem>
        </varlistentry>
  
- &config1;
- &config2;
- &config3;
  <!-- split-config0-end -->
- 
- </chapter>
- <!-- 警告：このファイルは直接編集しないでください！
- 1. config.sgmlを編集したら、split-config.shを起動します。
- 2. するとconfig[0-3].sgmlが生成されます。
- 3. config.sgmlとともにconfig[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはconfig[0-3].sgmlに対して行います。
- 5. 指摘された点があればconfig.sgmlに反映し、1に戻ります。
- 6. config.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-config1-start -->
  
        <varlistentry id="guc-old-snapshot-threshold" xreflabel="old_snapshot_threshold">
--- 3897,3903 ----
***************
*** 8579,8592 ****
        </listitem>
       </varlistentry>
  <!-- split-config1-end -->
- <!-- 警告：このファイルは直接編集しないでください！
- 1. config.sgmlを編集したら、split-config.shを起動します。
- 2. するとconfig[0-3].sgmlが生成されます。
- 3. config.sgmlとともにconfig[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはconfig[0-3].sgmlに対して行います。
- 5. 指摘された点があればconfig.sgmlに反映し、1に戻ります。
- 6. config.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-config2-start -->
  
       <varlistentry id="guc-join-collapse-limit" xreflabel="join_collapse_limit">
--- 8558,8563 ----
***************
*** 12311,12324 ****
       </varlistentry>
  
  <!-- split-config2-end -->
- <!-- 警告：このファイルは直接編集しないでください！
- 1. config.sgmlを編集したら、split-config.shを起動します。
- 2. するとconfig[0-3].sgmlが生成されます。
- 3. config.sgmlとともにconfig[0-3].sgmlのうち変更されたファイルをcommit/pushしてpull requestを作成してください。
- 4. レビューはconfig[0-3].sgmlに対して行います。
- 5. 指摘された点があればconfig.sgmlに反映し、1に戻ります。
- 6. config.sgmlの変更がなければ、pull requestをマージして終了です。お疲れ様でした！
- -->
  <!-- split-config3-start -->
  
       <varlistentry id="guc-default-transaction-read-only" xreflabel="default_transaction_read_only">
--- 12282,12287 ----
***************
*** 16210,16212 ****
--- 16173,16177 ----
    </sect1>
  
  <!-- split-config3-end -->
+ 
+ </chapter>
EOF
