␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER POLICY</refname>␟  <refpurpose>change the definition of a row-level security policy</refpurpose>␟  <refpurpose>行単位のセキュリティポリシーの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER POLICY</command> changes the definition of an existing
   row-level security policy.  Note that <command>ALTER POLICY</command>
   only allows the set of roles to which the policy applies and the
   <literal>USING</literal> and <literal>WITH CHECK</literal> expressions to
   be modified.  To change other properties of a policy, such as the command
   to which it applies or whether it is permissive or restrictive, the policy
   must be dropped and recreated.␟<command>ALTER POLICY</command>は既存の行単位のセキュリティポリシーの定義を変更します。
<command>ALTER POLICY</command>はポリシーが適用されるロールの集合、および<literal>USING</literal>と<literal>WITH CHECK</literal>の式を変更できるだけであることに注意してください。
適用されるコマンドや、許容と制限の別といったその他のポリシーの属性を変更するには、ポリシーを削除して再作成しなければなりません。␞␞  </para>␞
␝  <para>␟   To use <command>ALTER POLICY</command>, you must own the table that
   the policy applies to.␟<command>ALTER POLICY</command>を使うには、ポリシーの適用対象のテーブルの所有者でなければなりません。␞␞  </para>␞
␝  <para>␟   In the second form of <command>ALTER POLICY</command>, the role list,
   <replaceable class="parameter">using_expression</replaceable>, and
   <replaceable class="parameter">check_expression</replaceable> are replaced
   independently if specified.  When one of those clauses is omitted, the
   corresponding part of the policy is unchanged.␟<command>ALTER POLICY</command>の2番目の構文で、ロールのリスト、<replaceable class="parameter">using_expression</replaceable>、<replaceable class="parameter">check_expression</replaceable>が指定された時は、それぞれ独立して置換されます。
それらの1つが省略された場合、ポリシーのその部分については変更されません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of an existing policy to alter.␟変更対象の既存のポリシーの名前です。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of the table that the
      policy is on.␟ポリシーが適用されているテーブルの名前（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      The new name for the policy.␟ポリシーの新しい名前です。␞␞     </para>␞
␝     <para>␟      The role(s) to which the policy applies.  Multiple roles can be
      specified at one time.  To apply the policy to all roles,
      use <literal>PUBLIC</literal>.␟ポリシーの適用対象のロールです。
複数のロールを一度に指定することができます。
ポリシーをすべてのロールに適用するには、<literal>PUBLIC</literal>を指定します。␞␞     </para>␞
␝     <para>␟      The <literal>USING</literal> expression for the policy.
      See <xref linkend="sql-createpolicy"/> for details.␟ポリシーの<literal>USING</literal>式です。
詳しくは<xref linkend="sql-createpolicy"/>を参照して下さい。␞␞     </para>␞
␝     <para>␟      The <literal>WITH CHECK</literal> expression for the policy.
      See <xref linkend="sql-createpolicy"/> for details.␟ポリシーの<literal>WITH CHECK</literal>式です。
詳しくは<xref linkend="sql-createpolicy"/>を参照して下さい。␞␞     </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>ALTER POLICY</command> is a <productname>PostgreSQL</productname> extension.␟<command>ALTER POLICY</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
