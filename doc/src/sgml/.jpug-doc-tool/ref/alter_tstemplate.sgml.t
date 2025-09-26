␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER TEXT SEARCH TEMPLATE</refname>␟  <refpurpose>change the definition of a text search template</refpurpose>␟  <refpurpose>テキスト検索テンプレートの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER TEXT SEARCH TEMPLATE</command> changes the definition of
   a text search template.  Currently, the only supported functionality
   is to change the template's name.␟<command>ALTER TEXT SEARCH TEMPLATE</command>はテキスト検索テンプレートの定義を変更します。
現時点では、テンプレート名称の変更機能のみがサポートされています。␞␞  </para>␞
␝  <para>␟   You must be a superuser to use <command>ALTER TEXT SEARCH TEMPLATE</command>.␟<command>ALTER TEXT SEARCH TEMPLATE</command>を使用するためにはスーパーユーザでなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing text search template.␟既存のテキスト検索テンプレートの名称（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      The new name of the text search template.␟新しいテキスト検索テンプレートの名称です。␞␞     </para>␞
␝     <para>␟      The new schema for the text search template.␟テキスト検索テンプレートの新しいスキーマです。␞␞     </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER TEXT SEARCH TEMPLATE</command> statement in
   the SQL standard.␟標準SQLには<command>ALTER TEXT SEARCH TEMPLATE</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
