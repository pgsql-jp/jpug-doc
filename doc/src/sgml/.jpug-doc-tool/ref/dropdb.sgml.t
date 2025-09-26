␝  <manvolnum>1</manvolnum>␟  <refmiscinfo>Application</refmiscinfo>␟<refmiscinfo>アプリケーション</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>dropdb</refname>␟  <refpurpose>remove a <productname>PostgreSQL</productname> database</refpurpose>␟  <refpurpose><productname>PostgreSQL</productname>データベースを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <application>dropdb</application> destroys an existing
   <productname>PostgreSQL</productname> database.
   The user who executes this command must be a database
   superuser or the owner of the database.␟<application>dropdb</application>は既存の<productname>PostgreSQL</productname>データベースを削除します。
このコマンドを実行できるのは、データベースのスーパーユーザまたはデータベースの所有者のみです。␞␞  </para>␞
␝  <para>␟   <application>dropdb</application> is a wrapper around the
   <acronym>SQL</acronym> command <link linkend="sql-dropdatabase"><command>DROP DATABASE</command></link>.
   There is no effective difference between dropping databases via
   this utility and via other methods for accessing the server.␟<application>dropdb</application>は、<acronym>SQL</acronym>コマンド<link linkend="sql-dropdatabase"><command>DROP DATABASE</command></link>のラッパーです。
このユーティリティを使用しても、これ以外の方法でサーバにアクセスして削除しても、特に違いはありません。␞␞  </para>␞
␝ <refsect1>␟  <title>Options</title>␟  <title>オプション</title>␞␞␞
␝  <para>␟   <application>dropdb</application> accepts the following command-line arguments:␟   <application>dropdb</application>は、下記のコマンドライン引数を受け付けます。␞␞␞
␝       <para>␟        Specifies the name of the database to be removed.␟削除するデータベース名を指定します。␞␞       </para>␞
␝       <para>␟        Echo the commands that <application>dropdb</application> generates
        and sends to the server.␟<application>dropdb</application>が生成し、サーバに送信するコマンドをエコー表示します。␞␞       </para>␞
␝       <para>␟        Attempt to terminate all existing connections to the target database
        before dropping it.   See <xref linkend="sql-dropdatabase"/> for more
        information on this option.␟削除の前に対象データベースへの既存の接続をすべて終了することを試みます。
このオプションに関する詳細な情報は<xref linkend="sql-dropdatabase"/>を参照してください。␞␞       </para>␞
␝       <para>␟       Issues a verification prompt before doing anything destructive.␟削除を行う前に、確認のためのプロンプトを表示します。␞␞       </para>␞
␝       <para>␟       Print the <application>dropdb</application> version and exit.␟<application>dropdb</application>のバージョンを表示し、終了します。␞␞       </para>␞
␝       <para>␟       Do not throw an error if the database does not exist. A notice is issued
       in this case.␟指定したデータベースが存在しない場合でもエラーとしません。
この場合には注意が発生します。␞␞       </para>␞
␝       <para>␟       Show help about <application>dropdb</application> command line
       arguments, and exit.␟<application>dropdb</application>のコマンドライン引数の使用方法を表示し、終了します。␞␞       </para>␞
␝  <para>␟   <application>dropdb</application> also accepts the following
   command-line arguments for connection parameters:␟また<application>dropdb</application>は、以下のコマンドライン引数を接続パラメータとして受け付けます。␞␞␞
␝       <para>␟        Specifies the host name of the machine on which the
        server
        is running.  If the value begins with a slash, it is used
        as the directory for the Unix domain socket.␟サーバが稼働しているマシンのホスト名を指定します。
この値がスラッシュから始まる場合、Unixドメインソケット用のディレクトリとして使用されます。␞␞       </para>␞
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
␝       <para>␟        Force <application>dropdb</application> to prompt for a
        password before connecting to a database.␟データベースに接続する前に、<application>dropdb</application>は強制的にパスワード入力を促します。␞␞       </para>␞
␝       <para>␟        This option is never essential, since
        <application>dropdb</application> will automatically prompt
        for a password if the server demands password authentication.
        However, <application>dropdb</application> will waste a
        connection attempt finding out that the server wants a password.
        In some cases it is worth typing <option>-W</option> to avoid the extra
        connection attempt.␟サーバがパスワード認証を要求する場合<application>dropdb</application>は自動的にパスワード入力を促しますので、これが重要になることはありません。
しかし、<application>dropdb</application>は、サーバにパスワードが必要かどうかを判断するための接続試行を無駄に行います。
こうした余計な接続試行を防ぐために<option>-W</option>の入力が有意となる場合もあります。␞␞       </para>␞
␝       <para>␟         Specifies the name of the database to connect to in order to drop the
         target database. If not specified, the <literal>postgres</literal>
         database will be used; if that does not exist (or is the database
         being dropped), <literal>template1</literal> will be used.
         This can be a <link linkend="libpq-connstring">connection
         string</link>.  If so, connection string parameters will override any
         conflicting command line options.␟対象データベースを削除するために接続するデータベースの名前を指定します。
指定されない場合は、<literal>postgres</literal>データベースが使用されます。
このデータベースが存在しない場合（またはこのデータベースが削除中である場合）<literal>template1</literal>が使用されます。
これは<link linkend="libpq-connstring">接続文字列</link>でも構いません。
その場合、接続文字列パラメータは衝突するコマンドラインオプションよりも優先します。␞␞       </para>␞
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
␝  <para>␟   In case of difficulty, see <xref linkend="sql-dropdatabase"/>
   and <xref linkend="app-psql"/> for
   discussions of potential problems and error messages.
   The database server must be running at the
   targeted host.  Also, any default connection settings and environment
   variables used by the <application>libpq</application> front-end
   library will apply.␟問題が発生した場合、考えられる原因とエラーメッセージについては<xref linkend="sql-dropdatabase"/>と<xref linkend="app-psql"/>を参照してください。
対象ホストでデータベースサーバが稼働していなければなりません。
また、<application>libpq</application>のフロントエンドライブラリの、あらゆるデフォルトの設定や環境変数が適用されます。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝   <para>␟    To destroy the database <literal>demo</literal> on the default
    database server:␟次のコマンドは、デフォルトのデータベースサーバ上の<literal>demo</literal>データベースを削除します。␞␞<screen>␞
␝   <para>␟    To destroy the database <literal>demo</literal> using the
    server on host <literal>eden</literal>, port 5000, with verification and a peek
    at the underlying command:␟次のコマンドはホスト<literal>eden</literal>のポート番号5000で動作しているサーバからデータベース<literal>demo</literal>を削除します。
その際、削除を確認し、またバックエンドに送られるコマンドを表示します。␞␞<screen>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟<prompt>$ </prompt><userinput>dropdb -p 5000 -h eden -i -e demo</userinput> <computeroutput>Database "demo" will be permanently deleted. Are you sure? (y/n) </computeroutput><userinput>y</userinput> <computeroutput>DROP DATABASE demo;</computeroutput> </screen></para> </screen></para>␟no translation␞␞␞
