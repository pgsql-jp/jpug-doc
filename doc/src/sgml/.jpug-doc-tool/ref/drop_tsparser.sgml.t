␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP TEXT SEARCH PARSER</refname>␟  <refpurpose>remove a text search parser</refpurpose>␟  <refpurpose>テキスト検索パーサを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP TEXT SEARCH PARSER</command> drops an existing text search
   parser.  You must be a superuser to use this command.␟<command>DROP TEXT SEARCH PARSER</command>は既存のテキスト検索パーサを削除します。
このコマンドを実行するためには、スーパーユーザでなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the text search parser does not exist.
      A notice is issued in this case.␟テキスト検索パーサが存在しない場合でもエラーとしません。
この場合は注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an existing text search parser.␟既存のテキスト検索パーサの名称（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the text search parser,
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟テキスト検索パーサに依存するオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the text search parser if any objects depend on it.
      This is the default.␟依存するオブジェクトが存在する場合、テキスト検索パーサの削除を中止します。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Remove the text search parser <literal>my_parser</literal>:␟テキスト検索パーサ<literal>my_parser</literal>を削除します。␞␞␞
␝␟   This command will not succeed if there are any existing text search
   configurations that use the parser.  Add <literal>CASCADE</literal> to
   drop such configurations along with the parser.␟このパーサを使用するテキスト検索設定が存在する場合、このコマンドは成功しません。
こうした設定をパーサと一緒に削除するためには<literal>CASCADE</literal>を付けてください。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP TEXT SEARCH PARSER</command> statement in the
   SQL standard.␟標準SQLには<command>DROP TEXT SEARCH PARSER</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
