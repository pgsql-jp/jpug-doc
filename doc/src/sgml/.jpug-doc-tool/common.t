␝␟<phrase>where <replaceable class="parameter">option</replaceable> can be:</phrase>␟<phrase>ここで<replaceable class="parameter">option</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟The message body consists of one or more identified fields, followed by a zero byte as a terminator. Fields can appear in any order. For each field there is the following:␟このメッセージの本体には、ゼロバイトを終端として後続する、1つ以上の識別されるフィールドが含まれます。
フィールドは任意の順番で現れる可能性があります。
各フィールドには以下があります。␞␞␞
␝␟<title>Pseudo-Types</title>␟ <title>疑似データ型</title>␞␞␞
␝␟Sets the directory for installing C and C++ header files. The default is <filename><replaceable>PREFIX</replaceable>/include</filename>.␟CおよびC++のヘッダファイルをインストールするディレクトリを設定します。
デフォルトは<filename><replaceable>PREFIX</replaceable>/include</filename>です。␞␞␞
␝␟<title><literal>WITH</literal> Clause</title>␟ <title><literal>WITH</literal>句</title>␞␞␞
␝␟<entry>Range</entry>␟ <entry>範囲</entry>␞␞␞
␝␟Returns status, either <literal>OK</literal> or <literal>ERROR</literal>.␟状態、つまり<literal>OK</literal>または<literal>ERROR</literal>を返します。␞␞␞
␝␟Name of the role to which this role membership was granted (can be the current user, or a different role in case of nested role memberships)␟このロールのメンバ資格を付与したロールの名前です。
（現在のユーザかもしれませんし、入れ子状のロールメンバ資格の場合は異なるロールかもしれません。）␞␞␞
␝␟User can initiate streaming replication and put the system in and out of backup mode.␟ユーザはストリーミングレプリケーションを開始することができ、システムをバックアップモードにしたり、戻したりできます。␞␞␞
␝␟(references <link linkend="catalog-pg-database"><structname>pg_database</structname></link>.<structfield>datname</structfield>)␟（参照先 <link linkend="catalog-pg-database"><structname>pg_database</structname></link>.<structfield>datname</structfield>）␞␞␞
␝␟This variable specifies one or more shared libraries that are to be preloaded at connection start. It contains a comma-separated list of library names, where each name is interpreted as for the <link linkend="sql-load"><command>LOAD</command></link> command. Whitespace between entries is ignored; surround a library name with double quotes if you need to include whitespace or commas in the name. The parameter value only takes effect at the start of the connection. Subsequent changes have no effect. If a specified library is not found, the connection attempt will fail.␟この変数は、接続時に事前読み込みされる、1つまたは複数の共有ライブラリを指定します。
ここにはカンマ区切りでライブラリ名のリストを格納し、各々の名前は<link linkend="sql-load"><command>LOAD</command></link>コマンドで解釈されます。
項目の間の空白は無視されます。
名前の中に空白あるいはカンマを含める場合は、二重引用符で囲ってください。
このパラメータは、接続の開始時にのみ効果があります。
以降の変更は効果がありません。
もし指定したライブラリが見つからない場合は、接続は失敗します。␞␞␞
␝␟The OID of the object this security label pertains to␟このセキュリティラベルが関係するオブジェクトのOID␞␞␞
␝␟Print lots of debug logging output on <filename>stderr</filename>.␟<filename>stderr</filename>に大量のデバッグログを出力します。␞␞␞
␝␟(references <link linkend="catalog-pg-attribute"><structname>pg_attribute</structname></link>.<structfield>attname</structfield>)␟（参照先 <link linkend="catalog-pg-attribute"><structname>pg_attribute</structname></link>.<structfield>attname</structfield>）␞␞␞
␝␟Current date and time (start of current transaction), with limited precision; see <xref linkend="functions-datetime-current"/>␟精度を限定した現在の日付と時刻（現在のトランザクションの開始時）。<xref linkend="functions-datetime-current"/>を参照。␞␞␞
␝␟Name of an option␟オプションの名前です。␞␞␞
␝␟<entry>Core?</entry>␟ <entry>コアか？</entry>␞␞␞
␝␟The column is allowed to contain null values. This is the default.␟その列がNULL値を持てることを指定します。
これがデフォルトです。␞␞␞
␝␟Truncate to specified precision; see <xref linkend="functions-datetime-trunc"/>␟指定された精度で切り捨て。<xref linkend="functions-datetime-trunc"/>参照。␞␞␞
␝␟Values: 0, 1 Default: 0 Applies to: pgp_sym_encrypt, pgp_pub_encrypt␟値: 0, 1
デフォルト: 0
適用範囲: pgp_sym_encrypt, pgp_pub_encrypt␞␞␞
␝␟Specifies the host name of the machine on which the server is running. If the value begins with a slash, it is used as the directory for the Unix domain socket. The default is taken from the <envar>PGHOST</envar> environment variable, if set, else a Unix domain socket connection is attempted.␟サーバが稼働しているマシンのホスト名を指定します。
この値がスラッシュから始まる場合、Unixドメインソケット用のディレクトリとして使用されます。
デフォルトは、設定されていれば環境変数<envar>PGHOST</envar>から取得されます。
設定されていなければ、Unixドメインソケット接続とみなされます。␞␞␞
␝␟<entry><literal>TABLE</literal>, table column</entry>␟ <entry><literal>TABLE</literal>、テーブルの列</entry>␞␞␞
␝␟On success, 0 is returned and a negative value if the conversion failed. If an overflow occurred, <literal>ECPG_INFORMIX_NUM_OVERFLOW</literal> is returned.␟成功時0が、変換失敗時負の値が返されます。
オーバーフローが発生した場合は<literal>ECPG_INFORMIX_NUM_OVERFLOW</literal>が返されます。␞␞␞
␝␟<entry>Name</entry>␟ <entry>名前</entry>␞␞␞
␝␟<refpurpose>start a transaction block</refpurpose>␟ <refpurpose>トランザクションブロックを開始する</refpurpose>␞␞␞
␝␟Never issue a password prompt. If the server requires password authentication and a password is not available by other means such as a <filename>.pgpass</filename> file, the connection attempt will fail. This option can be useful in batch jobs and scripts where no user is present to enter a password.␟パスワードの入力を促しません。
サーバがパスワード認証を必要とし、かつ、<filename>.pgpass</filename>ファイルなどの他の方法が利用できない場合、接続試行は失敗します。
バッチジョブやスクリプトなどパスワードを入力するユーザが存在しない場合にこのオプションは有用かもしれません。␞␞␞
␝␟Care has been taken to make it possible to install <productname>PostgreSQL</productname> into shared installation locations (such as <filename>/usr/local/include</filename>) without interfering with the namespace of the rest of the system. First, the string <quote><literal>/postgresql</literal></quote> is automatically appended to <varname>datadir</varname>, <varname>sysconfdir</varname>, and <varname>docdir</varname>, unless the fully expanded directory name already contains the string <quote><literal>postgres</literal></quote> or <quote><literal>pgsql</literal></quote>. For example, if you choose <filename>/usr/local</filename> as prefix, the documentation will be installed in <filename>/usr/local/doc/postgresql</filename>, but if the prefix is <filename>/opt/postgres</filename>, then it will be in <filename>/opt/postgres/doc</filename>. The public C header files of the client interfaces are installed into <varname>includedir</varname> and are namespace-clean. The internal header files and the server header files are installed into private directories under <varname>includedir</varname>. See the documentation of each interface for information about how to access its header files. Finally, a private subdirectory will also be created, if appropriate, under <varname>libdir</varname> for dynamically loadable modules.␟（<filename>/usr/local/include</filename>といった）共用のインストール場所に、システムの他の名前空間に影響を与えることなく<productname>PostgreSQL</productname>をインストールできるような配慮がなされています。
まず、完全に展開したディレクトリ名に<quote><literal>postgres</literal></quote>か<quote><literal>pgsql</literal></quote>という文字列が含まれていない場合、<quote><literal>/postgresql</literal></quote>という文字列が自動的に<varname>datadir</varname>、<varname>sysconfdir</varname>、<varname>docdir</varname>に追加されます。
例えば、接頭辞として<filename>/usr/local</filename>を使用する場合、ドキュメントは<filename>/usr/local/doc/postgresql</filename>にインストールされますが、接頭辞が<filename>/opt/postgres</filename>の場合は<filename>/opt/postgres/doc</filename>にインストールされます。
クライアントインタフェース用の外部向けCヘッダファイルは<varname>includedir</varname>にインストールされ、名前空間の問題はありません。
内部向けヘッダファイルやサーバ用ヘッダファイルは、<varname>includedir</varname>以下の非公開ディレクトリにインストールされます。
各インタフェース用のヘッダファイルにアクセスする方法についての情報は、そのインタフェースのドキュメントを参照してください。
最後に、適切であれば、動的ロード可能モジュール用に<varname>libdir</varname>以下にも非公開用のサブディレクトリが作成されます。␞␞␞
␝␟<entry>View Name</entry>␟ <entry>ビュー名</entry>␞␞␞
␝␟<phrase>where <replaceable class="parameter">direction</replaceable> can be one of:</phrase>␟<phrase>ここで<replaceable class="parameter">direction</replaceable>は以下の一つです。</phrase>␞␞␞
␝␟Refer to <xref linkend="textsearch"/> for further information.␟詳細は<xref linkend="textsearch"/>を参照してください。␞␞␞
␝␟column number (count starts at 1)␟（1から始まる）列番号␞␞␞
␝␟<literal>YES</literal> if the constraint is deferrable and initially deferred, <literal>NO</literal> if not␟制約が遅延可能で初期状態が遅延であれば<literal>YES</literal>。さもなくば<literal>NO</literal>。␞␞␞
␝␟Convert a variable of type date to its textual representation using a format mask.␟書式マスクを使用してdate型変数をテキスト表現に変換します。␞␞␞
␝␟<title>Installation Locations</title>␟ <title>インストレーションの位置</title>␞␞␞
␝␟<entry>certificates revoked by certificate authorities</entry>␟ <entry>認証局により失効された証明書</entry>␞␞␞
␝␟<term><literal>TEMPORARY</literal> or <literal>TEMP</literal></term>␟ <term><literal>TEMPORARY</literal>または<literal>TEMP</literal></term>␞␞␞
␝␟This function can only be used while connected to SPI. Otherwise, it returns NULL and sets <varname>SPI_result</varname> to <symbol>SPI_ERROR_UNCONNECTED</symbol>.␟この関数はSPIに接続されている間にのみ使うことができます。
それ以外の場合はNULLを返し、<varname>SPI_result</varname>を<symbol>SPI_ERROR_UNCONNECTED</symbol>にセットします。␞␞␞
␝␟Adds an offset to an address.␟オフセットをアドレスに加算します。␞␞␞
␝␟Use <command>\lo_list</command> to find out the large object's <acronym>OID</acronym>.␟ラージオブジェクトの<acronym>OID</acronym>を確認するには、<command>\lo_list</command>を使用してください。␞␞␞
␝␟Number of columns.␟列数。␞␞␞
␝␟Row identifier␟行識別子␞␞␞
␝␟<entry>2 bytes</entry>␟ <entry>2バイト</entry>␞␞␞
␝␟<title>Optimizer</title>␟ <title>オプティマイザ</title>␞␞␞
␝␟OID of the subscription␟サブスクリプションのOIDです。␞␞␞
␝␟/* Put each element of the composite type column in the SELECT list. */␟/* SELECTリストに複合型の列の各要素を書く。 */␞␞␞
␝␟A descriptor name.␟記述子の名前です。␞␞␞
␝␟<entry>backslash</entry>␟ <entry>バックスラッシュ</entry>␞␞␞
␝␟Not possible␟安全␞␞␞
␝␟<title>Generated Columns</title>␟ <title>生成列</title>␞␞␞
␝␟OID of a table␟テーブルのOIDです。␞␞␞
␝␟<title>Client Applications</title>␟ <title>クライアントアプリケーション</title>␞␞␞
␝␟<entry>Modifier</entry>␟ <entry>修飾子</entry>␞␞␞
␝␟<entry>left</entry>␟ <entry>左</entry>␞␞␞
␝␟Direction values other than <symbol>FETCH_FORWARD</symbol> may fail if the cursor's plan was not created with the <symbol>CURSOR_OPT_SCROLL</symbol> option.␟カーソルの計画が<symbol>CURSOR_OPT_SCROLL</symbol>オプション付きで作成されていない場合、<symbol>FETCH_FORWARD</symbol>以外の方向値は失敗する可能性があります。␞␞␞
␝␟Function/Operator␟関数/演算子␞␞␞
␝␟Negotiating SSL encryption.␟SSL暗号化の調停状態です。␞␞␞
␝␟Minimum value of the sequence␟シーケンスの最小値␞␞␞
␝␟(references <link linkend="catalog-pg-class"><structname>pg_class</structname></link>.<structfield>relname</structfield>)␟（参照先 <link linkend="catalog-pg-class"><structname>pg_class</structname></link>.<structfield>relname</structfield>）␞␞␞
␝␟Another response could be this:␟他の応答として以下もあります。␞␞␞
␝␟<title>Examples</title>␟ <title>例</title>␞␞␞
␝␟To make these settings persist over reboots, modify <filename>/etc/sysctl.conf</filename>.␟これらの設定を再起動しても永続化するには、<filename>/etc/sysctl.conf</filename>を変更します。␞␞␞
␝␟And the matching code in the C module could then follow this skeleton:␟そして、Cモジュール内の対応するコードは以下のような骨格に従うことになります。␞␞␞
␝␟This feature was shamelessly plagiarized from <application>Bash</application>.␟この機能は<application>Bash</application>の機能を真似たものです。␞␞␞
␝␟This function is restricted to superusers and members of the <literal>pg_monitor</literal> role by default, but other users can be granted EXECUTE to run the function.␟デフォルトではこの関数の実行はスーパーユーザと<literal>pg_monitor</literal>ロールのメンバに限定されますが、他のユーザに関数を実行するEXECUTE権限を与えることができます。␞␞␞
␝␟This function is restricted to superusers and roles with privileges of the <literal>pg_monitor</literal> role by default, but other users can be granted EXECUTE to run the function.␟デフォルトではこの関数の実行はスーパーユーザと<literal>pg_monitor</literal>ロールの権限を持つロールに限定されますが、他のユーザに関数を実行するEXECUTE権限を与えることができます。␞␞␞
␝␟<refpurpose>close a cursor</refpurpose>␟ <refpurpose>カーソルを閉じる</refpurpose>␞␞␞
␝␟Name of the database that the foreign server is defined in (always the current database)␟外部サーバを定義したデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>Partial Mode</entry>␟ <entry>部分モード</entry>␞␞␞
␝␟Name of the table that contains the column␟その列を含むテーブルの名前です。␞␞␞
␝␟This option is ignored when emitting an archive (non-text) output file. For the archive formats, you can specify the option when you call <command>pg_restore</command>.␟このオプションはアーカイブ（テキストでない）出力ファイルを出力する場合には無視されます。
アーカイブ形式では、<command>pg_restore</command>を呼び出す時にこのオプションを指定できます。␞␞␞
␝␟<title>Uninstallation:</title>␟ <title>アンインストール:</title>␞␞␞
␝␟<title>Example Usage</title>␟ <title>使用例</title>␞␞␞
␝␟Name of the database that contains the foreign table (always the current database)␟外部テーブルが含まれるデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>Storage Size</entry>␟ <entry>格納サイズ</entry>␞␞␞
␝␟See <xref linkend="role-removal"/> for more discussion.␟詳しくは<xref linkend="role-removal"/>を参照してください。␞␞␞
␝␟<title>Configuration Parameters</title>␟ <title>設定パラメータ</title>␞␞␞
␝␟<title>Server Signaling Functions</title>␟ <title>サーバシグナル送信関数</title>␞␞␞
␝␟Convert a timestamp variable to a C char* using a format mask.␟書式マスクを使用してtimestamp型変数をC char*に変換します。␞␞␞
␝␟Name of the schema containing the constraint␟制約が含まれるスキーマの名前です。␞␞␞
␝␟<literal>true</literal> allows non-atomic execution of CALL and DO statements (but this field is ignored unless the <symbol>SPI_OPT_NONATOMIC</symbol> flag was passed to <function>SPI_connect_ext</function>)␟<literal>true</literal>でCALLとDO文の非原子的実行を許可します（ただし、<symbol>SPI_OPT_NONATOMIC</symbol>フラグが<function>SPI_connect_ext</function>に渡されていなければ、このフィールドは無視されます）␞␞␞
␝␟Role can create more roles␟ロールはロールを作成できる␞␞␞
␝␟<title>Range Types</title>␟ <title>範囲型</title>␞␞␞
␝␟Define options that are specific to this operator class (optional)␟この演算子クラスに固有のオプションを定義します（省略可能）␞␞␞
␝␟Do not dump publications.␟パブリケーションをダンプしません。␞␞␞
␝␟Name of the schema that contains the table that contains the column␟その列を含むテーブルを持つスキーマの名前です。␞␞␞
␝␟<entry>Example</entry>␟ <entry>例</entry>␞␞␞
␝␟<entry>Support Procedure 5</entry>␟ <entry>サポートプロシージャ 5</entry>␞␞␞
␝␟<title>Anti-Features</title>␟ <title>機能の無効化</title>␞␞␞
␝␟/* Fetch multiple columns into one structure. */␟ /* 複数列を1つの構造体に取り込む。 */␞␞␞
␝␟Name of the database that contains the domain (always the current database)␟ドメインを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>Support Function 3</entry>␟ <entry>サポート関数 3</entry>␞␞␞
␝␟Each column not present in the explicit or implicit column list will be filled with a default value, either its declared default value or null if there is none.␟明示的または暗黙的な列リストにない各列にはデフォルト値（デフォルト値が宣言されていればその値、未宣言ならばNULL）が挿入されます。␞␞␞
␝␟To abort all changes:␟全ての変更をアボートします。␞␞␞
␝␟Applies to a feature not available in <productname>PostgreSQL</productname>␟<productname>PostgreSQL</productname>では利用できない機能に適用されるものです。␞␞␞
␝␟-- need to be in a transaction to use cursors.␟-- カーソルを使用するには、トランザクション内部である必要があります。␞␞␞
␝␟The <parameter>options-&gt;params</parameter> object should normally mark each parameter with the <literal>PARAM_FLAG_CONST</literal> flag, since a one-shot plan is always used for the query.␟その問い合わせに対しては一度限りの計画が必ず使われますので、<parameter>options-&gt;params</parameter>オブジェクトは通常各パラメータに<literal>PARAM_FLAG_CONST</literal>フラグをつけるべきです。␞␞␞
␝␟The default value is 2. This parameter can only be set in the <filename>postgresql.conf</filename> file or on the server command line.␟デフォルト値は2です。
このパラメータは、<filename>postgresql.conf</filename>ファイルか、サーバのコマンドラインでのみ設定可能です。␞␞␞
␝␟<entry>variable-length character string</entry>␟ <entry>可変長文字列</entry>␞␞␞
␝␟IPC parameters can be adjusted using <command>sysctl</command>, for example:␟以下の例のようにIPCパラメータを<command>sysctl</command>を用いて調整することができます。␞␞␞
␝␟Values of the primary key fields to be used to look up the local tuple. Each field is represented in text form. An error is thrown if there is no local row with these primary key values.␟ローカルタプルを検索するために使用される主キーフィールドの値です。
各フィールドはテキスト形式で表されます。
これらの主キーの値を持つ行がローカル側に存在しない場合はエラーが発生します。␞␞␞
␝␟If you are upgrading an existing system be sure to read <xref linkend="upgrading"/>, which has instructions about upgrading a cluster.␟もし既存のシステムのアップグレードをする場合、DBクラスタのアップグレードの解説が記載されている<xref linkend="upgrading"/>を参照してください。␞␞␞
␝␟Character sets are currently not implemented as schema objects, so this column is null.␟文字セットはスキーマオブジェクトとして実装されていないので、この列はNULLです。␞␞␞
␝␟<title>Binary Data Types</title>␟ <title>バイナリ列データ型</title>␞␞␞
␝␟Name of this index␟インデックスの名前です。␞␞␞
␝␟(references <link linkend="catalog-pg-attribute"><structname>pg_attribute</structname></link>.<structfield>attnum</structfield>)␟（参照先 <link linkend="catalog-pg-attribute"><structname>pg_attribute</structname></link>.<structfield>attnum</structfield>）␞␞␞
␝␟<title>Miscellaneous</title>␟ <title>その他</title>␞␞␞
␝␟Name of the table that the trigger is defined on␟トリガが定義されたテーブルの名前です。␞␞␞
␝␟Parser hook setup function␟パーサフック設定関数␞␞␞
␝␟Role has superuser privileges␟ロールはスーパーユーザの権限を持っている␞␞␞
␝␟(references <link linkend="catalog-pg-namespace"><structname>pg_namespace</structname></link>.<structfield>nspname</structfield>)␟（参照先 <link linkend="catalog-pg-namespace"><structname>pg_namespace</structname></link>.<structfield>nspname</structfield>）␞␞␞
␝␟Negotiating GSS encryption.␟GSS暗号化の調停状態です。␞␞␞
␝␟Retrieve the current timestamp.␟現在のタイムスタンプを取り出します。␞␞␞
␝␟The return value is the same as for <function>SPI_execute_plan</function>.␟戻り値は<function>SPI_execute_plan</function>と同じです。␞␞␞
␝␟<entry>Default</entry>␟ <entry>デフォルト</entry>␞␞␞
␝␟For nonscalar data types, see below.␟スカラデータ型以外については後述します。␞␞␞
␝␟(references <link linkend="catalog-pg-am"><structname>pg_am</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-am"><structname>pg_am</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<title>Operator Classes and Operator Families</title>␟ <title>演算子クラスと演算子族</title>␞␞␞
␝␟<title>Tablespaces</title>␟ <title>テーブル空間</title>␞␞␞
␝␟As of <productname>PostgreSQL</productname> 9.0, the attribute numbers in <parameter>primary_key_attnums</parameter> are interpreted as logical column numbers, corresponding to the column's position in <literal>SELECT * FROM relname</literal>. Previous versions interpreted the numbers as physical column positions. There is a difference if any column(s) to the left of the indicated column have been dropped during the lifetime of the table.␟<productname>PostgreSQL</productname> 9.0の段階で、<parameter>primary_key_attnums</parameter>の中の属性数は、<literal>SELECT * FROM relname</literal>内の列の位置に対応する、論理的列数として翻訳されます。
以前のバージョンは物理的な列の位置として数を翻訳しました。
テーブルの存続期間中に、表示された列の左側のどんな列でも削除されると差異が生じます。␞␞␞
␝␟<title>Enum Support Functions</title>␟ <title>列挙型サポート関数</title>␞␞␞
␝␟Character sets are currently not implemented as schema objects, so this column is null␟文字セットはスキーマオブジェクトとして実装されていないので、この列はNULLです。␞␞␞
␝␟Name of the schema that contains the domain␟ドメインを持つスキーマの名前です。␞␞␞
␝␟The end LSN of the prepared transaction.␟プリペアドトランザクションの終了LSNです。␞␞␞
␝␟OID of the database to which this backend is connected.␟バックエンドが接続されているデータベースのOIDです。␞␞␞
␝␟Name of the connection to use; omit this parameter to use the unnamed connection.␟使用する接続の名前です。
無名の接続を使用する場合はこのパラメータを省略します。␞␞␞
␝␟<title>Environment Variables</title>␟ <title>環境変数</title>␞␞␞
␝␟Name of the database that the column data type (the underlying type of the domain, if applicable) is defined in (always the current database)␟列データ型（もし適用されていたら背後にあるドメインの型）を定義したデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<title>Date/Time Types</title>␟ <title>日付/時刻データ型</title>␞␞␞
␝␟<entry>Simplified Chinese</entry>␟ <entry>簡体字</entry>␞␞␞
␝␟<entry>greater than or equal</entry>␟ <entry>以上</entry>␞␞␞
␝␟If true (the default when omitted) then an error thrown on the remote side of the connection causes an error to also be thrown locally. If false, the remote error is locally reported as a NOTICE, and the function returns no rows.␟真（省略時のデフォルト）の場合、接続のリモート側で発生したエラーによりローカル側でもエラーが発生します。
偽の場合リモート側のエラーはローカル側にはNOTICEとして報告され、この関数は行を返しません。␞␞␞
␝␟<entry>ISO 8601; January 8, 1999 in any mode</entry>␟ <entry>ISO 8601。すべてのモードで1999年1月8日になります。</entry>␞␞␞
␝␟<title>Usage</title>␟ <title>使用方法</title>␞␞␞
␝␟Maximum value of the sequence␟シーケンスの最大値␞␞␞
␝␟<entry>Decimal Octet Value</entry>␟ <entry>10進オクテット値</entry>␞␞␞
␝␟<productname>PostgreSQL</productname> includes its own time zone database, which it requires for date and time operations. This time zone database is in fact compatible with the IANA time zone database provided by many operating systems such as FreeBSD, Linux, and Solaris, so it would be redundant to install it again. When this option is used, the system-supplied time zone database in <replaceable>DIRECTORY</replaceable> is used instead of the one included in the PostgreSQL source distribution. <replaceable>DIRECTORY</replaceable> must be specified as an absolute path. <filename>/usr/share/zoneinfo</filename> is a likely directory on some operating systems. Note that the installation routine will not detect mismatching or erroneous time zone data. If you use this option, you are advised to run the regression tests to verify that the time zone data you have pointed to works correctly with <productname>PostgreSQL</productname>.␟<productname>PostgreSQL</productname>は、日付時刻に関する操作で必要な、独自の時間帯データベースを持ちます。
実際のところ、この時間帯データベースはFreeBSD、Linux、Solarisなどの多くのオペレーティングシステムで提供されるIANA時間帯データベースと互換性があります。
このため、これを再びインストールすることは冗長です。
このオプションが使用されると、<replaceable>DIRECTORY</replaceable>にあるシステムが提供する時間帯データベースがPostgreSQLソース配布物に含まれるものの代わりに使用されます。
<replaceable>DIRECTORY</replaceable>は絶対パスで指定しなければなりません。
<filename>/usr/share/zoneinfo</filename>がオペレーティングシステムの一部でよく使われます。
インストール処理が時間帯データの不一致、またはエラーがあることを検知しないことに注意してください。
このオプションを使用する場合、指定した時間帯データが<productname>PostgreSQL</productname>で正しく動作するかどうかを検証するためにリグレッションテストを実行することが推奨されています。␞␞␞
␝␟<entry>variable-precision, inexact</entry>␟ <entry>可変精度、不正確</entry>␞␞␞
␝␟(references <link linkend="catalog-pg-namespace"><structname>pg_namespace</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-namespace"><structname>pg_namespace</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟Name of the database that the domain data type is defined in (always the current database)␟ドメインデータ型を定義したデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>File</entry>␟ <entry>ファイル</entry>␞␞␞
␝␟the prepared statement to be saved␟保存する準備済み文␞␞␞
␝␟Name of the schema containing the collation␟照合を含むスキーマの名前です。␞␞␞
␝␟Approximate value of <phrase role="symbol_font">&pi;</phrase>␟<phrase role="symbol_font">&pi;</phrase>の近似値␞␞␞
␝␟A code identifying the field type; if zero, this is the message terminator and no string follows. The presently defined field types are listed in <xref linkend="protocol-error-fields"/>. Since more field types might be added in future, frontends should silently ignore fields of unrecognized type.␟フィールド種類を識別するコードです。
ゼロならば、メッセージの終端であり、後続する文字列がないことを表します。
<xref linkend="protocol-error-fields"/>に、現時点でフィールド種類として定義されているものを列挙します。
将来もっと多くのフィールド種類が追加される可能性がありますので、フロントエンドは、認知できない種類のフィールドに対して何もせずに無視すべきです。␞␞␞
␝␟(This won't work as root; do it as an unprivileged user.) See <xref linkend="regress"/> for detailed information about interpreting the test results. You can repeat this test at any later time by issuing the same command.␟（これは root では動作しません。
非特権ユーザとして実行してください。）
<xref linkend="regress"/>にはテスト結果の解釈に関する詳しい情報があります。
同じコマンドを入力することで、後にいつでもテストを繰り返すことができます。␞␞␞
␝␟Then you can use it in a <command>SELECT</command> command, for instance:␟これで、例えば以下のように<command>SELECT</command>コマンドを使うことができます。␞␞␞
␝␟<entry>Support Function 4</entry>␟ <entry>サポート関数 4</entry>␞␞␞
␝␟A page image obtained with <function>get_raw_page</function> should be passed as argument. For example:␟<function>get_raw_page</function>で得られたページイメージを引数として渡さなければなりません。
以下に例を示します。␞␞␞
␝␟* If the user supplies a parameter on the command line, use it as the * conninfo string; otherwise default to setting dbname=postgres and using * environment variables or defaults for all other connection parameters.␟ * ユーザがコマンドラインでパラメータを提供した場合、conninfo文字列として使用する。
     * 提供されない場合はデフォルトでdbname=postgresを使用する。
     * その他の接続パラメータについては環境変数やデフォルトを使用する。␞␞␞
␝␟The OID of the specific referenced object␟特定の参照されるオブジェクトのOID␞␞␞
␝␟Function signature␟関数の呼び出し形式␞␞␞
␝␟<entry>Field</entry>␟ <entry>フィールド</entry>␞␞␞
␝␟<entry><emphasis>not supported as a server encoding</emphasis>␟ <entry><emphasis>サーバの符号化方式としてサポートされていません</emphasis>␞␞␞
␝␟Not the password (always reads as <literal>********</literal>)␟パスワードでありません（常に<literal>********</literal>のように読まれます）␞␞␞
␝␟The LSN of the prepare.␟プリペアドのLSNです。␞␞␞
␝␟The LSN of the commit.␟コミットのLSNです。␞␞␞
␝␟<entry><literal>WITH CHECK expression</literal></entry>␟ <entry><literal>WITH CHECK式</literal></entry>␞␞␞
␝␟<entry>Operator class member</entry>␟ <entry>演算子クラスメンバ</entry>␞␞␞
␝␟If the argument begins with <literal>|</literal>, then the entire remainder of the line is taken to be the <replaceable class="parameter">command</replaceable> to execute, and neither variable interpolation nor backquote expansion are performed in it. The rest of the line is simply passed literally to the shell.␟引数が<literal>|</literal>で始まっている場合、行の残りの部分はすべて実行する<replaceable class="parameter">command</replaceable>であると解釈され、その中では変数の置換も逆引用符の展開も行われません。
行の残り部分は、単にあるがままにシェルに渡されます。␞␞␞
␝␟(references any OID column)␟（いずれかのOID列）␞␞␞
␝␟Name of the database that contains the table that the trigger is defined on (always the current database)␟トリガが定義されたテーブルを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<returnvalue>an integer between 1 and 10</returnvalue>␟ <returnvalue>1と10の間の整数</returnvalue>␞␞␞
␝␟If true (the default when omitted) then an error thrown on the remote side of the connection causes an error to also be thrown locally. If false, the remote error is locally reported as a NOTICE, and the function's return value is set to <literal>ERROR</literal>.␟真（省略時のデフォルト）の場合、接続のリモート側で発生したエラーによりローカル側でもエラーが発生します。
偽の場合リモート側のエラーはローカル側にはNOTICEとして報告され、この関数の戻り値は<literal>ERROR</literal>になります。␞␞␞
␝␟Password expiry time (only used for password authentication)␟パスワード有効期限（パスワード認証でのみ使用）␞␞␞
␝␟<title>Documentation</title>␟ <title>ドキュメンテーション</title>␞␞␞
␝␟<entry>less than</entry>␟ <entry>小なり</entry>␞␞␞
␝␟<title>Installation</title>␟ <title>インストール</title>␞␞␞
␝␟-- some computations here␟ -- ここで演算をいくつか行います。␞␞␞
␝␟<entry>1&ndash;4</entry>␟ <entry>1-4</entry>␞␞␞
␝␟Some examples follow.␟以下に例を示します。␞␞␞
␝␟When two <type>text</type> arguments are given, the first one is first looked up as a persistent connection's name; if found, the command is executed on that connection. If not found, the first argument is treated as a connection info string as for <function>dblink_connect</function>, and the indicated connection is made just for the duration of this command.␟2つの<type>text</type>型の引数が与えられた場合、一番目の引数はまず永続接続の名前を検索するために使われます。
もし見つかれば、コマンドがその接続上で実行されます。
見つからなければ、一番目の引数は<function>dblink_connect</function>用の接続情報文字列として扱われ、このコマンド実行時と同様に指定された接続が開きます。␞␞␞
␝␟<title>Server Configuration</title>␟ <title>サーバ設定</title>␞␞␞
␝␟<title>Backup Control Functions</title>␟ <title>バックアップ制御関数</title>␞␞␞
␝␟(references <link linkend="catalog-pg-statistic-ext-data"><structname>pg_statistic_ext_data</structname></link>.<structfield>stxdinherit</structfield>)␟（参照先 <link linkend="catalog-pg-statistic-ext-data"><structname>pg_statistic_ext_data</structname></link>.<structfield>stxdinherit</structfield>）␞␞␞
␝␟Successful dispatch of the cancellation is no guarantee that the request will have any effect, however. If the cancellation is effective, the command being canceled will terminate early and return an error result. If the cancellation fails (say, because the server was already done processing the command), then there will be no visible result at all.␟キャンセルの送信が成功しても、要求が有効になるとは限りません。
キャンセルが有効な場合、キャンセルされるコマンドは早期に終了し、エラー結果を返します。
キャンセルが失敗した場合 （サーバがコマンドの処理をすでに完了していた場合など）、目に見える結果はまったくありません。␞␞␞
␝␟<returnvalue>t</returnvalue> (rather than <literal>NULL</literal>)␟ <returnvalue>t</returnvalue> (<literal>NULL</literal>ではなく)␞␞␞
␝␟The name (optionally schema-qualified) of an existing text search configuration.␟既存のテキスト検索設定の名称（スキーマ修飾可）です。␞␞␞
␝␟Always <literal>EXECUTE</literal> (the only privilege type for functions)␟常に<literal>EXECUTE</literal>です（関数用の唯一の権限です）。␞␞␞
␝␟<entry><quote>non-printable</quote> octets</entry>␟ <entry><quote>表示できない</quote>オクテット</entry>␞␞␞
␝␟The above transaction will insert both 3 and 4.␟上記のトランザクションでは、3と4の両方が挿入されます。␞␞␞
␝␟The OID of the system catalog this object appears in␟このオブジェクトが現れるシステムカタログのOID␞␞␞
␝␟Name of the connection to use.␟使用する接続名です。␞␞␞
␝␟<entry align="center">Tables, views, and foreign tables</entry>␟ <entry align="center">テーブル、ビューおよび外部テーブル</entry>␞␞␞
␝␟<entry>January 8 in any mode</entry>␟ <entry>すべてのモードで1月8日になります。</entry>␞␞␞
␝␟The possible response messages from the backend are:␟バックエンドから送信される可能性がある応答メッセージを以下に示します。␞␞␞
␝␟If using GCC, all programs and libraries are compiled with code coverage testing instrumentation. When run, they generate files in the build directory with code coverage metrics. See <xref linkend="regress-coverage"/> for more information. This option is for use only with GCC and when doing development work.␟GCCを使用している場合、すべてのプログラムとライブラリはコードカバレッジテスト機構付きでコンパイルされます。
実行すると、これらは構築用ディレクトリ内にコードカバレッジメトリックを持ったファイルを生成します。
詳細は<xref linkend="regress-coverage"/>を参照してください。
このオプションはGCC専用であり、また、開発作業中に使用するためのものです。␞␞␞
␝␟Name of the schema that contains the view␟ビューを持つスキーマの名前です。␞␞␞
␝␟If <literal>data_type</literal> identifies a character or bit string type, the declared maximum length; null for all other data types or if no maximum length was declared.␟<literal>data_type</literal>が文字列またはビット列と識別される場合、その宣言された最大長です。
他のデータ型または最大長が宣言されていない場合はNULLです。␞␞␞
␝␟<entry>less than or equal</entry>␟ <entry>以下</entry>␞␞␞
␝␟Name of the foreign server used by this mapping␟このマッピングに使用される外部サーバ名です。␞␞␞
␝␟<title>Extensibility</title>␟ <title>拡張性</title>␞␞␞
␝␟<entry>Korean</entry>␟ <entry>韓国語</entry>␞␞␞
␝␟(references <link linkend="catalog-pg-tablespace"><structname>pg_tablespace</structname></link>.<structfield>spcname</structfield>)␟（参照先 <link linkend="catalog-pg-tablespace"><structname>pg_tablespace</structname></link>.<structfield>spcname</structfield>）␞␞␞
␝␟Note that this function is also called when inserting routed tuples into a foreign-table partition or executing <command>COPY FROM</command> on a foreign table, in which case it is called in a different way than it is in the <command>INSERT</command> case. See the callback functions described below that allow the FDW to support that.␟この関数は外部テーブルパーティションに転送対象のタプルを挿入する際、あるいは<command>COPY FROM</command>を外部テーブルに対して実行する際にも呼び出されることに注意してください。
<command>COPY FROM</command>の場合、<command>INSERT</command>とはこの関数の呼び出され方は異なります。
FDWがそれをサポートすることを可能にする以下で説明するコールバック関数をご覧ください。␞␞␞
␝␟<title>Introduction</title>␟ <title>はじめに</title>␞␞␞
␝␟The information from the trigger manager is passed to the function body in the following variables:␟トリガマネージャからの情報は、以下の変数内に格納されて関数本体に渡されます。␞␞␞
␝␟<entry>Meaning</entry>␟ <entry>意味</entry>␞␞␞
␝␟<title>Compatibility</title>␟ <title>互換性</title>␞␞␞
␝␟These examples all specify the same address. Upper and lower case is accepted for the digits <literal>a</literal> through <literal>f</literal>. Output is always in the first of the forms shown.␟これらの例はすべて同一のアドレスを指定します。
<literal>a</literal>から<literal>f</literal>までの桁は大文字小文字どちらでも構いません。
出力は常に最初に示された形式となります。␞␞␞
␝␟Name of the database containing the constraint (always the current database)␟制約が含まれるデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<title>Outputs</title>␟ <title>出力</title>␞␞␞
␝␟The following less trivial example writes the Russian word <quote>slon</quote> (elephant) in Cyrillic letters:␟次の少し意味のある例はロシア語の<quote>slon</quote>（象）をキリル文字で書いたものです。␞␞␞
␝␟<title>Statistics</title>␟ <title>統計情報</title>␞␞␞
␝␟<para>The <literal>IF EXISTS</literal> option is an extension.</para>␟ <para><literal>IF EXISTS</literal>オプションは拡張です。</para>␞␞␞
␝␟As with <token>EXISTS</token>, it's unwise to assume that the subquery will be evaluated completely.␟<token>EXISTS</token>と同様、副問い合わせが完全に評価されることを前提としてはなりません。␞␞␞
␝␟<title>System Catalog Information Functions</title>␟ <title>システムカタログ情報関数</title>␞␞␞
␝␟<productname>PostgreSQL</productname>'s text search features are described at length in <xref linkend="textsearch"/>.␟ <productname>PostgreSQL</productname>のテキスト検索機能については<xref linkend="textsearch"/>で詳しく説明します。␞␞␞
␝␟<title>General Functions</title>␟ <title>一般的な関数</title>␞␞␞
␝␟<entry>greater than</entry>␟ <entry>大なり</entry>␞␞␞
␝␟OID of the table for this index␟このインデックスに対応するテーブルのOIDです。␞␞␞
␝␟Create the subscription.␟サブスクリプションを作成します。␞␞␞
␝␟Time at which these statistics were last reset␟統計情報がリセットされた最終時刻です。␞␞␞
␝␟The parameter data type(s) of the function.␟関数のパラメータのデータ型です。␞␞␞
␝␟<title>Object Identifier Types</title>␟ <title>オブジェクト識別子データ型</title>␞␞␞
␝␟Do not display progress messages.␟進行メッセージを表示しません。␞␞␞
␝␟<entry>Support Function 2</entry>␟ <entry>サポート関数 2</entry>␞␞␞
␝␟See the SQL <xref linkend="sql-fetch"/> command for details of the interpretation of the <parameter>direction</parameter> and <parameter>count</parameter> parameters.␟<parameter>direction</parameter>パラメータおよび<parameter>count</parameter>パラメータの解釈の詳細についてはSQL <xref linkend="sql-fetch"/>コマンドを参照してください。␞␞␞
␝␟<title>Genetic Query Optimizer</title>␟ <title>遺伝的問い合わせオプティマイザ</title>␞␞␞
␝␟<title>Predefined Roles</title>␟ <title>定義済みロール</title>␞␞␞
␝␟For more information, see <xref linkend="storage-file-layout"/>.␟詳細については<xref linkend="storage-file-layout"/>を参照してください。␞␞␞
␝␟Natural logarithm␟自然対数␞␞␞
␝␟Process ID of backend.␟バックエンドのプロセスIDです。␞␞␞
␝␟<entry><literal>TH</literal> suffix</entry>␟ <entry><literal>TH</literal>接尾辞</entry>␞␞␞
␝␟<phrase>where <replaceable class="parameter">role_specification</replaceable> can be:</phrase>␟<phrase>ここで<replaceable class="parameter">role_specification</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟The user name of the new owner of the table.␟テーブルの新しい所有者のユーザ名です。␞␞␞
␝␟Current time of day; see <xref linkend="functions-datetime-current"/>␟現在の時刻。<xref linkend="functions-datetime-current"/>を参照。␞␞␞
␝␟For more information, see <xref linkend="ddl-schemas"/>.␟詳細については<xref linkend="ddl-schemas"/>を参照してください。␞␞␞
␝␟<entry>Ignored</entry>␟ <entry>このキーワードは無視されます</entry>␞␞␞
␝␟<title>How It Works</title>␟ <title>どうやって動くのか</title>␞␞␞
␝␟<entry>hour of day (01&ndash;12)</entry>␟ <entry>時 (01&ndash;12)</entry>␞␞␞
␝␟<literal>YES</literal> if the privilege is grantable, <literal>NO</literal> if not␟この権限を付与可能な場合は<literal>YES</literal>、さもなくば<literal>NO</literal>です。␞␞␞
␝␟-- query␟-- 問い合わせ␞␞␞
␝␟/* Put all values in the SELECT list into one structure. */␟ /* SELECTリストの値をすべて1つの構造体に取り込む。 */␞␞␞
␝␟Enables verbose mode.␟冗長モードを有効にします。␞␞␞
␝␟<title>Aggregate Functions</title>␟ <title>集約関数</title>␞␞␞
␝␟The name of the role that the privilege was granted to␟権限が与えられたロールの名前␞␞␞
␝␟row to be copied␟コピーされる行␞␞␞
␝␟Not equal␟不等␞␞␞
␝␟<title>See Also</title>␟ <title>関連項目</title>␞␞␞
␝␟* Should PQclear PGresult whenever it is no longer needed to avoid memory * leaks␟ * メモリリークを避けるため、必要なくなったときにはいつでもPGresultを 
     * PQclearすべき␞␞␞
␝␟Name of this table␟テーブルの名前です。␞␞␞
␝␟<title>Release Notes</title>␟ <title>リリースノート</title>␞␞␞
␝␟Always <literal>USAGE</literal>␟常に<literal>USAGE</literal>です。␞␞␞
␝␟Returns number of bits in the bit string.␟ビット文字列中のビット数を返します。␞␞␞
␝␟<title>Transaction Management</title>␟ <title>トランザクション制御</title>␞␞␞
␝␟<title>Caveats</title>␟ <title>警告</title>␞␞␞
␝␟User name␟ユーザ名␞␞␞
␝␟<entry>6 bytes</entry>␟ <entry>6バイト</entry>␞␞␞
␝␟<title>Interval Input</title>␟ <title>時間間隔の入力</title>␞␞␞
␝␟<entry>Support Procedure 1</entry>␟ <entry>サポートプロシージャ 1</entry>␞␞␞
␝␟<title>Access Privilege Inquiry Functions</title>␟ <title>アクセス権限照会関数</title>␞␞␞
␝␟Name of the database containing the collation (always the current database)␟照合を含むデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<returnvalue></returnvalue> <type>double precision</type> for <type>real</type> or <type>double precision</type>, otherwise <type>numeric</type>␟ <returnvalue></returnvalue> 引数が<type>double precision</type>あるいは<type>real</type>に対しては<type>double precision</type>、それ以外は<type>numeric</type>␞␞␞
␝␟<entry>Support Procedure 3</entry>␟ <entry>サポートプロシージャ 3</entry>␞␞␞
␝␟The name of an existing server.␟既存のサーバの名前です。␞␞␞
␝␟<title>Parameters</title>␟ <title>パラメータ</title>␞␞␞
␝␟<title>Index Support</title>␟ <title>インデックスサポート</title>␞␞␞
␝␟<title>Files</title>␟ <title>ファイル</title>␞␞␞
␝␟<title>Cleaning:</title>␟ <title>クリーニング:</title>␞␞␞
␝␟For more information, see <xref linkend="wal-configuration"/>.␟詳細については<xref linkend="wal-configuration"/>を参照してください。␞␞␞
␝␟Either the 4-digit or the 6-digit escape form can be used to specify UTF-16 surrogate pairs to compose characters with code points larger than U+FFFF, although the availability of the 6-digit form technically makes this unnecessary. (Surrogate pairs are not stored directly, but are combined into a single code point.)␟U+FFFFより大きなコードポイントを持つ文字を構成するUTF-16サロゲートペアを指定するために、4桁と6桁の形式のどちらかを使用できますが、技術的には6桁形式の機能によりこれは不要になります。
（サロゲートペアは直接格納されるわけではなく、一つのコードポイントに結合されます。）␞␞␞
␝␟The data type(s) of the function's arguments (optionally schema-qualified), if any.␟もしあれば、その関数の引数のデータ型（スキーマ修飾可能）です。␞␞␞
␝␟<title>Basic Setup</title>␟ <title>基本的な設定</title>␞␞␞
␝␟/* Assign descriptor to the cursor */␟ /* 記述子をカーソルに割り当てる */␞␞␞
␝␟<title>Window Functions</title>␟ <title>ウィンドウ関数</title>␞␞␞
␝␟Name of the table for this index␟このインデックスに対応するテーブルの名前です。␞␞␞
␝␟Waiting for a response from the server.␟サーバからの応答待ち状態です。␞␞␞
␝␟A connection info string, as previously described for <function>dblink_connect</function>.␟上で<function>dblink_connect</function>で説明した接続情報文字列です。␞␞␞
␝␟<entry>millisecond (000&ndash;999)</entry>␟ <entry>ミリ秒 (000&ndash;999)</entry>␞␞␞
␝␟<title>Session Information Functions</title>␟ <title>セッション情報関数</title>␞␞␞
␝␟<title>Recovery Control Functions</title>␟ <title>リカバリ制御関数</title>␞␞␞
␝␟Name of the schema that contains the constraint␟制約を持つスキーマの名前です。␞␞␞
␝␟The label provider associated with this label.␟このラベルに関連付いたラベルプロバイダです。␞␞␞
␝␟<entry>January 8, except error in <literal>YMD</literal> mode</entry>␟ <entry>1月8日。ただし<literal>YMD</literal>モードではエラー。</entry>␞␞␞
␝␟The <function>options</function> function is passed a pointer to a <structname>local_relopts</structname> struct, which needs to be filled with a set of operator class specific options. The options can be accessed from other support functions using the <literal>PG_HAS_OPCLASS_OPTIONS()</literal> and <literal>PG_GET_OPCLASS_OPTIONS()</literal> macros.␟<function>options</function>関数には<structname>local_relopts</structname>構造体へのポインタが渡されますが、構造体を演算子クラスに固有のオプションの集合で満たすことが必要です。
オプションはマクロ<literal>PG_HAS_OPCLASS_OPTIONS()</literal>と<literal>PG_GET_OPCLASS_OPTIONS()</literal>を使って他のサポート関数からアクセスできます。␞␞␞
␝␟If there are both <type>unknown</type> and known-type arguments, and all the known-type arguments have the same type, assume that the <type>unknown</type> arguments are also of that type, and check which candidates can accept that type at the <type>unknown</type>-argument positions. If exactly one candidate passes this test, use it. Otherwise, fail.␟もし<type>unknown</type>と既知の型の引数の両方があり、そして全ての既知の型の引数が同じ型を持っていた場合、<type>unknown</type>引数も同じ型であると仮定し、
どの候補が<type>unknown</type>引数の位置にある型を受け付けることができるかを検査します。
正確に1つの候補がこの検査を通過した場合、それを使います。それ以外は失敗します。␞␞␞
␝␟<entry>User name</entry>␟ <entry>ユーザ名</entry>␞␞␞
␝␟<entry>ISO 8601, with time zone as UTC offset</entry>␟ <entry>ISO 8601, UTC オフセットとしてのタイムゾーン</entry>␞␞␞
␝␟Name of the database that contains the table (always the current database)␟テーブルを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>1 byte</entry>␟ <entry>1バイト</entry>␞␞␞
␝␟Setting this value to <xref linkend="guc-geqo-threshold"/> or more may trigger use of the GEQO planner, resulting in non-optimal plans. See <xref linkend="runtime-config-query-geqo"/>.␟この値を<xref linkend="guc-geqo-threshold"/>か、それ以上に設定するとGEQOプランナ使用の誘引となり、最適ではない計画をもたらします。<xref linkend="runtime-config-query-geqo"/>を参照してください。␞␞␞
␝␟Converts a date to a C char* string.␟date型をC char*文字列に変換します。␞␞␞
␝␟(references <link linkend="catalog-pg-statistic-ext"><structname>pg_statistic_ext</structname></link>.<structfield>stxname</structfield>)␟（参照先 <link linkend="catalog-pg-statistic-ext"><structname>pg_statistic_ext</structname></link>.<structfield>stxname</structfield>）␞␞␞
␝␟<title>Geometric Types</title>␟ <title>幾何データ型</title>␞␞␞
␝␟<entry>upper case ordinal number suffix</entry>␟ <entry>大文字による序数接尾辞</entry>␞␞␞
␝␟The server's system clock at the time of transmission, as microseconds since midnight on 2000-01-01.␟転送時点でのサーバのシステム時刻。
2000年1月1日午前0時からのマイクロ秒。␞␞␞
␝␟This option disables the use of dollar quoting for function bodies, and forces them to be quoted using SQL standard string syntax.␟このオプションは、関数本体用のドル引用符の使用を無効にし、強制的に標準SQLの文字列構文を使用した引用符付けを行います。␞␞␞
␝␟<entry>Central European</entry>␟ <entry>中央ヨーロッパ</entry>␞␞␞
␝␟if <literal>true</literal>, raise error if the query is not of a kind that returns tuples (this does not forbid the case where it happens to return zero tuples)␟<literal>true</literal>であれば、問い合わせがタプルを返す種類のものでない場合にエラーを発生します(これはたまたま0個のタプルを返す場合を禁止しません)␞␞␞
␝␟<title>Options</title>␟ <title>オプション</title>␞␞␞
␝␟<title>How to Use It</title>␟ <title>使用方法</title>␞␞␞
␝␟(references <link linkend="catalog-pg-proc"><structname>pg_proc</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-proc"><structname>pg_proc</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟These functions can only be executed if the SPI connection has been set as nonatomic in the call to <function>SPI_connect_ext</function>.␟これらの関数はSPI接続が<function>SPI_connect_ext</function>の呼び出しで非原子的と設定されている場合のみ、実行できます。␞␞␞
␝␟Server name of the user mapping.␟ユーザマップのサーバ名です。␞␞␞
␝␟<entry><literal>FM</literal> prefix</entry>␟ <entry><literal>FM</literal>接頭辞</entry>␞␞␞
␝␟<phrase>where <replaceable class="parameter">event</replaceable> can be one of:</phrase>␟<phrase>ここで<replaceable class="parameter">event</replaceable>は以下の一つです。</phrase>␞␞␞
␝␟Name of the default collation␟デフォルト照合の名前です。␞␞␞
␝␟<entry>Support Procedure 11</entry>␟ <entry>サポートプロシージャ 11</entry>␞␞␞
␝␟<title>Using Cursors</title>␟ <title>カーソルの使用</title>␞␞␞
␝␟This command conforms to the SQL standard, with these <productname>PostgreSQL</productname> extensions:␟このコマンドは標準SQLに準拠していますが、以下の<productname>PostgreSQL</productname>の拡張があります。␞␞␞
␝␟<entry>Contents</entry>␟ <entry>内容</entry>␞␞␞
␝␟<entry>Indexable Operators</entry>␟ <entry>インデックス可能な演算子</entry>␞␞␞
␝␟Do not output commands to set <acronym>TOAST</acronym> compression methods. With this option, all columns will be restored with the default compression setting.␟<acronym>TOAST</acronym>圧縮方式を設定するコマンドを出力しません。
このオプションにより、列はすべてデフォルトの圧縮の設定でリストアされます。␞␞␞
␝␟Connection OK; waiting to send.␟接続はOKです。送信待ち状態です。␞␞␞
␝␟Attribute numbers (1-based) of the primary key fields, for example <literal>1 2</literal>.␟例えば<literal>1 2</literal>といった、主キーフィールドの属性番号（1始まり）です。␞␞␞
␝␟This command is primarily intended for use in plain-text dumps generated by <application>pg_dump</application>, <application>pg_dumpall</application>, and <application>pg_restore</application>, but it may be useful elsewhere.␟《機械翻訳》このコマンドは、主に<application>pg_dump</application>、<application>pg_dumpall</application>、および<application>pg_restore</application>で生成されるプレーンテキストダンプでの使用を目的としていますが、他の場所でも役立つ場合があります。␞␞␞
␝␟<title>Data Validity Checking Functions</title>␟ <title>データ有効性検証関数</title>␞␞␞
␝␟<entry>Same as above</entry>␟ <entry>同上</entry>␞␞␞
␝␟<literal>YES</literal> if the constraint is deferrable, <literal>NO</literal> if not␟制約が遅延可能ならば<literal>YES</literal>。さもなくば<literal>NO</literal>。␞␞␞
␝␟<entry>Identifier</entry>␟ <entry>識別子</entry>␞␞␞
␝␟(references <link linkend="catalog-pg-authid"><structname>pg_authid</structname></link>.<structfield>rolname</structfield>)␟（参照先 <link linkend="catalog-pg-authid"><structname>pg_authid</structname></link>.<structfield>rolname</structfield>）␞␞␞
␝␟The name of a column to be created in the new table.␟新しいテーブルで作成される列の名前です。␞␞␞
␝␟Name of the column data type (the underlying type of the domain, if applicable)␟列データ型（もし適用されていたら背後にあるドメインの型）の名前です。␞␞␞
␝␟Name of the foreign table␟外部テーブルの名前です。␞␞␞
␝␟(references <link linkend="catalog-pg-tablespace"><structname>pg_tablespace</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-tablespace"><structname>pg_tablespace</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<option>e2fs</option> to use the UUID library created by the <literal>e2fsprogs</literal> project; this library is present in most Linux systems and in macOS, and can be obtained for other platforms as well␟<option>e2fs</option>は<literal>e2fsprogs</literal>プロジェクトで作られたUUIDライブラリを使います。
このライブラリはたいていのLinuxシステムとmacOSにあり、また、その他のプラットフォームでも入手可能です。␞␞␞
␝␟from the SQL environment, or:␟をSQL環境から実行するか、または␞␞␞
␝␟<title>Trigger Functions</title>␟ <title>トリガ関数</title>␞␞␞
␝␟An error has occurred.␟エラーが起こりました。␞␞␞
␝␟Commit timestamp of the transaction. The value is in number of microseconds since PostgreSQL epoch (2000-01-01).␟トランザクションのコミット時刻です。
その値はPostgreSQLのエポック（2000-01-01）からのマイクロ秒数です。␞␞␞
␝␟<title>Composite Types</title>␟ <title>複合型</title>␞␞␞
␝␟(references <link linkend="catalog-pg-database"><structname>pg_database</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-database"><structname>pg_database</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟The table this column belongs to␟この列が属するテーブル␞␞␞
␝␟<title>Security</title>␟ <title>セキュリティ</title>␞␞␞
␝␟Always <literal>TYPE USAGE</literal>␟常に<literal>TYPE USAGE</literal>␞␞␞
␝␟<entry>Database name</entry>␟ <entry>データベース名</entry>␞␞␞
␝␟The name of the role that granted the privilege␟権限を与えたロールの名前␞␞␞
␝␟<refpurpose>commit the current transaction</refpurpose>␟ <refpurpose>現在のトランザクションをコミットする</refpurpose>␞␞␞
␝␟Role can create databases␟ロールはデータベースを作成できる␞␞␞
␝␟<entry>equal</entry>␟ <entry>等しい</entry>␞␞␞
␝␟The <literal>DEFERRABLE</literal> <replaceable class="parameter">transaction_mode</replaceable> is a <productname>PostgreSQL</productname> language extension.␟<literal>DEFERRABLE</literal> <replaceable class="parameter">transaction_mode</replaceable>は<productname>PostgreSQL</productname>の言語拡張です。␞␞␞
␝␟an array of length <parameter>nargs</parameter>, containing the actual parameter values␟実パラメータ値を含む、<parameter>nargs</parameter>長の配列␞␞␞
␝␟This function exists but is not implemented at the moment!␟この関数は存在しますが、現在実装されていません。␞␞␞
␝␟Role name␟ロール名␞␞␞
␝␟Name of the schema that this table is in␟テーブルが存在するスキーマの名前です。␞␞␞
␝␟-- possibly some other data preparation work␟-- その他のデータ準備操作を行うこともあります。␞␞␞
␝␟Name of the trigger␟トリガの名前です。␞␞␞
␝␟<title>Numeric Types</title>␟ <title>数値データ型</title>␞␞␞
␝␟Role bypasses every row-level security policy, see <xref linkend="ddl-rowsecurity"/> for more information.␟すべての行単位セキュリティポリシーを無視するロール。詳しくは<xref linkend="ddl-rowsecurity"/>を参照してください。␞␞␞
␝␟<entry>unlimited</entry>␟ <entry>無制限</entry>␞␞␞
␝␟<title><productname>PostgreSQL</productname> Features</title>␟ <title><productname>PostgreSQL</productname>の機能</title>␞␞␞
␝␟<title>Functional Dependencies</title>␟ <title>関数従属性</title>␞␞␞
␝␟The <acronym>SQL</acronym> declaration of the function must look like this:␟この関数の<acronym>SQL</acronym>宣言は以下のようになります。␞␞␞
␝␟<entry>currency amount</entry>␟ <entry>貨幣金額</entry>␞␞␞
␝␟<title>Authors</title>␟ <title>作者</title>␞␞␞
␝␟<title>Implementation</title>␟ <title>実装</title>␞␞␞
␝␟<entry>Support Procedure 4</entry>␟ <entry>サポートプロシージャ 4</entry>␞␞␞
␝␟<title>Changes</title>␟ <title>変更点</title>␞␞␞
␝␟<title>Subscribers</title>␟ <title>サブスクライバー</title>␞␞␞
␝␟string containing command to execute␟実行するコマンドを含む文字列。␞␞␞
␝␟If no compression level is specified, the default compression level will be used. If only a level is specified without mentioning an algorithm, <literal>gzip</literal> compression will be used if the level is greater than 0, and no compression will be used if the level is 0.␟圧縮レベルが指定されていない場合、デフォルトの圧縮レベルが使用されます。
アルゴリズムを指定せずにレベルのみが指定されている場合、レベルが0より大きい場合は<literal>gzip</literal>圧縮が使用され、レベルが0の場合は圧縮が使用されません。␞␞␞
␝␟A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞␞
␝␟A typical workflow looks like this:␟典型的な作業の流れは以下のようになります。␞␞␞
␝␟Data type of the sequence␟シーケンスのデータ型␞␞␞
␝␟<title>General Performance</title>␟ <title>性能一般</title>␞␞␞
␝␟Reload with:␟元に戻すには次のようにします。␞␞␞
␝␟<title>Server Applications</title>␟ <title>サーバアプリケーション</title>␞␞␞
␝␟<title>Visibility of Data Changes</title>␟ <title>データ変更の可視性</title>␞␞␞
␝␟<title>libc Collations</title>␟ <title>libc照合順序</title>␞␞␞
␝␟If you do use a literal string, keep in mind that any double quotes you might wish to include in the SQL statement must be written as octal escapes (<literal>\042</literal>) not the usual C idiom <literal>\"</literal>. This is because the string is inside an <literal>EXEC SQL</literal> section, so the ECPG lexer parses it according to SQL rules not C rules. Any embedded backslashes will later be handled according to C rules; but <literal>\"</literal> causes an immediate syntax error because it is seen as ending the literal.␟どうしてもリテラル文字列を使う場合には、SQL文に含める二重引用符は、通常のCのイディオムである<literal>\"</literal>ではなく、8進エスケープ(<literal>\042</literal>)として書かなければならないことを心に留めておいてください。
これは文字列が<literal>EXEC SQL</literal>内にあるからで、そのためECPG字句解析器はCの規則ではなくSQLの規則に従って解析します。
埋め込まれたバックスラッシュは後でCの規則に従って扱われます。ですが、<literal>\"</literal>はリテラルの終了とみなされますので、すぐに文法エラーを引き起こします。␞␞␞
␝␟The OID of the large object.␟ラージオブジェクトのOIDです。␞␞␞
␝␟(references <link linkend="catalog-pg-collation"><structname>pg_collation</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-collation"><structname>pg_collation</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<entry align="center">with sync on</entry>␟ <entry align="center">同期が有効の場合</entry>␞␞␞
␝␟<title>Concepts</title>␟ <title>概念</title>␞␞␞
␝␟command string␟コマンド文字列␞␞␞
␝␟<entry>user-specified precision, exact</entry>␟ <entry>ユーザ指定精度、正確</entry>␞␞␞
␝␟prepared statement (returned by <function>SPI_prepare</function>)␟（<function>SPI_prepare</function>で返される）準備済み文␞␞␞
␝␟Name of the table␟テーブルの名前です。␞␞␞
␝␟Name of the schema that contains the table␟テーブルを持つスキーマの名前です。␞␞␞
␝␟<entry>Existing row</entry>␟ <entry>既存の行</entry>␞␞␞
␝␟The <quote>specific name</quote> of the function. See <xref linkend="infoschema-routines"/> for more information.␟関数の<quote>仕様名称</quote>です。
詳細は<xref linkend="infoschema-routines"/>を参照してください。␞␞␞
␝␟<title>Credits</title>␟ <title>クレジット</title>␞␞␞
␝␟Name of the type␟型の名前␞␞␞
␝␟Name of the role that the privilege was granted to␟権限を与えられたロールの名前です。␞␞␞
␝␟<entry>New row</entry>␟ <entry>新しい行</entry>␞␞␞
␝␟The <literal>WITH</literal> clause is a <productname>PostgreSQL</productname> extension; storage parameters are not in the standard.␟<literal>WITH</literal>句は<productname>PostgreSQL</productname>の拡張です。
格納パラメータは標準にはありません。␞␞␞
␝␟<title>Return Value</title>␟ <title>戻り値</title>␞␞␞
␝␟<refpurpose>define a cursor</refpurpose>␟ <refpurpose>カーソルを定義する</refpurpose>␞␞␞
␝␟Name of the database that contains the table that contains the column (always the current database)␟その列を含むテーブルを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟The output columns are:␟出力列は以下の通りです。␞␞␞
␝␟<para>Module for storing (key, value) pairs</para>␟ <para>（キー、値）の組み合わせを格納するモジュール</para>␞␞␞
␝␟The field value.␟フィールド値です。␞␞␞
␝␟Namespace (empty string for <literal>pg_catalog</literal>).␟名前空間（<literal>pg_catalog</literal>の場合は空文字列）。␞␞␞
␝␟(references <link linkend="catalog-pg-class"><structname>pg_class</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-class"><structname>pg_class</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟Name of the database containing the function (always the current database)␟関数が含まれるデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟Current time of day, with limited precision; see <xref linkend="functions-datetime-current"/>␟精度を限定した現在の時刻。<xref linkend="functions-datetime-current"/>を参照。␞␞␞
␝␟The operator family this entry is for␟この項目用の演算子族␞␞␞
␝␟<title>Client Interfaces</title>␟ <title>クライアントインタフェース</title>␞␞␞
␝␟(see note)␟（注記を参照）␞␞␞
␝␟<entry>microsecond (000000&ndash;999999)</entry>␟ <entry>マイクロ秒 (000000&ndash;999999)</entry>␞␞␞
␝␟<title>SQL/JSON Query Functions</title>␟ <title>SQL/JSON問い合わせ関数</title>␞␞␞
␝␟<title>Diagnostics</title>␟ <title>診断</title>␞␞␞
␝␟If <literal>data_type</literal> identifies a numeric type, this column indicates in which base the values in the columns <literal>numeric_precision</literal> and <literal>numeric_scale</literal> are expressed. The value is either 2 or 10. For all other data types, this column is null.␟<literal>data_type</literal>が数値型と識別される場合、この列は、<literal>numeric_precision</literal>および<literal>numeric_scale</literal>で表現される値の基が何かを示します。
この値は2または10です。
他の全ての型の場合では、この列はNULLです。␞␞␞
␝␟<entry>Phase</entry>␟ <entry>フェーズ</entry>␞␞␞
␝␟<entry>right</entry>␟ <entry>右</entry>␞␞␞
␝␟This function should be called with the same arguments as the return attributes of <function>heap_page_items</function>.␟この関数は<function>heap_page_items</function>の戻り値の属性と同じ引数で呼び出してください。␞␞␞
␝␟<title>Regression Tests</title>␟ <title>リグレッションテスト</title>␞␞␞
␝␟<entry align="center">with sync off</entry>␟ <entry align="center">同期が無効の場合</entry>␞␞␞
␝␟<title>Merge Support Functions</title>␟ <title>マージサポート関数</title>␞␞␞
␝␟This clause is only provided for compatibility with non-standard SQL databases. Its use is discouraged in new applications.␟この句は非標準的なSQLデータベースとの互換性のためだけに提供されています。
新しいアプリケーションでこれを使用するのはお勧めしません。␞␞␞
␝␟Connect over TCP/IP␟TCP/IPを介した接続。␞␞␞
␝␟Session defaults for run-time configuration variables␟実行時設定変数のセッションデフォルト␞␞␞
␝␟Name of the database containing the table (always the current database)␟テーブルを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>Percentage of free space</entry>␟ <entry>空き領域の割合</entry>␞␞␞
␝␟For a security label on a table column, this is the column number (the <structfield>objoid</structfield> and <structfield>classoid</structfield> refer to the table itself). For all other object types, this column is zero.␟テーブル列上のセキュリティラベルでは、これは列番号です（<structfield>objoid</structfield>および<structfield>classoid</structfield>はテーブル自身を参照します）。
他のすべての種類のオブジェクトでは、この列はゼロです。␞␞␞
␝␟<entry>Cyrillic</entry>␟ <entry>キリル文字</entry>␞␞␞
␝␟Name of the object␟オブジェクトの名前です。␞␞␞
␝␟<entry>Style Specification</entry>␟ <entry>形式指定</entry>␞␞␞
␝␟<title>System Views</title>␟ <title>システムビュー</title>␞␞␞
␝␟<title>Limitations</title>␟ <title>制限事項</title>␞␞␞
␝␟Cube root␟立方根␞␞␞
␝␟Usually, a row reflecting an incorrect entry will have values for only the <structfield>line_number</structfield> and <structfield>error</structfield> fields.␟不正なエントリに対応する行は、通常は<structfield>line_number</structfield>フィールドと<structfield>error</structfield>フィールドにのみ値が入ります。␞␞␞
␝␟Type of the privilege: <literal>SELECT</literal>, <literal>INSERT</literal>, <literal>UPDATE</literal>, or <literal>REFERENCES</literal>␟権限の種類です。
<literal>SELECT</literal>、<literal>INSERT</literal>、<literal>UPDATE</literal>、もしくは<literal>REFERENCES</literal>です。␞␞␞
␝␟This option is for use by in-place upgrade utilities. Its use for other purposes is not recommended or supported. The behavior of the option may change in future releases without notice.␟このオプションは現位置でのアップグレード用のユーティリティにより使用されるものです。
他の目的での使用は推奨されませんし、サポートもされません。
このオプションの動作は、将来通知することなく変更される可能性があります。␞␞␞
␝␟The name of the index method this operator family is for.␟演算子族が対象とするインデックスメソッドの名前です。␞␞␞
␝␟<entry>1 microsecond</entry>␟ <entry>1マイクロ秒</entry>␞␞␞
␝␟<phrase>where <replaceable class="parameter">publication_object</replaceable> is one of:</phrase>␟<phrase>ここで<replaceable class="parameter">publication_object</replaceable>は以下のいずれかです。</phrase>␞␞␞
␝␟<title>Network Address Types</title>␟ <title>ネットワークアドレス型</title>␞␞␞
␝␟Increment value of the sequence␟シーケンスの増分値␞␞␞
␝␟<entry>0 to 31 and 127 to 255</entry>␟ <entry>0から31まで、および127から255まで</entry>␞␞␞
␝␟Name of the constraint␟制約の名前です。␞␞␞
␝␟Returns the number of points. Available for <type>path</type>, <type>polygon</type>.␟点の数を返します。
<type>path</type>、<type>polygon</type>で利用可能です。␞␞␞
␝␟The long version is the rest of this <phrase>section</phrase>.␟<phrase>この節</phrase>の残りで詳細を説明します。␞␞␞
␝␟<title>Replication Slots</title>␟ <title>レプリケーションスロット</title>␞␞␞
␝␟input relation␟入力リレーション␞␞␞
␝␟OID of this index␟インデックスのOIDです。␞␞␞
␝␟where the members are defined as follows:␟メンバは下記のように定義されています。␞␞␞
␝␟<entry>Ordering Operators</entry>␟ <entry>順序付け演算子</entry>␞␞␞
␝␟User can create databases␟ユーザはデータベースを作成可能です。␞␞␞
␝␟<title>Generic File Access Functions</title>␟ <title>汎用ファイルアクセス関数</title>␞␞␞
␝␟Xid of the transaction (only present for streamed transactions). This field is available since protocol version 2.␟トランザクションのxid（ストリームトランザクションのためにのみ存在します）。
このフィールドはプロトコルバージョン2以降で利用可能です。␞␞␞
␝␟<entry>Percentage of live tuples</entry>␟ <entry>有効タプルの割合</entry>␞␞␞
␝␟<title>Built-in Operator Classes</title>␟ <title>組み込み演算子クラス</title>␞␞␞
␝␟Current date and time (start of current transaction); see <xref linkend="functions-datetime-current"/>␟現在の日付と時刻（現在のトランザクションの開始時）。<xref linkend="functions-datetime-current"/>を参照。␞␞␞
␝␟Name of the database that contains the trigger (always the current database)␟トリガを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟A code defining the specific semantics of this dependency relationship; see text␟この依存関係の特定のセマンティクスを定義するコード（後述）␞␞␞
␝␟<entry>Function</entry>␟ <entry>関数</entry>␞␞␞
␝␟For roles that can log in, this sets maximum number of concurrent connections this role can make. -1 means no limit.␟ログイン可能なロールでは、これはロールが確立できる同時実行接続数を設定します。
-1は制限無しを意味します。␞␞␞
␝␟<title>Rationale</title>␟ <title>原理</title>␞␞␞
␝␟Only superusers and users with the appropriate <literal>SET</literal> privilege can change this setting.␟この設定を変更できるのは、スーパーユーザと適切な<literal>SET</literal>権限を持つユーザだけです。␞␞␞
␝␟<title>Sepgsql Functions</title>␟ <title>sepgsql関数</title>␞␞␞
␝␟<entry>7 or 19 bytes</entry>␟ <entry>7もしくは19バイト</entry>␞␞␞
␝␟Changing cluster options acquires a <literal>SHARE UPDATE EXCLUSIVE</literal> lock.␟clusterオプションの変更は<literal>SHARE UPDATE EXCLUSIVE</literal>ロックを取得します。␞␞␞
␝␟The format codes to be used for each column. Each must presently be zero (text) or one (binary). All must be zero if the overall copy format is textual.␟各列で使用される書式コードです。
現在それぞれは0（テキスト）または1（バイナリ）でなければなりません。
コピー全体の書式がテキストの場合、すべてが0でなければなりません。␞␞␞
␝␟Arbitrary text that serves as the description of this object␟このオブジェクトの説明となる任意のテキスト␞␞␞
␝␟/* Data from current inner tuple */ bool allTheSame; /* tuple is marked all-the-same? */ bool hasPrefix; /* tuple has a prefix? */ Datum prefixDatum; /* if so, the prefix value */ int nNodes; /* number of nodes in the inner tuple */ Datum *nodeLabels; /* node label values (NULL if none) */␟ /* 現在の内部タプルからのデータ */
    bool        allTheSame;     /* タプルはall-the-sameと印が付けられているか？ */
    bool        hasPrefix;      /* タプルは接頭辞を持つか？ */
    Datum       prefixDatum;    /* もしそうなら、接頭辞の値 */
    int         nNodes;         /* 内部タプルの中のノード数 */
    Datum      *nodeLabels;     /* ノードのラベルの値（なければNULL） */␞␞␞
␝␟If a language is installed into <literal>template1</literal>, all subsequently created databases will have the language installed automatically.␟言語を<literal>template1</literal>にインストールすると、その後に作成されるデータベース全てにその言語は自動的にインストールされます。␞␞␞
␝␟<phrase>where <replaceable>aggregate_signature</replaceable> is:</phrase>␟<phrase>ここで<replaceable>aggregate_signature</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟This command will work independent of whether <literal>foo</literal> is an aggregate, function, or procedure.␟このコマンドは<literal>foo</literal>が集約、関数、プロシージャの何れであるかによらず動作します。␞␞␞
␝␟Defines a set of user-visible parameters that control operator class behavior.␟演算子クラスの振舞いを制御するユーザに可視のパラメータの集合を定義します。␞␞␞
␝␟The security label applied to this object.␟このオブジェクトに適用されるセキュリティラベルです。␞␞␞
␝␟Run through all candidates and keep those with the most exact matches on input types. Keep all candidates if none have exact matches. If only one candidate remains, use it; else continue to the next step.␟全ての候補を検索し、入力型に最も正確に合うものを残します。
正確に合うものが何もなければ全ての候補を残します。
1つの候補しか残らない場合、それを使います。
それ以外の場合は次の段階に進みます。␞␞␞
␝␟When specifying a parameter of type <type>boolean</type>, the <literal>=</literal> <replaceable class="parameter">value</replaceable> part can be omitted, which is equivalent to specifying <literal>TRUE</literal>.␟<type>boolean</type>型のパラメータを指定する場合、<literal>=</literal> <replaceable class="parameter">value</replaceable>の部分を省略できます。これは<literal>TRUE</literal>を指定するのと同じです。␞␞␞
␝␟<entry>4 bytes</entry>␟ <entry>4バイト</entry>␞␞␞
␝␟<returnvalue></returnvalue> same type as input␟ <returnvalue></returnvalue>入力と同じ型␞␞␞
␝␟<title>Developer Options</title>␟ <title>開発者向けオプション</title>␞␞␞
␝␟Waiting to receive the results of a query from a remote server.␟リモートサーバから問い合わせの結果を受信するのを待機しています。␞␞␞
␝␟Callers should always zero out the entire <parameter>options</parameter> struct, then fill whichever fields they want to set. This ensures forward compatibility of code, since any fields that are added to the struct in future will be defined to behave backwards-compatibly if they are zero. The currently available <parameter>options</parameter> fields are:␟呼び出し元は、必ず<parameter>options</parameter>構造体全体をゼロクリアしてから、設定したいフィールドを埋めるべきです。
構造体に将来追加されるフィールドは、ゼロであれば後方互換性があるように振る舞うよう定義されますので、これはコードの将来の互換性を確実にします。
現在利用可能な<parameter>options</parameter>フィールドは以下の通りです。␞␞␞
␝␟input row description␟入力行の記述␞␞␞
␝␟<entry align="center">table rows</entry>␟ <entry align="center">テーブル行</entry>␞␞␞
␝␟<title>Snapshot Synchronization Functions</title>␟ <title>スナップショット同期関数</title>␞␞␞
␝␟For more information, see <xref linkend="wal-internals"/>.␟詳細については<xref linkend="wal-internals"/>を参照してください。␞␞␞
␝␟<title>Server</title>␟ <title>サーバ</title>␞␞␞
␝␟<title>Acknowledgments</title>␟ <title>謝辞</title>␞␞␞
␝␟Name of the foreign server␟外部サーバの名前␞␞␞
␝␟The default name of the Kerberos service principal used by GSSAPI. <literal>postgres</literal> is the default. There's usually no reason to change this unless you are building for a Windows environment, in which case it must be set to upper case <literal>POSTGRES</literal>.␟GSSAPIで使用されるKerberosのサービスプリンシパルのデフォルトの名前です。
デフォルトでは<literal>postgres</literal>です。
これを変える理由はWindows環境のために構築しているのでない限り、特にありません。
Windows環境のために構築している場合は大文字の<literal>POSTGRES</literal>に設定する必要があります。␞␞␞
␝␟<entry align="center">Tables and foreign tables</entry>␟ <entry align="center">テーブルおよび外部テーブル</entry>␞␞␞
␝␟<entry><replaceable>day</replaceable>/<replaceable>month</replaceable>/<replaceable>year</replaceable></entry>␟ <entry><replaceable>day</replaceable>（日）/<replaceable>month</replaceable>（月）/<replaceable>year</replaceable>（年）</entry>␞␞␞
␝␟pass-through argument for <parameter>parserSetup</parameter>␟<parameter>parserSetup</parameter>に渡される引数␞␞␞
␝␟(references <link linkend="catalog-pg-type"><structname>pg_type</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-type"><structname>pg_type</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<title>Character Types</title>␟ <title>文字型</title>␞␞␞
␝␟<title>Release date:</title>␟ <title>リリース日:</title>␞␞␞
␝␟In the dollar-quoting approach, this becomes:␟ドル引用符を用いる時は、次のようになります。␞␞␞
␝␟New name for the table.␟テーブルの新しい名前です。␞␞␞
␝␟<entry>Strategy Number</entry>␟ <entry>ストラテジ番号</entry>␞␞␞
␝␟<title>Notes</title>␟ <title>注釈</title>␞␞␞
␝␟Always null, since this information is not applied to array element data types in <productname>PostgreSQL</productname>␟常にNULLです。
この情報は、<productname>PostgreSQL</productname>における配列要素のデータ型には当てはまらないからです。␞␞␞
␝␟Do not dump security labels.␟セキュリティラベルをダンプしません。␞␞␞
␝␟<entry>up to 131072 digits before the decimal point; up to 16383 digits after the decimal point</entry>␟ <entry>小数点より上は131072桁まで、小数点より下は16383桁まで</entry>␞␞␞
␝␟<title>Multivariate N-Distinct Counts</title>␟ <title>多変量N個別値計数</title>␞␞␞
␝␟Identifies the following TupleData message as a new tuple.␟以下のTupleDataメッセージが新しいタプルであることを識別します。␞␞␞
␝␟Specifies the host name of the machine on which the server is running. If the value begins with a slash, it is used as the directory for the Unix-domain socket.␟サーバが稼働しているマシンのホスト名を指定します。
この値がスラッシュから始まる場合、Unixドメインソケット用のディレクトリとして使用されます。␞␞␞
␝␟<title>Foreign Keys</title>␟ <title>外部キー</title>␞␞␞
␝␟<entry>Input</entry>␟ <entry>入力</entry>␞␞␞
␝␟* WRONG␟ * 間違い␞␞␞
␝␟<option>ossp</option> to use the <ulink url="http://www.ossp.org/pkg/lib/uuid/">OSSP UUID library</ulink>␟<option>ossp</option>は<ulink url="http://www.ossp.org/pkg/lib/uuid/">OSSP UUIDライブラリ</ulink>を使用します。␞␞␞
␝␟<entry>Type</entry>␟ <entry>型</entry>␞␞␞
␝␟(references <link linkend="catalog-pg-foreign-server"><structname>pg_foreign_server</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-foreign-server"><structname>pg_foreign_server</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟(references <link linkend="catalog-pg-constraint"><structname>pg_constraint</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-constraint"><structname>pg_constraint</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟Specifies whether the selected option should be turned on or off. You can write <literal>TRUE</literal>, <literal>ON</literal>, or <literal>1</literal> to enable the option, and <literal>FALSE</literal>, <literal>OFF</literal>, or <literal>0</literal> to disable it. The <replaceable class="parameter">boolean</replaceable> value can also be omitted, in which case <literal>TRUE</literal> is assumed.␟選択したオプションを有効にするか無効にするか指定します。
オプションを有効にする場合には<literal>TRUE</literal>、<literal>ON</literal>または<literal>1</literal>と書くことができ、無効にする場合には<literal>FALSE</literal>、<literal>OFF</literal>または<literal>0</literal>と書くことができます。
<replaceable class="parameter">boolean</replaceable>の値は省略することもでき、その場合には<literal>TRUE</literal>とみなされます。␞␞␞
␝␟<title>Example</title>␟ <title>例</title>␞␞␞
␝␟Name of the schema containing the function␟関数が含まれるスキーマの名前です。␞␞␞
␝␟<refpurpose>execute a statement prepared by <function>SPI_prepare</function></refpurpose>␟ <refpurpose><function>SPI_prepare</function>で準備された文を実行する</refpurpose>␞␞␞
␝␟Allowed, but not in PG␟許容されるが、PostgreSQLでは発生しない␞␞␞
␝␟Identifies the message as an authentication request.␟認証要求としてメッセージを識別します。␞␞␞
␝␟Start value of the sequence␟シーケンスの開始値␞␞␞
␝␟<entry>Japanese</entry>␟ <entry>日本語</entry>␞␞␞
␝␟If <literal>data_type</literal> identifies a character type, the maximum possible length in octets (bytes) of a datum; null for all other data types. The maximum octet length depends on the declared character maximum length (see above) and the server encoding.␟<literal>data_type</literal>が文字列と識別される場合、オクテット（バイト）単位で表したデータの最大長です。
他のデータ型ではNULLです。
最大オクテット長は宣言された文字最大長(上述)とサーバ符号化方式に依存します。␞␞␞
␝␟Length of message contents in bytes, including self.␟自身を含むメッセージ内容のバイト単位の長さ。␞␞␞
␝␟<refpurpose>define a new data type</refpurpose>␟ <refpurpose>新しいデータ型を定義する</refpurpose>␞␞␞
␝␟Name of the table that is used by the function␟関数で使用されるテーブルの名前です。␞␞␞
␝␟<refpurpose>move a cursor</refpurpose>␟ <refpurpose>カーソルを移動する</refpurpose>␞␞␞
␝␟<title>Installing the Files</title>␟ <title>ファイルのインストール</title>␞␞␞
␝␟<entry>Turkish</entry>␟ <entry>トルコ</entry>␞␞␞
␝␟<entry>Baltic</entry>␟ <entry>バルト語派</entry>␞␞␞
␝␟The name (optionally schema-qualified) of an existing text search template.␟既存のテキスト検索テンプレートの名称（スキーマ修飾可）です。␞␞␞
␝␟(references <link linkend="catalog-pg-authid"><structname>pg_authid</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-authid"><structname>pg_authid</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<title>ICU Collations</title>␟ <title>ICU照合順序</title>␞␞␞
␝␟ID of this user␟ユーザID␞␞␞
␝␟COMMIT; -- free lock␟ COMMIT; -- ロックを解放␞␞␞
␝␟This utility, like most other <productname>PostgreSQL</productname> utilities, also uses the environment variables supported by <application>libpq</application> (see <xref linkend="libpq-envars"/>).␟このユーティリティは、他のほとんどの<productname>PostgreSQL</productname>ユーティリティと同様、<application>libpq</application>がサポートする環境変数(<xref linkend="libpq-envars"/>参照)も使います。␞␞␞
␝␟Name of the schema containing the type␟型を持つスキーマの名前␞␞␞
␝␟Name of the database containing the object (always the current database)␟オブジェクトを持つデータベースの名前（常に現在のデータベースです）。␞␞␞
␝␟Name of the schema this index is in␟インデックスが存在するスキーマの名前です。␞␞␞
␝␟If set to 0, the realm name from the authenticated user principal is stripped off before being passed through the user name mapping (<xref linkend="auth-username-maps"/>). This is discouraged and is primarily available for backwards compatibility, as it is not secure in multi-realm environments unless <literal>krb_realm</literal> is also used. It is recommended to leave <literal>include_realm</literal> set to the default (1) and to provide an explicit mapping in <filename>pg_ident.conf</filename> to convert principal names to <productname>PostgreSQL</productname> user names.␟0に設定されている場合は、認証されたユーザプリンシパルからのrealm名が、ユーザ名マッピング（<xref linkend="auth-username-maps"/>）で渡されるシステムユーザ名から外されています。
<literal>krb_realm</literal>も一緒に使われていない限り、これは複数realm環境で安全ではありませんので、非推奨であり、主に後方互換性のために利用できます。
<literal>include_realm</literal>をデフォルト(1)にしたまま、プリンシパル名を<productname>PostgreSQL</productname>ユーザ名に変換するために<filename>pg_ident.conf</filename>で明示的なマッピングを指定することをお薦めします。␞␞␞
␝␟<entry>Aliases</entry>␟ <entry>別名</entry>␞␞␞
␝␟The number of columns in the data to be copied (denoted <replaceable>N</replaceable> below).␟コピーされるデータ内の列数です
（以下では<replaceable>N</replaceable>と表されます）。␞␞␞
␝␟Name of the schema that contains the trigger␟トリガを持つスキーマの名前です。␞␞␞
␝␟<title>Authentication</title>␟ <title>認証</title>␞␞␞
␝␟<literal>COLLATION</literal> or <literal>DOMAIN</literal> or <literal>FOREIGN DATA WRAPPER</literal> or <literal>FOREIGN SERVER</literal> or <literal>SEQUENCE</literal>␟<literal>COLLATION</literal>または<literal>DOMAIN</literal>または<literal>FOREIGN DATA WRAPPER</literal>または<literal>FOREIGN SERVER</literal>または<literal>SEQUENCE</literal>␞␞␞
␝␟<title><link linkend="logical-replication">Logical Replication</link></title>␟ <title><link linkend="logical-replication">論理レプリケーション</link></title>␞␞␞
␝␟Time zone abbreviation␟時間帯省略形␞␞␞
␝␟<title>Build Process Details</title>␟ <title>構築プロセスの詳細</title>␞␞␞
␝␟<title>Author</title>␟ <title>作者</title>␞␞␞
␝␟The hazard does not arise with a non-schema-qualified name, because a search path containing schemas that permit untrusted users to create objects is not a <link linkend="ddl-schemas-patterns">secure schema usage pattern</link>.␟信用できないユーザにオブジェクトの作成を許可するスキーマを含む検索パスは、<link linkend="ddl-schemas-patterns">安全なスキーマ使用パターン</link>ではありませんので、スキーマで修飾されていない名前では危険は起こりません。␞␞␞
␝␟Then, for each parameter, there is the following:␟そして、各パラメータに対して、以下が続きます。␞␞␞
␝␟{ /* error */␟ {                           /* エラー時 */␞␞␞
␝␟The function returns 0 on success and a negative value if the conversion failed.␟この関数は成功時に0を返します。
変換が失敗した場合は負の値が返ります。␞␞␞
␝␟Name of the function (might be duplicated in case of overloading)␟関数の名前です（オーバーロードされている場合は重複する可能性があります）。␞␞␞
␝␟<title>Database Roles</title>␟ <title>データベースロール</title>␞␞␞
␝␟The matching code in the C module could then follow this skeleton:␟Cモジュールにおける対応するコードは次の骨格に従うことになります。␞␞␞
␝␟User mapping specific options, as <quote>keyword=value</quote> strings␟<quote>keyword=value</quote>文字列のようなユーザマッピングの特定のオプション␞␞␞
␝␟This is a non-standard syntax for <function>trim()</function>.␟これは<function>trim()</function>の非標準構文です。␞␞␞
␝␟Do not dump subscriptions.␟サブスクリプションをダンプしません。␞␞␞
␝␟Default data directory location␟デフォルトのデータディレクトリの場所です。␞␞␞
␝␟define options that are specific to this operator class (optional)␟この演算子クラスに固有のオプションの集合を定義します（省略可能）␞␞␞
␝␟size in bytes of storage to allocate␟割り当てる領域のバイト数␞␞␞
␝␟Specifies an amount of memory in kilobytes. Sizes may also be specified as a string containing the numerical size followed by any one of the following memory units: <literal>B</literal> (bytes), <literal>kB</literal> (kilobytes), <literal>MB</literal> (megabytes), <literal>GB</literal> (gigabytes), or <literal>TB</literal> (terabytes).␟メモリの量をキロバイト単位で指定します。
サイズは、数値のサイズに続いて、<literal>B</literal>(バイト)、<literal>kB</literal>(キロバイト)、<literal>MB</literal>(メガバイト)、<literal>GB</literal>(ギガバイト)または<literal>TB</literal>(テラバイト)のいずれか1つのメモリ単位を含む文字列として指定することもできます。␞␞␞
␝␟Value of the option␟オプションの値です。␞␞␞
␝␟<entry>Pattern</entry>␟ <entry>パターン</entry>␞␞␞
␝␟<entry align="center">&bull;</entry>␟ <entry align="center">○</entry>␞␞␞
␝␟Name of the schema containing the object, if applicable, else an empty string␟適用されるオブジェクトを持つスキーマの名前。そうでなければ空文字列␞␞␞
␝␟<entry>Sub-object ID (e.g., attribute number for a column)</entry>␟ <entry>オブジェクトのサブID（例えば、列の列番号）</entry>␞␞␞
␝␟Comment string from the extension's control file␟拡張の制御ファイルからのコメント文字列␞␞␞
␝␟<title>Polymorphic Types</title>␟ <title>多様型</title>␞␞␞
␝␟The client's system clock at the time of transmission, as microseconds since midnight on 2000-01-01.␟転送時点でのクライアントのシステム時刻。
2000年1月1日午前0時からのマイクロ秒。␞␞␞
␝␟Note that, although these constants will remain (in order to maintain compatibility), an application should never rely upon these occurring in a particular order, or at all, or on the status always being one of these documented values. An application might do something like this:␟これらの定数は（互換性を保つため）なくなることはありませんが、アプリケーションは、これらが特定の順で出現したり、本書に書いてある値のどれかに必ずステータス値が該当するということを決して当てにしてはいけません。
アプリケーションは、以下に示すようにするべきです。␞␞␞
␝␟Type of the privilege: <literal>SELECT</literal>, <literal>INSERT</literal>, <literal>UPDATE</literal>, <literal>DELETE</literal>, <literal>TRUNCATE</literal>, <literal>REFERENCES</literal>, or <literal>TRIGGER</literal>␟権限の種類は、
<literal>SELECT</literal>、<literal>INSERT</literal>、<literal>UPDATE</literal>、<literal>DELETE</literal>、<literal>TRUNCATE</literal>、<literal>REFERENCES</literal>、または<literal>TRIGGER</literal>のいずれかです。␞␞␞
␝␟Name of the schema that contains the table that is used by the function␟関数で使用されるテーブルを含むスキーマの名前です。␞␞␞
␝␟which expands to:␟これは以下に展開されます。␞␞␞
␝␟pointer to an array containing the <acronym>OID</acronym>s of the data types of the parameters␟パラメータのデータ型の<acronym>OID</acronym>を持つ配列へのポインタ␞␞␞
␝␟data structure containing query parameter types and values; NULL if none␟問い合わせパラメータの型と値を含むデータ構造。なければNULL␞␞␞
␝␟The name (optionally schema-qualified) of an existing text search parser.␟既存のテキスト検索パーサの名称（スキーマ修飾可）です。␞␞␞
␝␟When this form is used, the column's statistics are removed, so running <link linkend="sql-analyze"><command>ANALYZE</command></link> on the table afterwards is recommended.␟この形式を使用すると、列の統計情報が削除されるので、後でテーブルに対して<link linkend="sql-analyze"><command>ANALYZE</command></link>を実行することをお勧めします。␞␞␞
␝␟The first keyword specifies whether the objects matched by the pattern are to be included or excluded. The second keyword specifies the type of object to be filtered using the pattern:␟最初のキーワードは、パターンに一致するオブジェクトを含めるか除外するかを指定します。
2番目のキーワードは、パターンを使用してフィルタリングするオブジェクトのタイプを指定します。␞␞␞
␝␟Select the next number from this sequence:␟このシーケンスから次の番号を選択します。␞␞␞
␝␟OID of the relation corresponding to the ID in the relation message.␟Relationメッセージ中のIDに対応するリレーションのOID。␞␞␞
␝␟<title>Requirements</title>␟ <title>必要条件</title>␞␞␞
␝␟Waiting for connection to be made.␟接続の確立待ち状態です。␞␞␞
␝␟Square root␟平方根␞␞␞
␝␟<entry>16 bytes</entry>␟ <entry>16バイト</entry>␞␞␞
␝␟Reference to relation␟リレーションへの参照␞␞␞
␝␟<title>Collecting Crash Dumps</title>␟ <title>クラッシュダンプの収集</title>␞␞␞
␝␟<title>GUC Parameters</title>␟ <title>GUCパラメータ</title>␞␞␞
␝␟A C type specification.␟Cの型指定です。␞␞␞
␝␟This function will only work as desired if the data type's input function has been updated to report invalid input as a <quote>soft</quote> error. Otherwise, invalid input will abort the transaction, just as if the string had been cast to the type directly.␟この関数は、データ型の入力関数が無効な入力を<quote>ソフト</quote>エラーとして報告するように更新されている場合にのみ、機能します。
そうでない場合、無効な入力は、文字列が直接その型にキャストされたかのように、トランザクションを中断します。␞␞␞
␝␟<entry><literal>th</literal> suffix</entry>␟ <entry><literal>th</literal>接尾辞</entry>␞␞␞
␝␟The OID of the object this description pertains to␟この補足説明が属するオブジェクトのOID␞␞␞
␝␟<title>Configuration Settings Functions</title>␟ <title>構成設定関数</title>␞␞␞
␝␟(references <link linkend="catalog-pg-operator"><structname>pg_operator</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-operator"><structname>pg_operator</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<phrase>and <replaceable class="parameter">table_and_columns</replaceable> is:</phrase>␟<phrase>また<replaceable class="parameter">table_and_columns</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟Offset from UTC (positive means east of Greenwich)␟UTCからのオフセット（正はグリニッジより東側を意味する）␞␞␞
␝␟<entry>16+16n bytes</entry>␟ <entry>16+16nバイト</entry>␞␞␞
␝␟Column Type␟列 型␞␞␞
␝␟User is a superuser␟ユーザはスーパーユーザです。␞␞␞
␝␟If the argument is a <symbol>NULL</symbol> pointer, no operation is performed.␟引数が<symbol>NULL</symbol>ポインタの場合、操作は実行されません。␞␞␞
␝␟Always null, because arrays always have unlimited maximum cardinality in <productname>PostgreSQL</productname>␟常にNULLです。<productname>PostgreSQL</productname>では配列の次数は無制限だからです。␞␞␞
␝␟Replaces fields in the left operand (which must be a composite type) with matching values from <type>hstore</type>.␟左辺(複合型でなければなりません)のフィールドを<type>hstore</type>の対応する値で置換します。␞␞␞
␝␟<entry>Operation</entry>␟ <entry>演算</entry>␞␞␞
␝␟(references <link linkend="catalog-pg-opclass"><structname>pg_opclass</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-opclass"><structname>pg_opclass</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟A name to use for a returned column.␟返される列で使用される名前です。␞␞␞
␝␟/* Print every column in a row. */␟ /* 1行の列をすべて表示する。 */␞␞␞
␝␟<title>Precision</title>␟ <title>精度</title>␞␞␞
␝␟<entry>Data Type</entry>␟ <entry>データ型</entry>␞␞␞
␝␟<row><entry>Name</entry><entry>Description</entry></row>␟ <row><entry>名前</entry><entry>説明</entry></row>␞␞␞
␝␟Computes the union of the arguments.␟引数の結合を計算します。␞␞␞
␝␟See <xref linkend="sql-createsubscription-notes"/> for details of how <literal>copy_data = true</literal> can interact with the <literal>origin</literal> parameter.␟<literal>copy_data = true</literal>が<literal>origin</literal>パラメータとどのように相互作用するかの詳細については、<xref linkend="sql-createsubscription-notes"/>を参照してください。␞␞␞
␝␟<title>Environment</title>␟ <title>環境</title>␞␞␞
␝␟<title>System Catalogs</title>␟ <title>システムカタログ</title>␞␞␞
␝␟<entry>lower case ordinal number suffix</entry>␟ <entry>小文字による序数接尾辞</entry>␞␞␞
␝␟This option is mainly aimed at binary package distributors who know their target operating system well. The main advantage of using this option is that the PostgreSQL package won't need to be upgraded whenever any of the many local daylight-saving time rules change. Another advantage is that PostgreSQL can be cross-compiled more straightforwardly if the time zone database files do not need to be built during the installation.␟このオプションは、対象オペレーティングシステムを熟知しているパッケージ配布者を主な対象としたもの。
このオプションを使用する大きな利点は、多くの局所的な夏時間規則の変更があってもPostgreSQLパッケージを更新する必要がないことです。
他の利点として、時間帯データベースファイルをインストール時に構築する必要がありませんので、PostgreSQLのクロスコンパイルをより簡単に行うことができます。␞␞␞
␝␟Restoring a dump causes the destination to execute arbitrary code of the source superusers' choice. Partial dumps and partial restores do not limit that. If the source superusers are not trusted, the dumped SQL statements must be inspected before restoring. Non-plain-text dumps can be inspected by using <application>pg_restore</application>'s <option>--file</option> option. Note that the client running the dump and restore need not trust the source or destination superusers.␟ダンプをリストアすると、リストア先ではダンプ側のスーパーユーザが選択した任意のコードが実行されることになります。
部分的なダンプや部分的なリストアであってもそれは制限されません。
ダンプ側のスーパーユーザが信頼できない場合は、リストアする前にダンプされたSQL文を検査する必要があります。
非平文ダンプは、<application>pg_restore</application>の<option>--file</option>オプションを使って検査できます。
ダンプやリストアを実行するクライアントは、ダンプやリストア先のスーパーユーザを信頼する必要はありません。␞␞␞
␝␟<entry>variable</entry>␟ <entry>可変長</entry>␞␞␞
␝␟<entry>Comment</entry>␟ <entry>コメント</entry>␞␞␞
␝␟<entry><literal>USING expression</literal></entry>␟ <entry><literal>USING式</literal></entry>␞␞␞
␝␟This option is primarily intended for testing purposes and other scenarios that require repeatable output (e.g., comparing dump files). It is not recommended for general use, as a malicious server with advance knowledge of the key may be able to inject arbitrary code that will be executed on the machine that runs <application>psql</application> with the dump output.␟このオプションは主にテスト目的や、出力の再現性が必要な場合（例えば、ダンプファイルの比較）を想定しています。
悪意のあるサーバがキーを事前に知っている場合、ダンプ出力を使って<application>psql</application>を実行するマシンで任意のコードを実行できる可能性があるため、一般的な使用には推奨されません。␞␞␞
␝␟case ECPGt_int: /* integer */␟ case ECPGt_int: /* 整数 */␞␞␞
␝␟<title>Additional Modules</title>␟ <title>追加モジュール</title>␞␞␞
␝␟<entry>Support Procedure 2</entry>␟ <entry>サポートプロシージャ 2</entry>␞␞␞
␝␟<title>Transaction ID and Snapshot Information Functions</title>␟ <title>トランザクションIDとスナップショット情報関数</title>␞␞␞
␝␟<title>Sample Output</title>␟ <title>サンプル出力</title>␞␞␞
␝␟Password expiry time (only used for password authentication); null if no expiration␟パスワード有効期限（パスワード認証でのみ使用）。
NULLの場合には満了時間はありません。␞␞␞
␝␟If the current query buffer is empty, the most recently sent query is re-executed instead.␟現在の問い合わせバッファが空の場合、最も最近に送信された問い合わせが再実行されます。␞␞␞
␝␟<title>Localization</title>␟ <title>ローカライゼーション</title>␞␞␞
␝␟The name of an existing foreign-data wrapper.␟既存の外部データラッパーの名前です。␞␞␞
␝␟Sets the directory for various configuration files, <filename><replaceable>PREFIX</replaceable>/etc</filename> by default.␟各種設定ファイル用のディレクトリを設定します。
デフォルトでは<filename><replaceable>PREFIX</replaceable>/etc</filename>です。␞␞␞
␝␟elevation int -- (in ft)␟ elevation  int     -- （フィート単位）␞␞␞
␝␟Xid of the transaction.␟トランザクションのXIDです。␞␞␞
␝␟<entry>Variable</entry>␟ <entry>変数</entry>␞␞␞
␝␟Defaults to false.␟デフォルトは偽です。␞␞␞
␝␟<title>Privileges</title>␟ <title>権限</title>␞␞␞
␝␟</synopsis><replaceable class="parameter">select_statement</replaceable> is any <command>SELECT</command> statement without an <literal>ORDER BY</literal>, <literal>LIMIT</literal>, <literal>FOR NO KEY UPDATE</literal>, <literal>FOR UPDATE</literal>, <literal>FOR SHARE</literal>, or <literal>FOR KEY SHARE</literal> clause.␟</synopsis><replaceable class="parameter">select_statement</replaceable>には、<literal>ORDER BY</literal>、<literal>LIMIT</literal>、<literal>FOR NO KEY UPDATE</literal>、<literal>FOR UPDATE</literal>、<literal>FOR SHARE</literal>、<literal>FOR KEY SHARE</literal>句を持たない、任意の<command>SELECT</command>文が入ります。␞␞␞
␝␟<title><productname>PostgreSQL</productname> Error Codes</title>␟ <title><productname>PostgreSQL</productname>エラーコード</title>␞␞␞
␝␟<entry>Parameter</entry>␟ <entry>パラメータ</entry>␞␞␞
␝␟An array describing which parameters are null. Must have same length as the statement's number of arguments.␟どのパラメータがNULLであるかを示す配列。
文の引数の数と同じ長さでなければなりません。␞␞␞
␝␟<title>Description</title>␟ <title>説明</title>␞␞␞
␝␟If the execution of the command was successful then the following (nonnegative) value will be returned:␟コマンドの実行に成功したときは、次の（負でない）値が返されます。␞␞␞
␝␟<entry><literal>'\001'::bytea</literal></entry>␟ <entry><literal>'\001'::bytea;</literal></entry>␞␞␞
␝␟For clients using extended query protocol, durations of the Parse, Bind, and Execute steps are logged independently.␟拡張問い合わせプロトコルを使用するクライアントでは、Parse、Bind、Executeそれぞれの段階で要した時間が独立して記録されます。␞␞␞
␝␟Specifies whether to use color in diagnostic messages. Possible values are <literal>always</literal>, <literal>auto</literal> and <literal>never</literal>.␟診断メッセージで色を使うかどうかを指定します。
指定可能な値は<literal>always</literal>、<literal>auto</literal>、<literal>never</literal>です。␞␞␞
␝␟See <xref linkend="fdw-row-locking"/> for more information.␟さらなる情報については<xref linkend="fdw-row-locking"/>を参照してください。␞␞␞
␝␟The data type of the operator's right operand.␟演算子の右オペランドのデータ型です。␞␞␞
␝␟A list of the frequencies of the most common element values, i.e., the fraction of rows containing at least one instance of the given value. Two or three additional values follow the per-element frequencies; these are the minimum and maximum of the preceding per-element frequencies, and optionally the frequency of null elements. (Null when <structfield>most_common_elems</structfield> is.)␟最も一般的な要素値の出現頻度のリストで、与えられた値の少なくとも1つのインスタンスを含む行の断片です。
2つもしくは3つの追加の値が1つの要素ごとの出現頻度に続きます。
最小で最大の要素ごとの出現頻度があります。さらにオプションとしてNULL要素の出現頻度もあります。
（<structfield>most_common_elems</structfield>がNULLの時はNULLです。）␞␞␞
␝␟<title>Bibliography</title>␟ <title>参考文献</title>␞␞␞
␝␟<entry>Algorithm</entry>␟ <entry>アルゴリズム</entry>␞␞␞
␝␟The number of primary key fields.␟主キーフィールドの個数です。␞␞␞
␝␟The return value is the same as for <function>SPI_execute</function>.␟戻り値は<function>SPI_execute</function>と同じです。␞␞␞
␝␟<title>WAL Summarization Information Functions</title>␟ <title>WAL要約情報関数</title>␞␞␞
␝␟<title>Indexes</title>␟ <title>インデックス</title>␞␞␞
␝␟After you have compiled the source code (see <xref linkend="dfunc"/>), declare the function and the triggers:␟ソースコードをコンパイル（<xref linkend="dfunc"/>を参照してください）した後に、以下の様に関数とトリガを宣言します。␞␞␞
␝␟Do not throw an error if the view does not exist. A notice is issued in this case.␟ビューが存在しない場合でもエラーとしません。
この場合には注意メッセージが発行されます。␞␞␞
␝␟This parameter can only be set in the <filename>postgresql.conf</filename> file or on the server command line.␟このパラメータは、<filename>postgresql.conf</filename>ファイルか、サーバのコマンドラインでのみ設定可能です。␞␞␞
␝␟Allows applications to select which security libraries to initialize.␟アプリケーションがどのセキュリティライブラリを初期化するか選択することができます。␞␞␞
␝␟This parameter is only available if the <symbol>LOCK_DEBUG</symbol> macro was defined when <productname>PostgreSQL</productname> was compiled.␟このパラメータは<productname>PostgreSQL</productname>がコンパイル時に<symbol>LOCK_DEBUG</symbol>マクロが定義された場合のみ有効です。␞␞␞
␝␟<title>Logical Decoding</title>␟ <title>ロジカルデコーディング</title>␞␞␞
␝␟The OID of the system catalog the dependent object is in␟依存するオブジェクトが存在するシステムカタログのOID␞␞␞
␝␟Whether the sequence cycles␟シーケンスが周回するかどうか␞␞␞
␝␟/* close the connection to the database and cleanup */␟ /* データベースとの接続を閉じ、後始末を行う。 */␞␞␞
␝␟Name of the schema that contains the table that the trigger is defined on␟トリガが定義されたテーブルを持つスキーマの名前です。␞␞␞
␝␟<title>Arrays</title>␟ <title>配列</title>␞␞␞
␝␟Note that there is no <literal>CREATE ROUTINE</literal> command.␟<literal>CREATE ROUTINE</literal>コマンドは無いことに注意してください。␞␞␞
␝␟The meaning of the fields is:␟フィールドの意味は以下の通りです。␞␞␞
␝␟Name of the view␟ビューの名前です。␞␞␞
␝␟number of input parameters (<literal>$1</literal>, <literal>$2</literal>, etc.)␟入力パラメータ（<literal>$1</literal>、<literal>$2</literal>など）の数␞␞␞
␝␟For more information, see <xref linkend="ddl-constraints"/>.␟詳細については<xref linkend="ddl-constraints"/>を参照してください。␞␞␞
␝␟These fields do not apply to <literal>local</literal> records.␟これらのフィールドは<literal>local</literal>レコードに適用されません。␞␞␞
␝␟Name of an existing column.␟既存の列の名前です。␞␞␞
␝␟if called from an unconnected C function␟未接続のC関数から呼び出された場合␞␞␞
␝␟one of <symbol>FETCH_FORWARD</symbol>, <symbol>FETCH_BACKWARD</symbol>, <symbol>FETCH_ABSOLUTE</symbol> or <symbol>FETCH_RELATIVE</symbol>␟<symbol>FETCH_FORWARD</symbol>、<symbol>FETCH_BACKWARD</symbol>、<symbol>FETCH_ABSOLUTE</symbol>、<symbol>FETCH_RELATIVE</symbol>のいずれか␞␞␞
␝␟Name of the domain␟ドメインの名前です。␞␞␞
␝␟<title>Source Code</title>␟ <title>ソースコード</title>␞␞␞
␝␟<title>Installation Procedure</title>␟ <title>インストール手順</title>␞␞␞
␝␟Set <replaceable>NUMBER</replaceable> as the default port number for server and clients. The default is 5432. The port can always be changed later on, but if you specify it here then both server and clients will have the same default compiled in, which can be very convenient. Usually the only good reason to select a non-default value is if you intend to run multiple <productname>PostgreSQL</productname> servers on the same machine.␟サーバとクライアントのデフォルトのポート番号を<replaceable>NUMBER</replaceable>に設定します。
デフォルトは5432です。
このポートは後でいつでも変更できますが、ここで指定した場合、サーバとクライアントはコンパイル時に同じデフォルト値を持つようになります。
これは非常に便利です。
通常、デフォルト以外の値を選択すべき唯一の理由は、同じマシンで複数の<productname>PostgreSQL</productname>を稼働させることです。␞␞␞
␝␟/* Open a cursor with input parameters. */␟ /* 入力パラメータ付きでカーソルを開く。 */␞␞␞
␝␟Access privileges; see <xref linkend="ddl-priv"/> for details␟アクセス権限。
詳細は<xref linkend="ddl-priv"/>を参照してください␞␞␞
␝␟This is the source code of the trigger function:␟以下がトリガ関数のソースコードです。␞␞␞
␝␟If PostgreSQL on Windows crashes, it has the ability to generate <productname>minidumps</productname> that can be used to track down the cause for the crash, similar to core dumps on Unix. These dumps can be read using the <productname>Windows Debugger Tools</productname> or using <productname>Visual Studio</productname>. To enable the generation of dumps on Windows, create a subdirectory named <filename>crashdumps</filename> inside the cluster data directory. The dumps will then be written into this directory with a unique name based on the identifier of the crashing process and the current time of the crash.␟もしWindows上のPostgreSQLがクラッシュした場合、Unixにおけるコアダンプと似た、クラッシュの原因を追跡するために使用できる<productname>minidumps</productname>を生成できます。
このダンプは<productname>Windows Debugger Tools</productname>や<productname>Visual Studio</productname>を使うことで解析できます。Windowsにてダンプを生成できるように、<filename>crashdumps</filename>という名前のサブディレクトリをデータベースクラスタディレクトリの中に作成します。
ダンプは、クラッシュ時の現在時間と原因となったプロセスの識別子を元にした一意な名前としてこのディレクトリの中に生成されます。␞␞␞
␝␟(references <link linkend="catalog-pg-language"><structname>pg_language</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-language"><structname>pg_language</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟Name of the schema containing the table␟テーブルを持つスキーマの名前です。␞␞␞
␝␟Name of the database that the foreign server used by this mapping is defined in (always the current database)␟このマッピングにより使用される外部サーバが定義されたデータベース名です（常に現在のデータベースです）。␞␞␞
␝␟Name of the database that contains the table that is used by the function (always the current database)␟関数で使用されるテーブルを含むデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟This function is now deprecated in favor of <function>SPI_prepare_extended</function>.␟この関数は<function>SPI_prepare_extended</function>のため現在では廃止予定です。␞␞␞
␝␟<entry>Maybe</entry>␟ <entry>たぶん</entry>␞␞␞
␝␟<entry align="left">Only for local objects</entry>␟ <entry align="left">ローカルオブジェクトに対してのみ</entry>␞␞␞
␝␟The name (optionally schema-qualified) of an existing table.␟既存のテーブルの名前です（スキーマ修飾名も可）。␞␞␞
␝␟For more information, see <xref linkend="sql-createtable"/>.␟詳細については<xref linkend="sql-createtable"/>を参照してください。␞␞␞
␝␟Flags; currently unused.␟フラグ。
現在は使用されていません。␞␞␞
␝␟The user defined GID of the prepared transaction.␟プリペアドトランザクションのユーザ定義GIDです。␞␞␞
␝␟Specifies the TCP port or local Unix domain socket file extension on which the server is listening for connections. Defaults to the <envar>PGPORT</envar> environment variable, if set, or a compiled-in default.␟サーバが接続を監視するTCPポートもしくはローカルUnixドメインソケットファイルの拡張子を指定します。
デフォルトは、設定されている場合、環境変数<envar>PGPORT</envar>の値となります。設定されていなければ、コンパイル時のデフォルト値となります。␞␞␞
␝␟<entry>Type of the object</entry>␟ <entry>オブジェクトの型</entry>␞␞␞
␝␟<title>Syntax</title>␟ <title>構文</title>␞␞␞
␝␟If <literal>AND CHAIN</literal> is specified, a new transaction is immediately started with the same transaction characteristics (see <xref linkend="sql-set-transaction"/>) as the just finished one. Otherwise, no new transaction is started.␟<literal>AND CHAIN</literal>が指定されていれば、新しいトランザクションは、直前に終了したものと同じトランザクションの特性(<xref linkend="sql-set-transaction"/>を参照してください)で即時に開始されます。
そうでなければ、新しいトランザクションは開始されません。␞␞␞
␝␟This function is restricted to superusers by default, but other users can be granted EXECUTE to run the function.␟デフォルトではこの関数の実行はスーパーユーザに限定されますが、他のユーザにも関数を実行するEXECUTE権限を与えることができます。␞␞␞
␝␟Name of the schema that the column data type (the underlying type of the domain, if applicable) is defined in␟列データ型（もし適用されていたら背後にあるドメインの型）を定義したスキーマの名前です。␞␞␞
␝␟Do everything except actually modifying the target directory.␟ターゲットディレクトリを実際に更新する以外はすべてのことを行います。␞␞␞
␝␟<title>Base Types</title>␟ <title>基本型</title>␞␞␞
␝␟For more information, see <xref linkend="manage-ag-overview"/>.␟詳細については<xref linkend="manage-ag-overview"/>を参照してください。␞␞␞
␝␟The name (optionally schema-qualified) of an existing operator.␟既存の演算子の名前です（スキーマ修飾名も可）。␞␞␞
␝␟/* Check to see that the backend connection was successfully made */␟ /* バックエンドとの接続確立に成功したかを確認する */␞␞␞
␝␟<entry>8 bytes</entry>␟ <entry>8バイト</entry>␞␞␞
␝␟<entry>Length</entry>␟ <entry>長さ</entry>␞␞␞
␝␟Now you can test the operation of the trigger:␟これで、トリガの操作を確認することができます。␞␞␞
␝␟Name of the database containing the type (always the current database)␟型を持つデータベースの名前（常に現在のデータベースです）。␞␞␞
␝␟Always null, since this information is not applied to parameter data types in <productname>PostgreSQL</productname>␟常にNULLです。
<productname>PostgreSQL</productname>では、この情報はパラメータデータ型に適用されないからです。␞␞␞
␝␟struct containing optional arguments␟オプションの引数を含む構造体␞␞␞
␝␟Example of creating such an index with a signature length of 32 bytes:␟署名の長さが32バイトのインデックスを作成する例␞␞␞
␝␟<entry>Western European</entry>␟ <entry>西ヨーロッパ</entry>␞␞␞
␝␟<entry>Column Name</entry>␟ <entry>列名</entry>␞␞␞
␝␟Do not dump comments.␟コメントをダンプしません。␞␞␞
␝␟<entry>1&ndash;2</entry>␟ <entry>1-2</entry>␞␞␞
␝␟<title>Error Handling</title>␟ <title>エラー処理</title>␞␞␞
␝␟remember what we said about visibility.␟ 可視性の説明を思い出してください。␞␞␞
␝␟0 indicates the overall <command>COPY</command> format is textual (rows separated by newlines, columns separated by separator characters, etc.). 1 indicates the overall copy format is binary (similar to DataRow format). See <xref linkend="sql-copy"/> for more information.␟0は<command>COPY</command>全体の書式がテキスト（行は改行で区切られ、列は区切り文字などで区切られます）であることを示します。
1はコピー全体の書式がバイナリ（DataRowの書式同様）であることを示します。
詳細については<xref linkend="sql-copy"/>を参照してください。␞␞␞
␝␟<title>Short Version</title>␟ <title>簡易版</title>␞␞␞
␝␟length of the character representation of the datum in bytes␟データの文字表現のバイト長です。␞␞␞
␝␟Name of a role␟ロール名です。␞␞␞
␝␟<listitem><para>Display version information, then exit.</para></listitem>␟ <listitem><para>バージョン情報を表示して終了します。</para></listitem>␞␞␞
␝␟-- create index␟-- インデックスの作成␞␞␞
␝␟If a different escape character than backslash is desired, it can be specified using the <literal>UESCAPE</literal><indexterm><primary>UESCAPE</primary></indexterm> clause after the string, for example:␟バックスラッシュ以外のエスケープ文字を使用したい場合、文字列の後に<literal>UESCAPE</literal><indexterm><primary>UESCAPE</primary></indexterm>句を使用して指定できます。例をあげます。␞␞␞
␝␟Name of the schema that the domain data type is defined in␟ドメインデータ型を定義したスキーマの名前です。␞␞␞
␝␟data structure containing parameter types and values; NULL if none␟パラメータの型と値からなるデータ構造。
なければNULL。␞␞␞
␝␟<phrase>where <replaceable class="parameter">action</replaceable> is one of:</phrase>␟<phrase>ここで<replaceable class="parameter">action</replaceable>は以下のいずれかです。</phrase>␞␞␞
␝␟User bypasses every row-level security policy, see <xref linkend="ddl-rowsecurity"/> for more information.␟ユーザはすべての行単位セキュリティポリシーを無視します。
詳しくは<xref linkend="ddl-rowsecurity"/>を参照してください。␞␞␞
␝␟<entry>Format</entry>␟ <entry>書式</entry>␞␞␞
␝␟an array of length <parameter>nargs</parameter>, describing which parameters are null␟どのパラメータがnullかを記述する、<parameter>nargs</parameter>長の配列␞␞␞
␝␟<title>Monetary Types</title>␟ <title>通貨型</title>␞␞␞
␝␟Possible␟可能性あり␞␞␞
␝␟For example, a function returning the greater of two integer values could be defined as:␟例えば、2つの整数のうち大きな方を返す関数は以下のように定義できます。␞␞␞
␝␟Name of the database that contains the view (always the current database)␟ビューを持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<entry>Object</entry>␟ <entry>オブジェクト</entry>␞␞␞
␝␟If you have set <literal>shared_memory_type</literal> to <literal>sysv</literal>, you might also want to configure your kernel to lock System V shared memory into RAM and prevent it from being paged out to swap. This can be accomplished using the <command>sysctl</command> setting <literal>kern.ipc.shm_use_phys</literal>.␟<literal>shared_memory_type</literal>を<literal>sysv</literal>に設定している場合は、System V共有メモリをRAM上に固定して、スワップによってページアウトされるのを避けるために、カーネルを設定することもできます。
これは<command>sysctl</command>を使用して<literal>kern.ipc.shm_use_phys</literal>を設定することで実現できます。␞␞␞
␝␟(references <link linkend="catalog-pg-opfamily"><structname>pg_opfamily</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-opfamily"><structname>pg_opfamily</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<title>Functions Provided</title>␟ <title>提供される関数</title>␞␞␞
␝␟Name of the domain data type␟ドメインデータ型の名前です。␞␞␞
␝␟<entry>UTC offset for PST (ISO 8601 basic format)</entry>␟ <entry>PSTのUTCオフセット(ISO 8601の基本フォーマット)</entry>␞␞␞
␝␟<entry>can be increased by recompiling <productname>PostgreSQL</productname></entry>␟ <entry><productname>PostgreSQL</productname>を再コンパイルすることで増やせます。</entry>␞␞␞
␝␟The column is not allowed to contain null values.␟その列がNULL値を持てないことを指定します。␞␞␞
␝␟(references <link linkend="catalog-pg-publication"><structname>pg_publication</structname></link>.<structfield>oid</structfield>)␟（参照先 <link linkend="catalog-pg-publication"><structname>pg_publication</structname></link>.<structfield>oid</structfield>）␞␞␞
␝␟<entry>24 bytes</entry>␟ <entry>24バイト</entry>␞␞␞
␝␟<entry>Result</entry>␟ <entry>結果</entry>␞␞␞
␝␟<title>Advisory Lock Functions</title>␟ <title>勧告的ロック用関数</title>␞␞␞
␝␟<title>Arguments</title>␟ <title>引数</title>␞␞␞
␝␟<entry>1&ndash;3</entry>␟ <entry>1-3</entry>␞␞␞
␝␟<entry>planner statistics</entry>␟ <entry>プランナ統計情報</entry>␞␞␞
␝␟In the SQL standard, <literal>WITH HIERARCHY OPTION</literal> is a separate (sub-)privilege allowing certain operations on table inheritance hierarchies. In PostgreSQL, this is included in the <literal>SELECT</literal> privilege, so this column shows <literal>YES</literal> if the privilege is <literal>SELECT</literal>, else <literal>NO</literal>.␟標準SQLでは、<literal>WITH HIERARCHY OPTION</literal>は、継承テーブル階層に対するある操作を許可する独立した（副次）権限です。
PostgreSQLでは、これは<literal>SELECT</literal>権限に含まれているため、この列は権限が<literal>SELECT</literal>の場合は<literal>YES</literal>、それ以外の場合は<literal>NO</literal>です。␞␞␞
␝␟Name of the role that granted the privilege␟権限を与えたロールの名前です。␞␞␞
␝␟Cache size of the sequence␟シーケンスのキャッシュサイズ␞␞␞
␝␟<entry>Escape</entry>␟ <entry>エスケープ</entry>␞␞␞
␝␟<entry>Support Number</entry>␟ <entry>サポート番号</entry>␞␞␞
␝␟The function raises an error if <replaceable>start_lsn</replaceable> is not available.␟<replaceable>start_lsn</replaceable>が利用できない場合、この関数はエラーを発生します。␞␞␞
␝␟<title>Enumerated Types</title>␟ <title>列挙型</title>␞␞␞
␝␟<entry>Abbreviations</entry>␟ <entry>簡略形</entry>␞␞␞
␝␟Name of the column␟列の名前です。␞␞␞
␝␟Absolute value␟絶対値␞␞␞
␝␟Example of creating such an index with a signature length of 100 bytes:␟署名の長さが100バイトのインデックスを作成する例。␞␞␞
␝␟Makes a new connection to the database server.␟新たにデータベースサーバへの接続を作成します。␞␞␞
␝␟This view can be helpful for checking whether planned changes in the authentication configuration file will work, or for diagnosing a previous failure. Note that this view reports on the <emphasis>current</emphasis> contents of the file, not on what was last loaded by the server.␟このビューは、認証の設定ファイルについて計画している変更が動作するかどうかを確認する、あるいは以前の失敗について分析するのに役立つでしょう。
このビューはサーバが最後に読み込んだものではなく、ファイルの<emphasis>現在の</emphasis>内容について報告することに注意してください。␞␞␞
␝␟Do not throw an error if a relation with the same name already exists. A notice is issued in this case. Note that there is no guarantee that the existing relation is anything like the one that would have been created.␟同じ名前のリレーションがすでに存在していてもエラーとしません。
この場合注意が発せられます。
既存のリレーションが作成しようとしたものと何かしら似たものであることは保証されません。␞␞␞
␝␟The name (optionally schema-qualified) of an existing text search dictionary.␟既存のテキスト検索辞書の名称（スキーマ修飾可）です。␞␞␞
␝␟Reference to publication␟パブリケーションへの参照␞␞␞
␝␟<title>Build</title>␟ <title>構築</title>␞␞␞
␝␟<entry>32 bytes</entry>␟ <entry>32バイト</entry>␞␞␞
␝␟Dump data as <command>INSERT</command> commands (rather than <command>COPY</command>). Controls the maximum number of rows per <command>INSERT</command> command. The value specified must be a number greater than zero. Any error during restoring will cause only rows that are part of the problematic <command>INSERT</command> to be lost, rather than the entire table contents.␟(<command>COPY</command>ではなく)<command>INSERT</command>コマンドでデータをダンプします。
<command>INSERT</command>コマンド1つあたりの最大行数を制御します。
指定する値は0より大きくなければなりません。
リストア中のエラーでは、テーブルの内容がまるごと失われることはなく、問題のある<command>INSERT</command>の一部の行が失われるだけです。␞␞␞
␝␟According to the SQL standard, omitting <literal>ESCAPE</literal> means there is no escape character (rather than defaulting to a backslash), and a zero-length <literal>ESCAPE</literal> value is disallowed. <productname>PostgreSQL</productname>'s behavior in this regard is therefore slightly nonstandard.␟標準SQLによれば、<literal>ESCAPE</literal>は（デフォルトがバックスラッシュとなるのではなく）エスケープ文字が存在しないことを意味します。長さゼロの<literal>ESCAPE</literal>は使用できません。
ですからこの点で<productname>PostgreSQL</productname>は少し非標準な振る舞いをします。␞␞␞
␝␟Index access method operator family is for␟演算子族用のインデックスアクセスメソッド␞␞␞
␝␟ScanKey scankeys; /* array of operators and comparison values */ ScanKey orderbys; /* array of ordering operators and comparison * values */ int nkeys; /* length of scankeys array */ int norderbys; /* length of orderbys array */␟ ScanKey     scankeys;       /* 演算子と比較する値の配列 */
    ScanKey     orderbys;       /* 順序付け演算子と比較する値の配列 */
    int         nkeys;          /* scankeys配列の長さ */
    int         norderbys;      /* orderbys配列の長さ */␞␞␞
␝␟Always null, since this information is not applied to return data types in <productname>PostgreSQL</productname>␟常にNULLです。<productname>PostgreSQL</productname>では、この情報は戻り値のデータ型に当てはまらないからです。␞␞␞
␝␟<title>Functions and Operators</title>␟ <title>関数と演算子</title>␞␞␞
␝␟<title>Inheritance</title>␟ <title>継承</title>␞␞␞
␝␟<title>Comment Information Functions</title>␟ <title>コメント情報関数</title>␞␞␞
␝␟<listitem><para>Show help, then exit.</para></listitem>␟ <listitem><para>ヘルプを表示して終了します。</para></listitem>␞␞␞
␝␟<title>Replication Management Functions</title>␟ <title>レプリケーション管理関数</title>␞␞␞
␝␟<title>Configuration</title>␟ <title>設定</title>␞␞␞
␝␟If you want to test the newly built server before you install it, you can run the regression tests at this point. The regression tests are a test suite to verify that <productname>PostgreSQL</productname> runs on your machine in the way the developers expected it to. Type:␟インストールを行う前に、新しく構築したサーバをテストしたい場合、この時点でリグレッションテストを実行できます。
リグレッションテストとは、使用するマシンにおいて<productname>PostgreSQL</productname>が、開発者の想定通りに動作することを検証するためのテストのまとまりです。
次のように入力します。␞␞␞
␝␟<entry>Column</entry>␟ <entry>列</entry>␞␞␞
␝␟The OID of the foreign server that contains this mapping␟マッピングを保持する外部サーバのOID␞␞␞
␝␟The environment variable <envar>PG_COLOR</envar> specifies whether to use color in diagnostic messages. Possible values are <literal>always</literal>, <literal>auto</literal> and <literal>never</literal>.␟環境変数<envar>PG_COLOR</envar>は診断メッセージで色を使うかどうかを指定します。
指定可能な値は<literal>always</literal>、<literal>auto</literal>、<literal>never</literal>です。␞␞␞
␝␟The arguments can appear in any order, not only the one shown above.␟引数は、上で示した順序だけではなく、任意の順序で記述することができます。␞␞␞
␝␟<title>Data-Modifying Statements in <literal>WITH</literal></title>␟ <title><literal>WITH</literal>内のデータ変更文</title>␞␞␞
␝␟<entry>Not equal</entry>␟ <entry>等しくない</entry>␞␞␞
␝␟<title>Large Objects</title>␟ <title>ラージオブジェクト</title>␞␞␞
␝␟To commit the current transaction and make all changes permanent:␟現在のトランザクションをコミットし、全ての変更を永続化します。␞␞␞
␝␟Before <productname>PostgreSQL</productname> 8.4, the <literal>OPERATOR</literal> clause could include a <literal>RECHECK</literal> option. This is no longer supported because whether an index operator is <quote>lossy</quote> is now determined on-the-fly at run time. This allows efficient handling of cases where an operator might or might not be lossy.␟<productname>PostgreSQL</productname> 8.4より前までは、<literal>OPERATOR</literal>句に<literal>RECHECK</literal>オプションを含めることができました。
インデックス演算子に<quote>損失がある</quote>かどうかは実行時にその場で決定されるようになりましたので、これはサポートされなくなりました。
これにより、演算子に損失があるかもしれないしないかもしれないような場合を効率的に扱うことができるようになりました。␞␞␞
␝␟an array of length <parameter>nargs</parameter>, containing the <acronym>OID</acronym>s of the data types of the parameters␟パラメータのデータ型の<acronym>OID</acronym>を含む、<parameter>nargs</parameter>長の配列␞␞␞
␝␟Prepare timestamp of the transaction. The value is in number of microseconds since PostgreSQL epoch (2000-01-01).␟トランザクションのプリペアド（準備された）時刻です。
その値はPostgreSQLのエポック（2000-01-01）からのマイクロ秒数です。␞␞␞
␝␟<refpurpose>execute a command with out-of-line parameters</refpurpose>␟ <refpurpose>行外のパラメータを持つコマンドを実行する</refpurpose>␞␞␞
␝␟The name (optionally schema-qualified) of an existing operator class.␟既存の演算子クラスの名前です（スキーマ修飾名も可）。␞␞␞
␝␟The <parameter>options</parameter> parameter can contain option settings, as described below.␟<parameter>options</parameter>パラメータには後述のオプション設定を含めることができます。␞␞␞
␝␟<title>Monitoring</title>␟ <title>監視</title>␞␞␞
␝␟Name of the database that contains the constraint (always the current database)␟制約を持つデータベースの名前です（常に現在のデータベースです）。␞␞␞
␝␟<title>Transforms</title>␟ <title>変換</title>␞␞␞
␝␟-- some computations␟ -- 何らかの演算␞␞␞
␝␟<title>Index Maintenance Functions</title>␟ <title>インデックス保守関数</title>␞␞␞
␝␟The function to be called␟呼び出される関数␞␞␞
␝␟Name of the schema that contains the foreign table␟外部テーブルを含むスキーマの名前です。␞␞␞
␝␟<title>Creating a Database</title>␟ <title>データベースの作成</title>␞␞␞
␝␟<title>Exit Status</title>␟ <title>終了ステータス</title>␞␞␞
␝␟Returns status, which is always <literal>OK</literal> (since any error causes the function to throw an error instead of returning).␟状態を返します。
これは常に<literal>OK</literal>です（何らかのエラーが起きるとこの関数は戻らずエラーとなるためです）。␞␞␞
␝␟The name (optionally schema-qualified) of the table that the policy is on.␟ポリシーが適用されているテーブルの名前（スキーマ修飾可）です。␞␞␞
␝␟<title>Procedural Languages</title>␟ <title>手続き言語</title>␞␞␞
␝␟<title>Trapping Errors</title>␟ <title>エラーの捕捉</title>␞␞␞
␝␟The key word <literal>COLUMN</literal> is noise and can be omitted.␟<literal>COLUMN</literal>キーワードには意味がなく、省略可能です。␞␞␞
␝␟<phrase>where <replaceable class="parameter">column_constraint</replaceable> is:</phrase>␟<phrase>ここで<replaceable class="parameter">column_constraint</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟<optional> <literal>INCLUDE ( <replaceable class="parameter">column_name</replaceable> [, ...])</literal> </optional> (table constraint)</term>␟ <optional> <literal>INCLUDE ( <replaceable class="parameter">column_name</replaceable> [, ...])</literal> </optional> (テーブル制約)</term>␞␞␞
␝␟<entry>Percentage of dead tuples</entry>␟ <entry>無効タプルの割合</entry>␞␞␞
␝␟Waiting to establish a connection to a remote server.␟リモートサーバへの接続が確立するのを待機しています。␞␞␞
␝␟/* Print members of the structure. */␟ /* 構造体のメンバを表示する。 */␞␞␞
␝␟<title>Utility Commands</title>␟ <title>ユーティリティコマンド</title>␞␞␞
␝␟The data type of the column. This can include array specifiers. For more information on the data types supported by <productname>PostgreSQL</productname>, refer to <xref linkend="datatype"/>.␟列のデータ型です。
これには、配列指定子を含めることができます。
<productname>PostgreSQL</productname>でサポートされるデータ型の情報に関する詳細は<xref linkend="datatype"/>を参照してください。␞␞␞
␝␟This is the Oracle version:␟以下はOracle版です。␞␞␞
␝␟Always null, since the <productname>PostgreSQL</productname> development group does not perform formal testing of feature conformance␟常にNULLです。
<productname>PostgreSQL</productname>開発グループは機能が準拠しているかどうかについて公式な試験を行っていないからです。␞␞␞
␝␟The end LSN of the transaction.␟トランザクションの終了LSNです。␞␞␞
␝␟<title>Data Types</title>␟ <title>データ型</title>␞␞␞
␝␟An array of actual parameter values. Must have same length as the statement's number of arguments.␟実パラメータ値の配列。
文の引数の数と同じ長さでなければなりません。␞␞␞
␝␟Name of table␟テーブルの名前␞␞␞
␝␟Extension name␟拡張名␞␞␞
␝␟The <function>crosstab</function> function is declared to return <type>setof record</type>, so the actual names and types of the output columns must be defined in the <literal>FROM</literal> clause of the calling <command>SELECT</command> statement, for example:␟<function>crosstab</function>関数は<type>setof record</type>を返すものとして宣言されていますので、出力列の実際の名前と型を、以下の例のように、呼出元の<command>SELECT</command>の<literal>FROM</literal>句で定義しなければなりません。␞␞␞
␝␟To test the dictionary, you can try␟辞書を試験するためには以下を試してください。␞␞␞
␝␟<entry>Support Function 1</entry>␟ <entry>サポート関数 1</entry>␞␞␞
␝␟See <xref linkend="client-authentication"/> for more information about client authentication configuration.␟クライアント認証設定の詳細については<xref linkend="client-authentication"/>を参照してください。␞␞␞
␝␟Name of the owner of the foreign server␟外部サーバの所有者の名前です。␞␞␞
␝␟Does <type>hstore</type> contain key?␟<type>hstore</type>がキーを含むか？␞␞␞
␝␟Returns the number of elements in the array.␟配列内の要素数を返します。␞␞␞
␝␟Name of the user being mapped, or <literal>PUBLIC</literal> if the mapping is public␟マップされているユーザ名、またはマッピングがpublicの場合<literal>PUBLIC</literal>です。␞␞␞
␝␟<returnvalue>f</returnvalue> (rather than <literal>NULL</literal>)␟ <returnvalue>f</returnvalue> (<literal>NULL</literal>ではなく)␞␞␞
␝␟Here is a complete example:␟以下に複雑な例を示します。␞␞␞
␝␟<entry>database users</entry>␟ <entry>データベースのユーザ</entry>␞␞␞
