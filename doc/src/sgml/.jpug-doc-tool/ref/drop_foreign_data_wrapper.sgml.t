␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP FOREIGN DATA WRAPPER</refname>␟  <refpurpose>remove a foreign-data wrapper</refpurpose>␟  <refpurpose>外部データラッパーを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP FOREIGN DATA WRAPPER</command> removes an existing
   foreign-data wrapper.  To execute this command, the current user
   must be the owner of the foreign-data wrapper.␟<command>DROP FOREIGN DATA WRAPPER</command>は既存の外部データラッパーを削除します。
このコマンドを実行するためには、現在のユーザは外部データラッパーの所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the foreign-data wrapper does not
      exist.  A notice is issued in this case.␟外部データラッパーが存在しない場合にエラーを発生しません。
この場合、注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name of an existing foreign-data wrapper.␟既存の外部データラッパーの名前です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the foreign-data
      wrapper (such as foreign tables and servers),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟外部データラッパーに依存するオブジェクト（外部テーブルやサーバなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the foreign-data wrapper if any objects depend
      on it.  This is the default.␟外部データラッパーに依存するオブジェクトが存在する場合に削除を取りやめます。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Drop the foreign-data wrapper <literal>dbi</literal>:␟外部データラッパー<literal>dbi</literal>を削除します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP FOREIGN DATA WRAPPER</command> conforms to ISO/IEC
   9075-9 (SQL/MED).  The <literal>IF EXISTS</literal> clause is
   a <productname>PostgreSQL</productname> extension.␟<command>DROP FOREIGN DATA WRAPPER</command>はISO/IEC 9075-9 (SQL/MED)に準拠しています。
<literal>IF EXISTS</literal>句は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP FOREIGN DATA WRAPPER dbi; </programlisting></para> </programlisting></para>␟no translation␞␞␞
