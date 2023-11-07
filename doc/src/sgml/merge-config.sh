#! /bin/sh
# split-config.shで分割されたconfig[0-3].sgmlを結合し、再びconfig.sgmlに戻すスクリプト。
# config[0-3].sgmlにレビュー結果を反映させた後、config.sgmlに反映するために使用する。
cat config[0-3].sgml > config.sgml
patch -p0 config.sgml <<EOF

*** config_cat.sgml	2023-10-23 18:14:39.712647422 +0900
--- config.sgml	2023-10-23 18:11:41.165281060 +0900
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
*** 4157,4175 ****
         </listitem>
        </varlistentry>
  
- &config1;
- &config2;
- &config3;
  <!-- split-config0-end -->
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
         <term><varname>old_snapshot_threshold</varname> (<type>integer</type>)
--- 4149,4155 ----
***************
*** 9103,9116 ****
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
--- 9083,9088 ----
***************
*** 13417,13430 ****
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
        <term><varname>default_transaction_read_only</varname> (<type>boolean</type>)
--- 13389,13394 ----
***************
*** 17773,17775 ****
--- 17737,17740 ----
  
    </sect1>
  <!-- split-config3-end -->
+ </chapter>
