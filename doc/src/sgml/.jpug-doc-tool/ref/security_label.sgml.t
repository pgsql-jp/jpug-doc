␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>SECURITY LABEL</refname>␟  <refpurpose>define or change a security label applied to an object</refpurpose>␟  <refpurpose>オブジェクトに適用するセキュリティラベルを定義または変更する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable>aggregate_signature</replaceable> is:</phrase>␟<phrase>ここで<replaceable>aggregate_signature</replaceable>は以下の通りです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>SECURITY LABEL</command> applies a security label to a database
   object.  An arbitrary number of security labels, one per label provider, can
   be associated with a given database object.  Label providers are loadable
   modules which register themselves by using the function
   <function>register_label_provider</function>.␟<command>SECURITY LABEL</command>はセキュリティラベルをデータベースオブジェクトに適用します。
ラベルプロバイダごとに１つの、任意の数のセキュリティラベルを指定したデータベースオブジェクトに関連付けることができます。
ラベルプロバイダは、<function>register_label_provider</function>関数を使用して自身を登録する、ロード可能なモジュールです。␞␞  </para>␞
␝    <para>␟      <function>register_label_provider</function> is not an SQL function; it can
      only be called from C code loaded into the backend.␟<function>register_label_provider</function>はSQL関数ではありません。
バックエンドにロードされたCコードからのみ呼び出すことができます。␞␞    </para>␞
␝  <para>␟   The label provider determines whether a given label is valid and whether
   it is permissible to assign that label to a given object.  The meaning of a
   given label is likewise at the discretion of the label provider.
   <productname>PostgreSQL</productname> places no restrictions on whether or how a
   label provider must interpret security labels; it merely provides a
   mechanism for storing them.  In practice, this facility is intended to allow
   integration with label-based mandatory access control (MAC) systems such as
   <productname>SELinux</productname>.  Such systems make all access control decisions
   based on object labels, rather than traditional discretionary access control
   (DAC) concepts such as users and groups.␟ラベルプロバイダは、指定されたラベルが有効かどうか、および指定されたオブジェクトにラベルを割り当てることが許されているかどうかを決定します。
また、ラベルプロバイダは指定されたラベルの意味の決定権を持ちます。
<productname>PostgreSQL</productname>は、ラベルプロバイダがセキュリティラベルを解釈するかしないか、どのように解釈するかに関して制限を持ちません。
単にこれらを格納するための機構を提供するだけです。
実際には、この機能は<productname>SELinux</productname>などのラベルベースの強制アクセス制御（MAC）システムと統合できるようにすることを意図したものです。
こうしたシステムでは、すべてのアクセス制御の決定は、ユーザとグループなどの伝統的な任意アクセス制御（DAC）という考えではなく、オブジェクトラベルに基づいて行われます。␞␞  </para>␞
␝  <para>␟   You must own the database object to use <command>SECURITY LABEL</command>.␟<command>SECURITY LABEL</command>を使用するには、データベースオブジェクトを所有していなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of the object to be labeled.  Names of objects that reside in
      schemas (tables, functions, etc.) can be schema-qualified.␟ラベル付けされるオブジェクトの名前です。
スキーマの中にあるオブジェクト(テーブル、関数など)の名前はスキーマ修飾可能です。␞␞     </para>␞
␝     <para>␟      The name of the provider with which this label is to be associated.  The
      named provider must be loaded and must consent to the proposed labeling
      operation.  If exactly one provider is loaded, the provider name may be
      omitted for brevity.␟このラベルが関連するプロバイダの名前です。
指定されたプロバイダはロードされていなければならず、かつ、提供されるラベル付け操作と一致しなければなりません。
プロバイダが１つだけロードされていた場合、プロバイダの名前を省略して簡略化することができます。␞␞     </para>␞
␝     <para>␟      The mode of a function, procedure, or aggregate
      argument: <literal>IN</literal>, <literal>OUT</literal>,
      <literal>INOUT</literal>, or <literal>VARIADIC</literal>.
      If omitted, the default is <literal>IN</literal>.
      Note that <command>SECURITY LABEL</command> does not actually
      pay any attention to <literal>OUT</literal> arguments, since only the input
      arguments are needed to determine the function's identity.
      So it is sufficient to list the <literal>IN</literal>, <literal>INOUT</literal>,
      and <literal>VARIADIC</literal> arguments.␟関数、プロシージャ、または集約の引数のモードです。
<literal>IN</literal>、<literal>OUT</literal>、<literal>INOUT</literal>、<literal>VARIADIC</literal>のいずれかです。
省略された場合のデフォルトは<literal>IN</literal>です。
関数の識別を決定するためには入力引数のみが必要ですので、実際には<command>SECURITY LABEL</command>は<literal>OUT</literal>をまったく考慮しないことに注意してください。
このため<literal>IN</literal>、<literal>INOUT</literal>、<literal>VARIADIC</literal>のリストで十分です。␞␞     </para>␞
␝     <para>␟      The name of a function, procedure, or aggregate argument.
      Note that <command>SECURITY LABEL</command> does not actually
      pay any attention to argument names, since only the argument data
      types are needed to determine the function's identity.␟関数、プロシージャ、または集約の引数の名前です。
関数の識別を決定するためには引数のデータ型のみが必要ですので、実際には<command>SECURITY LABEL ON FUNCTION</command>は引数名をまったく考慮しないことに注意してください。␞␞     </para>␞
␝     <para>␟      The data type of a function, procedure, or aggregate argument.␟関数、プロシージャ、または集約の引数のデータ型です。␞␞     </para>␞
␝     <para>␟      The OID of the large object.␟ラージオブジェクトのOIDです。␞␞     </para>␞
␝      <para>␟       This is a noise word.␟これは意味がない単語です。␞␞      </para>␞
␝     <para>␟      The new setting of the security label, written as a string literal.␟文字列リテラルで記述されたセキュリティラベルの新しい設定です。␞␞     </para>␞
␝     <para>␟      Write <literal>NULL</literal> to drop the security label.␟セキュリティラベルを削除するためには<literal>NULL</literal>と記述します。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   The following example shows how the security label of a table could
   be set or changed:␟以下の例はテーブルのセキュリティラベルを設定または変更する方法を示しています。␞␞␞
␝␟   To remove the label:␟ラベルを削除するには以下のようにします。␞␞␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞  <para>␞
␝  <para>␟   There is no <command>SECURITY LABEL</command> command in the SQL standard.␟標準SQLには<command>SECURITY LABEL</command>コマンドはありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞  <simplelist type="inline">␞
