␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP TRIGGER</refname>␟  <refpurpose>remove a trigger</refpurpose>␟  <refpurpose>トリガを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP TRIGGER</command> removes an existing
   trigger definition. To execute this command, the current
   user must be the owner of the table for which the trigger is defined.␟<command>DROP TRIGGER</command>は既存のトリガ定義を削除します。
このコマンドを実行できるのは、トリガが定義されたテーブルの所有者のみです。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the trigger does not exist. A notice is issued
      in this case.␟トリガが存在しない場合でもエラーになりません。この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name of the trigger to remove.␟削除するトリガの名前です。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of the table for which
      the trigger is defined.␟トリガが定義されたテーブルの名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the trigger,
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟このトリガに依存しているオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the trigger if any objects depend on it.  This is
      the default.␟依存しているオブジェクトがある場合に、トリガの削除を拒否します。
こちらがデフォルトです。␞␞     </para>␞
␝ <refsect1 id="sql-droptrigger-examples">␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Destroy the trigger <literal>if_dist_exists</literal> on the table
   <literal>films</literal>:␟テーブル<literal>films</literal>にあるトリガ<literal>if_dist_exists</literal>を削除します。␞␞␞
␝ <refsect1 id="sql-droptrigger-compatibility">␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   The <command>DROP TRIGGER</command> statement in
   <productname>PostgreSQL</productname> is incompatible with the SQL
   standard.  In the SQL standard, trigger names are not local to
   tables, so the command is simply <literal>DROP TRIGGER
   <replaceable>name</replaceable></literal>.␟<productname>PostgreSQL</productname>の<command>DROP TRIGGER</command>文には標準SQLとの互換性がありません。
標準SQLでは、トリガ名がテーブルに局所化されていないので、<literal>DROP TRIGGER <replaceable>name</replaceable></literal>というコマンドが使われています。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP TRIGGER if_dist_exists ON films; </programlisting></para> </programlisting></para>␟no translation␞␞␞
