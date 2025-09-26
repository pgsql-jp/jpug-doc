␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER RULE</refname>␟  <refpurpose>change the definition of a rule</refpurpose>␟  <refpurpose>ルールの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER RULE</command> changes properties of an existing
   rule.  Currently, the only available action is to change the rule's name.␟<command>ALTER RULE</command>は既存のルールの属性を変更します。
現時点で利用可能な操作はルールの名称変更のみです。␞␞  </para>␞
␝  <para>␟   To use <command>ALTER RULE</command>, you must own the table or view that
   the rule applies to.␟<command>ALTER RULE</command>を使用するためには、ルールを適用するテーブルまたはビューの所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of an existing rule to alter.␟変更対象の既存のルールの名前です。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of the table or view that the
      rule applies to.␟ルールを適用するテーブルまたはビューの名前（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      The new name for the rule.␟ルールの新しい名前です。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To rename an existing rule:␟既存のルールの名前を変更します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>ALTER RULE</command> is a
   <productname>PostgreSQL</productname> language extension, as is the
   entire query rewrite system.␟<command>ALTER RULE</command>は<productname>PostgreSQL</productname>の言語拡張で、問い合わせ書き換えシステム全体も言語拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟ALTER RULE notify_all ON emp RENAME TO notify_me; </programlisting></para> </programlisting></para>␟no translation␞␞␞
