␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP SERVER</refname>␟  <refpurpose>remove a foreign server descriptor</refpurpose>␟  <refpurpose>外部サーバの記述子を削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP SERVER</command> removes an existing foreign server
   descriptor.  To execute this command, the current user must be the
   owner of the server.␟<command>DROP SERVER</command>は既存の外部サーバ記述子を削除します。
このコマンドを実行するためには、現在のユーザはサーバの所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the server does not exist.  A notice is
      issued in this case.␟サーバが存在しない場合にエラーを発生しません。
この場合、注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name of an existing server.␟既存のサーバの名前です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the server (such as
      user mappings),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟サーバに依存するオブジェクト（ユーザマップなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the server if any objects depend on it.  This is
      the default.␟依存するオブジェクトが存在する場合サーバの削除を取りやめます。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Drop a server <literal>foo</literal> if it exists:␟サーバ<literal>foo</literal>が存在すれば、を削除します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP SERVER</command> conforms to ISO/IEC 9075-9
   (SQL/MED).  The <literal>IF EXISTS</literal> clause is
   a <productname>PostgreSQL</productname> extension.␟<command>DROP SERVER</command>はISO/IEC 9075-9 (SQL/MED)に準拠しています。
<literal>IF EXISTS</literal>句は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP SERVER IF EXISTS foo; </programlisting></para> </programlisting></para>␟no translation␞␞␞
