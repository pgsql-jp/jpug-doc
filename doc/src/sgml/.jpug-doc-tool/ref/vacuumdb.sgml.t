␝  <manvolnum>1</manvolnum>␟  <refmiscinfo>Application</refmiscinfo>␟  <refmiscinfo>アプリケーション</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>vacuumdb</refname>␟  <refpurpose>garbage-collect and analyze a <productname>PostgreSQL</productname> database</refpurpose>␟<refpurpose><productname>PostgreSQL</productname>データベースの不要領域の回収と解析を行う</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <application>vacuumdb</application> is a utility for cleaning a
   <productname>PostgreSQL</productname> database.
   <application>vacuumdb</application> will also generate internal statistics
   used by the <productname>PostgreSQL</productname> query optimizer.␟<application>vacuumdb</application>は、<productname>PostgreSQL</productname>データベースの不要領域のクリーンアップを行うユーティリティです。
また、<application>vacuumdb</application>は<productname>PostgreSQL</productname>の問い合わせオプティマイザが使用する内部的な統計情報も生成します。␞␞  </para>␞
␝  <para>␟   <application>vacuumdb</application> is a wrapper around the SQL
   command <link linkend="sql-vacuum"><command>VACUUM</command></link>.
   There is no effective difference between vacuuming and analyzing
   databases via this utility and via other methods for accessing the
   server.␟<application>vacuumdb</application>は、SQLコマンド<link linkend="sql-vacuum"><command>VACUUM</command></link>のラッパーです。
このユーティリティを使っても、これ以外の方法でサーバにアクセスしてバキュームや解析を行っても特に違いは生じません。␞␞  </para>␞
␝ <refsect1>␟  <title>Options</title>␟  <title>オプション</title>␞␞␞
␝   <para>␟    <application>vacuumdb</application> accepts the following command-line arguments:␟    <application>vacuumdb</application>では、下記のコマンドライン引数を指定できます。␞␞    <variablelist>␞
␝       <para>␟        Vacuum all databases.␟        全てのデータベースに対してバキュームを行います。␞␞       </para>␞
␝       <para>␟        Specifies the
        <glossterm linkend="glossary-buffer-access-strategy">Buffer Access Strategy</glossterm>
        ring buffer size for a given invocation of <application>vacuumdb</application>.
        This size is used to calculate the number of shared buffers which will
        be reused as part of this strategy.  See <xref linkend="sql-vacuum"/>.␟<application>vacuumdb</application>の指定された呼び出しに対して<glossterm linkend="glossary-buffer-access-strategy">バッファアクセスストラテジ</glossterm>リングバッファサイズを指定します。
このサイズは、このストラテジのパートとして再利用される共有バッファの数を計算するために使用されます。
<xref linkend="sql-vacuum"/>を参照してください。␞␞       </para>␞
␝       <para>␟        Specifies the name of the database to be cleaned or analyzed,
        when <option>-a</option>/<option>--all</option> is not used.
        If this is not specified, the database name is read
        from the environment variable <envar>PGDATABASE</envar>.  If
        that is not set, the user name specified for the connection is
        used.  The <replaceable>dbname</replaceable> can be a <link
        linkend="libpq-connstring">connection string</link>.  If so,
        connection string parameters will override any conflicting command
        line options.␟<option>-a</option>（または<option>--all</option>）も指定されていない場合、不要領域のクリーンアップ、または、解析を行うデータベース名を指定します。
データベース名が指定されていない場合は、データベース名は環境変数<envar>PGDATABASE</envar>から読み取られます。
この変数も設定されていない場合は、接続時に指定したユーザ名が使用されます。
<replaceable>dbname</replaceable>は<link linkend="libpq-connstring">接続文字列</link>に出来ます。その場合、接続文字列パラメータは競合するコマンドラインオプションを上書きします。␞␞       </para>␞
␝       <para>␟        Disable skipping pages based on the contents of the visibility map.␟可視性マップの内容に基づいてページを飛ばすことのないようにします。␞␞       </para>␞
␝       <para>␟        Echo the commands that <application>vacuumdb</application> generates
        and sends to the server.␟<application>vacuumdb</application>が生成し、サーバに送るコマンドをエコー表示します。␞␞       </para>␞
␝       <para>␟        Perform <quote>full</quote> vacuuming.␟<quote>完全な（full）</quote>クリーンアップを行います。␞␞       </para>␞
␝       <para>␟        Aggressively <quote>freeze</quote> tuples.␟積極的にタプルを<quote>凍結</quote>します。␞␞       </para>␞
␝       <para>␟        Always remove index entries pointing to dead tuples.␟無効なタプルを指しているインデックスエントリを常に削除します。␞␞       </para>␞
␝       <para>␟        Execute the vacuum or analyze commands in parallel by running
        <replaceable class="parameter">njobs</replaceable>
        commands simultaneously.  This option may reduce the processing time
        but it also increases the load on the database server.␟<replaceable class="parameter">njobs</replaceable>個のコマンドを同時に実行することで、vacuumまたはanalyzeコマンドを並列で実行します。このオプションは処理時間を短縮することもありますがデータベースサーバの負荷も増加します。␞␞       </para>␞
␝       <para>␟        <application>vacuumdb</application> will open
        <replaceable class="parameter">njobs</replaceable> connections to the
        database, so make sure your <xref linkend="guc-max-connections"/>
        setting is high enough to accommodate all connections.␟<application>vacuumdb</application>はデータベースに対する<replaceable class="parameter">njobs</replaceable>個の接続を開くので、<xref linkend="guc-max-connections"/>の設定が、これらの接続を許容するだけ十分に大きくしてください。␞␞       </para>␞
␝       <para>␟        Note that using this mode together with the <option>-f</option>
        (<literal>FULL</literal>) option might cause deadlock failures if
        certain system catalogs are processed in parallel.␟このモードを<option>-f</option>（<literal>FULL</literal>）オプションと一緒に使うと、一部のシステムカタログが並列処理されてデッドロックのエラーを起こす場合があることに注意してください。␞␞       </para>␞
␝       <para>␟        Only execute the vacuum or analyze commands on tables with a multixact
        ID age of at least <replaceable class="parameter">mxid_age</replaceable>.
        This setting is useful for prioritizing tables to process to prevent
        multixact ID wraparound (see
        <xref linkend="vacuum-for-multixact-wraparound"/>).␟マルチトランザクションIDの年代が少なくとも<replaceable class="parameter">mxid_age</replaceable>であるテーブルに対してのみ、バキュームもしくは解析コマンドを実行します。
この設定は、マルチトランザクションIDの周回を防ぐためテーブルに優先順位を付けて処理するのに有用です(<xref linkend="vacuum-for-multixact-wraparound"/>を参照してください)。␞␞       </para>␞
␝       <para>␟        For the purposes of this option, the multixact ID age of a relation is
        the greatest of the ages of the main relation and its associated
        <acronym>TOAST</acronym> table, if one exists.  Since the commands
        issued by <application>vacuumdb</application> will also process the
        <acronym>TOAST</acronym> table for the relation if necessary, it does
        not need to be considered separately.␟このオプションの目的のため、リレーションのマルチトランザクションIDの年代は、主であるリレーションの年代と、存在するなら、関連する<acronym>TOAST</acronym>テーブルの年代のうち最大のものです。
<application>vacuumdb</application>により発行されたコマンドも、必要であればリレーションの<acronym>TOAST</acronym>テーブルを処理しますので、別々に分けて考える必要はないです。␞␞       </para>␞
␝       <para>␟        Only execute the vacuum or analyze commands on tables with a
        transaction ID age of at least
        <replaceable class="parameter">xid_age</replaceable>.  This setting
        is useful for prioritizing tables to process to prevent transaction
        ID wraparound (see <xref linkend="vacuum-for-wraparound"/>).␟トランザクションIDの年代が少なくとも<replaceable class="parameter">xid_age</replaceable>であるテーブルに対してのみ、バキュームもしくは解析コマンドを実行します。
この設定は、トランザクションIDの周回を防ぐためテーブルに優先順位を付けて処理するのに有用です(<xref linkend="vacuum-for-wraparound"/>を参照してください)。␞␞       </para>␞
␝       <para>␟        For the purposes of this option, the transaction ID age of a relation
        is the greatest of the ages of the main relation and its associated
        <acronym>TOAST</acronym> table, if one exists.  Since the commands
        issued by <application>vacuumdb</application> will also process the
        <acronym>TOAST</acronym> table for the relation if necessary, it does
        not need to be considered separately.␟このオプションの目的のため、リレーションのトランザクションIDの年代は、主であるリレーションの年代と、存在するなら、関連する<acronym>TOAST</acronym>テーブルの年代のうち最大のものです。
<application>vacuumdb</application>により発行されたコマンドも、必要であればリレーションの<acronym>TOAST</acronym>テーブルを処理しますので、別々に分けて考える必要はないです。␞␞       </para>␞
␝       <para>␟        Clean or analyze all tables in
        <replaceable class="parameter">schema</replaceable> only.  Multiple
        schemas can be vacuumed by writing multiple <option>-n</option> switches.␟<replaceable class="parameter">schema</replaceable>内のすべてのテーブルのみをクリーンアップまたは解析します。
<option>-n</option>スイッチを複数記述することで複数のスキーマをバキュームできます。␞␞       </para>␞
␝       <para>␟        Do not clean or analyze any tables in
        <replaceable class="parameter">schema</replaceable>.  Multiple schemas
        can be excluded by writing multiple <option>-N</option> switches.␟<replaceable class="parameter">schema</replaceable>内のテーブルをクリーンアップまたは解析しません。
<option>-N</option>スイッチを複数記述することで複数のスキーマを除外できます。␞␞       </para>␞
␝       <para>␟        Do not remove index entries pointing to dead tuples.␟無効なタプルを指しているインデックスエントリを削除しません。␞␞       </para>␞
␝       <para>␟        Skip the main relation.␟主リレーションをスキップします。␞␞       </para>␞
␝       <para>␟        Skip the TOAST table associated with the table to vacuum, if any.␟もし存在するなら、バキュームするテーブルに関連するTOASTテーブルをスキップします。␞␞       </para>␞
␝       <para>␟        Do not truncate empty pages at the end of the table.␟テーブルの終わりにある空のページを切り詰めません。␞␞       </para>␞
␝       <para>␟        Specify the number of parallel workers for <firstterm>parallel vacuum</firstterm>.
        This allows the vacuum to leverage multiple CPUs to process indexes.
        See <xref linkend="sql-vacuum"/>.␟<firstterm>並列バキューム</firstterm>のためのパラレルワーカーの数を指定します。
これによりバキュームが複数CPUを活用してインデックスを処理できます。
<xref linkend="sql-vacuum"/>を参照してください。␞␞       </para>␞
␝       <para>␟        Do not display progress messages.␟進行メッセージを表示しません。␞␞       </para>␞
␝       <para>␟        Skip relations that cannot be immediately locked for processing.␟処理のためにすぐにロックできないリレーションをスキップします。␞␞       </para>␞
␝       <para>␟        Clean or analyze <replaceable class="parameter">table</replaceable> only.
        Column names can be specified only in conjunction with
        the <option>--analyze</option> or <option>--analyze-only</option> options.
        Multiple tables can be vacuumed by writing multiple
        <option>-t</option> switches.␟<replaceable class="parameter">table</replaceable>のみをクリーンアップ/解析します。
列名は<option>--analyze</option>や<option>--analyze-only</option>オプションがある場合にのみ設定できます。
複数の<option>-t</option>スイッチを記述することで複数のテーブルをバキュームすることができます。␞␞       </para>␞
␝        <para>␟         If you specify columns, you probably have to escape the parentheses
         from the shell.  (See examples below.)␟列を指定する場合は、シェルから括弧をエスケープする必要があるでしょう。
（後述の例を参照してください。）␞␞        </para>␞
␝       <para>␟        Print detailed information during processing.␟処理中に詳細な情報を表示します。␞␞       </para>␞
␝       <para>␟       Print the <application>vacuumdb</application> version and exit.␟<application>vacuumdb</application>のバージョンを表示し、終了します。␞␞       </para>␞
␝       <para>␟        Also calculate statistics for use by the optimizer.␟オプティマイザが使用する、データベースの統計情報も算出します。␞␞       </para>␞
␝       <para>␟        Only calculate statistics for use by the optimizer (no vacuum).␟オプティマイザにより使用される統計情報の計算のみを行います（バキュームを行いません）。␞␞       </para>␞
␝       <para>␟        Only calculate statistics for use by the optimizer (no vacuum),
        like <option>--analyze-only</option>.  Run three
        stages of analyze; the first stage uses the lowest possible statistics
        target (see <xref linkend="guc-default-statistics-target"/>)
        to produce usable statistics faster, and subsequent stages build the
        full statistics.␟<option>--analyze-only</option>と同様、オプティマイザにより使用される統計情報の計算のみを行います（バキュームを行いません）。
分析の3つの段階を実行します。
最初の段階では、使用可能な統計情報をより迅速に生成するために最小の統計情報目標値(<xref linkend="guc-default-statistics-target"/>を参照)を使い、後続のステージでは完全な統計情報を構築します。␞␞       </para>␞
␝       <para>␟        This option is only useful to analyze a database that currently has
        no statistics or has wholly incorrect ones, such as if it is newly
        populated from a restored dump or by <command>pg_upgrade</command>.
        Be aware that running with this option in a database with existing
        statistics may cause the query optimizer choices to become
        transiently worse due to the low statistics targets of the early
        stages.␟このオプションは、統計情報を現在持たないデータベースや、完全に誤った統計情報を持つデータベースを解析する場合にのみ有用です。
例えば、リストアされたダンプや<command>pg_upgrade</command>によって新たにデータが生成された場合などです。
統計情報が既にあるデータベースに対してこのオプションで実行すると、初期段階の統計情報目標値が低いため、問い合わせオプティマイザの選択が一時的に悪化する可能性があることに注意してください。␞␞       </para>␞
␝       <para>␟       Show help about <application>vacuumdb</application> command line
       arguments, and exit.␟<application>vacuumdb</application>のコマンドライン引数の使用方法を表示し、終了します。␞␞       </para>␞
␝   <para>␟    <application>vacuumdb</application> also accepts
    the following command-line arguments for connection parameters:␟<application>vacuumdb</application>には、以下に記す接続パラメータ用のコマンドライン引数も指定することもできます。␞␞    <variablelist>␞
␝       <para>␟        Specifies the host name of the machine on which the server
        is running.  If the value begins with a slash, it is used
        as the directory for the Unix domain socket.␟サーバが稼働しているマシンのホスト名を指定します。
ホスト名がスラッシュから始まる場合、Unixドメインソケット用のディレクトリとして使用されます。␞␞       </para>␞
␝       <para>␟        Specifies the TCP port or local Unix domain socket file
        extension on which the server
        is listening for connections.␟サーバが接続を監視するTCPポートもしくはUnixドメインソケットファイルの拡張子を指定します。␞␞       </para>␞
␝       <para>␟        User name to connect as.␟接続するユーザ名を指定します。␞␞       </para>␞
␝       <para>␟        Never issue a password prompt.  If the server requires
        password authentication and a password is not available by
        other means such as a <filename>.pgpass</filename> file, the
        connection attempt will fail.  This option can be useful in
        batch jobs and scripts where no user is present to enter a
        password.␟パスワードの入力を促しません。
サーバがパスワード認証を必要とし、かつ、<filename>.pgpass</filename>ファイルなどの他の方法が利用できない場合、接続試行は失敗します。
バッチジョブやスクリプトなどパスワードを入力するユーザが存在しない場合にこのオプションは有用かもしれません。␞␞       </para>␞
␝       <para>␟        Force <application>vacuumdb</application> to prompt for a
        password before connecting to a database.␟データベースに接続する前に、<application>vacuumdb</application>は強制的にパスワード入力を促します。␞␞       </para>␞
␝       <para>␟        This option is never essential, since
        <application>vacuumdb</application> will automatically prompt
        for a password if the server demands password authentication.
        However, <application>vacuumdb</application> will waste a
        connection attempt finding out that the server wants a password.
        In some cases it is worth typing <option>-W</option> to avoid the extra
        connection attempt.␟サーバがパスワード認証を要求する場合<application>vacuumdb</application>は自動的にパスワード入力を促しますので、これが重要になることはありません。
しかし、<application>vacuumdb</application>は、サーバにパスワードが必要かどうかを判断するための接続試行を無駄に行います。
こうした余計な接続試行を防ぐために<option>-W</option>の入力が有意となる場合もあります。␞␞       </para>␞
␝        When the <option>-a</option>/<option>--all</option> is used, connect␟        When the <option>-a</option>/<option>--all</option> is used, connect
        to this database to gather the list of databases to vacuum.
        If not specified, the <literal>postgres</literal> database will be used,
        or if that does not exist, <literal>template1</literal> will be used.
        This can be a <link linkend="libpq-connstring">connection
        string</link>.  If so, connection string parameters will override any
        conflicting command line options.  Also, connection string parameters
        other than the database name itself will be re-used when connecting
        to other databases.␟<option>-a</option>/<option>--all</option>が使われている場合に、バキュームするデータベースの一覧を集めるため、このデータベースに接続します。
データベース名が指定されていなければ<literal>postgres</literal>データベースが使用され、もし存在しなければ<literal>template1</literal>が使用されます。
これは<link linkend="libpq-connstring">接続文字列</link>に出来ます。
その場合、接続文字列パラメータは競合するコマンドラインオプションを上書きします。
また、データベース名以外の接続文字列パラメータは他のデータベースに接続する時に再利用されます。␞␞       </para>␞
␝ <refsect1>␟  <title>Environment</title>␟  <title>環境</title>␞␞␞
␝     <para>␟      Default connection parameters␟デフォルトの接続パラメータです。␞␞     </para>␞
␝     <para>␟      Specifies whether to use color in diagnostic messages. Possible values
      are <literal>always</literal>, <literal>auto</literal> and
      <literal>never</literal>.␟診断メッセージで色を使うかどうかを指定します。
指定可能な値は<literal>always</literal>、<literal>auto</literal>、<literal>never</literal>です。␞␞     </para>␞
␝  <para>␟   This utility, like most other <productname>PostgreSQL</productname> utilities,
   also uses the environment variables supported by <application>libpq</application>
   (see <xref linkend="libpq-envars"/>).␟このユーティリティは、他のほとんどの<productname>PostgreSQL</productname>ユーティリティと同様、<application>libpq</application>がサポートする環境変数(<xref linkend="libpq-envars"/>参照)も使います。␞␞  </para>␞
␝ <refsect1>␟  <title>Diagnostics</title>␟  <title>診断</title>␞␞␞
␝  <para>␟   In case of difficulty, see <xref linkend="sql-vacuum"/>
   and <xref linkend="app-psql"/> for
   discussions of potential problems and error messages.
   The database server must be running at the
   targeted host.  Also, any default connection settings and environment
   variables used by the <application>libpq</application> front-end
   library will apply.␟問題が発生した場合、考えられる原因とエラーメッセージについての説明は<xref linkend="sql-vacuum"/>と<xref linkend="app-psql"/>を参照してください。
データベースサーバは、指定したホストで稼働している必要があります。
また、<application>libpq</application>フロントエンドライブラリのデフォルトの設定や環境変数が適用されることに注意してください。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝   <para>␟    To clean the database <literal>test</literal>:␟<literal>test</literal>というデータベースをクリーンアップするには、下記のコマンドを実行します。␞␞<screen>␞
␝   <para>␟    To clean and analyze for the optimizer a database named
    <literal>bigdb</literal>:␟<literal>bigdb</literal>という名前のデータベースのクリーンアップとオプティマイザ用の解析を行う場合には、下記のコマンドを実行します。␞␞<screen>␞
␝   <para>␟    To clean a single table
    <literal>foo</literal> in a database named
    <literal>xyzzy</literal>, and analyze a single column
    <literal>bar</literal> of the table for the optimizer:␟<literal>xyzzy</literal>という名前のデータベースの<literal>foo</literal>という1つのテーブルだけのクリーンアップと、そのテーブルの<literal>bar</literal>という1つの列にだけ対してオプティマイザ用の解析を行う場合には、下記のコマンドを実行します。␞␞<screen>␞
␝   <para>␟    To clean all tables in the <literal>foo</literal> and <literal>bar</literal> schemas
    in a database named <literal>xyzzy</literal>:␟<literal>xyzzy</literal>という名前のデータベースの<literal>foo</literal>スキーマと<literal>bar</literal>スキーマのすべてのテーブルをクリーンアップする場合には、下記のコマンドを実行します。␞␞<screen>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟<prompt>$ </prompt><userinput>vacuumdb --analyze --verbose --table='foo(bar)' xyzzy</userinput> </screen></para> </screen></para>␟no translation␞␞␞
␝␟<prompt>$ </prompt><userinput>vacuumdb --schema='foo' --schema='bar' xyzzy</userinput> </screen></para> </screen></para>␟no translation␞␞␞
