␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER TEXT SEARCH PARSER</refname>␟  <refpurpose>change the definition of a text search parser</refpurpose>␟  <refpurpose>テキスト検索パーサの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER TEXT SEARCH PARSER</command> changes the definition of
   a text search parser.  Currently, the only supported functionality
   is to change the parser's name.␟<command>ALTER TEXT SEARCH PARSER</command>はテキスト検索パーサの定義を変更します。
現時点では、パーサ名称の変更機能のみがサポートされています。␞␞  </para>␞
␝  <para>␟   You must be a superuser to use <command>ALTER TEXT SEARCH PARSER</command>.␟<command>ALTER TEXT SEARCH PARSER</command>を使用するためにはスーパーユーザでなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing text search parser.␟既存のテキスト検索パーサの名称（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      The new name of the text search parser.␟新しいテキスト検索パーサの名称です。␞␞     </para>␞
␝     <para>␟      The new schema for the text search parser.␟全文検索パーサの新しいスキーマです。␞␞     </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER TEXT SEARCH PARSER</command> statement in
   the SQL standard.␟標準SQLには<command>ALTER TEXT SEARCH PARSER</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
