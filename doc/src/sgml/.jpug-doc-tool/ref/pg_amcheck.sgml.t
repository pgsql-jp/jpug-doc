␝  <refname>pg_amcheck</refname>␟  <refpurpose>checks for corruption in one or more
  <productname>PostgreSQL</productname> databases</refpurpose>␟  <refpurpose>一つ以上の<productname>PostgreSQL</productname>データベースに破損がないかどうかを検査する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <application>pg_amcheck</application> supports running
   <xref linkend="amcheck"/>'s corruption checking functions against one or
   more databases, with options to select which schemas, tables and indexes to
   check, which kinds of checking to perform, and whether to perform the checks
   in parallel, and if so, the number of parallel connections to establish and
   use.␟<application>pg_amcheck</application>は、一つ以上のデータベースに対して、どのスキーマ、テーブル、インデックスを検査すべきか、どの種類の検査を実行するか、検査を並列に行うかどうか、並列に行うなら並列接続をいくつ確立するかを指定して<xref linkend="amcheck"/>の破損検査関数を実行します。␞␞  </para>␞
␝  <para>␟   Only ordinary and toast table relations, materialized views, sequences, and
   btree indexes are currently supported.  Other relation types are silently
   skipped.␟通常のテーブルリレーションとTOASTテーブルリレーション、マテリアライズドビュー、シーケンスとBツリーインデックスのみが今のところサポートされています。
他のリレーションタイプは暗黙のうちにスキップされます。␞␞  </para>␞
␝  <para>␟   If <literal>dbname</literal> is specified, it should be the name of a
   single database to check, and no other database selection options should
   be present. Otherwise, if any database selection options are present,
   all matching databases will be checked. If no such options are present,
   the default database will be checked. Database selection options include
   <option>--all</option>, <option>--database</option> and
   <option>--exclude-database</option>. They also include
   <option>--relation</option>, <option>--exclude-relation</option>,
   <option>--table</option>, <option>--exclude-table</option>,
   <option>--index</option>, and <option>--exclude-index</option>,
   but only when such options are used with a three-part pattern
   (e.g. <option>mydb*.myschema*.myrel*</option>).  Finally, they include
   <option>--schema</option> and <option>--exclude-schema</option>
   when such options are used with a two-part pattern
   (e.g. <option>mydb*.myschema*</option>).␟<literal>dbname</literal>を指定するときは、検査すべき単一のデータベース名であるべきで、他のデータベースを選択するオプションは指定すべきではありません。
そうではなくてデータベースの選択オプションが指定されていると、一致するデータベースがすべて検査されます。
オプションを指定しない場合は、デフォルトのデータベースが検査されます。
データベース選択オプションには次のものが含まれます。
<option>--all</option>、<option>--database</option>、<option>--exclude-database</option>。
また、次のオプションも含まれます。
<option>--relation</option>、<option>--exclude-relation</option>、<option>--table</option>、<option>--exclude-table</option>、<option>--index</option>、<option>--exclude-index</option>。
しかし、これらのオプションは、3つの部分からなるパターン（つまり<option>mydb*.myschema*.myrel*</option>）を指定したときにのみ使用できます。
最後に、2つの部分からなるパターン（つまり<option>mydb*.myschema*</option>）を指定した時に使用できる<option>--schema</option>と<option>--exclude-schema</option>があります。␞␞  </para>␞
␝  <para>␟   <replaceable>dbname</replaceable> can also be a
   <link linkend="libpq-connstring">connection string</link>.␟<replaceable>dbname</replaceable>は、<link linkend="libpq-connstring">接続文字列</link>でも構いません。␞␞  </para>␞
␝ <refsect1>␟  <title>Options</title>␟  <title>オプション</title>␞␞␞
␝  <para>␟   The following command-line options control what is checked:␟以下のコマンドラインオプションは、何を検査するかを制御します。␞␞␞
␝      <para>␟       Check all databases, except for any excluded via
       <option>--exclude-database</option>.␟<option>--exclude-database</option>で除外したものを除くすべてのデータベースを検査します。␞␞      </para>␞
␝      <para>␟       Check databases matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>,
       except for any excluded by <option>--exclude-database</option>.
       This option can be specified more than once.␟<option>--exclude-database</option>で除外したものを除き、指定した<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするデータベースを検査します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝      <para>␟       Exclude databases matching the given
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>.
       This option can be specified more than once.␟与えられた<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするデータベースを除外します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝      <para>␟       Check indexes matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>,
       unless they are otherwise excluded.
       This option can be specified more than once.␟除外されていない限り、指定した<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするインデックスを検査します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝       This is similar to the <option>--relation</option> option, except that␟       This is similar to the <option>--relation</option> option, except that
       it applies only to indexes, not to other relation types.␟これは、インデックスにのみ適用され、他のリレーションタイプには適用されないことを除いて<option>--relation</option>オプションに類似しています。␞␞      </para>␞
␝      <para>␟       Exclude indexes matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>.
       This option can be specified more than once.␟与えられた<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするインデックスを除外します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝       This is similar to the <option>--exclude-relation</option> option,␟       This is similar to the <option>--exclude-relation</option> option,
       except that it applies only to indexes, not other relation types.␟これは、インデックスにのみ適用され、他のリレーションタイプには適用されないことを除いて<option>--exclude-relation</option>オプションに類似しています。␞␞      </para>␞
␝      <para>␟       Check relations matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>,
       unless they are otherwise excluded.
       This option can be specified more than once.␟除外されていない限り、<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするリレーションを検査します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝      <para>␟       Patterns may be unqualified, e.g. <literal>myrel*</literal>, or they
       may be schema-qualified, e.g. <literal>myschema*.myrel*</literal> or
       database-qualified and schema-qualified, e.g.
       <literal>mydb*.myschema*.myrel*</literal>. A database-qualified
       pattern will add matching databases to the list of databases to be
       checked.␟パターンはたとえば<literal>myrel*</literal>のように修飾されていなくても、<literal>myschema*.myrel*</literal>のようにスキーマ修飾されていても、<literal>mydb*.myschema*.myrel*</literal>のようにデータベース及びスキーマ修飾されていても構いません。
データベース修飾パターンは、マッチするデータベースを検査対象のデータベースのリストに追加します。␞␞      </para>␞
␝      <para>␟       Exclude relations matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>.
       This option can be specified more than once.␟指定された<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするリレーションを除外します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝       As with <option>--relation</option>, the␟       As with <option>--relation</option>, the
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link> may be unqualified, schema-qualified,
       or database- and schema-qualified.␟<option>--relation</option>におけるのと同様、<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>は修飾なし、スキーマ修飾、スキーマとデータベース修飾のどれでも構いません。␞␞      </para>␞
␝      <para>␟       Check tables and indexes in schemas matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>, unless they are otherwise excluded.
       This option can be specified more than once.␟除外されていない限り、指定した<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするスキーマ内のテーブルとインデックスを検査します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝      <para>␟       To select only tables in schemas matching a particular pattern,
       consider using something like
       <literal>--table=SCHEMAPAT.* --no-dependent-indexes</literal>.
       To select only indexes, consider using something like
       <literal>--index=SCHEMAPAT.*</literal>.␟特定のパターンにマッチするスキーマ内のテーブルだけを選択するには、<literal>--table=SCHEMAPAT.* --no-dependent-indexes</literal>のような使い方を考慮してください。
インデックスのみを選択するには、<literal>--index=SCHEMAPAT.*</literal>のような使い方を考慮してください。␞␞      </para>␞
␝      <para>␟       A schema pattern may be database-qualified. For example, you may
       write <literal>--schema=mydb*.myschema*</literal> to select
       schemas matching <literal>myschema*</literal> in databases matching
       <literal>mydb*</literal>.␟スキーマパターンはデータベース修飾でも構いません。
たとえば、<literal>mydb*</literal>にマッチするデータベース内の<literal>myschema*</literal>にマッチするスキーマを選択するには、<literal>--schema=mydb*.myschema*</literal>のように書くことができます。␞␞      </para>␞
␝      <para>␟       Exclude tables and indexes in schemas matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>.
       This option can be specified more than once.␟指定した<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするスキーマ内のテーブルとインデックスを除外します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝       As with <option>--schema</option>, the pattern may be␟       As with <option>--schema</option>, the pattern may be
       database-qualified.␟<option>--schema</option>と同様、パターンはデータベース修飾でも構いません。␞␞      </para>␞
␝      <para>␟       Check tables matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>,
       unless they are otherwise excluded.
       This option can be specified more than once.␟除外されていない限り、指定した<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするスキーマ内のテーブルを検査します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝       This is similar to the <option>--relation</option> option, except that␟       This is similar to the <option>--relation</option> option, except that
       it applies only to tables, materialized views, and sequences, not to
       indexes.␟これは、テーブル、マテリアライズドビュー、シーケンスにのみ適用され、インデックスには適用されないことを除いて<option>--relation</option>オプションに類似しています。␞␞      </para>␞
␝      <para>␟       Exclude tables matching the specified
       <link linkend="app-psql-patterns"><replaceable class="parameter">pattern</replaceable></link>.
       This option can be specified more than once.␟指定した<link linkend="app-psql-patterns"><replaceable class="parameter">パターン</replaceable></link>にマッチするテーブルを除外します。
このオプションは2回以上指定できます。␞␞      </para>␞
␝       This is similar to the <option>--exclude-relation</option> option,␟       This is similar to the <option>--exclude-relation</option> option,
       except that it applies only to tables, materialized views, and
       sequences, not to indexes.␟これは、テーブル、マテリアライズドビュー、シーケンスにのみ適用され、インデックスには適用されないことを除いて<option>--exclude-relation</option>オプションに類似しています。␞␞      </para>␞
␝      <para>␟       By default, if a table is checked, any btree indexes of that table
       will also be checked, even if they are not explicitly selected by
       an option such as <literal>--index</literal> or
       <literal>--relation</literal>. This option suppresses that behavior.␟デフォルトでは、<literal>--index</literal>や<literal>--relation</literal>オプションで明示的に選択されていなくても、テーブルが検査される際にそのテーブルのBツリーインデックスも検査されます。
このオプションはこの振る舞いを抑止します。␞␞      </para>␞
␝      <para>␟       By default, if a table is checked, its toast table, if any, will also
       be checked, even if it is not explicitly selected by an option
       such as <literal>--table</literal> or <literal>--relation</literal>.
       This option suppresses that behavior.␟デフォルトでは、<literal>--table</literal>や<literal>--relation</literal>オプションで明示的に選択されていなくても、テーブルが検査される際にそのテーブルのTOASTテーブルも検査されます。
このオプションはこの振る舞いを抑止します。␞␞      </para>␞
␝       or <literal>--relation</literal> matches no objects, it is a fatal␟       By default, if an argument to <literal>--database</literal>,
       <literal>--table</literal>, <literal>--index</literal>,
       or <literal>--relation</literal> matches no objects, it is a fatal
       error. This option downgrades that error to a warning.␟デフォルトでは、<literal>--database</literal>、<literal>--table</literal>、<literal>--index</literal>、<literal>--relation</literal>への引数がどのオブジェクトにもマッチしなければ、フェイタルエラーが起こります。
このオプションはそのエラーをワーニングへと格下げします。␞␞      </para>␞
␝  <para>␟   The following command-line options control checking of tables:␟次のコマンドラインオプションはテーブルの検査を制御します。␞␞␞
␝      <para>␟       By default, whenever a toast pointer is encountered in a table,
       a lookup is performed to ensure that it references apparently-valid
       entries in the toast table. These checks can be quite slow, and this
       option can be used to skip them.␟デフォルトでは、テーブル中のTOASTポインタに遭遇すると必ずTOASTテーブル中の明らかに有効なエントリを参照していることを確認するために検索が行われます。
このチェックは非常に遅くなることがあり、このオプションはこれを省略するために使うことができます。␞␞      </para>␞
␝      <para>␟       After reporting all corruptions on the first page of a table where
       corruption is found, stop processing that table relation and move on
       to the next table or index.␟破損が見つかった最初のテーブルのページに関してすべての破損の報告を行った後そのテーブルリレーションの処理を中断し、次のテーブルあるいはインデックスに進みます。␞␞      </para>␞
␝      <para>␟       Note that index checking always stops after the first corrupt page.
       This option only has meaning relative to table relations.␟インデックスの検査は、最初の破損したページの後で常に停止することに留意してください。
このオプションは、テーブルリレーションに関してのみ意味があります。␞␞      </para>␞
␝      <para>␟       If <literal>all-frozen</literal> is given, table corruption checks
       will skip over pages in all tables that are marked as all frozen.␟<literal>all-frozen</literal>が与えられると、テーブル破損検査は、すべて凍結されていると印が付いたすべてのテーブルの中のページをスキップします。␞␞      </para>␞
␝      <para>␟       If <literal>all-visible</literal> is given, table corruption checks
       will skip over pages in all tables that are marked as all visible.␟<literal>all-visible</literal>が与えられると、テーブル破損検査は、すべて可視と印が付いたすべてのテーブルの中のページをスキップします。␞␞      </para>␞
␝      <para>␟       By default, no pages are skipped.  This can be specified as
       <literal>none</literal>, but since this is the default, it need not be
       mentioned.␟デフォルトではページをスキップすることはありません。
<literal>none</literal>と指定することもできますが、これがデフォルトなのでそのように指定する必要はありません。␞␞      </para>␞
␝      <para>␟       Start checking at the specified block number. An error will occur if
       the table relation being checked has fewer than this number of blocks.
       This option does not apply to indexes, and is probably only useful
       when checking a single table relation. See <literal>--endblock</literal>
       for further caveats.␟指定したブロック番号から検査を開始します。
検査しているテーブルリレーションのブロック数がこのブロック数よりも小さければエラーが生じます。
このオプションはインデックスには適用されず、おそらく単一のテーブルリレーションを検査するときにのみ意味があるでしょう。
それ以外の警告については<literal>--endblock</literal>を参照してください。␞␞      </para>␞
␝      <para>␟       End checking at the specified block number.  An error will occur if the
       table relation being checked has fewer than this number of blocks.
       This option does not apply to indexes, and is probably only useful when
       checking a single table relation. If both a regular table and a toast
       table are checked, this option will apply to both, but higher-numbered
       toast blocks may still be accessed while validating toast pointers,
       unless that is suppressed using
       <option>--exclude-toast-pointers</option>.␟指定したブロック番号で検査を終了します。
検査しているテーブルリレーションのブロック数がこのブロック数よりも小さければエラーが生じます。
このオプションはインデックスには適用されず、おそらく単一のテーブルリレーションを検査するときにのみ意味があるでしょう。
通常のテーブルとTOASTテーブルの両方が検査される際にはこのオプションはその両方に適用されますが、<option>--exclude-toast-pointers</option>を使って抑止していない限りTOASTポインタを検証中により大きな番号のTOASTブロックがアクセスされるかも知れません。␞␞      </para>␞
␝  <para>␟   The following command-line options control checking of B-tree indexes:␟以下のコマンドラインオプションはBツリーインデックスの検査を制御します。␞␞␞
␝      <para>␟       For each index with unique constraint checked, verify that no more than
       one among duplicate entries is visible in the index using <xref linkend="amcheck"/>'s
       <option>checkunique</option> option.␟一意性制約を検査するインデックスごとに、<xref linkend="amcheck"/>の<option>checkunique</option>オプションを使って重複エントリのうちインデックスで可視であるのは1つだけであることを検証します。␞␞      </para>␞
␝      <para>␟       For each index checked, verify the presence of all heap tuples as index
       tuples in the index using <xref linkend="amcheck"/>'s
       <option>heapallindexed</option> option.␟検査しているインデックスごとに、<xref linkend="amcheck"/>の<option>heapallindexed</option>オプションを使ってすべてのヒープタプルがインデックス中のインデックスタプルとして存在していることを検証します。␞␞      </para>␞
␝      <para>␟       For each btree index checked, use <xref linkend="amcheck"/>'s
       <function>bt_index_parent_check</function> function, which performs
       additional checks of parent/child relationships during index checking.␟検査しているBツリーインデックスごとに、インデックス検査中に親／子関係の追加の検査を行う<xref linkend="amcheck"/>の<function>bt_index_parent_check</function>関数を使います。␞␞      </para>␞
␝      <para>␟       The default is to use <application>amcheck</application>'s
       <function>bt_index_check</function> function, but note that use of the
       <option>--rootdescend</option> option implicitly selects
       <function>bt_index_parent_check</function>.␟デフォルトでは<application>amcheck</application>の<function>bt_index_check</function>関数を使いますが、<option>--rootdescend</option>オプションを使うと暗黙的に<function>bt_index_parent_check</function>を選択することに注意してください。␞␞      </para>␞
␝      <para>␟       For each index checked, re-find tuples on the leaf level by performing a
       new search from the root page for each tuple using
       <xref linkend="amcheck"/>'s <option>rootdescend</option> option.␟検査しているインデックスごとに、<xref linkend="amcheck"/>の<option>rootdescend</option>オプションを使い、各タプルに関してルートページから新たに検索を実施してリーフレベルのタプルを再発見します。␞␞      </para>␞
␝      <para>␟       Use of this option implicitly also selects the
       <option>--parent-check</option> option.␟このオプションを使うと<option>--parent-check</option>オプションも暗黙的に選択します。␞␞      </para>␞
␝      <para>␟       This form of verification was originally written to help in the
       development of btree index features.  It may be of limited use or even
       of no use in helping detect the kinds of corruption that occur in
       practice.  It may also cause corruption checking to take considerably
       longer and consume considerably more resources on the server.␟この形式の検証は、元々はBツリーインデックスの機能の開発を支援するために作られました。
実際に発生する類の破損を検出するための支援としては限定的、あるいはまったく無用かも知れません。
また、これは破損検査に要する時間がかなり長くなったり、サーバでかなり多くのリソースを消費する原因になるかも知れません。␞␞      </para>␞
␝   <para>␟    The extra checks performed against B-tree indexes when the
    <option>--parent-check</option> option or the
    <option>--rootdescend</option> option is specified require
    relatively strong relation-level locks.  These checks are the only
    checks that will block concurrent data modification from
    <command>INSERT</command>, <command>UPDATE</command>, and
    <command>DELETE</command> commands.␟<option>--parent-check</option>オプション、あるいは<option>--rootdescend</option>オプションが指定された時にBツリーインデックスに対して行われる追加の検査では、比較的強いリレーションレベルのロックが必要です。
この検査だけが、<command>INSERT</command>、<command>UPDATE</command>、<command>DELETE</command>コマンドによる並行するデータ変更をブロックする検査です。␞␞   </para>␞
␝  <para>␟   The following command-line options control the connection to the server:␟以下のコマンドラインオプションは、サーバへの接続を制御します。␞␞␞
␝      <para>␟       Specifies the host name of the machine on which the server is running.
       If the value begins with a slash, it is used as the directory for the
       Unix domain socket.␟サーバが稼働しているマシンのホスト名を指定します。
この値がスラッシュから始まる場合、Unixドメインソケット用のディレクトリとして使用されます。␞␞      </para>␞
␝      <para>␟       Specifies the TCP port or local Unix domain socket file extension on
       which the server is listening for connections.␟サーバが接続を監視するTCPポートもしくはローカルUnixドメインソケットファイルの拡張子を指定します。␞␞      </para>␞
␝      <para>␟       User name to connect as.␟接続するユーザ名です。␞␞      </para>␞
␝      <para>␟       Never issue a password prompt.  If the server requires password
       authentication and a password is not available by other means such as
       a <filename>.pgpass</filename> file, the connection attempt will fail.
       This option can be useful in batch jobs and scripts where no user is
       present to enter a password.␟パスワードの入力を促しません。
サーバがパスワード認証を必要とし、かつ、<filename>.pgpass</filename>ファイルなどの他の方法が利用できない場合、接続試行は失敗します。
バッチジョブやスクリプトなどパスワードを入力するユーザが存在しない場合にこのオプションは有用かもしれません。␞␞      </para>␞
␝      <para>␟       Force <application>pg_amcheck</application> to prompt for a password
       before connecting to a database.␟<application>pg_amcheck</application>がデータベースに接続する前にパスワードのプロンプトを表示することを強制します。␞␞      </para>␞
␝      <para>␟       This option is never essential, since
       <application>pg_amcheck</application> will automatically prompt for a
       password if the server demands password authentication.  However,
       <application>pg_amcheck</application> will waste a connection attempt
       finding out that the server wants a password.  In some cases it is
       worth typing <option>-W</option> to avoid the extra connection attempt.␟サーバがパスワード認証を必要とするときには<application>pg_amcheck</application>はパスワードを自動的に要求するので、このオプションは絶対に必要というものではありません。
しかし、<application>pg_amcheck</application>はサーバがパスワードを必要としているかどうかを確認するために無駄な接続の試みをします。
ある種の状況では余分な接続の試みを避けるために<option>-W</option>をタイプする価値があります。␞␞      </para>␞
␝      <para>␟       Specifies a database or
       <link linkend="libpq-connstring">connection string</link> to be
       used to discover the list of databases to be checked. If neither
       <option>--all</option> nor any option including a database pattern is
       used, no such connection is required and this option does nothing.
       Otherwise, any connection string parameters other than
       the database name which are included in the value for this option
       will also be used when connecting to the databases
       being checked. If this option is omitted, the default is
       <literal>postgres</literal> or, if that fails,
       <literal>template1</literal>.␟データベースあるいは検査対象データベースのリストを発見するために使われる<link linkend="libpq-connstring">接続文字列</link>を指定します。
<option>--all</option>あるいはデータベースパターンを含むオプションが使われていなければ、そうした接続は必要ではなく、このオプションは何もしません。
そうでなければ、このオプションの値に含まれるデータベース名が、検査対象のデータベースに接続する際にも使われます。
このオプションが省略されるとデフォルトは<literal>postgres</literal>、あるいはそれが失敗すれば<literal>template1</literal>となります。␞␞      </para>␞
␝  <para>␟   Other options are also available:␟他のオプションも利用可能です。␞␞␞
␝      <para>␟      Echo to stdout all SQL sent to the server.␟サーバに送られたすべてのSQLを標準出力にそのまま表示します。␞␞      </para>␞
␝      <para>␟       Use <replaceable>num</replaceable> concurrent connections to the server,
       or one per object to be checked, whichever is less.␟サーバへの<replaceable>num</replaceable>並列接続か、検査対象オブジェクト1つにつき1本の接続のどちらか少ない方を使います。␞␞      </para>␞
␝      <para>␟       The default is to use a single connection.␟デフォルトでは単一の接続を使います。␞␞      </para>␞
␝      <para>␟       Show progress information. Progress information includes the number
       of relations for which checking has been completed, and the total
       size of those relations. It also includes the total number of relations
       that will eventually be checked, and the estimated size of those
       relations.␟進捗状況の情報を表示します。
進捗状況情報には、検査が完了したリレーションの数と（検査が完了した）リレーションの合計サイズが含まれます。
最終的に検査されるリレーションの全数と（これら（最終的に検査される）の）リレーションのサイズの見積もりも含まれます。␞␞      </para>␞
␝      <para>␟       Print more messages. In particular, this will print a message for
       each relation being checked, and will increase the level of detail
       shown for server errors.␟より多くのメッセージを表示します。
とりわけ、これは検査している個々のリレーションを表示し、サーバエラーに関しては詳細度のレベルを上げます。␞␞      </para>␞
␝      <para>␟       Print the <application>pg_amcheck</application> version and exit.␟<application>pg_amcheck</application>のバージョンを表示して終了します。␞␞      </para>␞
␝      <para>␟       Install any missing extensions that are required to check the
       database(s).  If not yet installed, each extension's objects will be
       installed into the given
       <replaceable class="parameter">schema</replaceable>, or if not specified
       into schema <literal>pg_catalog</literal>.␟データベースを検査するのに必要な拡張で漏れているものをインストールします。
もしまだインストールされていなければ、各拡張のオブジェクトは与えられた<replaceable class="parameter">schema</replaceable>、あるいは指定されていなければ<literal>pg_catalog</literal>スキーマにインストールされます。␞␞      </para>␞
␝      <para>␟       At present, the only required extension is <xref linkend="amcheck"/>.␟今の所唯一必要な拡張は<xref linkend="amcheck"/>です。␞␞      </para>␞
␝      <para>␟       Show help about <application>pg_amcheck</application> command line
       arguments, and exit.␟<application>pg_amcheck</application>コマンドライン引数に関するヘルプを表示して終了します。␞␞      </para>␞
␝ <refsect1>␟  <title>Environment</title>␟  <title>環境</title>␞␞␞
␝  <para>␟   <command>pg_amcheck</command>, like most other <productname>PostgreSQL</productname>
   utilities,
   also uses the environment variables supported by <application>libpq</application>
   (see <xref linkend="libpq-envars"/>).␟<command>pg_amcheck</command>は、他のほとんどの<productname>PostgreSQL</productname>ユーティリティと同様、<application>libpq</application>がサポートする環境変数（<xref linkend="libpq-envars"/>参照）も使います。␞␞  </para>␞
␝  <para>␟   The environment variable <envar>PG_COLOR</envar> specifies whether to use
   color in diagnostic messages. Possible values are
   <literal>always</literal>, <literal>auto</literal> and
   <literal>never</literal>.␟環境変数<envar>PG_COLOR</envar>は診断メッセージで色を使うかどうかを指定します。
指定可能な値は<literal>always</literal>、<literal>auto</literal>、<literal>never</literal>です。␞␞  </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   <application>pg_amcheck</application> is designed to work with
   <productname>PostgreSQL</productname> 14.0 and later.␟<application>pg_amcheck</application> は<productname>PostgreSQL</productname> 14.0以降で動作するように設計されています。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
