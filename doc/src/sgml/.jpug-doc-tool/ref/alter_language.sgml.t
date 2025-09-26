␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER LANGUAGE</refname>␟  <refpurpose>change the definition of a procedural language</refpurpose>␟  <refpurpose>手続き言語の定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER LANGUAGE</command> changes the definition of a
   procedural language.  The only functionality is to rename the language or
   assign a new owner.  You must be superuser or owner of the language to
   use <command>ALTER LANGUAGE</command>.␟<command>ALTER LANGUAGE</command>は、手続き言語の定義を変更します。
言語名の変更および言語の所有者の変更のみが可能です。
<command>ALTER LANGUAGE</command>を使用するためにはスーパーユーザまたは言語の所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Name of a language␟言語の名前です。␞␞     </para>␞
␝     <para>␟      The new name of the language␟新しい言語の名前です。␞␞     </para>␞
␝     <para>␟      The new owner of the language␟新しい言語の所有者です。␞␞     </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER LANGUAGE</command> statement in the SQL
   standard.␟標準SQLには<command>ALTER LANGUAGE</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
