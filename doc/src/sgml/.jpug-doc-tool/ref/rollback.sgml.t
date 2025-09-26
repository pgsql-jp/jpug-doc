␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ROLLBACK</refname>␟  <refpurpose>abort the current transaction</refpurpose>␟  <refpurpose>現在のトランザクションをアボートする</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ROLLBACK</command> rolls back the current transaction and causes
   all the updates made by the transaction to be discarded.␟<command>ROLLBACK</command>は現在のトランザクションをロールバックし、そのトランザクションで行われた全ての更新を廃棄させます。␞␞  </para>␞
␝  <indexterm zone="sql-rollback-chain">
   <primary>chained transactions</primary>
  </indexterm>
␟␟  <indexterm zone="sql-rollback-chain">
   <primary>連鎖トランザクション</primary>
  </indexterm>␞␞␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Optional key words. They have no effect.␟省略可能なキーワードです。何も効果がありません。␞␞     </para>␞
␝     <para>␟      If <literal>AND CHAIN</literal> is specified, a new (not aborted)
      transaction is immediately started with the same transaction
      characteristics (see <xref linkend="sql-set-transaction"/>) as the
      just finished one.  Otherwise, no new transaction is started.␟<literal>AND CHAIN</literal>が指定されていれば、新しい(アボートされていない)トランザクションは、直前に終了したものと同じトランザクションの特性(<xref linkend="sql-set-transaction"/>を参照してください)で即時に開始されます。
そうでなければ、新しいトランザクションは開始されません。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   Use <link linkend="sql-commit"><command>COMMIT</command></link> to
   successfully terminate a transaction.␟トランザクションを正常に終了させるには<link linkend="sql-commit"><command>COMMIT</command></link>を使用してください。␞␞  </para>␞
␝  <para>␟   Issuing <command>ROLLBACK</command> outside of a transaction
   block emits a warning and otherwise has no effect.  <command>ROLLBACK AND
   CHAIN</command> outside of a transaction block is an error.␟トランザクションブロックの外部で<command>ROLLBACK</command>を発行すると警告が発生しますが、それ以外は何の効果もありません。
トランザクションブロックの外部で<command>ROLLBACK AND CHAIN</command>を発行するとエラーになります。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To abort all changes:␟全ての変更をアボートします。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   The command <command>ROLLBACK</command> conforms to the SQL standard.  The
   form <literal>ROLLBACK TRANSACTION</literal> is a PostgreSQL extension.␟コマンド<command>ROLLBACK</command>は標準SQLに準拠しています。
<literal>ROLLBACK TRANSACTION</literal>の構文はPostgreSQLでの拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟ROLLBACK; </programlisting></para> </programlisting></para>␟no translation␞␞␞
