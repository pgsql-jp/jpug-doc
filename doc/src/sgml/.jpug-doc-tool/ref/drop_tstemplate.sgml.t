␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP TEXT SEARCH TEMPLATE</refname>␟  <refpurpose>remove a text search template</refpurpose>␟  <refpurpose>テキスト検索テンプレートを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP TEXT SEARCH TEMPLATE</command> drops an existing text search
   template.  You must be a superuser to use this command.␟<command>DROP TEXT SEARCH TEMPLATE</command>は既存のテキスト検索テンプレートを削除します。
このコマンドを実行するためには、スーパーユーザでなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the text search template does not exist.
      A notice is issued in this case.␟テキスト検索テンプレートが存在しない場合でもエラーとしません。
この場合は注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an existing text search
      template.␟既存のテキスト検索テンプレートの名称（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the text search template,
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟テキスト検索テンプレートに依存するオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the text search template if any objects depend on it.
      This is the default.␟依存するオブジェクトが存在する場合、テキスト検索テンプレートの削除を中止します。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Remove the text search template <literal>thesaurus</literal>:␟テキスト検索テンプレート<literal>thesaurus</literal>を削除します。␞␞␞
␝␟   This command will not succeed if there are any existing text search
   dictionaries that use the template.  Add <literal>CASCADE</literal> to
   drop such dictionaries along with the template.␟このテンプレートを使用するテキスト検索辞書が存在する場合、このコマンドは成功しません。
こうした辞書をテンプレートと一緒に削除するためには<literal>CASCADE</literal>を付けてください。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP TEXT SEARCH TEMPLATE</command> statement in the
   SQL standard.␟標準SQLには<command>DROP TEXT SEARCH TEMPLATE</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
