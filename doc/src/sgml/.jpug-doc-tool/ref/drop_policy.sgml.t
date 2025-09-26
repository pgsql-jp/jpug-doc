␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP POLICY</refname>␟  <refpurpose>remove a row-level security policy from a table</refpurpose>␟  <refpurpose>テーブルから行単位のセキュリティポリシーを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP POLICY</command> removes the specified policy from the table.
   Note that if the last policy is removed for a table and the table still has
   row-level security enabled via <command>ALTER TABLE</command>, then the
   default-deny policy will be used.  <literal>ALTER TABLE ... DISABLE ROW
   LEVEL SECURITY</literal> can be used to disable row-level security for a
   table, whether policies for the table exist or not.␟<command>DROP POLICY</command>はテーブルから指定したポリシーを削除します。
テーブルの最後のポリシーが削除され、そのテーブルではまだ<command>ALTER TABLE</command>による行単位セキュリティが有効な場合は、デフォルト拒否のポリシーが使われることに注意して下さい。
テーブルのポリシーの存在の有無に関わらず、<literal>ALTER TABLE ... DISABLE ROW LEVEL SECURITY</literal>を使い、テーブルの行単位セキュリティを無効にすることができます。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the policy does not exist. A notice is issued
      in this case.␟ポリシーが存在しない時にエラーを発生させません。
この場合、注意が発行されます。␞␞     </para>␞
␝     <para>␟      The name of the policy to drop.␟削除するポリシーの名前です。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of the table that
      the policy is on.␟ポリシーが適用されているテーブルの名前（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      These key words do not have any effect, since there are no
      dependencies on policies.␟これらのキーワードには何の効果もありません。
ポリシーには依存関係がないからです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To drop the policy called <literal>p1</literal> on the table named
   <literal>my_table</literal>:␟<literal>my_table</literal>という名前のテーブル上の<literal>p1</literal>というポリシーを削除するには、次のようにします。␞␞␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP POLICY</command> is a <productname>PostgreSQL</productname> extension.␟<command>DROP POLICY</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP POLICY p1 ON my_table; </programlisting></para> </programlisting></para>␟no translation␞␞␞
