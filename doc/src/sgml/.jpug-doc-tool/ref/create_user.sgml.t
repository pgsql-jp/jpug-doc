␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>CREATE USER</refname>␟  <refpurpose>define a new database role</refpurpose>␟<refpurpose>新しいデータベースロールを定義する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable class="parameter">option</replaceable> can be:</phrase>␟<phrase>ここで<replaceable class="parameter">option</replaceable>は以下の通りです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>CREATE USER</command> is now an alias for
   <link linkend="sql-createrole"><command>CREATE ROLE</command></link>.
   The only difference is that when the command is spelled
   <command>CREATE USER</command>, <literal>LOGIN</literal> is assumed
   by default, whereas <literal>NOLOGIN</literal> is assumed when
   the command is spelled
   <command>CREATE ROLE</command>.␟<command>CREATE USER</command>は<link linkend="sql-createrole"><command>CREATE ROLE</command></link>の別名になりました。
唯一の違いは、<command>CREATE USER</command>という名前でコマンドが呼び出されると、デフォルトで<literal>LOGIN</literal>になり、<command>CREATE ROLE</command>という名前でコマンドが呼び出されると、デフォルトで<literal>NOLOGIN</literal>となる点です。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   The <command>CREATE USER</command> statement is a
   <productname>PostgreSQL</productname> extension.  The SQL standard
   leaves the definition of users to the implementation.␟<command>CREATE USER</command>文は、<productname>PostgreSQL</productname>の拡張です。
標準SQLでは、ユーザの定義は実装に任されています。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
