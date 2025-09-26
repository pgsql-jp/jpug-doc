␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER OPERATOR CLASS</refname>␟  <refpurpose>change the definition of an operator class</refpurpose>␟  <refpurpose>演算子クラスの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER OPERATOR CLASS</command> changes the definition of
   an operator class.␟<command>ALTER OPERATOR CLASS</command>は演算子クラスの定義を変更します。␞␞  </para>␞
␝  <para>␟   You must own the operator class to use <command>ALTER OPERATOR CLASS</command>.
   To alter the owner, you must be able to <literal>SET ROLE</literal> to the
   new owning role, and that role must have <literal>CREATE</literal>
   privilege on the operator class's schema.
   (These restrictions enforce that altering the
   owner doesn't do anything you couldn't do by dropping and recreating the
   operator class.  However, a superuser can alter ownership of any operator
   class anyway.)␟<command>ALTER OPERATOR CLASS</command>を使用するには演算子クラスの所有者でなければなりません。
所有者を変更するには、新しい所有者ロールに対して<literal>SET ROLE</literal>ができなければなりません。また、そのロールは演算子クラスのスキーマにおいて<literal>CREATE</literal>権限を持たなければなりません。
（この制限により、演算子クラスの削除と再作成で行うことができない処理を所有者の変更で行えないようになります。
しかし、スーパーユーザはすべての演算子クラスの所有者を変更することができます。）␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing operator
      class.␟既存の演算子クラスの名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      The name of the index method this operator class is for.␟演算子クラス用のインデックスメソッドの名前です。␞␞     </para>␞
␝     <para>␟      The new name of the operator class.␟新しい演算子クラス名です。␞␞     </para>␞
␝     <para>␟      The new owner of the operator class.␟演算子クラスの新しい所有者です。␞␞     </para>␞
␝     <para>␟      The new schema for the operator class.␟演算子クラスの新しいスキーマです。␞␞     </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER OPERATOR CLASS</command> statement in
   the SQL standard.␟標準SQLには<command>ALTER OPERATOR CLASS</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
