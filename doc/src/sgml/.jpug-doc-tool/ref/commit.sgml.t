␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>COMMIT</refname>␟  <refpurpose>commit the current transaction</refpurpose>␟  <refpurpose>現在のトランザクションをコミットする</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>COMMIT</command> commits the current transaction. All
   changes made by the transaction become visible to others
   and are guaranteed to be durable if a crash occurs.␟<command>COMMIT</command>は現在のトランザクションをコミットします。
そのトランザクションで行われた全ての変更が他のユーザから見えるようになり、クラッシュが起きても一貫性が保証されるようになります。␞␞  </para>␞
␝  <indexterm zone="sql-commit-chain">
   <primary>chained transactions</primary>
  </indexterm>
␟␟  <indexterm zone="sql-commit-chain">
   <primary>連鎖トランザクション</primary>
  </indexterm>␞␞␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Optional key words. They have no effect.␟省略可能なキーワードです。何も効果はありません。␞␞     </para>␞
␝     <para>␟      If <literal>AND CHAIN</literal> is specified, a new transaction is
      immediately started with the same transaction characteristics (see <xref
      linkend="sql-set-transaction"/>) as the just finished one.  Otherwise,
      no new transaction is started.␟<literal>AND CHAIN</literal>が指定されていれば、新しいトランザクションは、直前に終了したものと同じトランザクションの特性(<xref linkend="sql-set-transaction"/>を参照してください)で即時に開始されます。
そうでなければ、新しいトランザクションは開始されません。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   Use <xref linkend="sql-rollback"/> to
   abort a transaction.␟トランザクションをアボートするには<xref linkend="sql-rollback"/>を使用してください。␞␞  </para>␞
␝  <para>␟   Issuing <command>COMMIT</command> when not inside a transaction does
   no harm, but it will provoke a warning message.  <command>COMMIT AND
   CHAIN</command> when not inside a transaction is an error.␟トランザクションの外部で<command>COMMIT</command>を発行しても特に問題は発生しません。
ただし、警告メッセージが表示されます。
トランザクションの外部で<command>COMMIT AND CHAIN</command>を発行するとエラーになります。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To commit the current transaction and make all changes permanent:␟現在のトランザクションをコミットし、全ての変更を永続化します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   The command <command>COMMIT</command> conforms to the SQL standard.  The
   form <literal>COMMIT TRANSACTION</literal> is a PostgreSQL extension.␟コマンド<command>COMMIT</command>は標準SQLに準拠しています。
<literal>COMMIT TRANSACTION</literal>の構文はPostgreSQLでの拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟COMMIT; </programlisting></para> </programlisting></para>␟no translation␞␞␞
