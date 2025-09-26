␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP LANGUAGE</refname>␟  <refpurpose>remove a procedural language</refpurpose>␟  <refpurpose>手続き言語を削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP LANGUAGE</command> removes the definition of a
   previously registered procedural language.  You must be a superuser
   or the owner of the language to use <command>DROP LANGUAGE</command>.␟<command>DROP LANGUAGE</command>は過去に登録された手続き言語の定義を削除します。
<command>DROP LANGUAGE</command>を使用するにはスーパーユーザか言語の所有者でなければなりません。␞␞  </para>␞
␝   <para>␟    As of <productname>PostgreSQL</productname> 9.1, most procedural
    languages have been made into <quote>extensions</quote>, and should
    therefore be removed with <link linkend="sql-dropextension"><command>DROP EXTENSION</command></link>
    not <command>DROP LANGUAGE</command>.␟<productname>PostgreSQL</productname> 9.1からほとんどの手続き言語は<quote>拡張</quote>にまとめられましたので、<command>DROP LANGUAGE</command>ではなく<link linkend="sql-dropextension"><command>DROP EXTENSION</command></link>を使用して削除すべきです。␞␞   </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the language does not exist. A notice is issued
      in this case.␟言語が存在しない場合でもエラーになりません。
この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name of an existing procedural language.␟既存の手続き言語の名前です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the language (such as
      functions in the language),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟その言語に依存するオブジェクト（その言語で記述された関数など）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the language if any objects depend on it.  This
      is the default.␟依存しているオブジェクトがある場合、その言語の削除を拒否します。
こちらがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   This command removes the procedural language
   <literal>plsample</literal>:␟次のコマンドは<literal>plsample</literal>という手続き言語を削除します。␞␞␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP LANGUAGE</command> statement in the SQL
   standard.␟標準SQLには<command>DROP LANGUAGE</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP LANGUAGE plsample; </programlisting></para> </programlisting></para>␟no translation␞␞␞
