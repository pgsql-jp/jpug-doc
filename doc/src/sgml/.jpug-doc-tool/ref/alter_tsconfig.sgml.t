␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER TEXT SEARCH CONFIGURATION</refname>␟  <refpurpose>change the definition of a text search configuration</refpurpose>␟  <refpurpose>テキスト検索設定の定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER TEXT SEARCH CONFIGURATION</command> changes the definition of
   a text search configuration.  You can modify
   its mappings from token types to dictionaries,
   or change the configuration's name or owner.␟<command>ALTER TEXT SEARCH CONFIGURATION</command>はテキスト検索設定の定義を変更します。
トークン型から辞書への対応付けの変更、または、設定名称の変更、設定の所有者の変更を行うことができます。␞␞  </para>␞
␝  <para>␟   You must be the owner of the configuration to use
   <command>ALTER TEXT SEARCH CONFIGURATION</command>.␟<command>ALTER TEXT SEARCH CONFIGURATION</command>を使用するためには、設定の所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing text search
      configuration.␟既存のテキスト検索設定の名称（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      The name of a token type that is emitted by the configuration's
      parser.␟設定のパーサが発行するトークン型の名称です。␞␞     </para>␞
␝     <para>␟      The name of a text search dictionary to be consulted for the
      specified token type(s).  If multiple dictionaries are listed,
      they are consulted in the specified order.␟指定したトークン型（複数可）で考慮されるテキスト検索辞書の名称です。
複数の辞書が列挙された場合、指定された順序で参照されます。␞␞     </para>␞
␝     <para>␟      The name of a text search dictionary to be replaced in the mapping.␟対応付けにて置換されるテキスト検索辞書の名称です。␞␞     </para>␞
␝     <para>␟      The name of a text search dictionary to be substituted for
      <replaceable class="parameter">old_dictionary</replaceable>.␟<replaceable class="parameter">old_dictionary</replaceable>を置き換えるテキスト検索辞書の名称です。␞␞     </para>␞
␝     <para>␟      The new name of the text search configuration.␟テキスト検索設定の新しい名称です。␞␞     </para>␞
␝     <para>␟      The new owner of the text search configuration.␟テキスト検索設定の新しい所有者です。␞␞     </para>␞
␝     <para>␟      The new schema for the text search configuration.␟テキスト検索設定の新しいスキーマです。␞␞     </para>␞
␝  <para>␟   The <literal>ADD MAPPING FOR</literal> form installs a list of dictionaries to be
   consulted for the specified token type(s); it is an error if there is
   already a mapping for any of the token types.
   The <literal>ALTER MAPPING FOR</literal> form does the same, but first removing
   any existing mapping for those token types.
   The <literal>ALTER MAPPING REPLACE</literal> forms substitute <replaceable
   class="parameter">new_dictionary</replaceable> for <replaceable
   class="parameter">old_dictionary</replaceable> anywhere the latter appears.
   This is done for only the specified token types when <literal>FOR</literal>
   appears, or for all mappings of the configuration when it doesn't.
   The <literal>DROP MAPPING</literal> form removes all dictionaries for the
   specified token type(s), causing tokens of those types to be ignored
   by the text search configuration.  It is an error if there is no mapping
   for the token types, unless <literal>IF EXISTS</literal> appears.␟<literal>ADD MAPPING FOR</literal>構文は指定したトークン型で参照される辞書のリストをインストールします。
既にそのトークン型に対する対応付けが存在する場合はエラーになります。
<literal>ALTER MAPPING FOR</literal>構文は、まず既存の対象トークン型に対する対応付けを削除する点を除き、同一です。
<literal>ALTER MAPPING REPLACE</literal>構文は、すべての<replaceable class="parameter">old_dictionary</replaceable>を<replaceable class="parameter">new_dictionary</replaceable>で置き換えます。
<literal>FOR</literal>があれば、これは指定したトークン型に対してのみ行われ、なければ、設定におけるすべての対応付けに対して行われます。
<literal>DROP MAPPING</literal>構文は指定したトークン型（複数可）に対するすべての辞書を削除します。
この結果、このテキスト検索設定ではこれらの型のトークンが無視されるようになります。
<literal>IF EXISTS</literal>がない限り、トークン型に対する対応付けが存在しない場合はエラーになります。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   The following example replaces the <literal>english</literal> dictionary
   with the <literal>swedish</literal> dictionary anywhere that <literal>english</literal>
   is used within <literal>my_config</literal>.␟次の例は、<literal>my_config</literal>内で<literal>english</literal>が使用されるすべてに対し、<literal>english</literal>辞書を<literal>swedish</literal>辞書で置換します。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER TEXT SEARCH CONFIGURATION</command> statement in
   the SQL standard.␟標準SQLには<command>ALTER TEXT SEARCH CONFIGURATION</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
