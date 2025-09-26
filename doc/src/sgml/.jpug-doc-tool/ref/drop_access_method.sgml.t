␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP ACCESS METHOD</refname>␟  <refpurpose>remove an access method</refpurpose>␟  <refpurpose>アクセスメソッドを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP ACCESS METHOD</command> removes an existing access method.
   Only superusers can drop access methods.␟<command>DROP ACCESS METHOD</command>は既存のアクセスメソッドを削除します。
スーパーユーザのみがアクセスメソッドを削除できます。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the access method does not exist.
      A notice is issued in this case.␟アクセスメソッドが存在しない時にエラーを発生させません。
この場合、注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name of an existing access method.␟既存のアクセスメソッドの名前です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the access method
      (such as operator classes, operator families, and indexes),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟アクセスメソッドに依存するオブジェクト（演算子クラス、演算子族、インデックスなど）を自動的に削除し、さらに、それらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the access method if any objects depend on it.
      This is the default.␟アクセスメソッドに依存するオブジェクトが1つでもあれば、削除を拒絶します。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Drop the access method <literal>heptree</literal>:␟アクセスメソッド<literal>heptree</literal>を削除するには次のようにします。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP ACCESS METHOD</command> is a
   <productname>PostgreSQL</productname> extension.␟<command>DROP ACCESS METHOD</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP ACCESS METHOD heptree; </programlisting></para> </programlisting></para>␟no translation␞␞␞
