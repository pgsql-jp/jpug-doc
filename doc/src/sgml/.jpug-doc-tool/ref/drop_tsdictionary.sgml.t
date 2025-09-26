␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP TEXT SEARCH DICTIONARY</refname>␟  <refpurpose>remove a text search dictionary</refpurpose>␟  <refpurpose>テキスト検索辞書を削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP TEXT SEARCH DICTIONARY</command> drops an existing text
   search dictionary.  To execute this command you must be the owner of the
   dictionary.␟<command>DROP TEXT SEARCH DICTIONARY</command>は既存のテキスト検索辞書を削除します。
このコマンドを実行するためには、その辞書の所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the text search dictionary does not exist.
      A notice is issued in this case.␟テキスト検索辞書が存在しない場合でもエラーとしません。
この場合は注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an existing text search
      dictionary.␟既存のテキスト検索辞書の名称（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the text search dictionary,
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟テキスト検索辞書に依存するオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the text search dictionary if any objects depend on it.
      This is the default.␟依存するオブジェクトが存在する場合、テキスト検索辞書の削除を中止します。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Remove the text search dictionary <literal>english</literal>:␟テキスト検索辞書<literal>english</literal>を削除します。␞␞␞
␝␟   This command will not succeed if there are any existing text search
   configurations that use the dictionary.  Add <literal>CASCADE</literal> to
   drop such configurations along with the dictionary.␟この辞書を使用するテキスト検索設定が存在する場合、このコマンドは成功しません。
こうした設定を辞書と一緒に削除するためには<literal>CASCADE</literal>を付けてください。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP TEXT SEARCH DICTIONARY</command> statement in the
   SQL standard.␟標準SQLには<command>DROP TEXT SEARCH DICTIONARY</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
