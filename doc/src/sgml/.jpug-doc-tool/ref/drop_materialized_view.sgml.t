␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP MATERIALIZED VIEW</refname>␟  <refpurpose>remove a materialized view</refpurpose>␟  <refpurpose>マテリアライズドビューを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP MATERIALIZED VIEW</command> drops an existing materialized
   view. To execute this command you must be the owner of the materialized
   view.␟<command>DROP MATERIALIZED VIEW</command>は既存のマテリアライズドビューを削除します。
このコマンドを実行するためにはマテリアライズドビューの所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the materialized view does not exist. A notice
      is issued in this case.␟マテリアライズドビューが存在しない場合でもエラーを発生しません。
この場合注意が発生します。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of the materialized view to
      remove.␟削除対象のマテリアライズドビューの名前（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the materialized view (such as
      other materialized views, or regular views),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟マテリアライズドビューに依存するオブジェクト（他のマテリアライズドビューや通常のビューなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the materialized view if any objects depend on it.  This
      is the default.␟依存するオブジェクトがある場合にマテリアライズドビューの削除を取りやめます。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   This command will remove the materialized view called
   <literal>order_summary</literal>:␟以下のコマンドは<literal>order_summary</literal>という名前のマテリアライズドビューを削除します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP MATERIALIZED VIEW</command> is a
   <productname>PostgreSQL</productname> extension.␟<command>DROP MATERIALIZED VIEW</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP MATERIALIZED VIEW order_summary; </programlisting></para> </programlisting></para>␟no translation␞␞␞
