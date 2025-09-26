␝  <manvolnum>1</manvolnum>␟  <refmiscinfo>Application</refmiscinfo>␟  <refmiscinfo>アプリケーション</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>pg_checksums</refname>␟  <refpurpose>enable, disable or check data checksums in a <productname>PostgreSQL</productname> database cluster</refpurpose>␟  <refpurpose><productname>PostgreSQL</productname>データベースクラスタのデータチェックサムを有効化、無効化、あるいは検査する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1 id="r1-app-pgchecksums-1">␟  <title>Description</title>␟  <title>説明</title>␞␞  <para>␞
␝  <para>␟   <application>pg_checksums</application> checks, enables or disables data
   checksums in a <productname>PostgreSQL</productname> cluster.  The server
   must be shut down cleanly before running
   <application>pg_checksums</application>. When verifying checksums, the exit
   status is zero if there are no checksum errors, and nonzero if at least one
   checksum failure is detected. When enabling or disabling checksums, the
   exit status is nonzero if the operation failed.␟<application>pg_checksums</application>は<productname>PostgreSQL</productname>クラスタのデータチェックサムの検査と有効化、無効化を行います。
<application>pg_checksums</application>を実行する前にサーバは正常停止されていなければなりません。
チェックサムを検査する場合、終了ステータスはチェックサム誤りが無ければゼロで、チェックサム誤りが一つでも在ったなら非ゼロです。
チェックサムの有効化、無効化をする場合、終了ステータスは操作に失敗したときに非ゼロになります。␞␞  </para>␞
␝  <para>␟   When verifying checksums, every file in the cluster is scanned. When
   enabling checksums, each relation file block with a changed checksum is
   rewritten in-place.
   Disabling checksums only updates the file <filename>pg_control</filename>.␟チェックサムを検査する場合、クラスタ内の各ファイルがスキャンされます。
チェックサムの有効化では、チェックサムが変更されたすべてのリレーションファイルブロックがその場で書き換えられます。
チェックサムの無効化では、ファイル<filename>pg_control</filename>だけ更新されます。␞␞  </para>␞
␝ <refsect1>␟  <title>Options</title>␟  <title>オプション</title>␞␞␞
␝   <para>␟    The following command-line options are available:␟以下のコマンドラインオプションが使用できます。␞␞␞
␝       <para>␟        Specifies the directory where the database cluster is stored.␟データベースクラスタが格納されているディレクトリを指定します。␞␞       </para>␞
␝       <para>␟        Checks checksums. This is the default mode if nothing else is
        specified.␟チェックサムを検査します。
これは何も指定しなかった場合のデフォルトのモードです。␞␞       </para>␞
␝       <para>␟        Disables checksums.␟チェックサムを無効化します。␞␞       </para>␞
␝       <para>␟        Enables checksums.␟チェックサムを有効化します。␞␞       </para>␞
␝       <para>␟        Only validate checksums in the relation with filenode
        <replaceable>filenode</replaceable>.␟指定したファイルノード<replaceable>filenode</replaceable>のリレーション内のチェックサムだけを検査します。␞␞       </para>␞
␝       <para>␟        By default, <command>pg_checksums</command> will wait for all files
        to be written safely to disk.  This option causes
        <command>pg_checksums</command> to return without waiting, which is
        faster, but means that a subsequent operating system crash can leave
        the updated data directory corrupt.  Generally, this option is useful
        for testing but should not be used on a production installation.
        This option has no effect when using <literal>--check</literal>.␟<command>pg_checksums</command>はデフォルトでは全てのファイルが安全にディスクに書かれるまで待ちます。
このオプションは、<command>pg_checksums</command>がこれを待たずに応答するようにします。より早いですが、直後のオペレーティングシステムのクラッシュで更新されたデータディレクトリの破損が残る可能性があることを意味します。
一般に、このオプションはテストには有用ですが、本番導入むけには使うべきではありません。
<literal>--check</literal>を使う場合には、このオプションは効果がありません。␞␞       </para>␞
␝       <para>␟        Enable progress reporting. Turning this on will deliver a progress
        report while checking or enabling checksums.␟進行報告を有効にします。
これを有効にするとチェックサムの検査あるいは有効化で、進行報告が出力されます。␞␞       </para>␞
␝       <para>␟        When set to <literal>fsync</literal>, which is the default,
        <command>pg_checksums</command> will recursively open and synchronize
        all files in the data directory.  The search for files will follow
        symbolic links for the WAL directory and each configured tablespace.␟デフォルトの<literal>fsync</literal>に設定すると、<command>pg_checksums</command>はデータディレクトリ内のすべてのファイルを再帰的に開いて同期します。
ファイルの検索はWALディレクトリと設定された各テーブル空間のシンボリックリンクをたどります。␞␞       </para>␞
␝       <para>␟        On Linux, <literal>syncfs</literal> may be used instead to ask the
        operating system to synchronize the whole file systems that contain the
        data directory, the WAL files, and each tablespace.  See
        <xref linkend="guc-recovery-init-sync-method"/> for information about
        the caveats to be aware of when using <literal>syncfs</literal>.␟Linuxでは、<literal>syncfs</literal>を代わりに使用して、データディレクトリ、WALファイル、各テーブル空間を含むファイルシステム全体を同期させるようにオペレーティングシステムに要求することもできます。
<literal>syncfs</literal>を使用する際に注意すべき点については、<xref linkend="guc-recovery-init-sync-method"/>を参照してください。␞␞       </para>␞
␝        This option has no effect when <option>--no-sync</option> is used.␟        This option has no effect when <option>--no-sync</option> is used.␟このオプションは<option>--no-sync</option>が使われている場合には効果がありません。␞␞       </para>␞
␝       <para>␟        Enable verbose output. Lists all checked files.␟冗長な出力を有効にします。
チェックした全ファイルの一覧を出力します。␞␞       </para>␞
␝       <para>␟        Print the <application>pg_checksums</application> version and exit.␟<application>pg_checksums</application>のバージョンを出力して終了します。␞␞       </para>␞
␝        <para>␟         Show help about <application>pg_checksums</application> command line
         arguments, and exit.␟<application>pg_checksums</application>のコマンドライン引数のヘルプを表示して終了します。␞␞        </para>␞
␝ <refsect1>␟  <title>Environment</title>␟  <title>環境</title>␞␞␞
␝     <para>␟      Specifies the directory where the database cluster is
      stored; can be overridden using the <option>-D</option> option.␟データベースクラスタが格納されたディレクトリを指定します。
これに対して<option>-D</option>オプションで上書き指定できます。␞␞     </para>␞
␝     <para>␟      Specifies whether to use color in diagnostic messages. Possible values
      are <literal>always</literal>, <literal>auto</literal> and
      <literal>never</literal>.␟診断メッセージで色を使うかどうかを指定します。
指定可能な値は<literal>always</literal>、<literal>auto</literal>、<literal>never</literal>です。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞  <para>␞
␝  <para>␟   Enabling checksums in a large cluster can potentially take a long time.
   During this operation, the cluster or other programs that write to the
   data directory must not be started or else data loss may occur.␟大きいクラスタでチェックサムを有効にするには、場合によっては長時間を要する可能性があります。
この操作中にデータディレクトリに書き込みをするクラスタや他のプログラムを開始してはいけません。さもないとデータ損失が起きるかもしれません。␞␞  </para>␞
␝  <para>␟   When using a replication setup with tools which perform direct copies
   of relation file blocks (for example <xref linkend="app-pgrewind"/>),
   enabling or disabling checksums can lead to page corruptions in the
   shape of incorrect checksums if the operation is not done consistently
   across all nodes. When enabling or disabling checksums in a replication
   setup, it is thus recommended to stop all the clusters before switching
   them all consistently. Destroying all standbys, performing the operation
   on the primary and finally recreating the standbys from scratch is also
   safe.␟リレーションファイルブロックの直接コピーを行うツール（例えば<xref linkend="app-pgrewind"/>）でレプリケーションのセットアップを使う時のチェックサムの有効化や無効化は、操作が全ノードを通して一貫して行われない場合、不正なチェックサムという形でページ破損を引き起こすおそれがあります。
したがって、レプリケーションのセットアップでチェックサムの有効化や無効化をするときには、一貫して切り替える前にすべてのクラスタを停止することを推奨します。
全てのスタンバイを廃棄して、プライマリ上で操作を行い、最後にスタンバイを新たに再作成するのも安全です。␞␞  </para>␞
␝  <para>␟   If <application>pg_checksums</application> is aborted or killed while
   enabling or disabling checksums, the cluster's data checksum configuration
   remains unchanged, and <application>pg_checksums</application> can be
   re-run to perform the same operation.␟チェックサムの有効化や無効化をしている最中に<application>pg_checksums</application>が中断されたり、killされたりした場合、クラスタのデータチェックサム設定は変更されないままとなり、<application>pg_checksums</application>を再実行して同じ操作をおこなえます。␞␞  </para>␞
