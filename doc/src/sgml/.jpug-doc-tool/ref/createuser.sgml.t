␝  <manvolnum>1</manvolnum>␟  <refmiscinfo>Application</refmiscinfo>␟<refmiscinfo>アプリケーション</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>createuser</refname>␟  <refpurpose>define a new <productname>PostgreSQL</productname> user account</refpurpose>␟<refpurpose>新しい<productname>PostgreSQL</productname>のユーザアカウントを定義する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞  <para>␞
␝  <para>␟   <application>createuser</application> creates a
   new <productname>PostgreSQL</productname> user (or more precisely, a role).
   Only superusers and users with <literal>CREATEROLE</literal> privilege can create
   new users, so <application>createuser</application> must be
   invoked by someone who can connect as a superuser or a user with
   <literal>CREATEROLE</literal> privilege.␟<application>createuser</application>は新しい<productname>PostgreSQL</productname>のユーザ（より正確にいえばロール）を作成します。
新しいユーザを作成できるのは、スーパーユーザと<literal>CREATEROLE</literal>権限を持つユーザのみです。
したがって、<application>createuser</application>は、スーパーユーザもしくは<literal>CREATEROLE</literal>権限を持つユーザとして接続可能なユーザによって実行されなければなりません。␞␞  </para>␞
␝  <para>␟   If you wish to create a role with the <literal>SUPERUSER</literal>,
   <literal>REPLICATION</literal>, or <literal>BYPASSRLS</literal> privilege,
   you must connect as a superuser, not merely with
   <literal>CREATEROLE</literal> privilege.
   Being a superuser implies the ability to bypass all access permission
   checks within the database, so superuser access should not be granted
   lightly. <literal>CREATEROLE</literal> also conveys
   <link linkend="role-creation">very extensive privileges</link>.␟<literal>SUPERUSER</literal>、<literal>REPLICATION</literal>、または<literal>BYPASSRLS</literal>権限を持つロールを作成したいのであれば、スーパーユーザとして接続しなければなりません。<literal>CREATEROLE</literal>権限だけではいけません。
スーパーユーザであるということは、そのデータベースにおけるアクセス権限の検査を素通りできることを意味しています。したがって、スーパーユーザのアクセス権を簡単に与えてはなりません。
<literal>CREATEROLE</literal>も<link linkend="role-creation">非常に広範な権限</link>を付与します。␞␞  </para>␞
␝  <para>␟   <application>createuser</application> is a wrapper around the
   <acronym>SQL</acronym> command <link linkend="sql-createrole"><command>CREATE ROLE</command></link>.
   There is no effective difference between creating users via
   this utility and via other methods for accessing the server.␟<application>createuser</application>は<acronym>SQL</acronym>コマンド<link linkend="sql-createrole"><command>CREATE ROLE</command></link>のラッパーです。
このユーティリティによってユーザを作成しても、これ以外の方法でサーバにアクセスしてユーザを作成しても特に違いはありません。␞␞  </para>␞
␝ <refsect1>␟  <title>Options</title>␟  <title>オプション</title>␞␞␞
␝  <para>␟   <application>createuser</application> accepts the following command-line arguments:␟<application>createuser</application>では、下記のコマンドライン引数を指定できます。␞␞␞
␝       <para>␟        Specifies the name of the <productname>PostgreSQL</productname> user
        to be created.
        This name must be different from all existing roles in this
        <productname>PostgreSQL</productname> installation.␟作成する<productname>PostgreSQL</productname>ユーザの名前を指定します。
この名前は、その<productname>PostgreSQL</productname>インストレーションに存在するすべてのロールと異なるものでなければなりません。␞␞       </para>␞
␝       <para>␟        Specifies an existing role that will be automatically added as a member of the new
        role with admin option, giving it the right to grant membership in the
        new role to others.  Multiple existing roles can be specified by
        writing multiple <option>-a</option> switches.␟アドミンオプションを持つ新しいロールのメンバとして自動的に追加される既存のロールを指定します。
これにより、新しいロールのメンバ資格を他の人に付与する権利が与えられます。
<option>-a</option>スイッチを複数記述することで、複数の既存のロールを指定できます。␞␞       </para>␞
␝       <para>␟        Set a maximum number of connections for the new user.
        The default is to set no limit.␟新しいユーザの最大接続数を設定します。
デフォルトでは無制限です。␞␞       </para>␞
␝       <para>␟        The new user will be allowed to create databases.␟新しいユーザに対してデータベースの作成を許可します。␞␞       </para>␞
␝       <para>␟        The new user will not be allowed to create databases.  This is the
        default.␟新しいユーザに対してデータベースの作成を禁止します。
これはデフォルトです。␞␞       </para>␞
␝       <para>␟        Echo the commands that <application>createuser</application> generates
        and sends to the server.␟<application>createuser</application>が生成しサーバに送信するコマンドを出力します。␞␞       </para>␞
␝       <para>␟        This option is obsolete but still accepted for backward
        compatibility.␟このオプションは廃止されましたが、後方互換性のためにまだ受け付けられます。␞␞       </para>␞
␝       <para>␟        Specifies the new role should be automatically added as a member
        of the specified existing role. Multiple existing roles can be
        specified by writing multiple <option>-g</option> switches.␟新しいロールが、指定された既存のロールのメンバとして自動的に追加されるように指定します。
<option>-g</option>スイッチを複数記述することで、複数の既存のロールを指定できます。␞␞       </para>␞
␝       <para>␟        The new role will automatically inherit privileges of roles
        it is a member of.
        This is the default.␟新しいロールは自動的にメンバとして属するロールの権限を継承します。
これがデフォルトです。␞␞       </para>␞
␝       <para>␟        The new role will not automatically inherit privileges of roles
        it is a member of.␟新しいロールは自動的にメンバとして属するロールの権限を継承しません。␞␞       </para>␞
␝       <para>␟        Prompt for the user name if none is specified on the command line, and
        also prompt for whichever of the options
        <option>-d</option>/<option>-D</option>,
        <option>-r</option>/<option>-R</option>,
        <option>-s</option>/<option>-S</option> is not specified on the command
        line.  (This was the default behavior up to PostgreSQL 9.1.)␟ユーザ名がコマンドラインで指定されない場合、ユーザ名の入力を促し、更に
<option>-d</option>/<option>-D</option>、<option>-r</option>/<option>-R</option>、<option>-s</option>/<option>-S</option>オプションがコマンドラインで指定されない場合にはどちらにするか入力を促します。
（これはPostgreSQL 9.1までのデフォルトの動作でした。）␞␞       </para>␞
␝       <para>␟        The new user will be allowed to log in (that is, the user name
        can be used as the initial session user identifier).
        This is the default.␟新しいユーザに対してログインを許可します。
（つまり、このユーザ名をセッション起動時のユーザ識別子として使用することができます。）
これがデフォルトです。␞␞       </para>␞
␝       <para>␟        The new user will not be allowed to log in.
        (A role without login privilege is still useful as a means of
        managing database permissions.)␟新しいユーザに対してログインを禁止します。
（ログイン権限を持たないロールはデータベース権限管理という面で有意です。）␞␞       </para>␞
␝       <para>␟        Specifies an existing role that will be automatically
        added as a member of the new role. Multiple existing roles can
        be specified by writing multiple <option>-m</option> switches.␟新しいロールのメンバとして自動的に追加される既存のロールを指定します。
<option>-m</option>スイッチを複数記述することで、複数の既存のロールを指定できます。␞␞       </para>␞
␝       <para>␟       If given, <application>createuser</application> will issue a prompt for
       the password of the new user. This is not necessary if you do not plan
       on using password authentication.␟このオプションが指定されると、<application>createuser</application>は新しいユーザのパスワードのプロンプトを表示します。
もしパスワード認証を使う予定がなければ、これは必要ありません。␞␞       </para>␞
␝       <para>␟        The new user will be allowed to create, alter, drop, comment on,
        change the security label for other roles; that is,
        this user will have <literal>CREATEROLE</literal> privilege.
        See <xref linkend="role-creation"/> for more details about what
        capabilities are conferred by this privilege.␟他のロールの作成、変更、削除、コメント付与、およびセキュリティラベルの変更を新しいユーザに対して許可します。つまり、このユーザは<literal>CREATEROLE</literal>権限を持つことになります。
この権限によって付与される機能の詳細については、<xref linkend="role-creation"/>を参照してください。␞␞       </para>␞
␝       <para>␟        The new user will not be allowed to create new roles.  This is the
        default.␟新しいユーザに対して新しいロールの作成を禁止します。
これはデフォルトです。␞␞       </para>␞
␝       <para>␟        The new user will be a superuser.␟新しいユーザはスーパーユーザになります。␞␞       </para>␞
␝       <para>␟        The new user will not be a superuser.  This is the default.␟新しいユーザはスーパーユーザにはなりません。
これはデフォルトです。␞␞       </para>␞
␝       <para>␟        Set a date and time after which the role's password is no longer valid.
        The default is to set no password expiry date.␟ロールのパスワードが有効でなくなる日時を設定します。
デフォルトはパスワードの有効期限を設定しません。␞␞       </para>␞
␝       <para>␟       Print the <application>createuser</application> version and exit.␟<application>createuser</application>のバージョンを表示し、終了します。␞␞       </para>␞
␝       <para>␟        The new user will bypass every row-level security (RLS) policy.␟新しいユーザは、すべての行レベルセキュリティ(RLS)ポリシーをバイパスします。␞␞       </para>␞
␝       <para>␟        The new user will not bypass row-level security (RLS) policies.  This is
        the default.␟新しいユーザは、行レベルセキュリティ(RLS)ポリシーをバイパスしません。
これがデフォルトです。␞␞       </para>␞
␝       <para>␟        The new user will have the <literal>REPLICATION</literal> privilege,
        which is described more fully in the documentation for <xref
        linkend="sql-createrole"/>.␟新しいユーザは<literal>REPLICATION</literal>権限を持ちます。
この権限については<xref linkend="sql-createrole"/>の文書で詳しく説明します。␞␞       </para>␞
␝       <para>␟        The new user will not have the <literal>REPLICATION</literal>
        privilege, which is described more fully in the documentation for <xref
        linkend="sql-createrole"/>.  This is the default.␟新しいユーザは<literal>REPLICATION</literal>権限を持ちません。
この権限については<xref linkend="sql-createrole"/>の文書で詳しく説明します。
これがデフォルトです。␞␞       </para>␞
␝       <para>␟       Show help about <application>createuser</application> command line
       arguments, and exit.␟<application>createuser</application>のコマンドライン引数の使用方法を表示し、終了します。␞␞       </para>␞
␝  <para>␟   <application>createuser</application> also accepts the following
   command-line arguments for connection parameters:␟<application>createuser</application>は、以下のコマンドライン引数も接続パラメータとして受け付けます。␞␞␞
␝       <para>␟        Specifies the host name of the machine on which the
        server
        is running.  If the value begins with a slash, it is used
        as the directory for the Unix domain socket.␟サーバが稼働しているマシンのホスト名を指定します。
この値がスラッシュから始まる場合、Unixドメインソケット用のディレクトリとして使用されます。␞␞       </para>␞
␝       <para>␟        Specifies the TCP port or local Unix domain socket file
        extension on which the server
        is listening for connections.␟サーバが接続を監視するTCPポートもしくはUnixドメインソケットファイルの拡張子を指定します。␞␞       </para>␞
␝       <para>␟        User name to connect as (not the user name to create).␟接続に使用するユーザ名です（作成するユーザの名前ではありません）。␞␞       </para>␞
␝       <para>␟        Never issue a password prompt.  If the server requires
        password authentication and a password is not available by
        other means such as a <filename>.pgpass</filename> file, the
        connection attempt will fail.  This option can be useful in
        batch jobs and scripts where no user is present to enter a
        password.␟パスワードの入力を促しません。
サーバがパスワード認証を必要とし、かつ、<filename>.pgpass</filename>ファイルなどの他の方法が利用できない場合、接続試行は失敗します。
バッチジョブやスクリプトなどパスワードを入力するユーザが存在しない場合にこのオプションは有用かもしれません。␞␞       </para>␞
␝       <para>␟        Force <application>createuser</application> to prompt for a
        password (for connecting to the server, not for the
        password of the new user).␟<application>createuser</application>は強制的にパスワード入力を促します。
（新しいユーザのパスワードではなく、サーバに接続するためのパスワードです）。␞␞       </para>␞
␝       <para>␟        This option is never essential, since
        <application>createuser</application> will automatically prompt
        for a password if the server demands password authentication.
        However, <application>createuser</application> will waste a
        connection attempt finding out that the server wants a password.
        In some cases it is worth typing <option>-W</option> to avoid the extra
        connection attempt.␟サーバがパスワード認証を要求する場合<application>createuser</application>は自動的にパスワード入力を促しますので、これが重要になることはありません。
しかし、<application>createuser</application>は、サーバにパスワードが必要かどうかを判断するための接続試行を無駄に行います。
こうした余計な接続試行を防ぐために<option>-W</option>の入力が有意となる場合もあります。␞␞       </para>␞
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
␝  <para>␟   In case of difficulty, see <xref linkend="sql-createrole"/>
   and <xref linkend="app-psql"/> for
   discussions of potential problems and error messages.
   The database server must be running at the
   targeted host.  Also, any default connection settings and environment
   variables used by the <application>libpq</application> front-end
   library will apply.␟問題が発生した場合、考えられる原因とエラーメッセージの説明については、<xref linkend="sql-createrole"/>と<xref linkend="app-psql"/>を参照してください。
データベースサーバは対象ホストで稼働していなければなりません。
また、<application>libpq</application>フロントエンドライブラリで使用される、デフォルトの接続設定と環境変数が適用されることを覚えておいてください。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝   <para>␟    To create a user <literal>joe</literal> on the default database
    server:␟デフォルトデータベースサーバ上に<literal>joe</literal>というユーザを作成します。␞␞<screen>␞
␝   <para>␟    To create a user <literal>joe</literal> on the default database
    server with prompting for some additional attributes:␟デフォルトデータベースサーバ上に<literal>joe</literal>というユーザを一部の属性入力が促されるように作成します。␞␞<screen>␞
␝   <para>␟    To create the same user <literal>joe</literal> using the
    server on host <literal>eden</literal>, port 5000, with attributes explicitly specified,
    taking a look at the underlying command:␟ホスト<literal>eden</literal>のポート番号5000上のサーバを使って上記と同じ<literal>joe</literal>というユーザを属性を明示的に指定して作成し、背後で実行される問い合わせを表示します。␞␞<screen>␞
␝   <para>␟    To create the user <literal>joe</literal> as a superuser,
    and assign a password immediately:␟<literal>joe</literal>というユーザをスーパーユーザとして作成します。作成時にパスワードを割り当てます。␞␞<screen>␞
␝</screen>␟    In the above example, the new password isn't actually echoed when typed,
    but we show what was typed for clarity.  As you see, the password is
    encrypted before it is sent to the client.␟上の例で、実際には入力した新しいパスワードは画面上に表示されませんが、分かりやすくするために記載しています。
上記の通りこのパスワードはクライアントに送信される前に暗号化されます。␞␞   </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
