␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP FOREIGN TABLE</refname>␟  <refpurpose>remove a foreign table</refpurpose>␟  <refpurpose>外部テーブルを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP FOREIGN TABLE</command> removes a foreign table.
   Only the owner of a foreign table can remove it.␟<command>DROP FOREIGN TABLE</command>は外部テーブルを削除します。
外部テーブルの所有者のみが削除することができます。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the foreign table does not exist.
      A notice is issued in this case.␟外部テーブルが存在しない場合でもエラーになりません。
この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of the foreign table to drop.␟削除する外部テーブルの名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the foreign table (such as
      views), and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟削除する外部テーブルに依存しているオブジェクト（ビューなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the foreign table if any objects depend on it.  This is
      the default.␟依存しているオブジェクトがある場合に、外部テーブルの削除を拒否します。
こちらがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To destroy two foreign tables, <literal>films</literal> and
   <literal>distributors</literal>:␟<literal>films</literal>および<literal>distributors</literal>という２つの外部テーブルを破棄します。␞␞␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   This command conforms to ISO/IEC 9075-9 (SQL/MED), except that the
   standard only allows one foreign table to be dropped per command, and apart
   from the <literal>IF EXISTS</literal> option, which is a <productname>PostgreSQL</productname>
   extension.␟このコマンドはISO/IEC 9075-9（SQL/MED）に準拠していますが、標準では1コマンドで1つの外部テーブルしか削除できないという点、および、<productname>PostgreSQL</productname>の拡張である<literal>IF EXISTS</literal>オプションを除きます。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP FOREIGN TABLE films, distributors; </programlisting></para> </programlisting></para>␟no translation␞␞␞
