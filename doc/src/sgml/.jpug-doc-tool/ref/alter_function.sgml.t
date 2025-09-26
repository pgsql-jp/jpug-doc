␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER FUNCTION</refname>␟  <refpurpose>change the definition of a function</refpurpose>␟  <refpurpose>関数定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable class="parameter">action</replaceable> is one of:</phrase>␟<phrase>ここで<replaceable class="parameter">action</replaceable>は以下のいずれかです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER FUNCTION</command> changes the definition of a
   function.␟<command>ALTER FUNCTION</command>は関数定義を変更します。␞␞  </para>␞
␝  <para>␟   You must own the function to use <command>ALTER FUNCTION</command>.
   To change a function's schema, you must also have <literal>CREATE</literal>
   privilege on the new schema.  To alter the owner, you must be able to
   <literal>SET ROLE</literal> to the new owning role, and that role must
   have <literal>CREATE</literal> privilege on
   the function's schema.  (These restrictions enforce that altering the owner
   doesn't do anything you couldn't do by dropping and recreating the function.
   However, a superuser can alter ownership of any function anyway.)␟<command>ALTER FUNCTION</command>を使用するには関数の所有者でなければなりません。
関数のスキーマを変更するには、新しいスキーマにおける<literal>CREATE</literal>権限も必要です。
所有者を変更するには、新しい所有者ロールに対して<literal>SET ROLE</literal>ができなければなりません。また、そのロールは関数のスキーマにおいて<literal>CREATE</literal>権限を持たなければなりません。
（この制限により、関数の削除と再作成で行うことができない処理を所有者の変更で行えないようになります。
しかし、スーパーユーザはすべての関数の所有者を変更することができます。）␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing function.  If no
      argument list is specified, the name must be unique in its schema.␟既存の関数名です（スキーマ修飾名も可）。
引数リストを指定しない場合、名前はスキーマ内で一意でなければなりません。␞␞     </para>␞
␝     <para>␟      The mode of an argument: <literal>IN</literal>, <literal>OUT</literal>,
      <literal>INOUT</literal>, or <literal>VARIADIC</literal>.
      If omitted, the default is <literal>IN</literal>.
      Note that <command>ALTER FUNCTION</command> does not actually pay
      any attention to <literal>OUT</literal> arguments, since only the input
      arguments are needed to determine the function's identity.
      So it is sufficient to list the <literal>IN</literal>, <literal>INOUT</literal>,
      and <literal>VARIADIC</literal> arguments.␟引数のモードで、<literal>IN</literal>、<literal>OUT</literal>、<literal>INOUT</literal>、<literal>VARIADIC</literal>のいずれかです。
省略された場合のデフォルトは<literal>IN</literal>です。
関数の識別を行うには入力引数のみが必要ですので、実際には<command>ALTER FUNCTION</command>が<literal>OUT</literal>引数を無視することに注意してください。
ですので、<literal>IN</literal>、<literal>INOUT</literal>および<literal>VARIADIC</literal>引数を列挙することで十分です。␞␞     </para>␞
␝     <para>␟      The name of an argument.
      Note that <command>ALTER FUNCTION</command> does not actually pay
      any attention to argument names, since only the argument data
      types are needed to determine the function's identity.␟引数の名前です。
関数の識別を行うには引数のデータ型のみが必要ですので、実際には<command>ALTER FUNCTION</command>は引数の名前を無視することに注意してください。␞␞     </para>␞
␝     <para>␟      The data type(s) of the function's arguments (optionally
      schema-qualified), if any.␟もしあれば、その関数の引数のデータ型（スキーマ修飾可能）です。␞␞     </para>␞
␝     <para>␟      The new name of the function.␟新しい関数名です。␞␞     </para>␞
␝     <para>␟      The new owner of the function.  Note that if the function is
      marked <literal>SECURITY DEFINER</literal>, it will subsequently
      execute as the new owner.␟新しい関数の所有者です。
関数に<literal>SECURITY DEFINER</literal>が指定されている場合、その後は新しい所有者の権限で関数が実行されることに注意してください。␞␞     </para>␞
␝     <para>␟      The new schema for the function.␟関数の新しいスキーマです。␞␞     </para>␞
␝     <para>␟      This form marks the function as dependent on the extension, or no longer
      dependent on that extension if <literal>NO</literal> is specified.
      A function that's marked as dependent on an extension is dropped when the
      extension is dropped, even if <literal>CASCADE</literal> is not specified.
      A function can depend upon multiple extensions, and will be dropped when
      any one of those extensions is dropped.␟この構文は、関数が拡張に依存している、もしくは<literal>NO</literal>が指定された場合には拡張にもはや依存していないと印を付けます。
拡張に依存していると印を付けられた関数は、<literal>CASCADE</literal>が指定されていなくても拡張が削除されると自動的に削除されます。
関数は複数の拡張に依存することができ、これらの拡張のうちどれか一つが削除されるとその関数は削除されます。␞␞     </para>␞
␝     <listitem>␟      <para><literal>CALLED ON NULL INPUT</literal> changes the function so
       that it will be invoked when some or all of its arguments are
       null. <literal>RETURNS NULL ON NULL INPUT</literal> or
       <literal>STRICT</literal> changes the function so that it is not
       invoked if any of its arguments are null; instead, a null result
       is assumed automatically.  See <xref linkend="sql-createfunction"/>
       for more information.␟<para><literal>CALLED ON NULL INPUT</literal>は、引数の一部またはすべてがNULLの場合に関数が呼び出されるように変更します。
<literal>RETURNS NULL ON NULL INPUT</literal>もしくは<literal>STRICT</literal>は、引数の一部がNULLの場合に関数が呼び出されないように変更します。
代わりに自動的にNULLという結果とされます。
詳細は<xref linkend="sql-createfunction"/>を参照してください。␞␞      </para>␞
␝      <para>␟       Change the volatility of the function to the specified setting.
       See <xref linkend="sql-createfunction"/> for details.␟関数の揮発性を指定した設定に変更します。
詳細については<xref linkend="sql-createfunction"/>を参照してください。␞␞      </para>␞
␝     <para>␟      Change whether the function is a security definer or not. The
      key word <literal>EXTERNAL</literal> is ignored for SQL
      conformance. See <xref linkend="sql-createfunction"/> for more information about
      this capability.␟関数のセキュリティを定義者にするか否かを変更します。
<literal>EXTERNAL</literal>キーワードはSQLとの互換性のためのものであり、無視されます。
この機能の詳細については<xref linkend="sql-createfunction"/>を参照してください。␞␞     </para>␞
␝     <para>␟      Change whether the function is deemed safe for parallelism.
      See <xref linkend="sql-createfunction"/> for details.␟関数が並列処理に対して安全であると見なされるかどうかを変更します。
詳しくは<xref linkend="sql-createfunction"/>を参照してください。␞␞     </para>␞
␝     <para>␟      Change whether the function is considered leakproof or not.
      See <xref linkend="sql-createfunction"/> for more information about
      this capability.␟関数を漏洩防止関数とみなすか否かを変更します。
この機能に関する詳細については<xref linkend="sql-createfunction"/>を参照してください。␞␞     </para>␞
␝      <para>␟       Change the estimated execution cost of the function.
       See <xref linkend="sql-createfunction"/> for more information.␟関数の推定実行コストを変更します。
詳細については<xref linkend="sql-createfunction"/>を参照してください。␞␞      </para>␞
␝      <para>␟       Change the estimated number of rows returned by a set-returning
       function.  See <xref linkend="sql-createfunction"/> for more information.␟集合を返す関数で返される推定行数を変更します。
詳細については<xref linkend="sql-createfunction"/>を参照してください。␞␞      </para>␞
␝     <para>␟      Set or change the planner support function to use for this function.
      See <xref linkend="xfunc-optimization"/> for details.  You must be
      superuser to use this option.␟この関数のために使うプランナサポート関数を設定もしくは変更します。
詳細は<xref linkend="xfunc-optimization"/>を参照してください。
このオプションを使うにはスーパーユーザでなければなりません。␞␞     </para>␞
␝     <para>␟      This option cannot be used to remove the support function altogether,
      since it must name a new support function.  Use <command>CREATE OR
      REPLACE FUNCTION</command> if you need to do that.␟新しいサポート関数の名前でなければならないため、このオプションはサポート関数を同時に削除するのに使うことはできません。
そうする必要があるなら、<command>CREATE OR REPLACE FUNCTION</command>を使ってください。␞␞     </para>␞
␝       <para>␟        Add or change the assignment to be made to a configuration parameter
        when the function is called.  If
        <replaceable>value</replaceable> is <literal>DEFAULT</literal>
        or, equivalently, <literal>RESET</literal> is used, the function-local
        setting is removed, so that the function executes with the value
        present in its environment.  Use <literal>RESET
        ALL</literal> to clear all function-local settings.
        <literal>SET FROM CURRENT</literal> saves the value of the parameter that
        is current when <command>ALTER FUNCTION</command> is executed as the value
        to be applied when the function is entered.␟関数呼び出し時に設定パラメータに対して行われる設定を追加または変更します。
<replaceable>value</replaceable>が<literal>DEFAULT</literal>、またはそれと等価な<literal>RESET</literal>が使用された場合、関数の局所的な設定は削除されます。
このため、関数はその環境内に存在する値で実行されます。
すべての関数の局所的な設定を消去したければ<literal>RESET ALL</literal>を使用してください。
<literal>SET FROM CURRENT</literal>は、<command>ALTER FUNCTION</command>が実行された時点でのパラメータの現在値を、関数起動時に適用される値として保管します。␞␞       </para>␞
␝       <para>␟        See <xref linkend="sql-set"/> and
        <xref linkend="runtime-config"/>
        for more information about allowed parameter names and values.␟設定可能なパラメータとその値に関する詳細については、<xref linkend="sql-set"/>および<xref linkend="runtime-config"/>を参照してください。␞␞       </para>␞
␝     <para>␟      Ignored for conformance with the SQL standard.␟標準SQLとの互換性のためのものであり、無視されます。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To rename the function <literal>sqrt</literal> for type
   <type>integer</type> to <literal>square_root</literal>:␟<type>integer</type>型用の<literal>sqrt</literal>関数の名前を<literal>square_root</literal>に変更します。␞␞<programlisting>␞
␝  <para>␟   To change the owner of the function <literal>sqrt</literal> for type
   <type>integer</type> to <literal>joe</literal>:␟<type>integer</type>型用の<literal>sqrt</literal>関数の所有者を<literal>joe</literal>に変更します。␞␞<programlisting>␞
␝  <para>␟   To change the schema of the function <literal>sqrt</literal> for type
   <type>integer</type> to <literal>maths</literal>:␟<type>integer</type>型用の<literal>sqrt</literal>関数のスキーマを<literal>maths</literal>に変更します。␞␞<programlisting>␞
␝  <para>␟   To mark the function <literal>sqrt</literal> for type
   <type>integer</type> as being dependent on the extension
   <literal>mathlib</literal>:␟<type>integer</type>型に対する関数<literal>sqrt</literal>が、拡張<literal>mathlib</literal>に依存するとして印をつけるには、次のようにします。␞␞<programlisting>␞
␝  <para>␟   To adjust the search path that is automatically set for a function:␟関数用に検索パスを自動的に設定するように調整します。␞␞<programlisting>␞
␝  <para>␟   To disable automatic setting of <varname>search_path</varname> for a function:␟関数用の<varname>search_path</varname>の自動設定を無効にします。␞␞<programlisting>␞
␝</programlisting>␟   The function will now execute with whatever search path is used by its
   caller.␟呼び出し元で使用される検索パスでこの関数が実行されるようになります。␞␞  </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   This statement is partially compatible with the <command>ALTER
   FUNCTION</command> statement in the SQL standard. The standard allows more
   properties of a function to be modified, but does not provide the
   ability to rename a function, make a function a security definer,
   attach configuration parameter values to a function,
   or change the owner, schema, or volatility of a function. The standard also
   requires the <literal>RESTRICT</literal> key word, which is optional in
   <productname>PostgreSQL</productname>.␟この文は標準SQLの<command>ALTER FUNCTION</command>文に部分的に従っています。
標準ではより多くの関数の属性を変更できますが、関数名の変更、関数を定義者の権限で実行するかどうかの変更、関数と設定パラメータ値の関連付け、関数の所有者やスキーマ、揮発性の変更を行う機能はありません。
また、標準では<literal>RESTRICT</literal>キーワードを必須としていますが、<productname>PostgreSQL</productname>では省略可能です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
