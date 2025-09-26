␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER USER</refname>␟  <refpurpose>change a database role</refpurpose>␟<refpurpose>データベースロールを変更する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable class="parameter">option</replaceable> can be:</phrase>␟<phrase>ここで<replaceable class="parameter">option</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟<phrase>where <replaceable class="parameter">role_specification</replaceable> can be:</phrase>␟<phrase>ここで<replaceable class="parameter">role_specification</replaceable>は以下の通りです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER USER</command> is now an alias for
   <link linkend="sql-alterrole"><command>ALTER ROLE</command></link>.␟<command>ALTER USER</command>は<link linkend="sql-alterrole"><command>ALTER ROLE</command></link>の別名になりました。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   The <command>ALTER USER</command> statement is a
   <productname>PostgreSQL</productname> extension.  The SQL standard
   leaves the definition of users to the implementation.␟<command>ALTER USER</command>文は、<productname>PostgreSQL</productname>の拡張です。
標準SQLでは、ユーザの定義は実装に任されています。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
