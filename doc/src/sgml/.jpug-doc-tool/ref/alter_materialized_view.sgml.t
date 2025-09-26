␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER MATERIALIZED VIEW</refname>␟  <refpurpose>change the definition of a materialized view</refpurpose>␟  <refpurpose>マテリアライズドビューの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable class="parameter">action</replaceable> is one of:</phrase>␟<phrase>ここで<replaceable class="parameter">action</replaceable>は以下のいずれかです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER MATERIALIZED VIEW</command> changes various auxiliary
   properties of an existing materialized view.␟<command>ALTER MATERIALIZED VIEW</command>は既存のマテリアライズドビューの各種補助属性を変更します。␞␞  </para>␞
␝  <para>␟   You must own the materialized view to use <command>ALTER MATERIALIZED
   VIEW</command>.  To change a materialized view's schema, you must also have
   <literal>CREATE</literal> privilege on the new schema.
   To alter the owner, you must be able to <literal>SET ROLE</literal> to the
   new owning role, and that role must have <literal>CREATE</literal>
   privilege on the materialized view's schema.
   (These restrictions enforce that altering
   the owner doesn't do anything you couldn't do by dropping and recreating the
   materialized view.  However, a superuser can alter ownership of any view
   anyway.)␟<command>ALTER MATERIALIZED VIEW</command>を使用するためにはそのマテリアライズドビューを所有していなければなりません。
マテリアライズドビューのスキーマを変更するためには、新しいスキーマに対する<literal>CREATE</literal>権限を持たなければなりません。
所有者を変更するには、新しい所有者ロールに対して<literal>SET ROLE</literal>ができなければなりません。また、そのロールはマテリアライズドビューのスキーマに対して<literal>CREATE</literal>権限を持たなければなりません。
（これらの制限により、マテリアライズドビューを削除し再作成することによってできる以上のことを所有者の変更で行えないようにします。
しかしスーパーユーザはいずれにせよ任意のビューの所有権を変更することができます。）␞␞  </para>␞
␝  <para>␟   The statement subforms and actions available for
   <command>ALTER MATERIALIZED VIEW</command> are a subset of those available
   for <command>ALTER TABLE</command>, and have the same meaning when used for
   materialized views.  See the descriptions for
   <link linkend="sql-altertable"><command>ALTER TABLE</command></link>
   for details.␟<command>ALTER MATERIALIZED VIEW</command>文で利用可能な副構文と操作は、<command>ALTER TABLE</command>で利用できるものの部分集合であり、マテリアライズドビューに対して使用した場合も同じ意味を持ちます。
詳細については<link linkend="sql-altertable"><command>ALTER TABLE</command></link>の説明を参照してください。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝      <para>␟       The name (optionally schema-qualified) of an existing materialized view.␟既存のマテリアライズドビューの名前（スキーマ修飾可）です。␞␞      </para>␞
␝      <para>␟       Name of an existing column.␟既存の列の名前です。␞␞      </para>␞
␝      <para>␟       The name of the extension that the materialized view is to depend on (or no longer
       dependent on, if <literal>NO</literal> is specified).  A materialized view
       that's marked as dependent on an extension is automatically dropped when
       the extension is dropped.␟マテリアライズドビューが依存する(もしくは<literal>NO</literal>が指定された場合にはもはや依存していない)拡張の名前です。
拡張に依存していると印をつけられたマテリアライズドビューは、拡張が削除されると自動的に削除されます。␞␞      </para>␞
␝      <para>␟       New name for an existing column.␟既存の列に対する新しい名前です。␞␞      </para>␞
␝     <para>␟      The user name of the new owner of the materialized view.␟マテリアライズドビューの新しい所有者となるユーザの名前です。␞␞     </para>␞
␝     <para>␟      The new name for the materialized view.␟マテリアライズドビューの新しい名前です。␞␞     </para>␞
␝     <para>␟      The new schema for the materialized view.␟マテリアライズドビューの新しいスキーマです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To rename the materialized view <literal>foo</literal> to
   <literal>bar</literal>:␟マテリアライズドビュー<literal>foo</literal>の名前を<literal>bar</literal>に変更します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>ALTER MATERIALIZED VIEW</command> is a
   <productname>PostgreSQL</productname> extension.␟<command>ALTER MATERIALIZED VIEW</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟ALTER MATERIALIZED VIEW foo RENAME TO bar; </programlisting></para> </programlisting></para>␟no translation␞␞␞
