␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>COMMENT</refname>␟  <refpurpose>define or change the comment of an object</refpurpose>␟  <refpurpose>オブジェクトのコメントを定義する、または変更する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable>aggregate_signature</replaceable> is:</phrase>␟<phrase>ここで<replaceable>aggregate_signature</replaceable>は以下の通りです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>COMMENT</command> stores a comment about a database object.␟<command>COMMENT</command>は、データベースオブジェクトに関するコメントを保存します。␞␞  </para>␞
␝  <para>␟   Only one comment string is stored for each object, so to modify a comment,
   issue a new <command>COMMENT</command> command for the same object.  To remove a
   comment, write <literal>NULL</literal> in place of the text string.
   Comments are automatically dropped when their object is dropped.␟各オブジェクトに保存できるコメント文字列は1つだけです。
ですので、コメントを編集するためには、同一オブジェクトに対して新しく<command>COMMENT</command>コマンドを発行してください。
コメントを削除するには、テキスト文字列の部分に<literal>NULL</literal>を記述してください。
オブジェクトが削除された時、コメントは自動的に削除されます。␞␞  </para>␞
␝  <para>␟   A <literal>SHARE UPDATE EXCLUSIVE</literal> lock is acquired on the
   object to be commented.␟コメントを付加するオブジェクトでは、<literal>SHARE UPDATE EXCLUSIVE</literal>ロックが獲得されます。␞␞  </para>␞
␝  <para>␟   For most kinds of object, only the object's owner can set the comment.
   Roles don't have owners, so the rule for <literal>COMMENT ON ROLE</literal> is
   that you must be superuser to comment on a superuser role, or have the
   <literal>CREATEROLE</literal> privilege and have been granted
   <literal>ADMIN OPTION</literal> on the target role.
   Likewise, access methods don't have owners either; you must be superuser
   to comment on an access method.
   Of course, a superuser can comment on anything.␟ほとんどの種類のオブジェクトでは、オブジェクトの所有者のみがコメントを設定できます。
ロールには所有者がありませんので、<literal>COMMENT ON ROLE</literal>における規則は、スーパーユーザロールに対するコメント付けはスーパーユーザでなければならない、または、<literal>CREATEROLE</literal>権限を持ち、対象のロールに対して<literal>ADMIN OPTION</literal>を付与されていなければならないとなります。
同様に、アクセスメソッドには所有者がいないため、アクセスメソッドにコメントをつけるにはスーパーユーザでなければなりません。
当然ながらスーパーユーザは何にでもコメントを付けることができます。␞␞  </para>␞
␝  <para>␟    Comments can be viewed using <application>psql</application>'s
    <command>\d</command> family of commands.
    Other user interfaces to retrieve comments can be built atop
    the same built-in functions that <application>psql</application> uses, namely
    <function>obj_description</function>, <function>col_description</function>,
    and <function>shobj_description</function>
    (see <xref linkend="functions-info-comment-table"/>).␟コメントは、<application>psql</application>の<command>\d</command>系のコマンドで表示できます。
<function>obj_description()</function>、<function>col_description()</function>、<function>shobj_description</function>という名前の、<application>psql</application>が使用する組み込み関数を使うように構築することで、他のユーザインタフェースを使ってコメントを取り出せるようになります
（<xref linkend="functions-info-comment-table"/>を参照してください）。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of the object to be commented.  Names of objects that reside in
      schemas (tables, functions, etc.) can be
      schema-qualified. When commenting on a column,
      <replaceable class="parameter">relation_name</replaceable> must refer
      to a table, view, composite type, or foreign table.␟コメントを付加するオブジェクトの名前です。
スキーマの中にあるオブジェクト(テーブル、関数など)の名前はスキーマ修飾可能です。
列にコメントを付与する場合、<replaceable class="parameter">relation_name</replaceable>はテーブル、ビュー、複合型、外部テーブルを参照するものでなければなりません。␞␞     </para>␞
␝     <para>␟      When creating a comment on a constraint, a trigger, a rule or
      a policy these parameters specify the name of the table or domain on
      which that object is defined.␟制約、トリガ、ルール、ポリシーにコメントを作成する場合、これらのパラメータはオブジェクトが定義されているテーブルまたはドメインの名前を指定します。␞␞     </para>␞
␝      <para>␟       The name of the source data type of the cast.␟キャストの変換元データ型の名前です。␞␞      </para>␞
␝      <para>␟       The name of the target data type of the cast.␟キャストの変換先のデータ型の名前です。␞␞      </para>␞
␝     <para>␟      The mode of a function, procedure, or aggregate
      argument: <literal>IN</literal>, <literal>OUT</literal>,
      <literal>INOUT</literal>, or <literal>VARIADIC</literal>.
      If omitted, the default is <literal>IN</literal>.
      Note that <command>COMMENT</command> does not actually pay
      any attention to <literal>OUT</literal> arguments, since only the input
      arguments are needed to determine the function's identity.
      So it is sufficient to list the <literal>IN</literal>, <literal>INOUT</literal>,
      and <literal>VARIADIC</literal> arguments.␟関数、プロシージャまたは集約の引数のモードで、<literal>IN</literal>、<literal>OUT</literal>、<literal>INOUT</literal>、<literal>VARIADIC</literal>のいずれかです。
省略時のデフォルトは<literal>IN</literal>です。
関数を識別するには入力引数のみが必要ですので、<command>COMMENT</command>が実際には<literal>OUT</literal>引数を無視することに注意してください。
したがって、<literal>IN</literal>、<literal>INOUT</literal>および<literal>VARIADIC</literal>引数を列挙することで十分です。␞␞     </para>␞
␝     <para>␟      The name of a function, procedure, or aggregate argument.
      Note that <command>COMMENT</command> does not actually pay
      any attention to argument names, since only the argument data
      types are needed to determine the function's identity.␟関数、プロシージャまたは集約の引数の名前です。
関数の識別には引数データ型のみが必要ですので、<command>COMMENT</command>が実際には引数の名前を無視することに注意してください。␞␞     </para>␞
␝     <para>␟      The data type of a function, procedure, or aggregate argument.␟関数、プロシージャまたは集約の引数のデータ型です。␞␞     </para>␞
␝     <para>␟      The OID of the large object.␟ラージオブジェクトのOIDです。␞␞     </para>␞
␝     <para>␟      The data type(s) of the operator's arguments (optionally
      schema-qualified).  Write <literal>NONE</literal> for the missing argument
      of a prefix operator.␟演算子の引数のデータ型（スキーマ修飾も可）です。
前置演算子における存在しない引数については<literal>NONE</literal>と記述してください。␞␞     </para>␞
␝      <para>␟       This is a noise word.␟これには意味はありません。␞␞      </para>␞
␝      <para>␟       The name of the data type of the transform.␟変換のデータ型の名前です。␞␞      </para>␞
␝      <para>␟       The name of the language of the transform.␟変換の言語の名前です。␞␞      </para>␞
␝     <para>␟      The new comment contents, written as a string literal.␟新しいコメントの内容です。文字列リテラルとして記述します。␞␞     </para>␞
␝     <para>␟      Write <literal>NULL</literal> to drop the comment.␟コメントを削除するには<literal>NULL</literal>と記述します。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   There is presently no security mechanism for viewing comments: any user
   connected to a database can see all the comments for objects in
   that database.  For shared objects such as
   databases, roles, and tablespaces, comments are stored globally so any
   user connected to any database in the cluster can see all the comments
   for shared objects.  Therefore, don't put security-critical
   information in comments.␟現在、コメントの閲覧に関するセキュリティ機構は存在しません。
データベースに接続したユーザは誰でも、そのデータベース内のオブジェクトのコメントを参照することができます。
データベース、ロール、テーブル空間などの共有オブジェクトに対するコメントは大域的に格納され、クラスタ内の任意のデータベースに接続した任意のユーザが共有オブジェクトに対するコメントをすべて見ることができます。
そのため、コメントにはセキュリティ的に重大な情報を記載してはいけません。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Attach a comment to the table <literal>mytable</literal>:␟テーブル<literal>mytable</literal>にコメントを付けます。␞␞␞
␝␟   Remove it again:␟先ほどのコメントを削除します。␞␞␞
␝  <para>␟   Some more examples:␟その他の例をいくつか示します。␞␞␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>COMMENT</command> command in the SQL standard.␟標準SQLには<command>COMMENT</command>はありません。␞␞  </para>␞
␝␟COMMENT ON ACCESS METHOD gin IS 'GIN index access method'; COMMENT ON AGGREGATE my_aggregate (double precision) IS 'Computes sample variance'; COMMENT ON CAST (text AS int4) IS 'Allow casts from text to int4'; COMMENT ON COLLATION "fr_CA" IS 'Canadian French'; COMMENT ON COLUMN my_table.my_column IS 'Employee ID number'; COMMENT ON CONVERSION my_conv IS 'Conversion to UTF8'; COMMENT ON CONSTRAINT bar_col_cons ON bar IS 'Constrains column col'; COMMENT ON CONSTRAINT dom_col_constr ON DOMAIN dom IS 'Constrains col of domain'; COMMENT ON DATABASE my_database IS 'Development Database'; COMMENT ON DOMAIN my_domain IS 'Email Address Domain'; COMMENT ON EVENT TRIGGER abort_ddl IS 'Aborts all DDL commands'; COMMENT ON EXTENSION hstore IS 'implements the hstore data type'; COMMENT ON FOREIGN DATA WRAPPER mywrapper IS 'my foreign data wrapper'; COMMENT ON FOREIGN TABLE my_foreign_table IS 'Employee Information in other database'; COMMENT ON FUNCTION my_function (timestamp) IS 'Returns Roman Numeral'; COMMENT ON INDEX my_index IS 'Enforces uniqueness on employee ID'; COMMENT ON LANGUAGE plpython IS 'Python support for stored procedures'; COMMENT ON LARGE OBJECT 346344 IS 'Planning document'; COMMENT ON MATERIALIZED VIEW my_matview IS 'Summary of order history'; COMMENT ON OPERATOR ^ (text, text) IS 'Performs intersection of two texts'; COMMENT ON OPERATOR - (NONE, integer) IS 'Unary minus'; COMMENT ON OPERATOR CLASS int4ops USING btree IS '4 byte integer operators for btrees'; COMMENT ON OPERATOR FAMILY integer_ops USING btree IS 'all integer operators for btrees'; COMMENT ON POLICY my_policy ON mytable IS 'Filter rows by users'; COMMENT ON PROCEDURE my_proc (integer, integer) IS 'Runs a report'; COMMENT ON PUBLICATION alltables IS 'Publishes all operations on all tables'; COMMENT ON ROLE my_role IS 'Administration group for finance tables'; COMMENT ON ROUTINE my_routine (integer, integer) IS 'Runs a routine (which is a function or procedure)'; COMMENT ON RULE my_rule ON my_table IS 'Logs updates of employee records'; COMMENT ON SCHEMA my_schema IS 'Departmental data'; COMMENT ON SEQUENCE my_sequence IS 'Used to generate primary keys'; COMMENT ON SERVER myserver IS 'my foreign server'; COMMENT ON STATISTICS my_statistics IS 'Improves planner row estimations'; COMMENT ON SUBSCRIPTION alltables IS 'Subscription for all operations on all tables'; COMMENT ON TABLE my_schema.my_table IS 'Employee Information'; COMMENT ON TABLESPACE my_tablespace IS 'Tablespace for indexes'; COMMENT ON TEXT SEARCH CONFIGURATION my_config IS 'Special word filtering'; COMMENT ON TEXT SEARCH DICTIONARY swedish IS 'Snowball stemmer for Swedish language'; COMMENT ON TEXT SEARCH PARSER my_parser IS 'Splits text into words'; COMMENT ON TEXT SEARCH TEMPLATE snowball IS 'Snowball stemmer'; COMMENT ON TRANSFORM FOR hstore LANGUAGE plpython3u IS 'Transform between hstore and Python dict'; COMMENT ON TRIGGER my_trigger ON my_table IS 'Used for RI'; COMMENT ON TYPE complex IS 'Complex number data type'; COMMENT ON VIEW my_view IS 'View of departmental costs'; </programlisting></para> </programlisting></para>␟no translation␞␞␞
