␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER OPERATOR</refname>␟  <refpurpose>change the definition of an operator</refpurpose>␟  <refpurpose>演算子の定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER OPERATOR</command> changes the definition of
   an operator.␟<command>ALTER OPERATOR</command>は演算子の定義を変更します。␞␞  </para>␞
␝  <para>␟   You must own the operator to use <command>ALTER OPERATOR</command>.
   To alter the owner, you must be able to <literal>SET ROLE</literal> to the
   new owning role, and that role must have <literal>CREATE</literal>
   privilege on the operator's schema.
   (These restrictions enforce that altering the owner
   doesn't do anything you couldn't do by dropping and recreating the operator.
   However, a superuser can alter ownership of any operator anyway.)␟<command>ALTER OPERATOR</command>を使用するには演算子の所有者でなければなりません。
所有者を変更するには、新しい所有者ロールに対して<literal>SET ROLE</literal>ができなければなりません。また、そのロールは演算子のスキーマにおいて<literal>CREATE</literal>権限を持たなければなりません。
（この制限により、演算子の削除と再作成で行うことができない処理を所有者の変更で行えないようになります。
しかし、スーパーユーザはすべての演算子の所有者を変更することができます。）␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing operator.␟既存の演算子の名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      The data type of the operator's left operand; write
      <literal>NONE</literal> if the operator has no left operand.␟演算子の左オペランドのデータ型です。
左オペランドがない演算子の場合は<literal>NONE</literal>を指定します。␞␞     </para>␞
␝     <para>␟      The data type of the operator's right operand.␟演算子の右オペランドのデータ型です。␞␞     </para>␞
␝     <para>␟      The new owner of the operator.␟演算子の新しい所有者です。␞␞     </para>␞
␝     <para>␟      The new schema for the operator.␟演算子の新しいスキーマです。␞␞     </para>␞
␝       <para>␟         The restriction selectivity estimator function for this operator; write NONE to remove existing selectivity estimator.␟この演算子の制約選択評価関数です。
既存の制約選択評価関数を削除するにはNONEを指定します。␞␞       </para>␞
␝       <para>␟         The join selectivity estimator function for this operator; write NONE to remove existing selectivity estimator.␟この演算子の結合選択評価関数です。
既存の結合選択評価関数を削除するにはNONEを指定します。␞␞       </para>␞
␝     <para>␟      The commutator of this operator. Can only be changed if the operator
      does not have an existing commutator.␟この演算子の交換子。
演算子に既存の交換子がない場合にのみ変更できます。␞␞     </para>␞
␝     <para>␟      The negator of this operator. Can only be changed if the operator does
      not have an existing negator.␟この演算子の否定子。
演算子に既存の否定子がない場合にのみ変更できます。␞␞     </para>␞
␝     <para>␟      Indicates this operator can support a hash join. Can only be enabled and
      not disabled.␟この演算子がハッシュ結合をサポートできることを示します。
有効にできるだけで、無効にはできません。␞␞     </para>␞
␝     <para>␟      Indicates this operator can support a merge join. Can only be enabled
      and not disabled.␟この演算子がマージ結合をサポートできることを示します。
有効にできるだけで、無効にはできません。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   Refer to <xref linkend="xoper"/> and
   <xref linkend="xoper-optimization"/> for further information.␟詳細は<xref linkend="xoper"/>と<xref linkend="xoper-optimization"/>を参照してください。␞␞  </para>␞
␝  <para>␟   Since commutators come in pairs that are commutators of each other,
   <literal>ALTER OPERATOR SET COMMUTATOR</literal> will also set the
   commutator of the <replaceable class="parameter">com_op</replaceable>
   to be the target operator.  Likewise, <literal>ALTER OPERATOR SET
   NEGATOR</literal> will also set the negator of
   the <replaceable class="parameter">neg_op</replaceable> to be the
   target operator.  Therefore, you must own the commutator or negator
   operator as well as the target operator.␟交換子は互いに交換子である対になっているので、<literal>ALTER OPERATOR SET COMMUTATOR</literal>は<replaceable class="parameter">com_op</replaceable>の交換子も対象演算子に設定します。
同様に、<literal>ALTER OPERATOR SET NEGATOR</literal>は<replaceable class="parameter">neg_op</replaceable>の否定子も対象演算子に設定します。
したがって、対象演算子と同様に交換子または否定子演算子を所有する必要があります。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Change the owner of a custom operator <literal>a @@ b</literal> for type <type>text</type>:␟<type>text</type>型用の独自の演算子<literal>a @@ b</literal>の所有者を変更します。␞␞<programlisting>␞
␝  <para>␟   Change the restriction and join selectivity estimator functions of a
   custom operator <literal>a &amp;&amp; b</literal> for
   type <type>int[]</type>:␟<type>int[]</type>型用の独自の演算子<literal>a &amp;&amp; b</literal>の制約および結合選択評価関数を変更します。␞␞<programlisting>␞
␝  <para>␟   Mark the <literal>&amp;&amp;</literal> operator as being its own
   commutator:␟<literal>&amp;&amp;</literal>演算子をそれ自身の交換子として印を付けます。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER OPERATOR</command> statement in
   the SQL standard.␟標準SQLには<command>ALTER OPERATOR</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
