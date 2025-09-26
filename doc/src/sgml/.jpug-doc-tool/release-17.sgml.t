␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2025-08-14</para>␞
␝  <para>␟   This release contains a variety of fixes from 17.5.
   For information about new features in major release 17, see
   <xref linkend="release-17"/>.␟このリリースは17.5に対し、様々な不具合を修正したものです。
17メジャーリリースにおける新機能については、<xref linkend="release-17"/>を参照してください。␞␞  </para>␞
␝   <para>␟    A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you have any
    BRIN <literal>numeric_minmax_multi_ops</literal> indexes, it is
    advisable to reindex them after updating.  See the fourth changelog
    entry below.␟《マッチ度[61.309524]》また、BRINブルームインデックスがある場合は、更新後にインデックスを再作成することをお勧めします。
以下の3番目の変更ログの項目を参照してください。
《機械翻訳》ただし、BRIN <literal>numeric_minmax_multi_ops</literal>インデックスがある場合は、更新の後にインデックス再作成することをお勧めします。
以下の4番目の変更ログエントリを参照してください。␞␞   </para>␞
␝   <para>␟    Also, if you are upgrading from a version earlier than 17.5,
    see <xref linkend="release-17-5"/>.␟また、17.5より前のバージョンからアップグレードする場合は、<xref linkend="release-17-5"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-17-6-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Tighten security checks in planner estimation functions
      (Dean Rasheed)␟《機械翻訳》セキュリティ予測機能におけるプランナチェックの強化
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;a85eddab2">&sect;</ulink>␞
␝     <para>␟      The fix for CVE-2017-7484, plus followup fixes, intended to prevent
      leaky functions from being applied to statistics data for columns
      that the calling user does not have permission to read.  Two gaps in
      that protection have been found.  One gap applies to partitioning
      and inheritance hierarchies where RLS policies on the tables should
      restrict access to statistics data, but did not.␟《機械翻訳》CVE-2017-7484（プラス）の修正は、呼び出し元のデータが読み取る統計処理を持たない列に対して、漏れのある関数がユーザのパーミッションに適用されるのを防ぐことを目的とした修正に続くものです。
この保護には2つのギャップがあります。
1つのギャップは、表のRLSポリシーがアクセスを統計処理のデータに制限する必要があるパーティショニングと継承の階層に適用されますが、適用されませんでした。␞␞     </para>␞
␝     <para>␟      The other gap applies to cases where the query accesses a table via
      a view, and the view owner has permissions to read the underlying
      table but the calling user does not have permissions on the view.
      The view owner's permissions satisfied the security checks, and the
      leaky function would get applied to the underlying table's
      statistics before we check the calling user's permissions on the
      view.  This has been fixed by making security checks on views occur
      at the start of planning.  That might cause permissions failures to
      occur earlier than before.␟《機械翻訳》もう1つのギャップは、問い合わせがビューを介して表にアクセスする場合に適用されます。
ビュー所有者には基礎となるテーブルの読取り権限がありますが、コール元のユーザにはビューに対する権限がありません。
ビュー所有者の権限はセキュリティチェックを満たしており、漏洩する関数は基礎となるテーブルの統計処理前チェックに適用されます。
コール元のユーザのビューに対する権限です。
この問題は、planningのスタートでビューのセキュリティチェックを実行することで修正されました。
これにより、前よりも前に権限エラーが発生する可能性があります。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Dean Rasheed for reporting this problem.
      (CVE-2025-8713)␟《マッチ度[72.566372]》<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたStephen Fewerに感謝します。
(CVE-2025-1094)
《機械翻訳》<productname>PostgreSQL</productname>プロジェクトは、この問題を報告してくれたDean Rasheedに感謝している。
(CVE-2025-8713)。␞␞     </para>␞
␝     <para>␟      Prevent <application>pg_dump</application> scripts from being used
      to attack the user running the restore (Nathan Bossart)␟《機械翻訳》リストアを実行しているユーザを攻撃するために<application>pg_dump</application>スクリプトが使用されるのを防ぎます。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;575f54d4c">&sect;</ulink>␞
␝     <para>␟      Since dump/restore operations typically involve running SQL commands
      as superuser, the target database installation must trust the source
      server.  However, it does not follow that the operating system user
      who executes <application>psql</application> to perform the restore
      should have to trust the source server.  The risk here is that an
      attacker who has gained superuser-level control over the source
      server might be able to cause it to emit text that would be
      interpreted as <application>psql</application> meta-commands.
      That would provide shell-level access to the restoring user's own
      account, independently of access to the target database.␟《機械翻訳》ダンプ/リストア操作には通常、スーパーユーザとしてのSQLコマンドの実行が含まれるため、ターゲットデータベースインストレーションはソースサーバを信頼する必要があります。
ただし、<application>psql</application>リストアを実行するために実行するオペレーティングシステムユーザがソースサーバを信頼する必要があるということにはなりません。
ここでのリスクは、ソースサーバに対してスーパーユーザ-レベルコントロールを獲得した攻撃者が、<application>psql</application>メタ-commandsと解釈されるテキストを発生させることができる可能性があるということです。
これにより、シェル-レベルアクセスは、アクセスへのとは独立して、復元するユーザ自身のアカウントに提供されます。
ターゲットデータベース␞␞     </para>␞
␝     <para>␟      To provide a positive guarantee that this can't happen,
      extend <application>psql</application> with
      a <command>\restrict</command> command that prevents execution of
      further meta-commands, and teach <application>pg_dump</application>
      to issue that before any data coming from the source server.␟《機械翻訳》これが起こらないことを確実に保証するために、<application>psql</application>を<command>\restrict</command>コマンドで拡張して、それ以上のメタコマンドの実行を防ぎ、<application>pg_dump</application>ソースサーバから来る前をそのデータに発行するように教える。␞␞     </para>␞
␝     <para>␟      The PostgreSQL Project thanks Martin Rakhmanov, Matthieu Denais, and
      RyotaK for reporting this problem.
      (CVE-2025-8714)␟《機械翻訳》PostgreSQLプロジェクトは、この問題を報告してくれたMartin Rakhmanov、Matthieu Denais、およびRyotaKに感謝します。
(CVE-2025-8714)。␞␞     </para>␞
␝     <para>␟      Convert newlines to spaces in names included in comments
      in <application>pg_dump</application> output
      (Noah Misch)␟《機械翻訳》<application>pg_dump</application> output.confのコメントに含まれる名前の改行をスペースに変換します。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;9b92f115b">&sect;</ulink>␞
␝     <para>␟      Object names containing newlines offered the ability to inject
      arbitrary SQL commands into the output script.  (Without the
      preceding fix, injection of <application>psql</application>
      meta-commands would also be possible this way.)
      CVE-2012-0868 fixed this class of problem at the time, but later
      work reintroduced several cases.␟《機械翻訳》改行を含むオブジェクト名は、任意のSQLコマンドをスクリプトに注入する機能を提供しました。
(上記の修正がなければ、<application>psql</application>メタコマンドのインジェクションもこの方法で可能でした。
CVE-2012-0868は当時このクラスの問題を修正しましたが、後の作業でいくつかのケースが再導入されました。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Noah Misch for reporting this problem.
      (CVE-2025-8715)␟《マッチ度[72.072072]》<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたTom Laneに感謝します。
(CVE-2024-10978)
《機械翻訳》<productname>PostgreSQL</productname>プロジェクトは、この問題を報告してくれたNoah Mischに感謝している。
(CVE-2025-8715)。␞␞     </para>␞
␝     <para>␟      Fix incorrect distance calculation in
      BRIN <literal>numeric_minmax_multi_ops</literal> support function
      (Peter Eisentraut, Tom Lane)␟《機械翻訳》BRIN <literal>numeric_minmax_multi_ops</literal>サポート関数での不正確な距離計算を修正しました。
(Peter Eisentraut, Tom Lane)␞␞      <ulink url="&commit_baseurl;0b0d3c19b">&sect;</ulink>␞
␝     <para>␟      The results were sometimes wrong on 64-bit platforms, and wildly
      wrong on 32-bit platforms.  This did not produce obvious failures
      because the logic is only used to choose how to merge values into
      ranges; at worst the index would become inefficient and bloated.
      Nonetheless it's recommended to reindex any BRIN indexes that use
      the <literal>numeric_minmax_multi_ops</literal> operator class.␟《機械翻訳》その結果、64-ビットプラットフォームで間違いになることもあれば、32-ビットプラットフォームで間違いになることもありました。
ロジックは値を範囲にマージする方法を選択するためにのみ使用されるため、これは明らかな失敗を引き起こしませんでした。
最悪の場合、インデックスは非効率的で肥大化してしまいます。
それでも、<literal>numeric_minmax_multi_ops</literal>演算子クラスを使用するBRINインデックスをインデックス再作成することをお勧めします。␞␞     </para>␞
␝     <para>␟      Avoid regression in the size of XML input that we will accept
      (Michael Paquier, Erik Wienhold)␟《機械翻訳》私たちが受け入れるXMLサイズのリグレッションは避けてください。
(Michael Paquier, Erik Wienhold)␞␞      <ulink url="&commit_baseurl;fd4ad33fe">&sect;</ulink>␞
␝     <para>␟      Our workaround for a bug in early 2.13.x releases
      of <application>libxml2</application> made use of a code path that
      rejects text chunks exceeding 10MB, whereas the previous coding did
      not.  Those early releases are presumably extinct in the wild by
      now, so revert to the previous coding.␟《機械翻訳》の2.13.xリリース初期のバグに対する回避策では、10コードパスを超えるテキストチャンクを拒否するメガバイトを使用していましたが、以前のコーディングでは使用していませんでした。
これらの初期リリースはおそらく現在では野生で絶滅しているため、以前のコーディングに戻してください。
<application>libxml2</application>␞␞     </para>␞
␝     <para>␟      Fix <command>MERGE</command> problems with concurrent updates
      (Dean Rasheed)␟《機械翻訳》修正<command>MERGE</command>同時更新の問題。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;91ad1bdef">&sect;</ulink>␞
␝     <para>␟      If a <command>MERGE</command>
      inside a CTE attempts an update or delete on a table with
      <literal>BEFORE ROW</literal> triggers, and a
      concurrent <command>UPDATE</command> or <command>DELETE</command>
      changes the target row, the <command>MERGE</command> command would
      fail (crashing in the case of an update action, and potentially
      executing the wrong action in the case of a delete action).␟《機械翻訳》<command>MERGE</command>CTE内のが<literal>BEFORE ROW</literal>トリガ、およびコンカレント<command>UPDATE</command>または<command>DELETE</command>は更新行を変更するを持つテーブルでターゲットまたは削除を試行した場合、<command>MERGE</command>コマンドは失敗します更新アクションのケースでクラッシュし、削除アクションのケースで間違いアクションを実行する可能性があります。␞␞     </para>␞
␝     <para>␟      Fix <command>MERGE</command> into a plain-inheritance parent table
      (Dean Rasheed)␟《機械翻訳》<command>MERGE</command>平地継承親テーブルに固定する。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;ab52f6b5b">&sect;</ulink>␞
␝     <para>␟      Insertions into such a target table could crash or produce incorrect
      query results due to failing to handle <literal>WITH CHECK
      OPTION</literal> and <literal>RETURNING</literal> actions.␟《機械翻訳》このようなターゲットテーブルに挿入すると、クラッシュが発生したり、ハンドルに失敗したために誤った問い合わせ結果が生成されたりする可能性があります<literal>RETURNING</literal>およびアクション。
<literal>WITH CHECK OPTION</literal>␞␞     </para>␞
␝     <para>␟      Allow tables with statement-level triggers to become partitions or
      inheritance children (Etsuro Fujita)␟《機械翻訳》ステートメント-レベルトリガを持つテーブルがパーティションまたは継承の子になることを許可します。
(Etsuro Fujita)␞␞      <ulink url="&commit_baseurl;e028ce911">&sect;</ulink>␞
␝     <para>␟      We do not allow partitions or inheritance child tables to have
      row-level triggers with transition tables, because an operation on
      the whole inheritance tree would need to maintain a separate
      transition table for each such child table.  But that problem does
      not apply for statement-level triggers, because only the parent's
      statement-level triggers will be fired.  The code that checks
      whether an existing table can become a partition or inheritance
      child nonetheless rejected both kinds of trigger.␟《機械翻訳》継承ツリー全体の行は、このような子レベルごとに個別の遷移テーブルを維持する必要があるため、パーティションまたは継承の子テーブルが遷移テーブルを持つオペレーション-トリガを持つことはできません。
しかし、この問題はステートメントレベルトリガには当てはまりません。
親のステートメント-レベルトリガのみが起動されるためです。
既存のテーブルがパーティションまたは継承の子になることができるかどうかをチェックするコードは、それでも両方の種類のトリガを拒否しました。
テーブル␞␞     </para>␞
␝     <para>␟      Disallow collecting transition tuples from child foreign tables
      (Etsuro Fujita)␟《機械翻訳》子外部テーブルからの遷移タプルの収集を禁止します。
(Etsuro Fujita)␞␞      <ulink url="&commit_baseurl;9048a83c7">&sect;</ulink>␞
␝     <para>␟      We do not support triggers with transition tables on foreign tables.
      However, the case of a partition or inheritance child that is a
      foreign table was overlooked.  If the parent has such a trigger,
      incorrect transition tuples were collected from the foreign child.
      Instead throw an error, reporting that the case is not supported.␟《機械翻訳》外部テーブルの遷移テーブルではトリガをサポートしません。
しかし、ケースであるパーティションまたは継承の子の外部テーブルが見落とされていました。
親にそのようなトリガがある場合、不正な遷移タプルが外部の子から収集されました。
代わりにエラーをスローして、ケースがサポートされていないことを報告します。␞␞     </para>␞
␝     <para>␟      Allow resetting unknown custom parameters with reserved prefixes
      (Nathan Bossart)␟《機械翻訳》予約プレフィックスを持つ不明なカスタムパラメータのリセットを許可します。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;39ff05636">&sect;</ulink>␞
␝     <para>␟      Previously, if a parameter setting had been stored
      using <command>ALTER DATABASE/ROLE/SYSTEM</command>, the stored
      setting could not be removed if the parameter was unknown but had a
      reserved prefix.  This case could arise if an extension used to have
      a parameter, but that parameter had been removed in an upgrade.␟《機械翻訳》以前は、パラメータ設定が<command>ALTER DATABASE/ROLE/SYSTEM</command>を使用して保存されている場合、パラメータが不明で予約プレフィックスがあると、保存された設定を削除できませんでした。
このケースは、extensionにパラメータがあったが、アップグレードでパラメータが削除された場合に発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix a potential deadlock during <command>ALTER SUBSCRIPTION ... DROP
      PUBLICATION</command> (Ajin Cherian)␟《機械翻訳》潜在的なデッドロックを修正する<command>ALTER SUBSCRIPTION ... DROP PUBLICATION</command>.
(Ajin Cherian)␞␞      <ulink url="&commit_baseurl;8c298324a">&sect;</ulink>␞
␝     <para>␟      Ensure that server processes acquire catalog locks in a consistent
      order during replication origin drops.␟《機械翻訳》保証プロセスがサーバロックを獲得するカタログは、複製起点が落ちる間に一貫したオーダーで行われる。␞␞     </para>␞
␝     <para>␟      Shorten the race condition window for creating indexes with
      conflicting names (Tom Lane)␟《機械翻訳》名前が競合するインデックスを作成するための[競合条件]ウィンドウを短縮します。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;fdd826922">&sect;</ulink>␞
␝     <para>␟      When choosing an auto-generated name for an index, avoid conflicting
      with not-yet-committed <structname>pg_class</structname> rows as
      well as fully-valid ones.  This avoids possibly choosing the same
      name as some concurrent <command>CREATE INDEX</command> did,
      when that command is still in process of filling its index, or is
      done but is part of a not-yet-committed transaction.  There's still
      a window for trouble, but it's only as long as the time needed to
      validate a new index's parameters and insert
      its <structname>pg_class</structname> row.␟《機械翻訳》インデックス用に自動生成された名前を選択する時、完全に有効なものと同様に、まだコミットされていない<structname>pg_クラス</structname>行と競合しないようにします。
これにより、いくつかの同時実行<command>CREATE INDEX</command> didと同じ名前が選択される可能性を避けることができます。
そのコマンドがまだプロセスにあってインデックスを満たしている場合、または完了したがまだコミットされていないトランザクションのパートである場合です。
トラブル用のウィンドウはまだありますが、それは新しいインデックスのパラメータを検証し、その<structname>pg_class</structname>行を挿入するのに必要な時間だけです。␞␞     </para>␞
␝     <para>␟      Prevent usage of incorrect <command>VACUUM</command> options in some
      cases where multiple tables are vacuumed in a single command (Nathan
      Bossart, Michael Paquier)␟《機械翻訳》誤った<command>VACUUM</command>オプションテーブルが単一のマルチプルでバキュームされる場合のコマンドの使用を防止しました。
(Nathan Bossart, Michael Paquier)␞␞      <ulink url="&commit_baseurl;2e0b5d252">&sect;</ulink>␞
␝     <para>␟      The <literal>TRUNCATE</literal> and <literal>INDEX_CLEANUP</literal>
      options of one table could be applied to others.␟《機械翻訳》あるオプションの<literal>TRUNCATE</literal>および<literal>INDEX_CLEANUP</literal>テーブルは他の地域にも適用できる。␞␞     </para>␞
␝     <para>␟      Ensure that the table's free-space map is updated in a timely way
      when vacuuming a table that has no indexes (Masahiko Sawada)␟《機械翻訳》インデックスを持たないテーブルを保証するときに、テーブルのフリー-スペースマップがタイムリーに更新されるバキューム処理。
(Masahiko Sawada)␞␞      <ulink url="&commit_baseurl;792238c8b">&sect;</ulink>␞
␝     <para>␟      A previous optimization caused FSM vacuuming to sometimes be skipped
      for such tables.␟《機械翻訳》以前の最適化では、FSMバキューム処理がこのようなテーブルのスキップされたになることがありました。␞␞     </para>␞
␝     <para>␟      Fix processing of character classes within <literal>SIMILAR
      TO</literal> regular expressions (Laurenz Albe)␟《機械翻訳》<literal>SIMILAR TO</literal>正規表現内の文字クラスの処理を修正しました。
(Laurenz Albe)␞␞      <ulink url="&commit_baseurl;e3ffc3e91">&sect;</ulink>␞
␝     <para>␟      The code that translates <literal>SIMILAR TO</literal> pattern
      matching expressions to POSIX-style regular expressions did not
      consider that square brackets can be nested.  For example, in a
      pattern like <literal>[[:alpha:]%_]</literal>, the code treated
      the <literal>%</literal> and <literal>_</literal> characters as
      metacharacters when they should be literals.␟《機械翻訳》<literal>SIMILAR TO</literal>パターンマッチ表現をPOSIX-スタイル表現に変換するコードは、大括弧がネストできることを考慮していませんでした。
例の場合、<literal>[[:alpha:]%_]</literal>のようなパターンでは、コードは<literal>%</literal>および<literal>_</literal>文字がリテラルであるべきときにメタ文字として処理しました。␞␞     </para>␞
␝     <para>␟      When deparsing queries, always add parentheses around the expression
      in <literal>FETCH FIRST <replaceable>expression</replaceable> ROWS
      WITH TIES</literal> clauses (Heikki Linnakangas)␟《機械翻訳》問い合わせを解析するときは、<literal>FETCH FIRST <replaceable>expression</replaceable> ROWS WITH TIES</literal>句の式の前後に必ずカッコを追加してください。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;54c05292b">&sect;</ulink>␞
␝     <para>␟      This avoids some cases where the deparsed result wasn't
      syntactically valid.␟《機械翻訳》これにより、逆解析された結果が構文的に有効でなかった場合を回避できる。␞␞     </para>␞
␝     <para>␟      Limit the checkpointer process's fsync request queue size (Alexander
      Korotkov, Xuneng Zhou)␟《機械翻訳》チェックポインタプロセスのfsyncリクエストキューサイズを制限します。
(Alexander Korotkov, Xuneng Zhou)␞␞      <ulink url="&commit_baseurl;13559de95">&sect;</ulink>␞
␝     <para>␟      With very large <varname>shared_buffers</varname> settings, it was
      possible for the checkpointer to attempt to allocate more than 1GB
      for fsync requests, leading to failure and an infinite loop.  Clamp
      the queue size to prevent this scenario.␟《機械翻訳》非常にラージ<varname>shared_buffers</varname>設定では、チェックポインタがfsync要求に対して複数のギガバイトを割り当てようとする可能性があり、失敗して無限ループが発生しました。
キューサイズをクランプして、このシナリオを防止します。␞␞     </para>␞
␝     <para>␟      Avoid infinite wait in logical decoding when reading a
      partially-written WAL record (Vignesh C)␟《機械翻訳》部分的に作成されたWAL無限を読み込む場合、ロジカルデコーディングでのレコード待機を回避してください。
(Vignesh C)␞␞      <ulink url="&commit_baseurl;c9f4e7520">&sect;</ulink>␞
␝     <para>␟      If the server crashes after writing the first part of a WAL record
      that would span multiple pages, subsequent logical decoding of the
      WAL stream would wait for data to arrive on the next WAL page.
      That might never happen if the server is now idle.␟《機械翻訳》マルチプルサーバにまたがるWALレコードの最初のパートを書き込んだ後にページがクラッシュした場合、WALストリームの次のロジカルデコーディングはデータが次のWALページに到着するのを待ちます。
サーバが現在アイドル状態の場合、これは起こらない可能性があります。␞␞     </para>␞
␝     <para>␟      Fix inconsistent spelling of LWLock names
      for <literal>MultiXactOffsetSLRU</literal>
      and <literal>MultiXactMemberSLRU</literal> (Bertrand Drouvot)␟《機械翻訳》<literal>MultiXactOffsetSLRU</literal>と<literal>MultiXactMemberSLRU</literal>のLWLock名のスペルの矛盾を修正しました。
(Bertrand Drouvot)␞␞      <ulink url="&commit_baseurl;b3abec0ad">&sect;</ulink>␞
␝     <para>␟      This resulted in different wait-event names being displayed
      in <structname>pg_wait_events</structname>
      and <structname>pg_stat_activity</structname>, potentially breaking
      monitoring queries that join those views.␟《機械翻訳》これにより、異なる待機イベント名が<structname>pg_wait_events</structname>と<structname>pg_stat_activity</structname>に表示され、これらのビューを監視する結合問い合わせが壊れる可能性がある。␞␞     </para>␞
␝     <para>␟      Fix inconsistent quoting of role names in ACL strings (Tom Lane)␟《機械翻訳》ロール文字列におけるACL名の矛盾したクォートを修正しました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;50959f96e">&sect;</ulink>␞
␝     <para>␟      The previous quoting rule was locale-sensitive, which could lead to
      portability problems when transferring <type>aclitem</type> values
      across installations.  (<application>pg_dump</application> does not
      do that, but other tools might.)  To ensure consistency, always quote
      non-ASCII characters in <type>aclitem</type> output; but to preserve
      backward compatibility, never require that they be quoted
      during <type>aclitem</type> input.␟《機械翻訳》以前の引用符付きルールはロケールに依存していました。
このため、インストール環境間で<type>aclitem</type>値を転送する際に移植性の問題が発生する可能性がありました<application>pg_dump</application>これは行いませんが、他のツールでは行う場合があります。
保証一貫性では、非ASCII文字は常に<type>aclitem</type>出力で引用符付けされます。
しかし、逆方向互換性を維持するために、<type>aclitem</type>入力で引用符付けされる必要はありません。␞␞     </para>␞
␝     <para>␟      Reject equal signs (<literal>=</literal>) in the names of relation
      options and foreign-data options (Tom Lane)␟《機械翻訳》リレーションオプションと外国-データオプションの名前に等号(<literal>=</literal>を使用しないでください。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;d4046125d">&sect;</ulink>␞
␝     <para>␟      There's no evident use-case for option names like this, and allowing
      them creates ambiguity in the stored representation.␟《機械翻訳》このようなオプション名には明確な-ケースの使用法はなく、それらを許可すると、保存された表現形式に曖昧さが生じます。␞␞     </para>␞
␝     <para>␟      Fix potentially-incorrect decompression of LZ4-compressed archive
      data (Mikhail Gribkov)␟《機械翻訳》LZ 4で圧縮されたアーカイブデータの圧縮解除が不正確になる可能性を修正しました。
(Mikhail Gribkov)␞␞      <ulink url="&commit_baseurl;074003431">&sect;</ulink>␞
␝     <para>␟      This error seems to manifest only with not-very-compressible input
      data, which may explain why it escaped detection.␟《機械翻訳》このエラーは、あまり圧縮されない入力データでのみ現れるようであり、これが検出を免れた理由を説明している可能性がある。␞␞     </para>␞
␝     <para>␟      Avoid a rare scenario where a btree index scan could mark the wrong
      index entries as dead (Peter Geoghegan)␟《機械翻訳》2本の木のインデックススキャンが間違いのインデックスの入り口を死んだものとしてマークにするような珍しいシナリオは避けてください。
(Peter Geoghegan)␞␞      <ulink url="&commit_baseurl;40aa5ddea">&sect;</ulink>␞
␝     <para>␟      Avoid re-distributing cache invalidation messages from other
      transactions during logical replication (vignesh C)␟《機械翻訳》キャッシュ中に他のトランザクションから論理レプリケーション無効化メッセージを再配布しないようにします。
(vignesh C)␞␞      <ulink url="&commit_baseurl;45c357e0e">&sect;</ulink>␞
␝     <para>␟      Our previous round of minor releases included a bug fix to ensure
      that replication receiver processes would respond to cross-process
      cache invalidation messages, preventing them from using stale
      catalog data while performing replication updates.  However, the fix
      unintentionally made them also redistribute those messages again,
      leading to an exponential increase in the number of invalidation
      messages, which would often end in a memory allocation failure.
      Fix by not redistributing received messages.␟《機械翻訳》前回のマイナーリリースでは、レプリケーションレシーバプロセスがクロス-プロセスキャッシュの無効化メッセージに応答して、レプリケーションアップデートの実行中に古いカタログデータを使用できないようにする保証のバグ修正が含まれていました。
しかし、この修正により、意図せずこれらのメッセージが再配布され、無効化メッセージの数が急激に増加し、多くの場合、メモリアロケーション障害が発生しました。
受信したメッセージを再配布しないことで修正しました。␞␞     </para>␞
␝     <para>␟      Avoid unexpected server shutdown when replication slot
      synchronization is misconfigured (Fujii Masao)␟《機械翻訳》サーバシャットダウンの同期が誤って設定されている場合は、予期しないレプリケーションスロットを回避します。
(Fujii Masao)␞␞      <ulink url="&commit_baseurl;f71fa981c">&sect;</ulink>␞
␝     <para>␟      The postmaster process would report an error (and then stop)
      if <varname>sync_replication_slots</varname> was set
      to <literal>true</literal> while <varname>wal_level</varname> was
      less than <literal>logical</literal>.  The desired behavior is just
      that slot synchronization should be disabled, so reduce this error
      message's level to avoid postmaster shutdown.␟《機械翻訳》<varname>sync_レプリケーション_slots</varname>が<literal>true</literal> while<varname>wal_レベル</varname>がより小さい<literal>logical</literal>に設定された場合、postmasterプロセスはエラーをレポートします。
望ましい動作は、スロットの同期を無効にすることです。
そのため、postmasterシャットダウンを回避するために、このエラーメッセージのレベルを減らします。␞␞     </para>␞
␝     <para>␟      Avoid premature removal of old WAL during checkpoints (Vitaly Davydov)␟《機械翻訳》チェックポイントの間、古いWALの時期尚早な削除を避けます。
(Vitaly Davydov)␞␞      <ulink url="&commit_baseurl;2090edc6f">&sect;</ulink>␞
␝     <para>␟      If a replication slot's restart point is advanced while a checkpoint
      is in progress, no-longer-needed WAL segments could get removed too
      soon, leading to recovery failure if the database crashes
      immediately afterwards.  Fix by keeping them for one additional
      checkpoint cycle.␟《機械翻訳》レプリケーションスロットの進行中にチェックポイントのリスタートポイントが進められた場合、不要となったWALセグメントがあまりにも早く削除され、その直後にリカバリがクラッシュした場合にデータベース障害が発生する可能性がありました。
チェックポイントサイクルを1つ増やすためにそれらを保持することで修正しました。␞␞     </para>␞
␝     <para>␟      Never move a replication slot's confirmed-flush position backwards
      (Shveta Malik)␟《機械翻訳》レプリケーションスロットの確定フラッシュ位置を後方に移動しないでください。
(Shveta Malik)␞␞      <ulink url="&commit_baseurl;7318f241d">&sect;</ulink>␞
␝     <para>␟      In some cases a replication client could acknowledge an LSN that's
      past what it has stored persistently, and then perhaps send an older
      LSN after a restart.  We consider this not-a-bug so long as the
      client did not have anything it needed to do for the WAL between the
      two points.  However, we should not re-send that WAL for fear of
      data duplication, so make sure we always believe the latest
      confirmed LSN for a given slot.␟《機械翻訳》場合によっては、レプリケーションクライアントは永続的に保存したものを過ぎたLSNを確認し、リスタートの後に古いLSNを送信することがあります。
バグが2つのポイント間のWALのために必要なことを何も持っていない限り、これはクライアントではないと考えます。
しかし、データの重複を恐れてそのWALを再送信すべきではないので、makeは常に特定のスロットの最新の確認されたLSNを信じています。␞␞     </para>␞
␝     <para>␟      Prevent excessive delays before launching new logical replication
      workers (Tom Lane)␟《機械翻訳》前の新規論理レプリケーション労働者の立ち上げの過度の遅延を防止する。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;9f33300e6">&sect;</ulink>␞
␝     <para>␟      In some cases the logical replication launcher could sleep
      considerably longer than the
      configured <varname>wal_retrieve_retry_interval</varname> before
      launching a new worker.␟《機械翻訳》場合によっては、論理レプリケーションランチャは、設定された<varname>wal_retrieve_retry_interval</varname>新しいワーカーを開始する前よりもかなり長くスリープする可能性があります。␞␞     </para>␞
␝     <para>␟      Fix use-after-free during logical replication of <command>INSERT
      ... ON CONFLICT</command> (Ethan Mertz, Michael Paquier)␟《機械翻訳》<command>INSERT ... ON CONFLICT</command>のフリー中の論理レプリケーション後の使用を修正。
(Ethan Mertz, Michael Paquier)␞␞      <ulink url="&commit_baseurl;9e0b4b1ab">&sect;</ulink>␞
␝     <para>␟      This could result in incorrect progress reporting, or with very bad
      luck it could result in a crash of the WAL sender process.␟《機械翻訳》これは不正確な進行状況報告となる可能性があり、非常に運が悪い場合はWAL送信者のクラッシュがプロセスになってしまう可能性があります。␞␞     </para>␞
␝     <para>␟      Allow waiting for a transaction on a standby server to be
      interrupted (Kevin K Biju)␟《機械翻訳》スタンバイサーバのトランザクションが中断されるのを待つことを許可する。
(Kevin K Biju)␞␞      <ulink url="&commit_baseurl;24c5ad5be">&sect;</ulink>␞
␝     <para>␟      Creation of a replication slot on a standby server may require waiting
      for some active transaction(s) to finish on the primary and then be
      replayed on the standby.  Since that could be an indefinite wait,
      it's desirable to allow the operation to be cancelled, but there was
      no check for query cancel in the loop.␟《機械翻訳》スタンバイサーバにレプリケーションスロットを作成すると、一部のアクティブトランザクションがプライマリで終了し、スタンバイでリプレイされるのを待つ必要がある場合があります。
これは無期限の待機になる可能性があるため、オペレーションをキャンセルできるようにすることが望ましいですが、ループに問い合わせキャンセルのチェックはありませんでした。␞␞     </para>␞
␝     <para>␟      Do not let cascading logical WAL senders try to send data that's
      beyond what has been replayed on their standby server (Alexey
      Makhmutov)␟《機械翻訳》カスケードされたロジカルのWAL送信者のトライが、彼らのスタンバイサーバで再生された範囲を超えてデータを送信しないようにしてください。
(Alexey Makhmutov)␞␞      <ulink url="&commit_baseurl;87be749c7">&sect;</ulink>␞
␝     <para>␟      This avoids a situation where such WAL senders could get stuck at
      standby server shutdown, waiting for replay work that will not
      happen because the server's startup process is already shut down.␟《機械翻訳》これにより、このようなWAL送信者がスタンバイサーバシャットダウンで立ち往生し、リプレイサーバのスタートアッププロセスが既にダウンで閉鎖されているために発生しないであろう作業を待つというシチュエーションを回避することができます。␞␞     </para>␞
␝     <para>␟      Fix per-relation memory leakage in autovacuum (Tom Lane)␟《機械翻訳》オートバキュームにおけるリレーションごとのメモリ漏洩の修復。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;cd3064f98">&sect;</ulink>␞
␝     <para>␟      Fix session-lifespan memory leaks
      in <function>XMLSERIALIZE(... INDENT)</function>
      (Dmitry Kovalenko, Tom Lane)␟《機械翻訳》セッションのライフスパン<function>XMLSERIALIZE(... INDENT)</function> lifespanが.メモリ
(Dmitry Kovalenko, Tom Lane)␞␞      <ulink url="&commit_baseurl;95cf1a181">&sect;</ulink>␞
␝     <para>␟      Fix possible crash after out-of-memory when allocating large chunks
      with the <quote>bump</quote> allocator (Tom Lane)␟《機械翻訳》<quote>bump</quote>アロケーターを使用してクラッシュチャンクを割り当てるときに、メモリ外の後に発生する可能性があったラージを修正しました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;a05cf22e0">&sect;</ulink>␞
␝     <para>␟      Fix some places that might try to fetch toasted fields of system
      catalogs without any snapshot (Nathan Bossart)␟《機械翻訳》トライのないシステムカタログのフェッチに焼けた畑にsnapshotが降る可能性のあるいくつかの場所を修正します。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;fe8ea7a2a">&sect;</ulink>␞
␝     <para>␟      This could result in an assertion failure or <quote>cannot fetch
      toast data without an active snapshot</quote> error.␟《機械翻訳》これにより、アサーションが故障するか、<quote>TOASTデータなしでアクティブsnapshotをフェッチすることはできません</quote>エラーが故障する可能性があります。␞␞     </para>␞
␝     <para>␟      Avoid assertion failure during cross-table constraint updates
      (Tom Lane, Jian He)␟《機械翻訳》クロス-テーブル間の制約更新中のアサーションの失敗を避けてください。
(Tom Lane, Jian He)␞␞      <ulink url="&commit_baseurl;bbfcbc4cd">&sect;</ulink>␞
␝     <para>␟      Remove faulty assertion that a command tag must have been determined
      by the end of <function>PortalRunMulti()</function> (Álvaro Herrera)␟《機械翻訳》<function>PortalRunMulti()</function>の終わりまでにアサーションが決定されたはずの欠陥のあるコマンドタグを除去します。
(Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;0c466f5e0">&sect;</ulink>␞
␝     <para>␟      This failed in edge cases such as an empty prepared statement.␟《機械翻訳》これは、プリペアドステートメントが空いている場合などのエッジケースでは失敗しました。␞␞     </para>␞
␝     <para>␟      Fix assertion failure in <literal>XMLTABLE</literal> parsing
      (Richard Guo)␟《機械翻訳》<literal>XMLTABLE</literal>パースのアサーション障害を修正します。
(Richard Guo)␞␞      <ulink url="&commit_baseurl;2f48b4f07">&sect;</ulink>␞
␝     <para>␟      Restore the ability to run PL/pgSQL expressions in parallel
      (Dipesh Dhameliya)␟《機械翻訳》リストアパラレルでPL/pgSQL式を実行できるようになりました。
(Dipesh Dhameliya)␞␞      <ulink url="&commit_baseurl;a553a2289">&sect;</ulink>␞
␝     <para>␟      PL/pgSQL's notion of an <quote>expression</quote> is very broad,
      encompassing any SQL <command>SELECT</command> query that returns a
      single column and no more than one row.  So there are cases, for
      example evaluation of an aggregate function, where the query
      involves significant work and it'd be useful to run it with parallel
      workers.  This used to be possible, but a previous bug fix
      unintentionally disabled it.␟《機械翻訳》PL/pgSQLにおける<quote>式</quote>の概念は非常に幅広く、任意のSQL <command>SELECT</command>単一の問い合わせのみを返し、複数のカラムを返さない行を包含します。
そのため、集約関数の例を評価する場合、問い合わせが重要な作業を伴い、並列ワーカーを使用して実行すると便利な場合があります。
これは以前は可能でしたが、以前のバグ修正で意図せず無効になっていました。␞␞     </para>␞
␝     <para>␟      Fix edge-case resource leaks in PL/Python error reporting (Tom Lane)␟《マッチ度[57.352941]》PL/Pythonのメモリリークが修復されました。
(Mat Arye, Tom Lane)
《機械翻訳》PL/Pythonケースレポートでのエッジエラーリソースリークを修正した。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;7559a16e2">&sect;</ulink>␞
␝     <para>␟      An out-of-memory failure while reporting an error from Python could
      result in failure to drop reference counts on Python objects,
      leading to session-lifespan memory leakage.␟《機械翻訳》Pythonからメモリを報告する際にエラー外の障害が発生すると、Pythonオブジェクトのリファレンスカウントをドロップできなくなり、セッション寿命のメモリ漏れにつながる可能性がある。␞␞     </para>␞
␝     <para>␟      Fix <application>libpq</application>'s
      <function>PQcancelCreate()</function> function for the case where
      the server's address was specified using <literal>hostaddr</literal>
      (Sergei Kornilov)␟《機械翻訳》<literal>hostaddr</literal>を使用して、libpqの関数が指定されたケースについて、<application>サーバ</application>の<function>PQcancelCreate()</function>アドレスを修正します。
(Sergei Kornilov)␞␞      <ulink url="&commit_baseurl;445bd37b1">&sect;</ulink>␞
␝     <para>␟      <application>libpq</application> would crash if the resulting cancel
      object was actually used.␟《機械翻訳》<application>libpq</application>その結果生じたキャンセルオブジェクトが実際に使用された場合、クラッシュになります。␞␞     </para>␞
␝     <para>␟      Fix <application>libpq</application>'s <function>PQport()</function>
      function to never return NULL unless the passed connection is NULL
      (Daniele Varrazzo)␟《機械翻訳》<application>libpq</application>の<function>PQport()</function>関数を修正し、通過するNULLがNULLでない限り、結果コネクションには決して入らないようにします。
(Daniele Varrazzo)␞␞      <ulink url="&commit_baseurl;3f10d2b66">&sect;</ulink>␞
␝     <para>␟      This is the documented behavior, but
      recent <application>libpq</application> versions would return NULL
      in some cases where the user had not provided a port specification.
      Revert to our historical behavior of returning an empty string in
      such cases.  (v18 and later will return the compiled-in default port
      number, typically <literal>"5432"</literal>, instead.)␟《機械翻訳》これは文書化された動作ですが、最近の<application>libpq</application>バージョンでは、NULLが結果指定を提供していない場合にユーザをポートすることがありました。
このような場合に空の文字列を返すという従来の動作に戻してください。
(v18以降では、コンパイル時に組み込まれたデフォルトポート番号を結果します。
通常は<literal>"5432"</literal>代わりにです。␞␞     </para>␞
␝     <para>␟      Avoid failure when GSSAPI authentication requires packets larger
      than 16kB (Jacob Champion, Tom Lane)␟《機械翻訳》GSSAPI認証が16キロバイトより大きいパケットを必要とする場合の失敗を回避します。
(Jacob Champion, Tom Lane)␞␞      <ulink url="&commit_baseurl;8b0aa7a6b">&sect;</ulink>␞
␝     <para>␟      Larger authentication packets are needed for Active Directory users
      who belong to many AD groups.  This limitation manifested in
      connection failures with unintelligible error messages,
      typically <quote>GSSAPI context establishment error: The routine
      must be called again to complete its function: Unknown
      error</quote>.␟《機械翻訳》多数のADグループに属する認証ユーザには、より大きなアクティブディレクトリパケットが必要です。
この制限は、通常、理解できないコネクションメッセージを伴うエラー障害として現れます<quote>GSSAPIコンテキスト確立エラー:ルーチンは、関数を完了するために再度コールする必要があります:不明エラー</quote>。␞␞     </para>␞
␝     <para>␟      Fix timing-dependent failures in SSL and GSSAPI data transmission
      (Tom Lane)␟《機械翻訳》SSLおよびGSSAPIタイミング転送におけるデータ依存の障害を修正しました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;30e0d9ee9">&sect;</ulink>␞
␝     <para>␟      When using SSL or GSSAPI encryption in non-blocking
      mode, <application>libpq</application> sometimes failed
      with <quote>SSL error: bad length</quote> or <quote>GSSAPI caller
      failed to retransmit all data needing to be retried</quote>.␟《機械翻訳》ブロッキング以外の暗号化でSSLまたはGSSAPIモードを使用すると、<application>libpq</application><quote>SSLエラー:不良長さ</quote>で失敗したり、<quote>GSSAPI呼び出し元がすべてのデータの再送信に失敗し、再試行が必要になる</quote>場合がありました。␞␞     </para>␞
␝     <para>␟      Avoid null-pointer dereference during connection lookup
      in <application>ecpg</application> applications (Aleksander
      Alekseev)␟《機械翻訳》<application>ecpg</application> applications.xmlでのNULLルックアップ中にポインタからコネクションへの間接参照を行わないようにしました。
(Aleksander Alekseev)␞␞      <ulink url="&commit_baseurl;2805e1c1e">&sect;</ulink>␞
␝     <para>␟      The case could occur only if the application has some connections
      that are named and some that are not.␟《機械翻訳》ケースは、アプリケーションに記名的である接続とそうでない接続がある場合にのみ発生する可能性があります。␞␞     </para>␞
␝     <para>␟      Improve <application>psql</application>'s tab completion
      for <command>COPY</command> and <command>\copy</command> options
      (Atsushi Torikoshi)␟《機械翻訳》改善<application>psql</application>の<command>COPY</command>と<command>\copy</command>オプションのタブ完成。
(Atsushi Torikoshi)␞␞      <ulink url="&commit_baseurl;c1c6169eb">&sect;</ulink>␞
␝     <para>␟      The same completions were offered for both <command>COPY
      FROM</command> and <command>COPY TO</command>, although some options
      are only valid for one case or the other.  Distinguish these cases
      to provide more accurate suggestions.␟《機械翻訳》<command>COPY FROM</command>と<command>COPY TO</command>の両方に同じ補完が提供されましたが、一部のオプションはどちらか一方のケースでのみ有効です。
これらのケースを区別して、より正確な提案を提供します。␞␞     </para>␞
␝     <para>␟      Avoid assertion failure in <application>pgbench</application> when
      multiple pipeline sync messages are received (Fujii Masao)␟《機械翻訳》<application>pgbench</application>アサーションマルチプル同期メッセージが受信された場合のパイプライン障害を回避します。
(Fujii Masao)␞␞      <ulink url="&commit_baseurl;398e07162">&sect;</ulink>␞
␝     <para>␟      Fix duplicate transaction replay when initializing a subscription
      with <application>pg_createsubscriber</application> (Shlok Kyal)␟《機械翻訳》重複を<application>pg_createsubscriber</application>で初期化する際のトランザクションリプレイを修正しました。
サブスクリプション
(Shlok Kyal)␞␞      <ulink url="&commit_baseurl;967309116">&sect;</ulink>␞
␝     <para>␟      It was possible for the last transaction processed during subscriber
      recovery to be sent again once normal replication begins.␟《機械翻訳》通常のトランザクションが始まれば、サブスクライバーリカバリ中に処理された最後のレプリケーションを再び送ることが可能であった。␞␞     </para>␞
␝     <para>␟      Ensure that <application>pg_dump</application> dumps comments on
      not-null constraints on domain types (Jian He, Álvaro Herrera)␟《機械翻訳》<application>pg_dump</application>保証型の非NULL制約に関するコメントをダンプするドメイン。
(Jian He, Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;6b755d8d7">&sect;</ulink>␞
␝     <para>␟      Ensure that <application>pg_dump</application> dumps comments on
      domain constraints in a valid order (Jian He)␟《機械翻訳》有効な保証内のドメイン制約に関するコメントをダンプする<application>pg_dump</application>オーダー。
(Jian He)␞␞      <ulink url="&commit_baseurl;d07bc7c2b">&sect;</ulink>␞
␝     <para>␟      In some cases the comment command could appear before creation of
      the constraint.␟《機械翻訳》場合によっては、コメントコマンドは前が制約を作り出したように見えることもあります。␞␞     </para>␞
␝     <para>␟      Ensure stable sort ordering in <application>pg_dump</application>
      for all types of database objects (Noah Misch, Andreas Karlsson)␟《機械翻訳》保証安定(stable)ソート順序付けin <application>pg_dump</application>全種類のデータベースオブジェクト。
(Noah Misch, Andreas Karlsson)␞␞      <ulink url="&commit_baseurl;1ca1889ea">&sect;</ulink>␞
␝     <para>␟      <application>pg_dump</application> sorts objects by their logical
      names before performing dependency-driven reordering.  This sort did
      not account for the full unique key identifying certain object types
      such as rules and constraints, and thus it could produce dissimilar
      sort orders for logically-identical databases.  That made it
      difficult to compare databases by
      diff'ing <application>pg_dump</application> output, so improve the
      logic to ensure stable sort ordering in all cases.␟《機械翻訳》<application>pg_dump</application>は、オブジェクトをロジカル名でソートします。
前は依存駆動型の順序変更を実行します。
このソートは、ルールや制約などの特定のアカウントタイプを識別する完全なユニークキーをしませんでした。
そのため、論理的に同一のデータベースに対して異なるソート順序が生成される可能性がありました。
そのため、差分<application>pg_dump</application>出力。
したがって、改善はロジックを保証安定(stable)ソート順序付けに比較しますによってデータベースを比較することは困難でした。
オブジェクト␞␞     </para>␞
␝     <para>␟      Fix incorrect parsing of object types
      in <application>pg_dump</application> filter files (Fujii Masao)␟《機械翻訳》<application>pg_dump</application>パースファイルのオブジェクトタイプの不正なフィルタを修正します。
(Fujii Masao)␞␞      <ulink url="&commit_baseurl;7dafc4a41">&sect;</ulink>␞
␝     <para>␟      Treat keywords as extending to the next whitespace, rather than
      stopping at the first non-alphanumeric character as before.
      This makes no difference for valid keywords, but it allows some
      error cases to be recognized properly.  For
      example, <literal>table-data</literal> will now be rejected, whereas
      previously it was misinterpreted as <literal>table</literal>.␟《機械翻訳》キーワードは、英数文字以外の最初の文字で拡張として停止するのではなく、次の空白まで前として扱います。
これにより、有効なキーワードに対して差は作成されませんが、一部のエラーの大文字と小文字を正しく認識できます。
例では、以前は<literal>table</literal>と誤解されていましたが、現在は<literal>table-data</literal>が拒否されます。␞␞     </para>␞
␝     <para>␟      <application>pg_restore</application> failed to restore large
      objects (BLOBs) from directory-format dumps made
      by <application>pg_dump</application> versions
      before <productname>PostgreSQL</productname> v12 (Pavel Stehule)␟《機械翻訳》<application>pg_restore</application> <application>pg_dump</application>バージョンフォーマット<productname>PostgreSQL</productname>v12.で作成されたディレクトリ-前ダンプのラージオブジェクト(BLOB)のリストアに失敗しました。
(Pavel Stehule)␞␞      <ulink url="&commit_baseurl;839802792">&sect;</ulink>␞
␝     <para>␟      In <application>pg_upgrade</application>, check for inconsistent
      inherited not-null constraints (Ali Akbar)␟《機械翻訳》<application>pg_upgrade</application>,チェックでは、継承された非NULL制約に一貫性がありません。
(Ali Akbar)␞␞      <ulink url="&commit_baseurl;b8b2e6052">&sect;</ulink>␞
␝     <para>␟      <productname>PostgreSQL</productname> versions before 18 allow an
      inherited column not-null constraint to be dropped.  However, this
      results in a schema that cannot be restored, leading to failure
      in <application>pg_upgrade</application>.  Detect such cases
      during <application>pg_upgrade</application>'s preflight checks to
      allow users to fix them before initiating the upgrade.␟《機械翻訳》<productname>PostgreSQL</productname>バージョン前18では、カラム以外の継承されたNULL制約を削除できます。
ただし、これにより、スキーマを復元できなくなり、<application>pg_upgrade</application>の障害につながります。
<application>pg_upgrade</application>のプリフライトチェック中にこのようなケースを検出し、ユーザがアップグレードを開始する前を修正できるようにします。␞␞     </para>␞
␝     <para>␟      Don't require that the target installation
      have <varname>max_slot_wal_keep_size</varname> set to its default
      during <application>pg_upgrade</application> (Dilip Kumar)␟《機械翻訳》ターゲットインストールが<application>pg_upgrade</application>の間にそのデフォルトに<varname>max_slot_wal_keep_size</varname>を設定する必要はありません。
(Dilip Kumar)␞␞      <ulink url="&commit_baseurl;24f6c1bd4">&sect;</ulink>␞
␝     <para>␟      Avoid assertion failure if <varname>track_commit_timestamp</varname>
      is enabled during <application>initdb</application> (Hayato Kuroda,
      Andy Fan)␟《機械翻訳》<varname>track_commit_timestamp</varname>が<application>initdb</application>の間に有効になっている場合は、アサーション障害を回避します。
(Hayato Kuroda, Andy Fan)␞␞      <ulink url="&commit_baseurl;ae20c105f">&sect;</ulink>␞
␝     <para>␟      Fix <application>pg_waldump</application> to show information about
      dropped statistics in <literal>PREPARE TRANSACTION</literal> WAL
      records (Daniil Davydov)␟《機械翻訳》<literal>PREPARE TRANSACTION</literal> WALレコード内の削除された統計処理に関する情報を表示するよう<application>pg_waldump</application>を修正しました。
(Daniil Davydov)␞␞      <ulink url="&commit_baseurl;11efaaffa">&sect;</ulink>␞
␝     <para>␟      Avoid possible leak of the open connection
      during <filename>contrib/dblink</filename> connection establishment
      (Tom Lane)␟《機械翻訳》<filename>contrib/dblink</filename>コネクション設立の間、オープンコネクションのリークの可能性を避ける。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;e20b3256a">&sect;</ulink>␞
␝     <para>␟      In the rare scenario where we hit out-of-memory while inserting the
      new connection object into dblink's hashtable, the open connection
      would be leaked until end of session, leaving an idle session
      sitting on the remote server.␟《機械翻訳》ヒットシナリオ外装着中が新しいコネクションオブジェクトをdblinkのハッシュテーブルに渡すような稀なメモリでは、オープンコネクションがセッションの終わりまでリークされ、アイドル状態のセッションがリモートサーバに残ることになります。␞␞     </para>␞
␝     <para>␟      Make <filename>contrib/pg_prewarm</filename> cope with very
      large <varname>shared_buffers</varname> settings (Daria Shanina)␟《機械翻訳》make <filename>contrib/pg_prewarm</filename>非常にラージ<varname>shared_buffers</varname>設定に対処する。
(Daria Shanina)␞␞      <ulink url="&commit_baseurl;e4b8f925a">&sect;</ulink>␞
␝     <para>␟      Autoprewarm failed with a memory allocation error
      if <varname>shared_buffers</varname> was larger than about 50
      million buffers (400GB).␟《機械翻訳》<varname>shared_buffers</varname>が約50,000,000バッファ（400メモリアロケーション）より大きい場合、エラーギガバイトでautoprewarmが失敗しました。␞␞     </para>␞
␝     <para>␟      Prevent assertion failure
      in <filename>contrib/pg_prewarm</filename> (Masahiro Ikeda)␟《機械翻訳》<filename>contrib/pg_prewarm</filename>のアサーション障害を防止します。
(Masahiro Ikeda)␞␞      <ulink url="&commit_baseurl;b64c585fd">&sect;</ulink>␞
␝     <para>␟      Applying <function>pg_prewarm()</function> to a relation
      lacking storage (such as a view) caused an assertion failure,
      although there was no ill effect in non-assert builds.
      Add an error check to reject that case.␟《マッチ度[84.976526]》ビューのようなストレージを持たないリレーションに<function>pg_freespacemap()</function>を適用すると、アサート無しのビルドでは問題がなかったにもかかわらず、アサーションエラーが発生していました。
この問題を回避するためのエラーチェックが追加されました。
《機械翻訳》<function>pg_prewarm()</function>ビューなどのストレージのないリレーションに適用すると、アサーション障害が発生しましたが、非アサートビルドでは悪影響はありませんでした。
エラーチェックを追加して、そのケースを拒否してください。␞␞     </para>␞
␝     <para>␟      In <filename>contrib/pg_stat_statements</filename>, avoid leaving
      gaps in the set of parameter numbers used in a normalized query
      (Sami Imseih)␟《機械翻訳》では、<filename>contrib/pg_stat_statements</filename>正規化されたパラメータで使用される問い合わせ番号のセットにギャップを残さないようにします。
(Sami Imseih)␞␞      <ulink url="&commit_baseurl;290e8ab32">&sect;</ulink>␞
␝     <para>␟      Fix memory leakage in <filename>contrib/postgres_fdw</filename>'s
      DirectModify methods (Tom Lane)␟《機械翻訳》<filename>contrib/postgres_fdw</filename>のDirectModifyメソッドのメモリの漏れを修正した。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;9339c85af">&sect;</ulink>␞
␝     <para>␟      The <structname>PGresult</structname> holding the results of the
      remote modify command would be leaked for the rest of the session if
      the query fails between invocations of the DirectModify methods,
      which could happen when there's <literal>RETURNING</literal> data to
      process.␟《機械翻訳》DirectModifyメソッドの呼び出しと呼び出しの間にリモートが失敗した場合、コマンド変更セッションの結果を保持する<structname>PGresult</structname>が残りの問い合わせに対してリークされます。
これは、<literal>RETURNING</literal>データからプロセスがある場合に発生する可能性があります。␞␞     </para>␞
␝     <para>␟      Ensure that directories listed
      in <application>configure</application>'s
      <option>--with-includes</option>
      and <option>--with-libraries</option> options are searched before
      system-supplied directories (Tom Lane)␟《機械翻訳》<application>configure</application>の<option>--with-includes</option>と<option>--with-libraries</option>保証にリストされているディレクトリが検索されるオプション前システム提供されるディレクトリ
(Tom Lane)␞␞      <ulink url="&commit_baseurl;a644f5fc6">&sect;</ulink>␞
␝     <para>␟      A common reason for using these options is to allow a user-built
      version of some library to override the system-supplied version.
      However, that failed to work in some environments because of
      careless ordering of switches in the commands issued by the makefiles.␟《機械翻訳》これらのオプションを使用する一般的な理由は、一部のライブラリのユーザバージョンをシステム提供されるバージョンの上書きにするためです。
ただし、makefileが発行したコマンド内のスイッチの不注意な順序付けのために、一部の環境では機能しませんでした。␞␞     </para>␞
␝     <para>␟      Fix <application>configure</application>'s checks
      for <function>__cpuid()</function>
      and <function>__cpuidex()</function> (Lukas Fittl, Michael Paquier)␟《機械翻訳》<function>__cpuid()</function>と<function>__cpuidex()</function>に対する<application>configure</application>のチェックを修正した。
(Lukas Fittl, Michael Paquier)␞␞      <ulink url="&commit_baseurl;8de56323c">&sect;</ulink>␞
␝     <para>␟      <application>configure</application> failed to detect these
      Windows-specific functions, so that they would not be used,
      leading to slower-than-necessary CRC computations since the
      availability of hardware instructions could not be verified.
      The practical impact of this error was limited, because production
      builds for Windows typically do not use the Autoconf toolchain.␟《機械翻訳》<application>configure</application>これらのWindows固有の関数を検出できなかったため、それらは使用されず、ハードウェア命令の有効性を検証できなかったため、必要以上に遅いCRC計算につながりました。
このエラーの実際のインパクトは制限されていました。
なぜなら、Windows用の稼働ビルドは通常Autoconfツールチェーンを使用しないからです。␞␞     </para>␞
␝      Fix build failure with <option>--with-pam</option> option on␟      Fix build failure with <option>--with-pam</option> option on
      Solaris-based platforms (Tom Lane)␟《機械翻訳》Solarisベースのプラットフォームで<option>--with-pam</option>オプションを使用して、ビルドの障害を修正します。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;635a85627">&sect;</ulink>␞
␝     <para>␟      Solaris is inconsistent with other Unix platforms about the API for
      PAM authentication.  This manifested as an <quote>inconsistent
      pointer</quote> compiler warning, which we never did anything about.
      But as of GCC 14 it's an error not warning by default, so fix it.␟《機械翻訳》SolarisはPAM APIの認証に関して他のUnixプラットフォームと一貫性がありません。
これは<quote>一貫性のないポインタ</quote>コンパイラワーニングとして現れましたが、私たちは何もしませんでした。
しかしGCC 14ではデフォルトのワーニングではなくエラーなので、修正してください。␞␞     </para>␞
␝     <para>␟      Make our code portable to GNU Hurd (Michael Banck, Christoph Berg,
      Samuel Thibault)␟《機械翻訳》コードのmakeはGNU・ハードに譲ります。
(Michael Banck, Christoph Berg, Samuel Thibault)␞␞      <ulink url="&commit_baseurl;0991249d7">&sect;</ulink>␞
␝     <para>␟      Fix assumptions about <literal>IOV_MAX</literal>
      and <literal>O_RDONLY</literal> that don't hold on Hurd.␟《マッチ度[50.476190]》これにより、<literal>C</literal>および<literal>C.UTF-8</literal>の照合順序がサポートされます。
《機械翻訳》Hurdに当てはまらない<literal>IOV_MAX</literal>と<literal>O_RDONLY</literal>についての仮定を修正する。␞␞     </para>␞
␝     <para>␟      Make our usage of <function>memset_s()</function> conform strictly
      to the C11 standard (Tom Lane)␟《機械翻訳》make <function>memset_s()</function>はC11標準に厳密に準拠しています。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;5355a2400">&sect;</ulink>␞
␝     <para>␟      This avoids compile failures on some platforms.␟《機械翻訳》これにより、一部のプラットフォームでのコンパイル障害が回避されます。␞␞     </para>␞
␝     <para>␟      Silence compatibility warning when using Meson to build with MSVC
      (Peter Eisentraut)␟《機械翻訳》MSVCでMeson toワーニングを使用する場合、互換性ビルドを無音にする。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;2499c3490">&sect;</ulink>␞
␝     <para>␟      Prevent uninitialized-value compiler warnings in JSONB comparison
      code (Tom Lane)␟《機械翻訳》jsonb比較コードでの初期化されていない値のコンパイラ警報を防ぎます。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;5a2139a90">&sect;</ulink>␞
␝     <para>␟      Avoid deprecation warnings when building
      with <application>libxml2</application> 2.14 and later
      (Michael Paquier)␟《機械翻訳》<application>libxml2</application> 2.14以降で構築する場合は、非推奨の警告を回避してください。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;c911e7802">&sect;</ulink>␞
␝     <para>␟      Avoid problems when compiling <filename>pg_locale.h</filename> under
      C++ (John Naylor)␟《機械翻訳》<filename>pg_locale.h</filename> C++でのコンパイル時の問題を回避する。
(John Naylor)␞␞      <ulink url="&commit_baseurl;21ae8fc5f">&sect;</ulink>␞
␝     <para>␟      <productname>PostgreSQL</productname> header files generally need to
      be wrapped in <literal>extern "C" { ... }</literal> in order to be
      included in extensions written in C++.  This failed
      for <filename>pg_locale.h</filename> because of its use
      of <application>libicu</application> headers, but we can work around
      that by suppressing C++-only declarations in those headers.  C++
      extensions that want to use <application>libicu</application>'s C++
      APIs can do so by including the <application>libicu</application>
      headers ahead of <filename>pg_locale.h</filename>.␟《機械翻訳》<productname>PostgreSQL</productname>ヘッダファイルは一般的に<literal>extern "C" { ... }</literal>オーダーでラップして、C++で書かれた拡張に含める必要があります。
これは<application>libicu</application>ヘッダを使用していたために失敗しましたが、これらのヘッダでC++のみの宣言を抑制することでワークアラウンドできます。
<application>libicu</application>のC++APIを使用したいC++拡張は、<filename>pg_locale.h</filename>の前に<application>libicu</application>ヘッダを含めることで可能です。
<filename>pg_locale.h</filename>␞␞     </para>␞
␝ <sect1 id="release-17-5">␟  <title>Release 17.5</title>␟  <title>リリース17.5</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2025-05-08</para>␞
␝  <para>␟   This release contains a variety of fixes from 17.4.
   For information about new features in major release 17, see
   <xref linkend="release-17"/>.␟このリリースは17.4に対し、様々な不具合を修正したものです。
17メジャーリリースにおける新機能については、<xref linkend="release-17"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-17-5-migration">␟   <title>Migration to Version 17.5</title>␟   <title>バージョン17.5への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you have any self-referential foreign key constraints on
    partitioned tables, it may be necessary to recreate those constraints
    to ensure that they are being enforced correctly.  See the second
    changelog entry below.␟しかし、テーブルパーティションに自己参照外部キー制約がある場合は、それらの制約が正しく適用されるように再作成する必要があるかもしれません。
以下の2番目の変更ログの項目を参照してください。␞␞   </para>␞
␝   <para>␟    Also, if you have any BRIN bloom indexes, it may be advisable to
    reindex them after updating.  See the third changelog entry below.␟また、BRINブルームインデックスがある場合は、更新後にインデックスを再作成することをお勧めします。
以下の3番目の変更ログの項目を参照してください。␞␞   </para>␞
␝   <para>␟    Also, if you are upgrading from a version earlier than 17.1,
    see <xref linkend="release-17-1"/>.␟また、17.1より前のバージョンからアップグレードする場合は、<xref linkend="release-17-1"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-17-5-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Avoid one-byte buffer overread when examining invalidly-encoded
      strings that are claimed to be in GB18030 encoding
      (Noah Misch, Andres Freund)␟GB18030エンコーディングであると主張される無効なエンコード文字列を検査するとき、1バイトのバッファオーバーリードが回避されました。
(Noah Misch, Andres Freund)␞␞      <ulink url="&commit_baseurl;ec5f89e8a">&sect;</ulink>␞
␝     <para>␟      While unlikely, a SIGSEGV crash could occur if an incomplete
      multibyte character appeared at the end of memory.  This was
      possible both in the server and
      in <application>libpq</application>-using applications.
      (CVE-2025-4207)␟可能性は低いですが、不完全なマルチバイト文字がメモリの末尾に現れた場合、SIGSEGVクラッシュが発生する可能性がありました。
これは、サーバでも<application>libpq</application>を使用するアプリケーションでも発生する可能性がありました。
(CVE-2025-4207)␞␞     </para>␞
␝     <para>␟      Handle self-referential foreign keys on partitioned tables correctly
      (Álvaro Herrera)␟パーティションテーブルで自己参照の外部キーを正しく扱えるようになりました。
(Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;f51ae3187">&sect;</ulink>␞
␝     <para>␟      Creating or attaching partitions failed to make the required catalog
      entries for a foreign-key constraint, if the table referenced by the
      constraint was the same partitioned table.  This resulted in failure
      to enforce the constraint fully.␟パーティション作成またはアタッチ時に、制約によって参照されるテーブルが同一のパーティションテーブルである場合、外部キー制約に必要なカタログエントリの作成に失敗しました。
その結果、制約が完全には強制されませんでした。␞␞     </para>␞
␝     <para>␟      To fix this, you should drop and recreate any self-referential
      foreign keys on partitioned tables, if partitions have been created
      or attached since the constraint was created.  Bear in mind that
      violating rows might already be present, in which case recreating
      the constraint will fail, and you'll need to fix up those rows
      before trying again.␟これを修正するには、制約の作成後にパーティションが作成またはアタッチされている場合、パーティションテーブル上の自己参照外部キーをすべて削除して再作成する必要があります。
違反行がすでに存在する可能性があることに注意してください。
その場合、制約を再作成すると失敗するため、再試行する前にそれらの行を修正する必要があります。␞␞     </para>␞
␝     <para>␟      Avoid data loss when merging compressed BRIN summaries
      in <function>brin_bloom_union()</function> (Tomas Vondra)␟<function>brin_bloom_union()</function>で圧縮されたBRINサマリをマージする際のデータ損失が回避されました。
(Tomas Vondra)␞␞      <ulink url="&commit_baseurl;cb0ad70b8">&sect;</ulink>␞
␝     <para>␟      The code failed to account for decompression results not being
      identical to the input objects, which would result in failure to add
      some of the data to the merged summary, leading to missed rows in
      index searches.␟このコードでは、圧縮したものの展開結果が入力オブジェクトと一致しないことを考慮しておらず、その結果、一部のデータがマージされたサマリに追加されず、インデックス検索で行が欠落していました。␞␞     </para>␞
␝     <para>␟      This mistake was present back to v14 where BRIN bloom indexes were
      introduced, but this code path was only rarely reached then.  It's
      substantially more likely to be hit in v17 because parallel index
      builds now use the code.␟この誤りは、BRINブルームインデックスが導入されたv14時点から存在していましたが、当時はこのコードパスに到達することは稀でした。
v17では、パラレルインデックス作成でコードが使用されるようになったため、この誤りが発生する可能性が大幅に高くなりました。␞␞     </para>␞
␝     <para>␟      Fix unexpected <quote>attribute has wrong type</quote> errors
      in <command>UPDATE</command>, <command>DELETE</command>,
      and <command>MERGE</command> queries that use whole-row table
      references to views or functions in <literal>FROM</literal>
      (Tom Lane)␟<literal>FROM</literal>のビューまたは関数への行全体のテーブル参照を使用する<command>UPDATE</command>、<command>DELETE</command>、<command>MERGE</command>の問い合わせで発生する、予期しない<quote>attribute has wrong type</quote>エラーが修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;ca0830e5a">&sect;</ulink>␞
␝     <para>␟      Fix <command>MERGE</command> into a partitioned table
      with <literal>DO NOTHING</literal> actions (Tender Wang)␟<literal>DO NOTHING</literal>アクションを持つパーティションテーブルに対する<command>MERGE</command>が修正されました。
(Tender Wang)␞␞      <ulink url="&commit_baseurl;25303678a">&sect;</ulink>␞
␝     <para>␟      Some cases failed with <quote>unknown action in MERGE WHEN
      clause</quote> errors.␟ある場合には<quote>unknown action in MERGE WHEN clause</quote>エラーが発生して失敗しました。␞␞     </para>␞
␝     <para>␟      Prevent failure in <command>INSERT</command> commands when the table
      has a <literal>GENERATED</literal> column of a domain data type and
      the domain's constraints disallow null values (Jian He)␟テーブルにドメインデータ型の<literal>GENERATED</literal>列があり、ドメインの制約でNULL値が許可されていない場合に、<command>INSERT</command>コマンドが失敗しないようになりました。
(Jian He)␞␞      <ulink url="&commit_baseurl;3c39c000c">&sect;</ulink>␞
␝     <para>␟      Constraint failure was reported even if the generation expression
      produced a perfectly okay result.␟生成式で完全に正常な結果が生成された場合でも、制約エラーが報告されていました。␞␞     </para>␞
␝     <para>␟      Correctly process references to outer CTE names that appear within
      a <literal>WITH</literal> clause attached to
      an <command>INSERT</command>/<command>UPDATE</command>/<command>DELETE</command>/<command>MERGE</command>
      command that's inside <literal>WITH</literal> (Tom Lane)␟<literal>WITH</literal>句の中にある<command>INSERT</command>/<command>UPDATE</command>/<command>DELETE</command>/<command>MERGE</command>コマンドに付随した<literal>WITH</literal>句内に表れる、外側のCTE名への参照を正しく処理するようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;5e7be43f4">&sect;</ulink>␞
␝     <para>␟      The parser failed to detect disallowed recursion cases, nor did it
      account for such references when sorting CTEs into a usable order.␟パーサは、許可されていない再帰ケースを検出できず、CTEを使用可能な順に並べ替えるときに、そのような参照を考慮していませんでした。␞␞     </para>␞
␝     <para>␟      Fix misprocessing of casts within the keys of JSON constructor
      expressions (Amit Langote)␟JSONコンストラクタ式のキー内でのキャストの誤った処理が修正されました。
(Amit Langote)␞␞      <ulink url="&commit_baseurl;8b2392ae3">&sect;</ulink>␞
␝     <para>␟      Don't try to parallelize <function>array_agg()</function> when the
      argument is of an anonymous record type (Richard Guo, Tom Lane)␟引数が匿名レコード型の場合<function>array_agg()</function>の並列化を行わないようになりました。
(Richard Guo, Tom Lane)␞␞      <ulink url="&commit_baseurl;43847dd5e">&sect;</ulink>␞
␝     <para>␟      The protocol for communicating with parallel workers doesn't support
      identifying the concrete record type that a worker is returning.␟パラレルワーカーと通信するためのプロトコルは、ワーカーが返す具体的なレコード型の識別をサポートしていません。␞␞     </para>␞
␝     <para>␟      Fix <literal>ARRAY(<replaceable>subquery</replaceable>)</literal>
      and <literal>ARRAY[<replaceable>expression, ...</replaceable>]</literal>
      constructs to produce sane results when the input is of
      type <type>int2vector</type> or <type>oidvector</type> (Tom Lane)␟入力が<type>int2vector</type>型または<type>oidvector</type>型の場合に、<literal>ARRAY(<replaceable>subquery</replaceable>)</literal>および<literal>ARRAY[<replaceable>expression, ...</replaceable>]</literal>構文が正常な結果を生成するように修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;c826cd1b1">&sect;</ulink>␞
␝     <para>␟      This patch restores the behavior that existed
      before <productname>PostgreSQL</productname> 9.5: the result is of
      type <type>int2vector[]</type> or <type>oidvector[]</type>.␟このパッチは、<productname>PostgreSQL</productname> 9.5以前の動作を復元します。結果は<type>int2vector[]</type>型または<type>oidvector[]</type>型になります。␞␞     </para>␞
␝     <para>␟      Fix possible erroneous reports of invalid affixes while parsing
      <application>Ispell</application> dictionaries (Jacob Brazeal)␟<application>Ispell</application>辞書のパース中に無効な接辞が誤って報告される可能性が修正されました。
(Jacob Brazeal)␞␞      <ulink url="&commit_baseurl;99c01aadf">&sect;</ulink>␞
␝     <para>␟      Fix <literal>ALTER TABLE ADD COLUMN</literal> to correctly handle
      the case of a domain type that has a default
      (Jian He, Tom Lane, Tender Wang)␟デフォルトを持つドメイン型の場合を正しく処理するように<literal>ALTER TABLE ADD COLUMN</literal>が修正されました。
(Jian He, Tom Lane, Tender Wang)␞␞      <ulink url="&commit_baseurl;d6dd2a02b">&sect;</ulink>␞
␝     <para>␟      If a domain type has a default, adding a column of that type (without
      any explicit <literal>DEFAULT</literal>
      clause) failed to install the domain's default
      value in existing rows, instead leaving the new column null.␟ドメイン型にデフォルトがある場合、その型の列を（明示的な<literal>DEFAULT</literal>句なしで）追加すると、既存の行にドメインのデフォルト値が設定されず、新しい列はNULLのままになっていました。␞␞     </para>␞
␝     <para>␟      Repair misbehavior when there are duplicate column names in a
      foreign key constraint's <literal>ON DELETE SET DEFAULT</literal>
      or <literal>SET NULL</literal> action (Tom Lane)␟外部キー制約の<literal>ON DELETE SET DEFAULT</literal>または<literal>SET NULL</literal>アクションで重複した列名がある場合の不正動作が修復されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;5e6e97fbf">&sect;</ulink>␞
␝     <para>␟      Improve the error message for disallowed attempts to alter the
      properties of a foreign key constraint (Álvaro Herrera)␟外部キー制約のプロパティ変更が許可されなかった場合のエラーメッセージが改善されました。
(Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;4e026be5f">&sect;</ulink>␞
␝     <para>␟      Avoid error when resetting
      the <structfield>relhassubclass</structfield> flag of a temporary
      table that's marked <literal>ON COMMIT DELETE ROWS</literal>
      (Noah Misch)␟<literal>ON COMMIT DELETE ROWS</literal>とマークされた一時テーブルの<structfield>relhassubclass</structfield>フラグをリセットするときのエラーが回避されました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;d0a049987">&sect;</ulink>␞
␝     <para>␟      Add missing deparsing of the <literal>INDENT</literal> option
      of <function>XMLSERIALIZE()</function> (Jim Jones)␟<function>XMLSERIALIZE()</function>の<literal>INDENT</literal>オプションで欠落していた逆解析が追加されました。
(Jim Jones)␞␞      <ulink url="&commit_baseurl;2e0f93d7c">&sect;</ulink>␞
␝     <para>␟      Previously, views or rules
      using <literal>XMLSERIALIZE(... INDENT)</literal> were dumped
      without the <literal>INDENT</literal> clause, causing incorrect
      results after restore.␟以前は、<literal>XMLSERIALIZE(... INDENT)</literal>を使用するビューまたはルールが<literal>INDENT</literal>句なしでダンプされていたため、リストアの後に誤った結果が発生していました。␞␞     </para>␞
␝     <para>␟      Avoid premature evaluation of the arguments of an aggregate function
      that has both <literal>FILTER</literal> and <literal>ORDER
      BY</literal> (or <literal>DISTINCT</literal>) options (David Rowley)␟<literal>FILTER</literal>オプションと<literal>ORDER BY</literal>(または<literal>DISTINCT</literal>)の両方のオプションを持つ集約関数の引数を早期評価しないようにしました。
(David Rowley)␞␞      <ulink url="&commit_baseurl;065ce49a1">&sect;</ulink>␞
␝     <para>␟      If there is <literal>ORDER BY</literal>
      or <literal>DISTINCT</literal>, we consider pre-sorting the
      aggregate input values rather than doing the sort within the Agg
      plan node.  But this is problematic if the aggregate inputs include
      expressions that could fail (for example, a division where some of
      the input divisors could be zero) and there is
      a <literal>FILTER</literal> clause that's meant to prevent such
      failures.  Pre-sorting would push the expression evaluations to
      before the <literal>FILTER</literal> test, allowing the failures to
      happen anyway.  Avoid this by not pre-sorting if there's
      a <literal>FILTER</literal> and the input expressions are anything
      more complex than a simple Var or Const.␟<literal>ORDER BY</literal>または<literal>DISTINCT</literal>がある場合は、Aggプランノード内でソートをおこなうのではなく、集約入力値を事前にソートすることを検討します。
しかし、集約入力に失敗する可能性のある式（例えば、入力の除数の一部がゼロになる可能性のある除算）が含まれ、そのような失敗を防ぐための<literal>FILTER</literal>句がある場合、これは問題となります。
事前ソートをおこなうと式の評価が<literal>FILTER</literal>テストの前に押し出され、いずれにしても失敗が発生します。
<literal>FILTER</literal>があり、入力式が単純なVarまたはConstよりも複雑な場合は、事前ソートをおこなわないことでこれを回避するようになりました。␞␞     </para>␞
␝     <para>␟      Fix erroneous deductions from column <literal>NOT NULL</literal>
      constraints in the presence of outer joins (Richard Guo)␟外部結合が存在する場合の<literal>NOT NULL</literal>制約列からの誤った推論が修正されました。
(Richard Guo)␞␞      <ulink url="&commit_baseurl;bc5a08af3">&sect;</ulink>␞
␝     <para>␟      In some cases the planner would discard an <literal>IS NOT
      NULL</literal> query condition, even though the condition applies
      after an outer join and thus is not redundant.␟場合によっては、条件が外部結合の後に適用されるため冗長ではないにもかかわらず、プランナが<literal>IS NOT NULL</literal>問い合わせ条件を破棄していました。␞␞     </para>␞
␝     <para>␟      Avoid incorrect optimizations based on <literal>IS [NOT]
      NULL</literal> tests that are applied to composite values
      (Bruce Momjian)␟複合値に適用される<literal>IS [NOT] NULL</literal>テストに基づく誤った最適化が回避されました。
(Bruce Momjian)␞␞      <ulink url="&commit_baseurl;b8b1e87b7">&sect;</ulink>␞
␝     <para>␟      Fix planner's failure to identify more than one hashable
      ScalarArrayOpExpr subexpression within a top-level expression
      (David Geier)␟プランナがトップレベルの式内で複数のハッシュ可能なScalarArrayOpExpr部分式を識別できない問題が修正されました。
(David Geier)␞␞      <ulink url="&commit_baseurl;5672a8399">&sect;</ulink>␞
␝     <para>␟      This resulted in unnecessarily-inefficient execution of any
      additional subexpressions that could have been processed with a hash
      table (that is, <literal>IN</literal>, <literal>NOT IN</literal>,
      or <literal>= ANY</literal> clauses with all-constant right-hand
      sides).␟その結果、ハッシュテーブルで処理できる追加の部分式（すなわち、右辺がすべて全て定数の<literal>IN</literal>、<literal>NOT IN</literal>、<literal>= ANY</literal>句）が不必要に非効率的に実行されていました。␞␞     </para>␞
␝     <para>␟      Fix incorrect table size estimate with low fill factor (Tomas Vondra)␟低いfillfactor設定値によるテーブルサイズの誤った見積もりが修正されました。
(Tomas Vondra)␞␞      <ulink url="&commit_baseurl;587b6aa3f">&sect;</ulink>␞
␝     <para>␟      When the planner estimates the number of rows in a
      never-yet-analyzed table, it uses the table's fillfactor setting in
      the estimation, but it neglected to clamp the result to at least one
      row per page.  A low fillfactor could thus result in an unreasonably
      small estimate.␟プランナがまだ分析されていないテーブルの行数を推定するとき、テーブルのfillfactor設定を推定に使用しますが、結果を1ページあたり少なくとも1行に制限する処理が省略されていました。
そのためfillfactorの値が低いと、推定値が不当に小さくなる可能性がありました。␞␞     </para>␞
␝     <para>␟      Disable <quote>skip fetch</quote> optimization in bitmap heap scan
      (Matthias van de Meent)␟ビットマップヒープスキャンにおける<quote>skip fetch</quote>最適化が無効になりました。
(Matthias van de Meent)␞␞      <ulink url="&commit_baseurl;78cb2466f">&sect;</ulink>␞
␝     <para>␟      It turns out that this optimization can result in returning dead
      tuples when a concurrent vacuum marks a page all-visible.␟この最適化を使用すると、並行して実行されるバキュームがページをall-visibleとマークした時に、デッドタプルが返される可能性があることが判明しました。␞␞     </para>␞
␝     <para>␟      Fix performance issues in GIN index search startup when there are
      many search keys (Tom Lane, Vinod Sridharan)␟検索キーが多数ある場合のGINインデックス検索起動時のパフォーマンス問題が修正されました。
(Tom Lane, Vinod Sridharan)␞␞      <ulink url="&commit_baseurl;9094eb25b">&sect;</ulink>␞
␝     <para>␟      An indexable clause with many keys (for example, <literal>jsonbcol
      ?| array[...]</literal> with tens of thousands of array elements)
      took O(N<superscript>2</superscript>) time to start up, and was
      uncancelable for that interval too.␟多数のキーを持つインデックス可能な句（例えば、数万の配列要素を持つ<literal>jsonbcol?| array[...]</literal>）は、起動までO(N<superscript>2</superscript>)時間がかかり、その起動の間でもキャンセルできませんでした。␞␞     </para>␞
␝     <para>␟      Detect missing support procedures in a BRIN index operator class,
      and report an error instead of crashing (Álvaro Herrera)␟BRINインデックス演算子クラスでサポートされていないプロシージャを検出し、クラッシュする代わりにエラーを報告するようになりました。
(Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;ade976f8b">&sect;</ulink>␞
␝     <para>␟      Respond to interrupts (such as query cancel) while waiting for
      asynchronous subplans of an Append plan node (Heikki Linnakangas)␟Appendプランノードの非同期サブプランの待機中に、割り込み（問い合わせキャンセルなどの）に応答するようになりました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;e731e9d5e">&sect;</ulink>␞
␝     <para>␟      Previously, nothing would happen until one of the subplans becomes
      ready.␟以前は、サブプランの1つが準備されるまで何も起こりませんでした。␞␞     </para>␞
␝     <para>␟      Report the I/O statistics of active WAL senders more frequently
      (Bertrand Drouvot)␟活動中のWAL送信のI/O統計が、より頻繁に報告されるようになりました。
(Bertrand Drouvot)␞␞      <ulink url="&commit_baseurl;5cbbe70a9">&sect;</ulink>␞
␝     <para>␟      Previously, the <structname>pg_stat_io</structname> view failed to
      accumulate I/O performed by a WAL sender until that process exited.
      Now such I/O will be reported after at most one second's delay.␟以前は、<structname>pg_stat_io</structname>ビューはWAL送信プロセスが終了するまで、そのプロセスによって実行されたI/Oを集計することができませんでした。
今後はそのようなI/Oは、最大1秒遅れで報告されます。␞␞     </para>␞
␝     <para>␟      Fix race condition in handling
      of <varname>synchronous_standby_names</varname> immediately after
      startup (Melnikov Maksim, Michael Paquier)␟起動直後の<varname>synchronous_standby_names</varname>設定の扱いについて、競合状態が解消されました。
(Melnikov Maksim, Michael Paquier)␞␞      <ulink url="&commit_baseurl;3339847cc">&sect;</ulink>␞
␝     <para>␟      For a short period after system startup, backends might fail to wait
      for synchronous commit even
      though <varname>synchronous_standby_names</varname> is enabled.␟システム起動後の短時間において、<varname>synchronous_standby_names</varname>が有効になっているにもかかわらず、バックエンドが同期コミットを待機しない場合がありました。␞␞     </para>␞
␝     <para>␟      Cope with possible intra-query changes
      of <varname>io_combine_limit</varname> (Thomas Munro)␟問い合わせ内での<varname>io_combine_limit</varname>の変更に対応するようになりました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;e27346807">&sect;</ulink>␞
␝     <para>␟      Avoid infinite loop if <varname>scram_iterations</varname> is set to
      <systemitem>INT_MAX</systemitem> (Kevin K Biju)␟<varname>scram_iterations</varname>が<systemitem>INT_MAX</systemitem>に設定されている場合に無限ループしないようになりました。
(Kevin K Biju)␞␞      <ulink url="&commit_baseurl;34fbfe1f5">&sect;</ulink>␞
␝     <para>␟      Avoid possible crashes due to double transformation
      of <function>json_array()</function>'s subquery (Tom Lane)␟<function>json_array()</function>の副問い合わせの二重変換によるクラッシュの可能性が回避されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;717e8a1e5">&sect;</ulink>␞
␝     <para>␟      Fix <function>pg_strtof()</function> to not crash with null endptr
      (Alexander Lakhin, Tom Lane)␟<function>pg_strtof()</function>がNULLのendptrでクラッシュしないように修正されました。
(Alexander Lakhin, Tom Lane)␞␞      <ulink url="&commit_baseurl;d69c78108">&sect;</ulink>␞
␝     <para>␟      Fix crash after out-of-memory in certain GUC assignments (Daniel
      Gustafsson)␟特定のGUC割り当てでメモリ不足になった後に発生するクラッシュが回避されました。
(Daniel Gustafsson)␞␞      <ulink url="&commit_baseurl;8afec4ef6">&sect;</ulink>␞
␝     <para>␟      Avoid crash when a Snowball stemmer encounters an out-of-memory
      condition (Maksim Korotkov)␟Snowball語幹処理でメモリ不足が発生したときのクラッシュが回避されました。
(Maksim Korotkov)␞␞      <ulink url="&commit_baseurl;7edd2cbc5">&sect;</ulink>␞
␝     <para>␟      Fix over-enthusiastic freeing of SpecialJoinInfo structs during
      planning (Richard Guo)␟実行計画作成中にSpecialJoinInfo構造体を過剰に解放した後に発生するクラッシュが修正されました。
(Richard Guo)␞␞      <ulink url="&commit_baseurl;727bc6ac3">&sect;</ulink>␞
␝     <para>␟      This led to crashes during planning if partitionwise joining is
      enabled.␟これにより、パーティション同士の結合が有効な場合、実行計画作成中にクラッシュが発生していました。␞␞     </para>␞
␝     <para>␟      Disallow copying of invalidated replication slots (Shlok Kyal)␟無効化されたレプリケーションスロットのコピーが禁止されました。
(Shlok Kyal)␞␞      <ulink url="&commit_baseurl;a4309e85f">&sect;</ulink>␞
␝     <para>␟      This prevents trouble when the invalid slot points to WAL that's
      already been removed.␟これにより、無効なスロットがすでに削除されたWALを指している場合に発生するトラブルを防ぐことができます。␞␞     </para>␞
␝     <para>␟      Disallow restoring logical replication slots on standby servers that
      are not in hot-standby mode (Masahiko Sawada)␟ホットスタンバイモードではないスタンバイサーバ上での論理レプリケーションスロットのリストアが禁止されました。
(Masahiko Sawada)␞␞      <ulink url="&commit_baseurl;174952ece">&sect;</ulink>␞
␝     <para>␟      This prevents a scenario where the slot could remain valid after
      promotion even if <varname>wal_level</varname> is too low.␟これにより、<varname>wal_level</varname>が低すぎる場合でも、昇格後もスロットが有効なままになるシナリオが防止されます。␞␞     </para>␞
␝     <para>␟      Prevent over-advancement of catalog xmin in <quote>fast
      forward</quote> mode of logical decoding (Zhijie Hou)␟ロジカルデコーディングの<quote>fast forward</quote>モードでカタログのxminが過度に進むのが防止されました。
(Zhijie Hou)␞␞      <ulink url="&commit_baseurl;36148b22e">&sect;</ulink>␞
␝     <para>␟      This mistake could allow deleted catalog entries to be vacuumed away
      even though they were still potentially needed by the WAL-reading
      process.␟この間違いにより、削除されたカタログエントリが、WAL読み取りプロセスでまだ必要になる可能性があるにもかかわらず、バキュームされる可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid data loss when DDL operations that don't take a strong lock
      affect tables that are being logically replicated (Shlok Kyal,
      Hayato Kuroda)␟強力なロックを取得しないDDL操作が、論理的にレプリケートされるテーブルに影響を与える場合のデータ損失が回避されました。
(Shlok Kyal, Hayato Kuroda)␞␞      <ulink url="&commit_baseurl;cadaf0ac4">&sect;</ulink>␞
␝     <para>␟      The catalog changes caused by the DDL command were not reflected
      into WAL-decoding processes, allowing them to decode subsequent
      changes using stale catalog data, probably resulting in data
      corruption.␟DDLコマンドによって発生したカタログの変更がWALデコード処理に反映されなかったため、古いカタログデータを使用して後続の変更をデコードできてしまった結果、データ破損の可能性がありました。␞␞     </para>␞
␝     <para>␟      Prevent incorrect reset of replication origin when an apply worker
      encounters an error but the error is caught and does not result in
      worker exit (Hayato Kuroda)␟applyワーカーでエラーが発生し、そのエラーが捕捉されワーカーが終了しない場合に、レプリケーションオリジンが誤ってリセットされるのが防止されました。
(Hayato Kuroda)␞␞      <ulink url="&commit_baseurl;05676d87e">&sect;</ulink>␞
␝     <para>␟      This mistake could allow duplicate data to be applied.␟この間違いにより、重複データが適用される可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix crash in logical replication if the subscriber's partitioned
      table has a BRIN index (Tom Lane)␟サブスクライバーのパーティションテーブルにBRINインデックスがある場合に論理レプリケーションで発生するクラッシュが修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;788baa9a2">&sect;</ulink>␞
␝     <para>␟      Avoid duplicate snapshot creation in logical replication index
      lookups (Heikki Linnakangas)␟論理レプリケーションのインデックス検索で重複したスナップショットの作成を回避するようになりました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;c1dd3a944">&sect;</ulink>␞
␝     <para>␟      Improve detection of mixed-origin subscriptions
      (Hou Zhijie, Shlok Kyal)␟オリジンが一致しないサブスクリプションの検知が改善されました。
(Hou Zhijie, Shlok Kyal)␞␞      <ulink url="&commit_baseurl;0ae1245e0">&sect;</ulink>␞
␝     <para>␟      Subscription creation gives a warning if a subscribed-to table is
      also being followed through other publications, since that could
      cause duplicate data to be received.  This change improves that
      logic to also detect cases where a partition parent or child table
      is the one being followed through another publication.␟サブスクリプションの作成では、サブスクライブされたテーブルが他のパブリケーションでもフォローされている場合、重複データが受信される可能性があるため警告が表示されます。
今回の変更により、パーティションの親テーブルまたは子テーブルが別のパブリケーションを通してフォローされている場合も検出できるようにロジックが改善されました。␞␞     </para>␞
␝     <para>␟      Fix wrong checkpoint details in error message about incorrect
      recovery timeline choice (David Steele)␟不適切なリカバリータイムラインの選択に関するエラーメッセージでの誤ったチェックポイント詳細が修正されました。
(David Steele)␞␞      <ulink url="&commit_baseurl;29cce279b">&sect;</ulink>␞
␝     <para>␟      If the requested recovery timeline is not reachable, the reported
      checkpoint and timeline should be the values read from the
      backup_label, if there is one.  This message previously reported
      values from the control file, which is correct when recovering from
      the control file without a backup_label, but not when there is a
      backup_label.␟要求されたリカバリタイムラインに到達できない場合、報告されるチェックポイントとタイムラインは、存在する場合はbackup_labelから読み込まれた値である必要があります。
このメッセージは、以前にpg_controlファイルからの値を報告していましたが、これはbackup_labelのないpg_controlファイルからリカバリする場合は正しいのですが、backup_labelがある場合は正しくありません。␞␞     </para>␞
␝     <para>␟      Fix order of operations in <function>smgropen()</function>
      (Andres Freund)␟<function>smgropen()</function>内の処理順序が修正されました。
(Andres Freund)␞␞      <ulink url="&commit_baseurl;ee578921b">&sect;</ulink>␞
␝     <para>␟      Ensure that the SMgrRelation object is fully initialized before
      calling the smgr_open callback, so that it can be cleaned up
      properly if the callback fails.␟smgr_openコールバックを呼び出す前にSMgrRelationオブジェクトが完全に初期化されていることを確認するようになりました。これによりコールバックが失敗した場合に適切にクリーンアップできるようになりました。␞␞     </para>␞
␝     <para>␟      Remove incorrect assertion
      in <function>pgstat_report_stat()</function> (Michael Paquier)␟<function>pgstat_report_stat()</function>の誤ったアサーションが削除されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;4b6331e0f">&sect;</ulink>␞
␝     <para>␟      Fix overly-strict assertion
      in <function>gistFindCorrectParent()</function> (Heikki Linnakangas)␟<function>gistFindCorrectParent()</function>の厳密すぎるアサーションが修正されました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;6526d0794">&sect;</ulink>␞
␝     <para>␟      Avoid assertion failure in parallel vacuum
      when <varname>maintenance_work_mem</varname> has a very small value
      (Masahiko Sawada)␟<varname>maintenance_work_mem</varname>の値が非常に小さい場合、並列バキュームでのアサーションエラーが回避されるようになりました。
(Masahiko Sawada)␞␞      <ulink url="&commit_baseurl;a38dce3c4">&sect;</ulink>␞
␝     <para>␟      Fix rare assertion failure in standby servers when the primary is
      restarted (Heikki Linnakangas)␟プライマリの再起動時にスタンバイサーバで稀に発生するアサーションエラーが修正されました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;302ce5bd9">&sect;</ulink>␞
␝     <para>␟      In PL/pgSQL, avoid <quote>unexpected plan node type</quote> error
      when a scrollable cursor is defined on a
      simple <literal>SELECT <replaceable>expression</replaceable></literal>
      query (Andrei Lepikhov)␟PL/pgSQLで、単純な<literal>SELECT <replaceable>expression</replaceable></literal>問い合わせでスクロール可能なカーソルが定義されている場合の<quote>unexpected plan node type</quote>エラーが回避されました。
(Andrei Lepikhov)␞␞      <ulink url="&commit_baseurl;1353b1161">&sect;</ulink>␞
␝     <para>␟      Don't try to drop individual index partitions
      in <application>pg_dump</application>'s <option>--clean</option>
      mode (Jian He)␟<application>pg_dump</application>の<option>--clean</option>モードで個々のインデックスパーティションを削除しないようになりました。
(Jian He)␞␞      <ulink url="&commit_baseurl;3424c1075">&sect;</ulink>␞
␝     <para>␟      The server rejects such <command>DROP</command> commands.  That has
      no real consequences, since the partitions will go away anyway in
      the subsequent <command>DROP</command>s of either their parent
      tables or their partitioned index.  However, the error reported for
      the attempted drop causes problems when restoring
      in <option>--single-transaction</option> mode.␟サーバはこのような<command>DROP</command>コマンドを拒否します。
パーティションは、親テーブルまたはパーティションインデックスのいずれかの後続の<command>DROP</command>でいずれにしても削除されるため、実際には何の影響もありません。
ただし、試行されたDROPに対して報告されたエラーは、<option>--single-transaction</option>モードでリストアするときに問題を引き起こしていました。␞␞     </para>␞
␝     <para>␟      In <application>pg_dumpall</application>, avoid emitting invalid
      role <command>GRANT</command> commands
      if <structname>pg_auth_members</structname> contains invalid role
      OIDs (Tom Lane)␟<application>pg_dumpall</application>で、<structname>pg_auth_members</structname>に無効なロールのOIDが含まれている場合、無効なロールに対する<command>GRANT</command>コマンドが出力されないようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;16eff4261">&sect;</ulink>␞
␝     <para>␟      Instead, print a warning and skip the entry.  This copes better with
      catalog corruption that has been seen to occur in back branches as a
      result of race conditions between <command>GRANT</command>
      and <command>DROP ROLE</command>.␟代わりに、警告を出力してエントリをスキップします。
これにより、<command>GRANT</command>と<command>DROP ROLE</command>の間の競合状態の結果として過去のバージョンで発生するカタログの破損にうまく対処されます。␞␞     </para>␞
␝     <para>␟      In <application>pg_amcheck</application>
      and <application>pg_upgrade</application>, use the correct function
      to free allocations made by <application>libpq</application>
      (Michael Paquier, Ranier Vilela)␟<application>pg_amcheck</application>と<application>pg_upgrade</application>では、<application>libpq</application>によって作成された割り当てを解放するために正しい関数を使用するようになりました。
(Michael Paquier, Ranier Vilela)␞␞      <ulink url="&commit_baseurl;ee78823ff">&sect;</ulink>␞
␝     <para>␟      These oversights could result in crashes in certain Windows build
      configurations, such as a debug build
      of <application>libpq</application> used by a non-debug build of the
      calling application.␟これらの見落としにより、非デバッグビルドの呼び出し元アプリケーションで使用されるデバッグビルドの<application>libpq</application>のような、特定のWindowsビルド構成でクラッシュが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix <application>reindexdb</application>'s scheduling of parallel
      reindex operations (Alexander Korotkov)␟<application>reindexdb</application>の並列再インデックス操作のスケジューリングが修正されました。
(Alexander Korotkov)␞␞      <ulink url="&commit_baseurl;09ef2f8df">&sect;</ulink>␞
␝     <para>␟      The original coding failed to achieve the expected amount of
      parallelism.␟元のコーディングでは、指定された並列度を達成できませんでした。␞␞     </para>␞
␝     <para>␟      Avoid crashing with corrupt input data
      in <filename>contrib/pageinspect</filename>'s
      <function>heap_page_items()</function> (Dmitry Kovalenko)␟<filename>contrib/pageinspect</filename>の<function>heap_page_items()</function>において、破損した入力データによるクラッシュが回避されました。
(Dmitry Kovalenko)␞␞      <ulink url="&commit_baseurl;ecb8e5641">&sect;</ulink>␞
␝     <para>␟      Prevent assertion failure
      in <filename>contrib/pg_freespacemap</filename>'s
      <function>pg_freespacemap()</function> (Tender Wang)␟<filename>contrib/pg_freespacemap</filename>の<function>pg_freespacemap()</function>でのアサーションエラーが回避されました。
(Tender Wang)␞␞      <ulink url="&commit_baseurl;51d038da8">&sect;</ulink>␞
␝     <para>␟      Applying <function>pg_freespacemap()</function> to a relation
      lacking storage (such as a view) caused an assertion failure,
      although there was no ill effect in non-assert builds.
      Add an error check to reject that case.␟ビューのようなストレージを持たないリレーションに<function>pg_freespacemap()</function>を適用すると、アサート無しのビルドでは問題がなかったにもかかわらず、アサーションエラーが発生していました。
この問題を回避するためのエラーチェックが追加されました。␞␞     </para>␞
␝     <para>␟      In <filename>contrib/postgres_fdw</filename>, avoid pulling up
      restriction conditions from subqueries (Alexander Pyhalov)␟<filename>contrib/postgres_fdw</filename>で、副問い合わせからの制限条件を引き出さないようになりました。
(Alexander Pyhalov)␞␞      <ulink url="&commit_baseurl;729fe699e">&sect;</ulink>␞
␝     <para>␟      This fix prevents rare cases of <quote>unexpected expression in
      subquery output</quote> errors.␟この修正により、まれに発生する<quote>unexpected expression in subquery output</quote>エラーが回避されます。␞␞     </para>␞
␝     <para>␟      Fix build failure when an old version
      of <filename>libpq_fe.h</filename> is present in system include
      directories (Tom Lane)␟システムインクルードディレクトリに古いバージョンの<filename>libpq_fe.h</filename>が存在する場合のビルド失敗が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;f186f90e5">&sect;</ulink>␞
␝     <para>␟      Fix build failure on macOS 15.4 (Tom Lane, Peter Eisentraut)␟macOS 15.4でのビルド失敗が修正されました。
(Tom Lane, Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;915e88968">&sect;</ulink>␞
␝     <para>␟      This macOS update broke our configuration probe
      for <function>strchrnul()</function>.␟このmacOSアップデートにより、<function>strchrnul()</function>の設定プローブが壊れてしまいました。␞␞     </para>␞
␝     <para>␟      Fix valgrind labeling of per-buffer data of read streams
      (Thomas Munro)␟読み取りストリームのバッファ単位データのvalgrindラベル付けが修正されました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;57dca6faa">&sect;</ulink>␞
␝     <para>␟      This affects no core code in released versions
      of <productname>PostgreSQL</productname>, but an extension using the
      per-buffer data feature might have encountered spurious failures
      when being tested under valgrind.␟これは<productname>PostgreSQL</productname>のリリース版のコアコードには影響しませんが、バッファ単位のデータ機能を使用する拡張が、valgrindでテスト中に誤ったエラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid valgrind complaints about string hashing code (John Naylor)␟文字列ハッシュコードに関するvalgrindの警告が回避されました。
(John Naylor)␞␞      <ulink url="&commit_baseurl;fde7c0164">&sect;</ulink>␞
␝     <para>␟      Update time zone data files to <application>tzdata</application>
      release 2025b for DST law changes in Chile, plus historical
      corrections for Iran (Tom Lane)␟タイムゾーンデータファイルをチリの夏時間法の変更に加え、イランの歴史的修正に対応するため<application>tzdata</application>リリース2025bに更新しました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;5d5970b9f">&sect;</ulink>␞
␝     <para>␟      There is a new time zone America/Coyhaique for Chile's Aysén Region,
      to account for it changing to UTC-03 year-round and thus diverging
      from America/Santiago.␟チリのアイセン州が年間を通じてUTC-03に変更されてAmerica/Santiagoとの差異が生じるため、新しいタイムゾーンAmerica/Coyhaiqueが追加されました。␞␞     </para>␞
␝ <sect1 id="release-17-4">␟  <title>Release 17.4</title>␟  <title>リリース17.4</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2025-02-20</para>␞
␝  <para>␟   This release contains a few fixes from 17.3.
   For information about new features in major release 17, see
   <xref linkend="release-17"/>.␟このリリースは17.3に対し、いくつかの不具合を修正したものです。
17メジャーリリースにおける新機能については、<xref linkend="release-17"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-17-4-migration">␟   <title>Migration to Version 17.4</title>␟   <title>バージョン17.4への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you are upgrading from a version earlier than 17.1,
    see <xref linkend="release-17-1"/>.␟また、17.1より前のバージョンからアップグレードする場合は、<xref linkend="release-17-1"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-17-4-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Improve behavior of <application>libpq</application>'s quoting
      functions (Andres Freund, Tom Lane)␟<application>libpq</application>の引用符付け関数の動作が改善されました。
(Andres Freund, Tom Lane)␞␞      <ulink url="&commit_baseurl;a92db3d02">&sect;</ulink>␞
␝     <para>␟      The changes made for CVE-2025-1094 had one serious oversight:
      <function>PQescapeLiteral()</function>
      and <function>PQescapeIdentifier()</function> failed to honor their
      string length parameter, instead always reading to the input
      string's trailing null.  This resulted in including unwanted text in
      the output, if the caller intended to truncate the string via the
      length parameter.  With very bad luck it could cause a crash due to
      reading off the end of memory.␟CVE-2025-1094に対する変更には、重大な見落としが1つありました。
<function>PQescapeLiteral()</function>と<function>PQescapeIdentifier()</function>は、文字列長パラメータを考慮せず、常に入力文字列の末尾のNULLを読み込んでいました。
その結果、呼び出し元が長さパラメータを介して文字列を切り捨てる意図があったとしても、出力に不要なテキストが含まれていました。
非常に運が悪いと、メモリの終端を読み込んでクラッシュが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      In addition, modify all these quoting functions so that when invalid
      encoding is detected, an invalid sequence is substituted for just
      the first byte of the presumed character, not all of it.  This
      reduces the risk of problems if a calling application performs
      additional processing on the quoted string.␟さらに、これらの引用関数をすべて修正し、無効なエンコーディングが検出された場合に、想定される文字の全体ではなく最初のバイトのみ無効なシーケンスに置き換えます。
これにより、呼び出し元のアプリケーションが引用文字列に対して追加処理を実行した場合に問題が発生するリスクが軽減されます。␞␞     </para>␞
␝     <para>␟      Fix small memory leak
      in <application>pg_createsubscriber</application> (Ranier Vilela)␟<application>pg_createsubscriber</application>の小さなメモリリークが修正されました。
(Ranier Vilela)␞␞      <ulink url="&commit_baseurl;ff6d9cfcb">&sect;</ulink>␞
␝     <para>␟      Fix meson build system to correctly detect availability of
      the <filename>bsd_auth.h</filename> system header
      (Nazir Bilal Yavuz)␟Mesonビルドシステムで<filename>bsd_auth.h</filename>システムヘッダが利用可能かどうかを正しく検出するように修正されました。
(Nazir Bilal Yavuz)␞␞      <ulink url="&commit_baseurl;c9a1d2135">&sect;</ulink>␞
␝ <sect1 id="release-17-3">␟  <title>Release 17.3</title>␟  <title>リリース17.3</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2025-02-13</para>␞
␝  <para>␟   This release contains a variety of fixes from 17.2.
   For information about new features in major release 17, see
   <xref linkend="release-17"/>.␟このリリースは17.2に対し、様々な不具合を修正したものです。
17メジャーリリースにおける新機能については、<xref linkend="release-17"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-17-3-migration">␟   <title>Migration to Version 17.3</title>␟   <title>バージョン17.3への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you are upgrading from a version earlier than 17.1,
    see <xref linkend="release-17-1"/>.␟また、17.1より前のバージョンからアップグレードする場合は、<xref linkend="release-17-1"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-17-3-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Harden <function>PQescapeString</function> and allied functions
      against invalidly-encoded input strings (Andres Freund, Noah Misch)␟無効なエンコードがされた入力文字列に対して、<function>PQescapeString</function>および関連する関数が強化されました。
(Andres Freund, Noah Misch)␞␞      <ulink url="&commit_baseurl;43a77239d">&sect;</ulink>␞
␝     <para>␟      Data-quoting functions supplied by <application>libpq</application>
      now fully check the encoding validity of their input.  If invalid
      characters are detected, they report an error if possible.  For the
      ones that lack an error return convention, the output string is
      adjusted to ensure that the server will report invalid encoding and
      no intervening processing will be fooled by bytes that might happen
      to match single quote, backslash, etc.␟<application>libpq</application>が提供するクォートを付加する関数は、入力のエンコーディングの妥当性を完全にチェックするようになりました。
無効な文字が検出された場合、可能であればエラーを報告します。
エラーを返す規則がない関数については、出力文字列が調整され、サーバは無効なエンコーディングを報告し、介在するプロセスがシングルクォートやバックスラッシュなどに偶然一致するバイト列に騙されないようになりました。␞␞     </para>␞
␝     <para>␟      The purpose of this change is to guard against SQL-injection attacks
      that are possible if one of these functions is used to quote crafted
      input.  There is no hazard when the resulting string is sent
      directly to a <productname>PostgreSQL</productname> server (which
      would check its encoding anyway), but there is a risk when it is
      passed through <application>psql</application> or other client-side
      code.  Historically such code has not carefully vetted encoding, and
      in many cases it's not clear what it should do if it did detect such
      a problem.␟この変更の目的は、これらの関数のいずれかが細工された入力にクォートを付加するために使用された場合に発生する可能性のあるSQLインジェクション攻撃から保護することです。
結果の文字列が<productname>PostgreSQL</productname>サーバ（いずれにしてもエンコーディングをチェックする）に直接送信される場合には危険はありませんが、<application>psql</application>やその他のクライアント側のコードに渡している場合にはリスクがあります。
歴史的に、このようなコードはエンコーディングを慎重に検証しておらず、多くの場合、このような問題を検出した場合に何をすべきかが明確ではありません。␞␞     </para>␞
␝     <para>␟      This fix is effective only if the data-quoting function, the server,
      and any intermediate processing agree on the character encoding
      that's being used.  Applications that insert untrusted input into
      SQL commands should take special care to ensure that that's true.␟この修正は、クォート関数、サーバ、および介在する処理で使用される文字エンコーディングが一致する場合にのみ有効です。
信頼できない入力をSQLコマンドに挿入するアプリケーションは、それが正しいことを保証するために特別な注意を払う必要があります。␞␞     </para>␞
␝     <para>␟      Applications and drivers that quote untrusted input without using
      these <application>libpq</application> functions may be at risk of
      similar problems.  They should first confirm the data is valid in
      the encoding expected by the server.␟これらの<application>libpq</application>関数を使用せずに信頼できない入力にクォートを付加するアプリケーションとドライバは、同様の問題に直面する可能性があります。
そのようなアプリケーションやドライバはまず、データがサーバが期待するエンコーディングで有効であることを確認する必要があります。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Stephen Fewer for reporting this problem.
      (CVE-2025-1094)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたStephen Fewerに感謝します。
(CVE-2025-1094)␞␞     </para>␞
␝     <para>␟      Restore auto-truncation of database and user names appearing in
      connection requests (Nathan Bossart)␟接続要求に表示されるデータベース名とユーザ名の自動切り捨てが元に戻されました。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;d09fbf645">&sect;</ulink>␞
␝     <para>␟      This reverts a v17 change that proved to cause trouble for some
      users.  Over-length names should be truncated in an encoding-aware
      fashion, but for now just return to the former behavior of blind
      truncation at <literal>NAMEDATALEN-1</literal> bytes.␟これは、一部のユーザに問題を引き起こしたv17の変更を元に戻すものです。
長すぎる名前は、エンコーディングを意識した方法で切り捨てられるべきですが、現時点では<literal>NAMEDATALEN-1</literal>バイトでの単なる切り捨てをする以前の動作に戻るだけです。␞␞     </para>␞
␝     <para>␟      Exclude parallel workers from connection privilege checks and limits
      (Tom Lane)␟接続権限と接続数上限のチェックからパラレルワーカーが除外されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;15b4c46c3">&sect;</ulink>␞
␝     <para>␟      Do not
      check <literal>datallowconn</literal>, <literal>rolcanlogin</literal>,
      and <literal>ACL_CONNECT</literal> privileges when starting a
      parallel worker, instead assuming that it's enough for the leader
      process to have passed similar checks originally.  This avoids, for
      example, unexpected failures of parallelized queries when the leader
      is running as a role that lacks login privilege.  In the same vein,
      enforce <literal>ReservedConnections</literal>,
      <literal>datconnlimit</literal>, and <literal>rolconnlimit</literal>
      limits only against regular backends, and count only regular
      backends while checking if the limits were already reached.  Those
      limits are meant to prevent excessive consumption of process slots
      for regular backends --- but parallel workers and other special
      processes have their own pools of process slots with their own limit
      checks.␟パラレルワーカーを起動する時に<literal>datallowconn</literal>、<literal>rolcanlogin</literal>、<literal>ACL_CONNECT</literal>権限をチェックせず、代わりに、リーダープロセスが最初に同様のチェックに合格していれば十分であると想定します。
これにより、例えば、リーダーがログイン権限を持たないロールとして実行されている場合に、パラレル問い合わせでの予期しない失敗が回避されます。
同様に、<literal>ReservedConnections</literal>、<literal>datconnlimit</literal>、<literal>rolconnlimit</literal>制限を
通常のバックエンドに対してのみ適用し、制限にすでに達しているかどうかを確認する際は、通常のバックエンドに対してのみカウントします。
これらの制限は、通常のバックエンドのプロセススロットが過剰な消費を防ぐためのものですが、パラレルワーカーやその他の特殊なプロセスには、独自の制限チェックを備えた独自のプロセススロットプールがあります。␞␞     </para>␞
␝     <para>␟      Drop <quote>Lock</quote> suffix from LWLock wait event names
      (Bertrand Drouvot)␟LWLock待機イベント名から<quote>Lock</quote>接尾辞が削除されました。
(Bertrand Drouvot)␞␞      <ulink url="&commit_baseurl;5ffbbcfa1">&sect;</ulink>␞
␝     <para>␟      Refactoring unintentionally caused
      the <structname>pg_stat_activity</structname> view to show
      lock-related wait event names with a <quote>Lock</quote> suffix,
      which among other things broke joining it
      to <structname>pg_wait_events</structname>.␟リファクタリングによって、意図せず<structname>pg_stat_activity</structname>ビューに<quote>Lock</quote>接尾辞を持つロック関連の待機イベント名が表示されるようになりましたが、特に<structname>pg_wait_events</structname>との結合が壊れていました。␞␞     </para>␞
␝     <para>␟      Fix possible failure to return all matching tuples for a btree index
      scan with a ScalarArrayOp (<literal>= ANY</literal>) condition
      (Peter Geoghegan)␟ScalarArrayOp(<literal>= ANY</literal>)条件でのbtreeインデックススキャンで一致するすべてのタプルを返せない可能性が修正されました。
(Peter Geoghegan)␞␞      <ulink url="&commit_baseurl;9e85b20da">&sect;</ulink>␞
␝     <para>␟      Fix possible re-use of stale results in window aggregates (David
      Rowley)␟ウィンドウ集約で古い結果が再利用される可能性が修正されました。
(David Rowley)␞␞      <ulink url="&commit_baseurl;9d5ce4f1a">&sect;</ulink>␞
␝     <para>␟      A window aggregate with a <quote>run condition</quote> optimization
      and a pass-by-reference result type might incorrectly return the
      result from the previous partition instead of performing a fresh
      calculation.␟<quote>run condition</quote>最適化と参照渡しの結果型を持つウィンドウ集約で、新しい計算を実行する代わりに、前のパーティションの結果を誤って返す可能性がありました。␞␞     </para>␞
␝     <para>␟      Keep <varname>TransactionXmin</varname> in sync
      with <varname>MyProc-&gt;xmin</varname> (Heikki Linnakangas)␟<varname>TransactionXmin</varname>を<varname>MyProc-&gt;xmin</varname>と同期させるようになりました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;7cfdb4d1e">&sect;</ulink>␞
␝     <para>␟      This oversight could permit a process to try to access data that had
      already been vacuumed away.  One known consequence is
      transient <quote>could not access status of transaction</quote>
      errors.␟この見落としにより、プロセスがすでにバキュームされていたデータにアクセスしようとする可能性がありました。
結果として、一時的な<quote>could not access status of transaction</quote>エラーが発生することが知られています。␞␞     </para>␞
␝     <para>␟      Fix race condition that could cause failure to add a newly-inserted
      catalog entry to a catalog cache list (Heikki Linnakangas)␟新しく挿入されたカタログエントリをカタログキャッシュリストに追加できない可能性がある競合状態が修正されました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;96e61b279">&sect;</ulink>␞
␝     <para>␟      This could result, for example, in failure to use a newly-created
      function within an existing session.␟この結果、例えば、既存のセッション内で新たに作成された関数を使用できなくなる可能性がありました。␞␞     </para>␞
␝     <para>␟      Prevent possible catalog corruption when a system catalog is
      vacuumed concurrently with an update (Noah Misch)␟システムカタログが更新と同時にバキュームされる時にカタログが破損するのが防止されました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;1587f7b9f">&sect;</ulink>␞
␝     <para>␟      Fix data corruption when relation truncation fails (Thomas Munro)␟リレーションの切り捨てが失敗した場合に発生するデータ破損が修正されました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;0350b876b">&sect;</ulink>␞
␝     <para>␟      The filesystem calls needed to perform relation truncation could
      fail, leaving inconsistent state on disk (for example, effectively
      reviving deleted data).  We can't really prevent that, but we can
      recover by dint of making such failures into PANICs, so that
      consistency is restored by replaying from WAL up to just before the
      attempted truncation.  This isn't a hugely desirable behavior, but
      such failures are rare enough that it seems an acceptable solution.␟リレーションの切り捨て実行に必要なファイルシステムコールが失敗し、ディスクに不整合な状態が残る可能性があります（例えば、削除されたデータが実質的に復活してしまうなど）。
これを実際に防ぐことはできませんが、そのような失敗をPANICにすることで、WALから切り捨てが試行される直前までをリプレイすることで整合性を回復できます。
これは必ずしも望ましい動作ではありませんが、このような失敗は非常にまれであるため、許容できる解決策であると考えられます。␞␞     </para>␞
␝     <para>␟      Prevent checkpoints from starting during relation truncation
      (Robert Haas)␟リレーションの切り捨て中にチェックポイントが開始されないようになりました。
(Robert Haas)␞␞      <ulink url="&commit_baseurl;d4ffbf47b">&sect;</ulink>␞
␝     <para>␟      This avoids a race condition wherein the modified file might not get
      fsync'd before completing the checkpoint, creating a risk of data
      corruption if the operating system crashes soon after.␟これにより、チェックポイントが完了する前に変更されたファイルがfsyncされず、直後にオペレーティングシステムがクラッシュした場合にデータ破損の危険性があるという競合状態が回避することができます。␞␞     </para>␞
␝     <para>␟      Avoid possibly losing an update of
      <structname>pg_database</structname>.<structfield>datfrozenxid</structfield>
      when <command>VACUUM</command> runs concurrently with
      a <command>REASSIGN OWNED</command> that changes that database's
      owner (Kirill Reshke)␟データベースの所有者を変更する<command>REASSIGN OWNED</command>と<command>VACUUM</command>が同時に実行された場合に、<structname>pg_database</structname>.<structfield>datfrozenxid</structfield>の更新情報を失う可能性が回避されました。
(Kirill Reshke)␞␞      <ulink url="&commit_baseurl;fa6131377">&sect;</ulink>␞
␝     <para>␟      Fix incorrect <structfield>tg_updatedcols</structfield> values
      passed to <literal>AFTER UPDATE</literal> triggers (Tom Lane)␟<literal>AFTER UPDATE</literal>トリガに渡される不正な<structfield>tg_updatedcols</structfield>の値が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;2b72fed2d">&sect;</ulink>␞
␝     <para>␟      In some cases the <structfield>tg_updatedcols</structfield> bitmap
      could describe the set of columns updated by an earlier command in
      the same transaction, fooling the trigger into doing the wrong
      thing.␟場合によっては、<structfield>tg_updatedcols</structfield>ビットマップが、同一トランザクション内の以前のコマンドによって更新された一連の列集合を表すことがあり、トリガが誤った処理を実行する可能性がありました。␞␞     </para>␞
␝     <para>␟      Also, prevent memory bloat caused by making too many copies of
      the <structfield>tg_updatedcols</structfield> bitmap.␟また、<structfield>tg_updatedcols</structfield>ビットマップのコピーを過剰に作成することによるメモリの膨張が防止されました。␞␞     </para>␞
␝     <para>␟      Fix detach of a partition that has its own foreign-key constraint
      referencing a partitioned table (Amul Sul)␟パーティションテーブルを参照する外部キー制約を持つパーティションのデタッチが修正されました。
(Amul Sul)␞␞      <ulink url="&commit_baseurl;2f30847d1">&sect;</ulink>␞
␝     <para>␟      In common cases, foreign keys are defined on a partitioned table's
      top level; but if instead one is defined on a partition and
      references a partitioned table, and the referencing partition is
      detached, the relevant <structname>pg_constraint</structname>
      entries were updated incorrectly.  This led to errors
      like <quote>could not find ON INSERT check triggers of foreign key
      constraint</quote>.␟通常、外部キーはパーティションテーブルの最上位レベルで定義されます。
しかし、代わりに外部キーがパーティション上で定義され、別のパーティションテーブルを参照している場合、参照元のパーティションが切り離されると、関連する<structname>pg_constraint</structname>エントリが誤って更新されていました。
その結果、<quote>could not find ON INSERT check triggers of foreign key constraint</quote>などのエラーが発生していました。␞␞     </para>␞
␝     <para>␟      Fix <function>pg_get_constraintdef</function>'s support
      for <literal>NOT NULL</literal> constraints on domains
      (Álvaro Herrera)␟ドメイン上の<literal>NOT NULL</literal>制約に対する<function>pg_get_constraintdef</function>のサポートが修正されました。
(Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;6e793582b">&sect;</ulink>␞
␝     <para>␟      Fix mis-processing of <function>to_timestamp</function>'s
      <literal>FF<replaceable>n</replaceable></literal> format codes
      (Tom Lane)␟<function>to_timestamp</function>の<literal>FF<replaceable>n</replaceable></literal>書式コードの誤った処理が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;765f76d8c">&sect;</ulink>␞
␝     <para>␟      An integer format code immediately
      preceding <literal>FF<replaceable>n</replaceable></literal> would
      consume all available digits, leaving none
      for <literal>FF<replaceable>n</replaceable></literal>.␟<literal>FF<replaceable>n</replaceable></literal>の直前の整数書式コードは、利用可能な桁数をすべて消費してしまい、<literal>FF<replaceable>n</replaceable></literal>のための桁数が何も残らない問題が発生していました。␞␞     </para>␞
␝     <para>␟      When deparsing a <literal>PASSING</literal> clause in a SQL/JSON
      query function, ensure that variable names are double-quoted when
      necessary (Dean Rasheed)␟SQL/JSONクエリ関数の<literal>PASSING</literal>句を逆解析するときは、必要に応じて変数名を二重引用符で囲むようになりました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;d037cc2af">&sect;</ulink>␞
␝     <para>␟      When deparsing an <literal>XMLTABLE()</literal> expression, ensure
      that XML namespace names are double-quoted when necessary (Dean
      Rasheed)␟<literal>XMLTABLE()</literal>式を逆解析するときは、必要に応じてXML名前空間名を二重引用符で囲むようになりました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;61b12135f">&sect;</ulink>␞
␝     <para>␟      Include the <literal>ldapscheme</literal> option
      in <function>pg_hba_file_rules()</function> output (Laurenz Albe)␟<function>pg_hba_file_rules()</function>の出力に<literal>ldapscheme</literal>オプションが含まれるようになりました。
(Laurenz Albe)␞␞      <ulink url="&commit_baseurl;8ed9bf0a3">&sect;</ulink>␞
␝     <para>␟      Fix planning of pre-sorted <literal>UNION</literal> operations for
      cases where the input column datatypes don't all match (David
      Rowley)␟入力列のデータ型がすべて一致しない場合のソート済<literal>UNION</literal>操作のプランニングが修正されました。
(David Rowley)␞␞      <ulink url="&commit_baseurl;5db9367e5">&sect;</ulink>␞
␝     <para>␟      This error could lead to sorting data with the wrong sort operator,
      with consequences ranging from no visible problem to core dumps.␟このエラーにより、間違ったソート演算子でデータがソートされる可能性があり、その結果は目に見える問題がない場合からコアダンプが発生する場合まで、さまざまな結果が生じる可能性がありました。␞␞     </para>␞
␝     <para>␟      Don't merge <literal>UNION</literal> operations if their column
      collations aren't consistent (Tom Lane)␟列の照合順序が一貫していない場合は、<literal>UNION</literal>操作をマージしないように修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;c1ebef3c1">&sect;</ulink>␞
␝     <para>␟      Previously we ignored collations when deciding if it's safe to
      merge <literal>UNION</literal> steps into a single
      N-way <literal>UNION</literal> operation.  This was arguably valid
      before the introduction of nondeterministic collations, but it's not
      anymore, since the collation in use can affect the definition of
      uniqueness.␟以前は、<literal>UNION</literal>ステップを単一のN方向<literal>UNION</literal>操作にマージするのが安全かどうかを判断する際に、照合順序を無視していました。
これは、非決定論的照合順序が導入される前はおそらく有効でしたが、現在では使用されている照合順序が一意性の定義に影響を与える可能性があるため、もはや有効ではありません。␞␞     </para>␞
␝     <para>␟      Prevent <quote>wrong varnullingrels</quote> planner errors after
      pulling up a subquery that's underneath an outer join (Tom Lane)␟外部結合の下にある副問い合わせをプルアップした後の<quote>wrong varnullingrels</quote>プランナエラーが防止されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;72822a99d">&sect;</ulink>␞
␝     <para>␟      Ignore nulling-relation marker bits when looking up statistics
      (Richard Guo)␟統計情報を検索するときに、NULLになるリレーションのマーカービットを無視するようになりました。
(Richard Guo)␞␞      <ulink url="&commit_baseurl;297b280ab">&sect;</ulink>␞
␝     <para>␟      This oversight could lead to failure to use relevant statistics
      about expressions, or to <quote>corrupt MVNDistinct
      entry</quote> errors.␟この見落としにより、式に関する適切な統計処理が使用できなかったり、<quote>corrupt MVNDistinct entry</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix missed expression processing for partition pruning steps
      (Tom Lane)␟パーティション除去ステップにおける式処理の見落としが修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;0671a71e0">&sect;</ulink>␞
␝     <para>␟      This oversight could lead to <quote>unrecognized node type</quote>
      errors, and perhaps other problems, in queries accessing partitioned
      tables.␟この見落としにより、パーティションテーブルにアクセスする問い合わせで、<quote>unrecognized node type</quote>エラーやその他の問題が発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Give the slotsync worker process its own process slot (Tom Lane, Hou
      Zhijie)␟slotsyncワーカープロセスに独自のプロセススロットを割り当てるようになりました。
(Tom Lane, Hou Zhijie)␞␞      <ulink url="&commit_baseurl;14141bbbc">&sect;</ulink>␞
␝     <para>␟      This was overlooked in the addition of the slotsync worker, with the
      result that its process slot effectively came out of the pool meant
      for regular backend processes.  This could result in failure to
      launch the worker, or to subsequent failures of connection requests
      that should have succeeded according to the configured settings,
      if the number of regular backend processes
      approached <varname>max_connections</varname>.␟slotsyncワーカーの追加時にこの点が見落とされていたため、その結果、そのプロセススロットが通常のバックエンドプロセス用のプールから実質的に外れてしまいました。
この結果、通常のバックエンドプロセスの数が<varname>max_connections</varname>に近づいた場合に、ワーカーの起動に失敗したり、設定に従って成功するはずだった接続要求が失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      Allow dshash tables to grow past 1GB (Matthias van de Meent)␟dshashテーブルが1ギガバイトを超えて拡張できるようになりました。
(Matthias van de Meent)␞␞      <ulink url="&commit_baseurl;18452b70a">&sect;</ulink>␞
␝     <para>␟      This avoids errors like <quote>invalid DSA memory alloc request
      size</quote>.  The case can occur for example in transactions that
      process several million tables.␟これにより、<quote>invalid DSA memory alloc request size</quote>などのエラーが回避されます。
これは、例えば数百万のテーブルを処理するトランザクションで発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid possible integer overflow
      in <function>bringetbitmap()</function> (James Hunter, Evgeniy
      Gorbanyov)␟<function>bringetbitmap()</function>で発生する可能性のある整数オーバーフローが回避されました。
(James Hunter, Evgeniy Gorbanyov)␞␞      <ulink url="&commit_baseurl;e027ee990">&sect;</ulink>␞
␝     <para>␟      Since the result is only used for statistical purposes, the effects
      of this error were mostly cosmetic.␟この結果は統計目的でのみ使用されるため、このエラーの影響は主に見た目に関するものでした。␞␞     </para>␞
␝     <para>␟      Correct miscalculation of SLRU bank numbers (Yura Sokolov)␟SLRUバンク数の計算ミスが修正されました。
(Yura Sokolov)␞␞      <ulink url="&commit_baseurl;ffd9b8134">&sect;</ulink>␞
␝     <para>␟      This error led to using a smaller number of banks than intended,
      causing more contention but no functional misbehavior.␟このエラーにより、意図したバンク数よりも少ないバンク数が使用されたため、より多くの競合が発生しましたが、機能上の不具合はありませんでした。␞␞     </para>␞
␝     <para>␟      Ensure that an already-set process latch doesn't prevent the
      postmaster from noticing socket events (Thomas Munro)␟すでに設定されているプロセスラッチによって、postmasterがソケットイベントを認識できないことは発生しなくなりました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;44f400fbc">&sect;</ulink>␞
␝     <para>␟      An extremely heavy workload of backends launching workers and
      workers exiting could prevent the postmaster from responding to
      incoming client connections in a timely fashion.␟バックエンドによるワーカーの起動と終了のワークロードが非常に重いと、postmasterがクライアントからの接続にタイムリーに応答できなくなる可能性がありました。␞␞     </para>␞
␝     <para>␟      Prevent streaming standby servers from looping infinitely when
      reading a WAL record that crosses pages (Kyotaro Horiguchi,
      Alexander Kukushkin)␟ストリーミングスタンバイサーバがページをまたぐWALレコードを読み込む際の無限ループの発生が防止されました。
(Kyotaro Horiguchi, Alexander Kukushkin)␞␞      <ulink url="&commit_baseurl;e6767c0ed">&sect;</ulink>␞
␝     <para>␟      This would happen when the record's continuation is on a page that
      needs to be read from a different WAL source.␟これは、レコードの継続が別のWALソースから読む必要のあるページにある場合に発生していました。␞␞     </para>␞
␝     <para>␟      Fix unintended promotion of FATAL errors to PANIC during early
      process startup (Noah Misch)␟プロセスの初期起動中にFATALエラーが意図せずPANICに昇格してしまう問題が修正されました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;4bd9de3f4">&sect;</ulink>␞
␝     <para>␟      This fixes some unlikely cases that would result in <quote>PANIC:
      proc_exit() called in child process</quote>.␟これにより、<quote>PANIC: proc_exit() called in child process</quote>というエラーが発生する可能性の低いケースが修正されます。␞␞     </para>␞
␝     <para>␟      Fix cases where an operator family member operator or support
      procedure could become a dangling reference (Tom Lane)␟演算子族メンバの演算子、またはサポートプロシージャが宙に浮いた参照になる可能性があるケースが修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;ec7b89cc5">&sect;</ulink>␞
␝     <para>␟      In some cases a data type could be dropped while references to its
      OID still remain in <structname>pg_amop</structname>
      or <structname>pg_amproc</structname>.  While that caused no
      immediate issues, an attempt to drop the owning operator family
      would fail, and <application>pg_dump</application> would produce
      bogus output when dumping the operator family.  This fix causes
      creation and modification of operator families/classes to add
      needed dependency entries so that dropping a data type will also
      drop any dependent operator family elements.  That does not help
      vulnerable pre-existing operator families, though, so a band-aid has
      also been added to <command>DROP OPERATOR FAMILY</command> to
      prevent failure when dropping a family that has dangling members.␟<structname>pg_amop</structname>または<structname>pg_amproc</structname>にOIDへの参照が残っている状態でデータ型が削除される場合がありました。
これによって直ちに問題が発生することはありませんが、所有する演算子族を削除しようとすると失敗し、<application>pg_dump</application>が演算子族をダンプする際に誤った出力を生成することがありました。
この修正により、演算子族クラスの作成と変更に必要な依存関係エントリが追加され、データ型を削除すると依存する演算子族要素も削除されます。
しかし、これは脆弱な既存の演算子族には役立ちませんので、宙に浮いたメンバを持つ演算子族を削除する際の失敗を防ぐための対策が<command>DROP OPERATOR FAMILY</command>に追加されました。␞␞     </para>␞
␝     <para>␟      Fix multiple memory leaks in logical decoding output (Vignesh C,
      Masahiko Sawada, Boyu Yang)␟ロジカルデコーディングの出力における複数のメモリリークが修正されました。
(Vignesh C, Masahiko Sawada, Boyu Yang)␞␞      <ulink url="&commit_baseurl;836435424">&sect;</ulink>␞
␝     <para>␟      Fix small memory leak when
      updating the <varname>application_name</varname>
      or <varname>cluster_name</varname> settings (Tofig Aliev)␟<varname>application_name</varname>または<varname>cluster_name</varname>設定を更新するときの小さなメモリリークが修正されました。
(Tofig Aliev)␞␞      <ulink url="&commit_baseurl;9add1bbfa">&sect;</ulink>␞
␝     <para>␟      Avoid crash when a background process tries to check a new value
      of <varname>synchronized_standby_slots</varname> (Álvaro Herrera)␟バックグラウンドプロセスが<varname>synchronized_standby_slots</varname>の新しい値をチェックしようとしたときのクラッシュが回避されました。
(Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;9abdc1841">&sect;</ulink>␞
␝     <para>␟      Avoid integer overflow while
      testing <varname>wal_skip_threshold</varname> condition (Tom Lane)␟<varname>wal_skip_threshold</varname>条件のテスト中の整数オーバーフローが回避されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;1e25cdb21">&sect;</ulink>␞
␝     <para>␟      A transaction that created a very large relation could mistakenly
      decide to ensure durability by copying the relation into WAL instead
      of fsync'ing it, thereby negating the point
      of <varname>wal_skip_threshold</varname>.  (This only matters
      when <varname>wal_level</varname> is set
      to <literal>minimal</literal>, else a WAL copy is required anyway.)␟非常に大きなリレーションを作成したトランザクションは、fsyncではなくWALにリレーションをコピーすることで永続性を確保しようと誤って判断し、<varname>wal_skip_threshold</varname>の効果が無効になる可能性がありました。
（これは、<varname>wal_level</varname>が<literal>minimal</literal>に設定されている場合にのみ問題となります。それ以外の場合は、いずれにしてもWALコピーが必要です。）␞␞     </para>␞
␝     <para>␟      Fix unsafe order of operations during cache lookups (Noah Misch)␟キャッシュ検索時の安全でない操作順序が修正されました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;718af10da">&sect;</ulink>␞
␝     <para>␟      The only known consequence was a usually-harmless <quote>you don't
      own a lock of type ExclusiveLock</quote> warning
      during <command>GRANT TABLESPACE</command>.␟知られている唯一の影響は、<command>GRANT TABLESPACE</command>時に<quote>you don't own a lock of type ExclusiveLock</quote>という通常は無害なWARNINGが表示されることでした。␞␞     </para>␞
␝     <para>␟      Avoid potential use-after-free in parallel vacuum (Vallimaharajan G,
      John Naylor)␟並列バキュームでのメモリ解放後使用の可能性が回避されました。
(Vallimaharajan G, John Naylor)␞␞      <ulink url="&commit_baseurl;83ce20d67">&sect;</ulink>␞
␝     <para>␟      This bug seems to have no consequences in standard builds, but it's
      theoretically a hazard.␟このバグは標準的なビルドでは影響がないように見えますが、理論的には危険です。␞␞     </para>␞
␝     <para>␟      Fix possible <quote>failed to resolve name</quote> failures when
      using JIT on older ARM platforms (Thomas Munro)␟古いARMプラットフォームでJITを使用した場合に発生する可能性がある<quote>failed to resolve name</quote>エラーが修正されました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;8a9a51518">&sect;</ulink>␞
␝     <para>␟      This could occur as a consequence of inconsistency about the default
      setting of <option>-moutline-atomics</option> between gcc and clang.
      At least Debian and Ubuntu are known to ship gcc and clang compilers
      that target armv8-a but differ on the use of outline atomics by
      default.␟これは、gccとclangとの間で<option>-moutline-atomics</option>のデフォルト設定に一貫性がないために発生する可能性があります。
少なくともDebianとUbuntuは、armv8-aをターゲットとするgccとclangコンパイラを出荷していることが知られていますが、デフォルトのアウトラインアトミックの使用については異なっています。␞␞     </para>␞
␝     <para>␟      Fix assertion failure in <literal>WITH RECURSIVE ... UNION</literal>
      queries (David Rowley)␟<literal>WITH RECURSIVE ... UNION</literal>の問い合わせでのアサーションエラーが修正されました。
(David Rowley)␞␞      <ulink url="&commit_baseurl;7b8d45d27">&sect;</ulink>␞
␝     <para>␟      Avoid assertion failure in rule deparsing if a set operation leaf
      query contains set operations (Man Zeng, Tom Lane)␟集合操作のリーフ問い合わせに集合操作が含まれている場合、ルールの逆解析でのアサーションエラーが回避されました。
(Man Zeng, Tom Lane)␞␞      <ulink url="&commit_baseurl;fea81aee8">&sect;</ulink>␞
␝     <para>␟      Avoid edge-case assertion failure in parallel query startup (Tom Lane)␟パラレルクエリ起動時のエッジケースでのアサーションエラーが回避されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;556f7b7bc">&sect;</ulink>␞
␝     <para>␟      Fix assertion failure at shutdown when writing out the statistics
      file (Michael Paquier)␟シャットダウンで統計ファイルを書き出すときのアサーションエラーが修正されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;dc5f90541">&sect;</ulink>␞
␝     <para>␟      Avoid valgrind complaints about string hashing code (John Naylor)␟文字列ハッシュコードに関するvalgrindの警告が修正されました。
(John Naylor)␞␞      <ulink url="&commit_baseurl;6555fe197">&sect;</ulink>␞
␝     <para>␟      In <function>NULLIF()</function>, avoid passing a read-write
      expanded object pointer to the data type's equality function
      (Tom Lane)␟<function>NULLIF()</function>では、読み書き拡張オブジェクトポインタをデータ型の等価関数に渡さないようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;97be02ad0">&sect;</ulink>␞
␝     <para>␟      The equality function could modify or delete the object if it's
      given a read-write pointer, which would be bad if we decide to
      return it as the <function>NULLIF()</function> result.  There is
      probably no problem with any built-in equality function, but it's
      easy to demonstrate a failure with one coded in PL/pgSQL.␟読み書き可能なポインタが渡されると、等価関数はオブジェクトを変更または削除する可能性があります。
そのため、<function>NULLIF()</function>の結果としてそのポインタを返すことにした場合、問題が発生する可能性があります。
組み込みの等価関数ではおそらく問題はありませんが、PL/pgSQLでコーディングされた等価関数で失敗を示すのは簡単です。␞␞     </para>␞
␝     <para>␟      Ensure that expression preprocessing is applied to a default null
      value in <command>INSERT</command> (Tom Lane)␟<command>INSERT</command>のデフォルトのNULL値に式の前処理が適用されるようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;6e41e9e5e">&sect;</ulink>␞
␝     <para>␟      If the target column is of a domain type, the planner must insert a
      coerce-to-domain step not just a null constant, and this expression
      missed going through some required processing steps.  There is no
      known consequence with domains based on core data types, but in
      theory an error could occur with domains based on extension types.␟対象列がドメイン型の場合、プランナは単なるNULL定数だけでなくcoerce-to-domainステップを挿入する必要があり、この式はいくつかの必要な処理ステップを実行していませんでした。
コアデータ型に基づくドメインでの既知の影響はありませんが、理論的には拡張型に基づくドメインでエラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid data loss when starting a bulk write on a relation fork that
      already contains data (Matthias van de Meent)␟すでにデータが含まれているリレーションフォークでバルク書き込みを開始するときのデータ損失が回避されました。
(Matthias van de Meent)␞␞      <ulink url="&commit_baseurl;969583553">&sect;</ulink>␞
␝     <para>␟      Any pre-existing data was overwritten with zeroes.  This is not an
      issue for core <productname>PostgreSQL</productname>, which never
      does that.  Some extensions would like to, however.␟既存のデータはすべてゼロで上書きされました。
これは<productname>PostgreSQL</productname>コアではこのようなことは決しておこなわれませんので、問題になりません。
ただし、一部の拡張ではそうしたいものもあります。␞␞     </para>␞
␝     <para>␟      Avoid crash if a server process tried to iterate over a shared radix
      tree that it didn't create (Masahiko Sawada)␟サーバプロセスが作成していない共有基数木を反復処理しようとした場合のクラッシュが回避されました。
(Masahiko Sawada)␞␞      <ulink url="&commit_baseurl;9af2b3435">&sect;</ulink>␞
␝     <para>␟      There is no code in core <productname>PostgreSQL</productname> that
      does this, but an extension might wish to.␟<productname>PostgreSQL</productname>コアにはこれを実行するコードはありませんが、拡張では実行を希望するかもしれません。␞␞     </para>␞
␝     <para>␟      Repair memory leaks in PL/Python (Mat Arye, Tom Lane)␟PL/Pythonのメモリリークが修復されました。
(Mat Arye, Tom Lane)␞␞      <ulink url="&commit_baseurl;e98df02df">&sect;</ulink>␞
␝     <para>␟      Repeated use of <function>PLyPlan.execute</function>
      or <function>plpy.cursor</function> resulted in memory leakage for
      the duration of the calling PL/Python function.␟<function>PLyPlan.execute</function>または<function>plpy.cursor</function>を繰り返し使用すると、PL/Python関数の呼び出し中にメモリリークが発生していました。␞␞     </para>␞
␝     <para>␟      Fix PL/Tcl to compile with Tcl 9 (Peter Eisentraut)␟PL/TclがTcl 9でコンパイルできるように修正されました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;f979197eb">&sect;</ulink>␞
␝     <para>␟      In the <application>ecpg</application> preprocessor, fix possible
      misprocessing of cursors that reference out-of-scope variables
      (Tom Lane)␟<application>ecpg</application>プリプロセッサで、スコープ外の変数を参照するカーソルの誤った処理の可能性が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;a963abd54">&sect;</ulink>␞
␝     <para>␟      In <application>ecpg</application>, fix compile-time warnings about
      unsupported use of <literal>COPY ... FROM STDIN</literal> (Ryo
      Kanbayashi)␟<application>ecpg</application>で、サポートされていない<literal>COPY ... FROM STDIN</literal>の使用に関するコンパイル時の警告が修正されました。
(Ryo Kanbayashi)␞␞      <ulink url="&commit_baseurl;ba2dbedd5">&sect;</ulink>␞
␝     <para>␟      Previously, the intended warning was not issued due to a typo.␟以前は、タイプミスのために意図した警告が発行されませんでした。␞␞     </para>␞
␝     <para>␟      Fix <application>psql</application> to safely handle file path names
      that are encoded in SJIS (Tom Lane)␟<application>psql</application>が、SJISでエンコードされたファイルパス名を安全に処理できるように修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;0b713b94b">&sect;</ulink>␞
␝     <para>␟      Some two-byte characters in SJIS have a second byte that is equal to
      ASCII backslash (<literal>\</literal>).  These characters were
      corrupted by path name normalization, preventing access to files
      whose names include such characters.␟SJISのいくつかの2バイト文字では、2バイト目がASCIIのバックスラッシュ(<literal>\</literal>)に相当します。
これらの文字は、パス名の正規化によって破損していたため、ファイル名にそのような文字が含まれるファイルにアクセスできない問題がありました。␞␞     </para>␞
␝     <para>␟      Add <application>psql</application> tab completion for <literal>COPY
      (MERGE INTO)</literal> (Jian He)␟<application>psql</application>で<literal>COPY (MERGE INTO)</literal>タブ補完機能が追加されました。
(Jian He)␞␞      <ulink url="&commit_baseurl;4527b9e26">&sect;</ulink>␞
␝     <para>␟      Fix use of wrong version of <function>pqsignal()</function>
      in <application>pgbench</application>
      and <application>psql</application> (Fujii Masao, Tom Lane)␟<application>pgbench</application>と<application>psql</application>における<function>pqsignal()</function>の間違ったバージョンの使用が修正されました。
(Fujii Masao, Tom Lane)␞␞      <ulink url="&commit_baseurl;a0dfeae0d">&sect;</ulink>␞
␝     <para>␟      This error could lead to misbehavior when using
      the <option>-T</option> option in <application>pgbench</application>
      or the <command>\watch</command> command
      in <application>psql</application>, due to interrupted system calls
      not being resumed as expected.␟このエラーにより、<application>pgbench</application>の<option>-T</option>オプションや<application>psql</application>の<command>\watch</command>コマンドの使用時に、中断されたシステムコールが期待通りに再開されないため、誤動作が発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix misexecution of some nested <command>\if</command> constructs
      in <application>pgbench</application> (Michail Nikolaev)␟<application>pgbench</application>内の一部のネストされた<command>\if</command>構造の誤った実行が修正されました。
(Michail Nikolaev)␞␞      <ulink url="&commit_baseurl;ff9dc96f3">&sect;</ulink>␞
␝     <para>␟      An <command>\if</command> command appearing within a false
      (not-being-executed) <command>\if</command> branch was incorrectly
      treated the same as <command>\elif</command>.␟偽の（実行されていない）<command>\if</command>分岐内に現れた<command>\if</command>コマンドが誤って<command>\elif</command>と同じように扱われていました。␞␞     </para>␞
␝     <para>␟      In <application>pgbench</application>, fix possible misdisplay of
      progress messages during table initialization (Yushi Ogiwara, Tatsuo
      Ishii, Fujii Masao)␟<application>pgbench</application>で、テーブルの初期化中に進行状況メッセージが誤って表示される可能性が修正されました。
(Yushi Ogiwara, Tatsuo Ishii, Fujii Masao)␞␞      <ulink url="&commit_baseurl;adb103fca">&sect;</ulink>␞
␝     <para>␟      Make <application>pg_controldata</application> more robust against
      corrupted <filename>pg_control</filename> files (Ilyasov Ian, Anton
      Voloshin)␟<application>pg_controldata</application>が破損した<filename>pg_control</filename>ファイルに対してより堅牢になりました。
(Ilyasov Ian, Anton Voloshin)␞␞      <ulink url="&commit_baseurl;1b8a9533f">&sect;</ulink>␞
␝     <para>␟      Since <application>pg_controldata</application> will attempt to
      print the contents of <filename>pg_control</filename> even if the
      CRC check fails, it must take care not to misbehave for invalid
      field values.  This patch fixes some issues triggered by invalid
      timestamps and apparently-negative WAL segment sizes.␟<application>pg_controldata</application>はCRCチェックが失敗しても<filename>pg_control</filename>の内容を出力しようとするため、無効なフィールド値に対して誤動作しないように注意しなければなりません。
このパッチにより、無効なタイムスタンプと明らかに負のWALセグメントサイズによって引き起こされるいくつかの問題が修正されました。␞␞     </para>␞
␝     <para>␟      Fix possible crash in <application>pg_dump</application> with
      identity sequences attached to tables that are extension members
      (Tom Lane)␟拡張メンバであるテーブルにIDシーケンスがアタッチされている場合に、<application>pg_dump</application>で発生する可能性のあるクラッシュが修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;ad950ea98">&sect;</ulink>␞
␝     <para>␟      Fix memory leak in <application>pg_restore</application>
      with zstd-compressed data (Tom Lane)␟zstd圧縮データを使用した<application>pg_restore</application>のメモリリークが修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;04b860198">&sect;</ulink>␞
␝     <para>␟      The leak was per-decompression-operation, so would be most
      noticeable with a dump containing many tables or large objects.␟リークは解凍操作ごとに発生していたため、多数のテーブルや大きなオブジェクトを含むダンプで最も顕著になります。␞␞     </para>␞
␝     <para>␟      Fix <application>pg_basebackup</application> to correctly
      handle <filename>pg_wal.tar</filename> files exceeding 2GB on
      Windows (Davinder Singh, Thomas Munro)␟Windowsで2ギガバイトを超える<filename>pg_wal.tar</filename>ファイルを正しく処理できるように<application>pg_basebackup</application>が修正されました。
(Davinder Singh, Thomas Munro)␞␞      <ulink url="&commit_baseurl;faee3185a">&sect;</ulink>␞
␝     <para>␟      Use SQL-standard function bodies in the declarations
      of <filename>contrib/earthdistance</filename>'s SQL-language
      functions (Tom Lane, Ronan Dunklau)␟<filename>contrib/earthdistance</filename>のSQL言語関数の宣言で、標準SQL関数の本体を使用するようになりました。
(Tom Lane, Ronan Dunklau)␞␞      <ulink url="&commit_baseurl;3652de36e">&sect;</ulink>␞
␝     <para>␟      This change allows their references
      to <filename>contrib/cube</filename> to be resolved during extension
      creation, reducing the risk of search-path-based failures and
      possible attacks.␟この変更により、拡張の作成時に<filename>contrib/cube</filename>への参照が解決され、検索パスに基づく障害や攻撃のリスクが軽減されます。␞␞     </para>␞
␝     <para>␟      In particular, this restores their usability in contexts like
      generated columns, for which <productname>PostgreSQL</productname>
      v17 restricts the search path on security grounds.  We have received
      reports of databases failing to be upgraded to v17 because of that.
      This patch has been included in v16 to provide a workaround:
      updating the <filename>earthdistance</filename> extension to this
      version beforehand should allow an upgrade to succeed.␟特に、<productname>PostgreSQL</productname> v17がセキュリティ上の理由から検索パスを制限している生成列のようなコンテキストでの使いやすさが回復されます。
これにより、データベースをv17にアップグレードできないという報告を受けています。
このパッチは、回避策を提供するためにv16に含まれています。<filename>earthdistance</filename>拡張を事前にこのバージョンにアップデートしておけば、アップグレードは成功するはずです。␞␞     </para>␞
␝     <para>␟      Detect version mismatch
      between <filename>contrib/pageinspect</filename>'s SQL declarations
      and the underlying shared library (Tomas Vondra)␟<filename>contrib/pageinspect</filename>のSQL宣言と基礎となる共有ライブラリとの間のバージョン不一致を検出するようになりました。
(Tomas Vondra)␞␞      <ulink url="&commit_baseurl;3668c1d50">&sect;</ulink>␞
␝     <para>␟      Previously, such a mismatch could result in a crash while
      calling <function>brin_page_items()</function>.  Instead throw an
      error recommending updating the extension.␟以前は、このような不一致により<function>brin_page_items()</function>の呼び出し時にクラッシュが発生する可能性がありました。
代わりに、拡張のアップデートを推奨するエラーが発生するようになりました。␞␞     </para>␞
␝     <para>␟      When trying to cancel a remote query
      in <filename>contrib/postgres_fdw</filename>, re-issue the cancel
      request a few times if it didn't seem to do anything (Tom Lane)␟<filename>contrib/postgres_fdw</filename>でリモート問い合わせをキャンセルしようとした際に、何もおこなわれなかったように見える場合は、キャンセル要求を数回再発行するようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;89962bfef">&sect;</ulink>␞
␝     <para>␟      This fixes a race condition where we might try to cancel a just-sent
      query before the remote server has started to process it, so that
      the initial cancel request is ignored.␟これにより、リモートサーバが処理を開始する前に送信されたばかりの問い合わせをキャンセルしようとする競合状態が修正され、最初のキャンセルリクエストは無視されるようになります。␞␞     </para>␞
␝     <para>␟      Update configuration probes that determine the compiler switches
      needed to access ARM CRC instructions (Tom Lane)␟ARM CRC命令にアクセスするために必要なコンパイラスイッチを決定する設定プローブが更新されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;e266a0ed6">&sect;</ulink>␞
␝     <para>␟      On ARM platforms where the baseline CPU target lacks CRC
      instructions, we need to supply a <option>-march</option> switch to
      persuade the compiler to compile such instructions.  Recent versions
      of gcc reject the value we were trying, leading to silently falling
      back to software CRC.␟ベースラインCPUターゲットにCRC命令がないARMプラットフォームでは、コンパイラにそのような命令をコンパイルさせるために<option>-march</option>スイッチを指定する必要があります。
最近のバージョンのgccは、私たちが試していた値を拒否し、ソフトウェアCRCに自動的にフォールバックします。␞␞     </para>␞
␝     <para>␟      Fix meson build system to support old OpenSSL libraries on Windows
      (Darek Slusarczyk)␟Windows上で古いOpenSSLライブラリをサポートするように、mesonビルドシステムが修正されました。
(Darek Slusarczyk)␞␞      <ulink url="&commit_baseurl;0951d4ee4">&sect;</ulink>␞
␝     <para>␟      Add support for the legacy library
      names <filename>ssleay32</filename>
      and <filename>libeay32</filename>.␟従来のライブラリ名<filename>ssleay32</filename>と<filename>libeay32</filename>のサポートが追加されました。␞␞     </para>␞
␝     <para>␟      In Windows builds using meson, ensure all libcommon and libpgport
      functions are exported (Vladlen Popolitov, Heikki Linnakangas)␟mesonを使用したWindowsビルドで、すべてのlibcommon関数とlibpgport関数のエクスポートが確認されるようになりました。
(Vladlen Popolitov, Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;c80acbc6f">&sect;</ulink>␞
␝     <para>␟      This fixes <quote>unresolved external symbol</quote> build errors
      for extensions.␟これにより、拡張ビルド時の<quote>unresolved external symbol</quote>エラーが修正されます。␞␞     </para>␞
␝     <para>␟      Fix meson configuration process to correctly detect
      OSSP's <filename>uuid.h</filename> header file under MSVC
      (Andrew Dunstan)␟MSVCでOSSPの<filename>uuid.h</filename>ヘッダファイルを正しく検出するようにmeson設定プロセスが修正されました。
(Andrew Dunstan)␞␞      <ulink url="&commit_baseurl;7c655a04a">&sect;</ulink>␞
␝     <para>␟      When building with meson, install <filename>pgevent</filename>
      in <replaceable>pkglibdir</replaceable>
      not <replaceable>bindir</replaceable> (Peter Eisentraut)␟mesonでビルドする場合、<filename>pgevent</filename>を<replaceable>bindir</replaceable>ではなく<replaceable>pkglibdir</replaceable>にインストールするようになりました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;e00c1e249">&sect;</ulink>␞
␝     <para>␟      This matches the behavior of the make-based build system and the old
      MSVC build system.␟これは、makeベースのビルドシステムと古いMSVCビルドシステムの動作と一致しています。␞␞     </para>␞
␝     <para>␟      When building with meson, install <filename>sepgsql.sql</filename>
      under <filename>share/contrib/</filename>
      not <filename>share/extension/</filename> (Peter Eisentraut)␟mesonでビルドする場合、<filename>sepgsql.sql</filename>を<filename>share/extension/</filename>ではなく<filename>share/contrib/</filename>の下にインストールするようになりました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;24c5b73eb">&sect;</ulink>␞
␝     <para>␟      This matches what the make-based build system does.␟これは、makeベースのビルドシステムの動作と一致しています。␞␞     </para>␞
␝     <para>␟      Update time zone data files to <application>tzdata</application>
      release 2025a for DST law changes in Paraguay, plus historical
      corrections for the Philippines (Tom Lane)␟タイムゾーンデータファイルを、パラグアイのサマータイム法の変更とフィリピンの歴史的修正をした<application>tzdata</application>リリース2025aに更新しました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;e292ba333">&sect;</ulink>␞
␝ <sect1 id="release-17-2">␟  <title>Release 17.2</title>␟  <title>リリース17.2</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2024-11-21</para>␞
␝  <para>␟   This release contains a few fixes from 17.1.
   For information about new features in major release 17, see
   <xref linkend="release-17"/>.␟このリリースは17.1に対し、いくつかの不具合を修正したものです。
17メジャーリリースにおける新機能については、<xref linkend="release-17"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-17-2-migration">␟   <title>Migration to Version 17.2</title>␟   <title>バージョン17.2への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you are upgrading from a version earlier than 17.1,
    see <xref linkend="release-17-1"/>.␟しかしながら、17.1より前のバージョンからアップグレードする場合は、<xref linkend="release-17-1"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-17-2-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Repair ABI break for extensions that work with
      struct <structname>ResultRelInfo</structname> (Tom Lane)␟<structname>ResultRelInfo</structname>構造体で動作する拡張のABI破壊が修復されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;6bfacd368">&sect;</ulink>␞
␝     <para>␟      Last week's minor releases unintentionally broke binary
      compatibility with <application>timescaledb</application> and
      several other extensions.  Restore the affected structure to its
      previous size, so that such extensions need not be rebuilt.␟先週のマイナーリリースでは、<application>timescaledb</application>やその他のいくつかの拡張のバイナリ互換性が意図せず壊れていました。
これらの拡張をビルドし直す必要がないように、影響を受けた構造体を以前のサイズに戻しました。␞␞     </para>␞
␝     <para>␟      Restore functionality of <command>ALTER {ROLE|DATABASE} SET
      role</command> (Tom Lane, Noah Misch)␟<command>ALTER {ROLE|DATABASE} SET role</command>の機能を元に戻しました。
(Tom Lane, Noah Misch)␞␞      <ulink url="&commit_baseurl;1c05004a8">&sect;</ulink>␞
␝     <para>␟      The fix for CVE-2024-10978 accidentally caused settings
      for <varname>role</varname> to not be applied if they come from
      non-interactive sources, including previous <command>ALTER
      {ROLE|DATABASE}</command> commands and
      the <varname>PGOPTIONS</varname> environment variable.␟CVE-2024-10978の修正により、以前の<command>ALTER {ROLE|DATABASE}</command>コマンドや<varname>PGOPTIONS</varname>環境変数など、非対話型ソースから取得された場合に<varname>role</varname>の設定が誤って適用されない問題が発生していました。␞␞     </para>␞
␝     <para>␟      Fix cases where a logical replication
      slot's <structfield>restart_lsn</structfield> could go backwards
      (Masahiko Sawada)␟論理レプリケーションスロットの<structfield>restart_lsn</structfield>が逆戻りする可能性があった問題が修正されました。
(Masahiko Sawada)␞␞      <ulink url="&commit_baseurl;568e78a65">&sect;</ulink>␞
␝     <para>␟      Previously, restarting logical replication could sometimes cause the
      slot's restart point to be recomputed as an older value than had
      previously been advertised
      in <structname>pg_replication_slots</structname>.  This is bad,
      since for example WAL files might have been removed on the basis of
      the later <structfield>restart_lsn</structfield> value, in which
      case replication would fail to restart.␟以前は、論理レプリケーションを再起動すると、スロットの再起動ポイントが<structname>pg_replication_slots</structname>で以前に通知された値よりも古い値として再計算されることがありました。
これは、例えばWALファイルが後の<structfield>restart_lsn</structfield>値に基づいて削除されている可能性があり、その場合レプリケーションの再開に失敗するため、問題となります。␞␞     </para>␞
␝     <para>␟      Avoid deleting still-needed WAL files
      during <application>pg_rewind</application>
      (Polina Bungina, Alexander Kukushkin)␟<application>pg_rewind</application>実行中に必要なWALファイルが削除されなくなりました。
(Polina Bungina, Alexander Kukushkin)␞␞      <ulink url="&commit_baseurl;cb844d66b">&sect;</ulink>␞
␝     <para>␟      Previously, in unlucky cases, it was possible
      for <application>pg_rewind</application> to remove important WAL
      files from the rewound demoted primary.  In particular this happens
      if those files have been marked for archival (i.e.,
      their <filename>.ready</filename> files were created) but not yet
      archived.  Then the newly promoted node no longer has such files
      because of them having been recycled, but likely they are needed
      for recovery in the demoted node.
      If <application>pg_rewind</application> removes them, recovery is
      not possible anymore.␟以前は、不運な場合、<application>pg_rewind</application>が、巻き戻された降格プライマリから重要なWALファイルを削除することがありました。
特に、これらのファイルがアーカイブ対象としてマークされていても（つまり、<filename>.ready</filename>ファイルが作成されても）まだアーカイブされていない場合に、この問題が発生します。
その場合、新たに昇格したノードでは、これらのファイルはリサイクルされたため存在しませんが、降格したノードのリカバリに必要となる可能性があります。
<application>pg_rewind</application>がこれらのファイルを削除すると、リカバリは不可能になります。␞␞     </para>␞
␝     <para>␟      Fix race conditions associated with dropping shared statistics
      entries (Kyotaro Horiguchi, Michael Paquier)␟共有統計エントリの削除に関連する競合状態が修正されました。
(Kyotaro Horiguchi, Michael Paquier)␞␞      <ulink url="&commit_baseurl;1d6a03ea4">&sect;</ulink>␞
␝     <para>␟      These bugs could lead to loss of statistics data, assertion
      failures, or <quote>can only drop stats once</quote> errors.␟これらのバグにより、統計データの損失、アサーションエラー、または<quote>can only drop stats once</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Count index scans in <filename>contrib/bloom</filename> indexes in
      the statistics views, such as the
      <structname>pg_stat_user_indexes</structname>.<structfield>idx_scan</structfield>
      counter (Masahiro Ikeda)␟<structname>pg_stat_user_indexes</structname>.<structfield>idx_scan</structfield>カウンタなどの統計ビューで、<filename>contrib/bloom</filename>インデックス内のインデックススキャンをカウントするようになりました。
(Masahiro Ikeda)␞␞      <ulink url="&commit_baseurl;7af6d1306">&sect;</ulink>␞
␝     <para>␟      Fix crash when checking to see if an index's opclass options have
      changed (Alexander Korotkov)␟インデックスのopclassオプションが変更されたかどうかを確認する際に発生するクラッシュが修正されました。
(Alexander Korotkov)␞␞      <ulink url="&commit_baseurl;a6fa869cf">&sect;</ulink>␞
␝     <para>␟      Some forms of <command>ALTER TABLE</command> would fail if the
      table has an index with non-default operator class options.␟そのテーブルにデフォルト以外の演算子クラスオプションを持つインデックスがある場合、<command>ALTER TABLE</command>の一部の形式が失敗していました。␞␞     </para>␞
␝     <para>␟      Avoid assertion failure caused by disconnected NFA sub-graphs in
      regular expression parsing (Tom Lane)␟正規表現パースにおいて、切断されたNFAサブグラフによって引き起こされるアサーションエラーが回避されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;5f28e6ba7">&sect;</ulink>␞
␝     <para>␟      This bug does not appear to have any visible consequences in
      non-assert builds.␟このバグは、アサートなしのビルドでは目に見える影響は見られません。␞␞     </para>␞
␝ <sect1 id="release-17-1">␟  <title>Release 17.1</title>␟  <title>リリース17.1</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2024-11-14</para>␞
␝  <para>␟   This release contains a variety of fixes from 17.0.
   For information about new features in major release 17, see
   <xref linkend="release-17"/>.␟このリリースは17.0に対し、様々な不具合を修正したものです。
17メジャーリリースにおける新機能については、<xref linkend="release-17"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-17-1-migration">␟   <title>Migration to Version 17.1</title>␟   <title>バージョン17.1への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 17.X.␟17.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you have ever detached a partition from a partitioned
    table that has a foreign-key reference to another partitioned table,
    and not dropped the former partition, then you may have catalog and/or
    data corruption to repair, as detailed in the fifth changelog entry
    below.␟しかしながら、パーティションテーブルからパーティションを切り離したことがあり、そのパーティションが別のパーティションテーブルへの外部参照を持っていて、以前のそのパーティションを削除してない場合は、次の変更点の5番目のエントリで詳しく説明するように、カタログまたはデータの破損、あるいはその両方の破損を修復する必要があります。␞␞   </para>␞
␝   <para>␟    Also, in the uncommon case that a
    database's <varname>LC_CTYPE</varname> setting is <literal>C</literal>
    while its <varname>LC_COLLATE</varname> setting is some other locale,
    indexes on textual columns should be reindexed, as described in the
    sixth changelog entry below.␟また、データベースの<varname>LC_CTYPE</varname>設定が<literal>C</literal>であるのに、<varname>LC_COLLATE</varname>設定が他のロケールである稀なケースでは、次の変更点の6番目のエントリで説明しているように、テキスト列のインデックスを再作成する必要があります。␞␞   </para>␞
␝  <sect2 id="release-17-1-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Ensure cached plans are marked as dependent on the calling role when
      RLS applies to a non-top-level table reference (Nathan Bossart)␟最上位レベル以外のテーブル参照にRLSが適用される場合、キャッシュされた実行計画が呼び出し元のロールに依存するものとしてマークされるようになりました。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;edcda9bb4">&sect;</ulink>␞
␝     <para>␟      If a CTE, subquery, sublink, security invoker view, or coercion
      projection in a query references a table with row-level security
      policies, we neglected to mark the resulting plan as potentially
      dependent on which role is executing it.  This could lead to later
      query executions in the same session using the wrong plan, and then
      returning or hiding rows that should have been hidden or returned
      instead.␟問い合わせ内のCTE、サブクエリ、サブリンク、セキュリティ呼び出し元ビュー、または強制射影が行レベルセキュリティポリシーを持つテーブルを参照する場合、結果の実行計画がどのロールで実行しているかに依存する可能性があるとマークされていませんでした。
これにより、同じセッションで後に実行された問い合わせが間違った実行計画で実行され、本来非表示にする必要があった行が返されたり、返すべき行が非表示になったりする可能性がありました。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Wolfgang Walther for reporting this problem.
      (CVE-2024-10976)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたWolfgang Waltherに感謝します。
(CVE-2024-10976)␞␞     </para>␞
␝     <para>␟      Make <application>libpq</application> discard error messages
      received during SSL or GSS protocol negotiation (Jacob Champion)␟<application>libpq</application>がSSLまたはGSSプロトコルのネゴシエーション中に受信したエラーメッセージを廃棄するように修正されました。
(Jacob Champion)␞␞      <ulink url="&commit_baseurl;a5cc4c667">&sect;</ulink>␞
␝     <para>␟      An error message received before encryption negotiation is completed
      might have been injected by a man-in-the-middle, rather than being
      real server output.  Reporting it opens the door to various security
      hazards; for example, the message might spoof a query result that a
      careless user could mistake for correct output.  The best answer
      seems to be to discard such data and rely only
      on <application>libpq</application>'s own report of the connection
      failure.␟暗号化ネゴシエーションが完了する前に受け取ったエラーメッセージは、実際のサーバの出力ではなく、中間者攻撃によって挿入された可能性があります。
これを報告すると、さまざまなセキュリティ上の危険が生じる可能性があります。
例えば、このメッセージによって問い合わせの結果を偽装して、不注意なユーザが正しい出力と勘違いする可能性があります。
最良の解決策は、このようなデータを破棄し、<application>libpq</application>自身の接続失敗の報告のみに頼ることです。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Jacob Champion for reporting this problem.
      (CVE-2024-10977)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたJacob Championに感謝します。
(CVE-2024-10977)␞␞     </para>␞
␝     <para>␟      Fix unintended interactions between <command>SET SESSION
      AUTHORIZATION</command> and <command>SET ROLE</command> (Tom Lane)␟<command>SET SESSION AUTHORIZATION</command>と<command>SET ROLE</command>の間の意図しない相互作用が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;cd82afdda">&sect;</ulink>␞
␝     <para>␟      The SQL standard mandates that <command>SET SESSION
      AUTHORIZATION</command> have a side-effect of doing <command>SET
      ROLE NONE</command>.  Our implementation of that was flawed,
      creating more interaction between the two settings than intended.
      Notably, rolling back a transaction that had done <command>SET
      SESSION AUTHORIZATION</command> would revert <literal>ROLE</literal>
      to <literal>NONE</literal> even if that had not been the previous
      state, so that the effective user ID might now be different from
      what it had been before the transaction.  Transiently
      setting <varname>session_authorization</varname> in a
      function <literal>SET</literal> clause had a similar effect.
      A related bug was that if a parallel worker
      inspected <literal>current_setting('role')</literal>, it
      saw <literal>none</literal> even when it should see something else.␟標準SQLでは、<command>SET SESSION AUTHORIZATION</command>が副作用として<command>SET ROLE NONE</command>を実行することを義務付けています。
この実装には欠陥があり、2つの設定間に意図した以上の相互作用が発生していました。
特に、<command>SET SESSION AUTHORIZATION</command>を実行したトランザクションをロールバックすると、以前の状態ではなかったとしても<literal>ROLE</literal>が<literal>NONE</literal>に戻ってしまうことがありました。そのため実効ユーザIDがトランザクションの前とは異なる場合がありました。
関数の<literal>SET</literal>句で<varname>session_authorization</varname>を一時的に設定しても、同様の影響がありました。
関連するバグとして、パラレルワーカーが<literal>current_setting('role')</literal>を検査した場合、他の値を参照すべきときでも<literal>none</literal>と認識される問題がありました。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Tom Lane for reporting this problem.
      (CVE-2024-10978)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたTom Laneに感謝します。
(CVE-2024-10978)␞␞     </para>␞
␝     <para>␟      Prevent trusted PL/Perl code from changing environment variables
      (Andrew Dunstan, Noah Misch)␟信頼されたPL/Perlコードが環境変数を変更できないように修正されました。
(Andrew Dunstan, Noah Misch)␞␞      <ulink url="&commit_baseurl;3ebcfa54d">&sect;</ulink>␞
␝     <para>␟      The ability to manipulate process environment variables such
      as <literal>PATH</literal> gives an attacker opportunities to
      execute arbitrary code.  Therefore, <quote>trusted</quote> PLs must
      not offer the ability to do that.  To fix <literal>plperl</literal>,
      replace <varname>%ENV</varname> with a tied hash that rejects any
      modification attempt with a warning.
      Untrusted <literal>plperlu</literal> retains the ability to change
      the environment.␟<literal>PATH</literal>などのプロセス環境変数を操作する機能は、攻撃者に任意のコードを実行する機会を与えます。
したがって、<quote>信頼された</quote>PLはそれを行う機能を提供してはなりません。
<literal>plperl</literal>は、<varname>%ENV</varname>を、変更の試みを警告で拒否する結びつけられたハッシュに置き換えるよう修正されました。
信頼されていない<literal>plperlu</literal>は、環境を変更する機能を保持します。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Coby Abrams for reporting this problem.
      (CVE-2024-10979)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたCoby Abramsに感謝します。
(CVE-2024-10979)␞␞     </para>␞
␝     <para>␟      Fix updates of catalog state for foreign-key constraints when
      attaching or detaching table partitions (Jehan-Guillaume de
      Rorthais, Tender Wang, Álvaro Herrera)␟テーブルパーティションをアタッチまたはデタッチする際の、外部キーの制約のカタログ状態の更新が修正されました。
(Jehan-Guillaume de Rorthais, Tender Wang, Álvaro Herrera)␞␞      <ulink url="&commit_baseurl;5914a22f6">&sect;</ulink>␞
␝     <para>␟      If the referenced table is partitioned, then different catalog
      entries are needed for a referencing table that is stand-alone
      versus one that is a partition.  <literal>ATTACH/DETACH
      PARTITION</literal> commands failed to perform this conversion
      correctly.  In particular, after <literal>DETACH</literal> the now
      stand-alone table would be missing foreign-key enforcement triggers,
      which could result in the table later containing rows that fail the
      foreign-key constraint.  A subsequent re-<literal>ATTACH</literal>
      could fail with surprising errors, too.␟参照先テーブルがパーティションテーブルの場合、参照元テーブルがスタンドアローンの場合とパーティションの場合で、異なるカタログエントリが必要になります。
<literal>ATTACH/DETACH PARTITION</literal>コマンドはこの変換を正しく実行できませんでした。
特に、<literal>DETACH</literal>後、スタンドアローンになったテーブルには、外部キー強制トリガが欠落するため、その結果、外部キー制約に違反する行がテーブルに含まれる可能性がありました。
その後の再<literal>ATTACH</literal>も、予期しないエラーで失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      The way to fix this is to do <command>ALTER TABLE DROP
      CONSTRAINT</command> on the now stand-alone table for each faulty
      constraint, and then re-add the constraint.  If re-adding the
      constraint fails, then some erroneous data has crept in.  You will
      need to manually re-establish consistency between the referencing
      and referenced tables, then re-add the constraint.␟この問題を解決するには、スタンドアローンになったテーブルで問題のある制約ごとに<command>ALTER TABLE DROP CONSTRAINT</command>を実行し、その後制約を再度追加します。
制約の再追加に失敗した場合は、誤ったデータが入り込んでいます。
参照元テーブルと参照先テーブル間の整合性を手動で再確立し、制約を再度追加する必要があります。␞␞     </para>␞
␝     <para>␟      This query can be used to identify broken constraints and construct
      the commands needed to recreate them:␟このクエリを使用して、破損した制約を識別し、それらを再作成するために必要なコマンドを作成することができます。␞␞<programlisting>␞
␝</programlisting>␟      Since it is possible that one or more of the <literal>ADD
      CONSTRAINT</literal> steps will fail, you should save the query's
      output in a file and then attempt to perform each step.␟<literal>ADD CONSTRAINT</literal>の1つ以上のステップが失敗する可能性があるため、問い合わせの出力をファイルに保存してから、各ステップの実行を試行する必要があります。␞␞     </para>␞
␝     <para>␟      Fix test for <literal>C</literal> locale
      when <varname>LC_COLLATE</varname> is different
      from <varname>LC_CTYPE</varname> (Jeff Davis)␟<varname>LC_COLLATE</varname>が<varname>LC_CTYPE</varname>と異なる場合の<literal>C</literal>ロケールのテストが修正されました。
(Jeff Davis)␞␞      <ulink url="&commit_baseurl;8148e7124">&sect;</ulink>␞
␝     <para>␟      When using <literal>libc</literal> as the default collation
      provider, the test to see if <literal>C</literal> locale is in use
      for collation accidentally checked <varname>LC_CTYPE</varname>
      not <varname>LC_COLLATE</varname>.  This has no impact in the
      typical case where those settings are the same, nor if both are
      not <literal>C</literal> (nor its alias <literal>POSIX</literal>).
      However, if <varname>LC_CTYPE</varname> is <literal>C</literal>
      while <varname>LC_COLLATE</varname> is some other locale, wrong
      query answers could ensue, and corruption of indexes on strings was
      possible.  Users of databases with such settings should reindex
      affected indexes after installing this update.
      The converse case with <varname>LC_COLLATE</varname>
      being <literal>C</literal> while <varname>LC_CTYPE</varname> is some
      other locale would cause performance degradation, but no actual
      errors.␟デフォルトの照合順序プロバイダとして<literal>libc</literal>を使用している場合、照合順序に<literal>C</literal>ロケールが使用されているかどうかを確認するテストが、誤って<varname>LC_COLLATE</varname>ではなく<varname>LC_CTYPE</varname>をチェックしていました。
これらの設定が同じである一般的なケース、または両方が<literal>C</literal>（またはその別名である<literal>POSIX</literal>）でない場合は、この問題は発生しません。
ただし、<varname>LC_CTYPE</varname>が<literal>C</literal>で、<varname>LC_COLLATE</varname>が他のロケールである場合、問い合わせの応答が間違っていたり、文字列のインデックスが破損する可能性がありました。
このような設定を持つデータベースのユーザは、この更新をインストールした後に、影響を受けるインデックスを再作成する必要があります。
逆に<varname>LC_COLLATE</varname>が<literal>C</literal>で<varname>LC_CTYPE</varname>が他のロケールである場合は、パフォーマンスは低下しますが、実際のエラーは発生しません。␞␞     </para>␞
␝     <para>␟      Don't use partitionwise joins or grouping if the query's collation
      for the key column doesn't match the partition key's collation (Jian
      He, Webbo Han)␟キー列の問い合わせの照合順序がパーティションキーの照合順序と一致しない場合は、パーティション同士の結合またはグループ化を使用しないようになりました。
(Jian He, Webbo Han)␞␞      <ulink url="&commit_baseurl;a0cdfc889">&sect;</ulink>␞
␝     <para>␟      Such plans could produce incorrect results.␟このような計画は、間違った結果を生成する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid planner failure after converting an <literal>IS NULL</literal>
      test on a <literal>NOT NULL</literal> column to
      constant <literal>FALSE</literal> (Richard Guo)␟<literal>NOT NULL</literal>列の<literal>IS NULL</literal>テストを<literal>FALSE</literal>定数に変換した後のプランナ失敗が回避されました。
(Richard Guo)␞␞      <ulink url="&commit_baseurl;78b1c553b">&sect;</ulink>␞
␝     <para>␟      This bug typically led to errors such as <quote>variable not found
      in subplan target lists</quote>.␟このバグは典型的には、<quote>variable not found in subplan target lists</quote>などのエラーを引き起こしました。␞␞     </para>␞
␝     <para>␟      Avoid possible planner crash while inlining a SQL function whose
      arguments contain certain array-related constructs (Tom Lane, Nathan
      Bossart)␟引数に特定の配列関連の構成が含まれるSQL関数をインライン化する際に、プランナがクラッシュする可能性が回避されました。
(Tom Lane, Nathan Bossart)␞␞      <ulink url="&commit_baseurl;a3c4a91f1">&sect;</ulink>␞
␝     <para>␟      Fix possible wrong answers or <quote>wrong varnullingrels</quote>
      planner errors for <literal>MERGE ... WHEN NOT MATCHED BY
      SOURCE</literal> actions (Dean Rasheed)␟<literal>MERGE ... WHEN NOT MATCHED BY SOURCE</literal>アクションで発生する可能性のある、間違った応答または<quote>wrong varnullingrels</quote>プランナエラーが修正されました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;d7d297f84">&sect;</ulink>␞
␝     <para>␟      Fix possible <quote>could not find pathkey item to sort</quote>
      error when the output of a <literal>UNION ALL</literal> member query
      needs to be sorted, and the sort column is an expression (Andrei
      Lepikhov, Tom Lane)␟<literal>UNION ALL</literal>メンバ問い合わせの出力をソートする必要があり、ソート列が式である場合に発生する可能性のある<quote>could not find pathkey item to sort</quote>エラーが修正されました。
(Andrei Lepikhov, Tom Lane)␞␞      <ulink url="&commit_baseurl;54889ea64">&sect;</ulink>␞
␝     <para>␟      Fix edge case in B-tree ScalarArrayOp index scans (Peter Geoghegan)␟B-treeのScalarArrayOpを使うインデックススキャンの稀な不具合が修正されました。
(Peter Geoghegan)␞␞      <ulink url="&commit_baseurl;c177726ae">&sect;</ulink>␞
␝     <para>␟      When a scrollable cursor with a plan of this kind was backed up to its
      starting point and then run forward again, wrong answers were
      possible.␟この種のプランを持つスクロール可能なカーソルを開始点まで巻き戻した後、再び前方に実行した場合、誤った問い合わせ結果が生じる可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix assertion failure or confusing error message for <literal>COPY
      (<replaceable>query</replaceable>) TO ...</literal>, when
      the <replaceable>query</replaceable> is rewritten by a <literal>DO
      INSTEAD NOTIFY</literal> rule (Tender Wang, Tom Lane)␟<replaceable>問い合わせ</replaceable>が<literal>DO INSTEAD NOTIFY</literal>の規則によって書き換えられた場合に発生する、<literal>COPY (<replaceable>query</replaceable>) TO ...</literal>のアサーションエラーまたは紛らわしいエラーメッセージが修正されました。
(Tender Wang, Tom Lane)␞␞      <ulink url="&commit_baseurl;3685ad618">&sect;</ulink>␞
␝     <para>␟      Fix validation
      of <command>COPY</command>'s <literal>FORCE_NOT_NULL</literal>
      and <literal>FORCE_NULL</literal> options (Joel Jacobson)␟<command>COPY</command>の<literal>FORCE_NOT_NULL</literal>オプションと<literal>FORCE_NULL</literal>オプションの検証が修正されました。
(Joel Jacobson)␞␞      <ulink url="&commit_baseurl;c06a4746b">&sect;</ulink>␞
␝     <para>␟      Some incorrect usages are now rejected as they should be.␟一部の誤った使用法は、適切に拒否されるようになりました。␞␞     </para>␞
␝     <para>␟      Fix server crash when a <function>json_objectagg()</function> call
      contains a volatile function (Amit Langote)␟<function>json_objectagg()</function>呼び出しにVOLATILE関数が含まれている場合に発生するサーバクラッシュが修正されました。
(Amit Langote)␞␞      <ulink url="&commit_baseurl;7148cb3e3">&sect;</ulink>␞
␝     <para>␟      Fix detection of skewed data during parallel hash join (Thomas
      Munro)␟パラレルハッシュ結合中の偏ったデータ検出が修正されました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;4ac5d33a8">&sect;</ulink>␞
␝     <para>␟      After repartitioning the inner side of a hash join because one
      partition has accumulated too many tuples, we check to see if all
      the partition's tuples went into the same child partition, which
      suggests that they all have the same hash value and further
      repartitioning cannot improve matters.  This check malfunctioned in
      some cases, allowing repeated futile repartitioning which would
      eventually end in a resource-exhaustion error.␟1つのパーティションにタプルが蓄積されすぎたため、ハッシュ結合の内側を再分割した後、すべてのパーティションのタプルが同じ子パーティションに入ったかどうかを確認します。これは、すべてのタプルが同じハッシュ値を持つため、さらに再分割しても改善は問題にならないことを示唆しています。
このチェックは場合によっては誤動作し、無駄な再分割が繰り返され、最終的にはリソース不足のエラーになることがありました。␞␞     </para>␞
␝     <para>␟      Avoid crash when <command>ALTER DATABASE SET</command> is used to
      set a server parameter that requires search-path-based lookup, such
      as <varname>default_text_search_config</varname> (Jeff Davis)␟<command>ALTER DATABASE SET</command>を使用して、<varname>default_text_search_config</varname>などのサーチパスベースの検索を必要とするパラメータを設定した場合のクラッシュが回避されました。
(Jeff Davis)␞␞      <ulink url="&commit_baseurl;2fe4167bc">&sect;</ulink>␞
␝     <para>␟      Avoid repeated lookups of opclasses and collations while creating a
      new index on a partitioned table (Tom Lane)␟パーティションテーブルに新しいインデックスを作成する際の、opclassesと照合順序の繰り返し検索が回避されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;fee8cb947">&sect;</ulink>␞
␝     <para>␟      This was problematic mainly because some of the lookups would be
      done with a restricted <varname>search_path</varname>, leading to
      unexpected failures if the <command>CREATE INDEX</command> command
      referenced objects outside <literal>pg_catalog</literal>.␟これは主に一部の検索が制限された<varname>search_path</varname>で実行されるため、<command>CREATE INDEX</command>コマンドが<literal>pg_catalog</literal>外のオブジェクトを参照した場合に予期せぬエラーが発生する問題がありました。␞␞     </para>␞
␝     <para>␟      This fix also prevents comments on the parent partitioned index from
      being copied to child indexes.␟この修正により、親パーティションインデックスのコメントが子インデックスにコピーされるのも防止されます。␞␞     </para>␞
␝     <para>␟      Add missing dependency from a partitioned table to a non-built-in
      access method specified in <literal>CREATE TABLE ... USING</literal>
      (Michael Paquier)␟パーティションテーブルから<literal>CREATE TABLE ... USING</literal>で指定された非組み込みアクセスメソッドへの欠落した依存性が追加されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;bb584e831">&sect;</ulink>␞
␝     <para>␟      Dropping the access method should be blocked when a table exists
      that depends on it, but it was not, allowing subsequent odd
      behavior.  Note that this fix only prevents problems for partitioned
      tables created after this update.␟アクセスメソッドに依存するテーブルが存在する場合は、アクセスメソッドの削除はブロックされる必要がありますが、そうではなかっため、その後に異常な動作が発生する可能性がありました。
この修正は、この更新の後に作成されたパーティションテーブルの問題のみを防止することに注意してください。␞␞     </para>␞
␝     <para>␟      Disallow locale names containing non-ASCII characters (Thomas Munro)␟非ASCII文字を含むロケール名が許可されなくなりました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;9c7acc333">&sect;</ulink>␞
␝     <para>␟      This is only an issue on Windows, as such locale names are not used
      elsewhere.  They are problematic because it's quite unclear what
      encoding such names are represented in (since the locale itself
      defines the encoding to use).  In
      recent <productname>PostgreSQL</productname> releases, an abort in
      the Windows runtime library could occur because of confusion about
      that.␟このようなロケール名は他の場所では使用されていないため、これはWindowsだけの問題です。
このような名前がどのエンコーディングで表現されるのかが非常に不明確であるため、問題があります（ロケール自体が使用するエンコーディングを定義するため）。
最近の<productname>PostgreSQL</productname>リリースでは、その混乱によりWindowsランタイムライブラリのアボートが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Anyone who encounters the new error message should either create a
      new duplicated locale with an ASCII-only name using Windows Locale
      Builder, or consider using BCP 47-compliant locale names
      like <literal>tr-TR</literal>.␟新しいエラーメッセージに遭遇した場合は、Windows Locale Builderを使用してASCII文字のみの名前で新しい複製ロケールを作成するか、<literal>tr-TR</literal>のようなBCP 47準拠のロケール名の使用を検討してください。␞␞     </para>␞
␝     <para>␟      Fix race condition in committing a serializable transaction (Heikki
      Linnakangas)␟シリアライザブルトランザクションをコミットする際の競合状態が修正されました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;234f6d09e">&sect;</ulink>␞
␝     <para>␟      Mis-processing of a recently committed transaction could lead to an
      assertion failure or a <quote>could not access status of
      transaction</quote> error.␟最近コミットされたトランザクションの処理を誤って、アサーションエラーまたは<quote>could not access status of transaction</quote>エラーにつながる可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix race condition in <command>COMMIT PREPARED</command>
      that resulted in orphaned 2PC files (wuchengwen)␟孤立した二相コミット(2PC)ファイルが生成されていた<command>COMMIT PREPARED</command>で競合条件が修正されました。
(wuchengwen)␞␞      <ulink url="&commit_baseurl;f250cb29d">&sect;</ulink>␞
␝     <para>␟      A concurrent <command>PREPARE TRANSACTION</command> could
      cause <command>COMMIT PREPARED</command> to not remove the on-disk
      two-phase state file for the completed transaction.  There was no
      immediate ill effect, but a subsequent crash-and-recovery could fail
      with <quote>could not access status of transaction</quote>,
      requiring manual removal of the orphaned file to restore service.␟同時実行の<command>PREPARE TRANSACTION</command>により、<command>COMMIT PREPARED</command>が完了したトランザクションのディスク上の二相状態ファイルが削除されない原因となる可能性がありました。
すぐに悪影響はありませんでしたが、その後のクラッシュとリカバリが<quote>could not access status of transaction</quote>というエラーで、サービス復旧には孤立したファイルを手動で削除する必要がありました。␞␞     </para>␞
␝     <para>␟      Avoid invalid memory accesses after skipping an invalid toast index
      during <command>VACUUM FULL</command> (Tender Wang)␟<command>VACUUM FULL</command>中に無効なTOASTインデックスをスキップした後の無効なメモリアクセスが回避されました。
(Tender Wang)␞␞      <ulink url="&commit_baseurl;1532599a8">&sect;</ulink>␞
␝     <para>␟      A list tracking yet-to-be-rebuilt indexes was not properly updated
      in this code path, risking assertion failures or crashes later on.␟このコードパスでは、まだ再構築されていないインデックスを追跡しているリストが適切に更新されず、後でアサーションエラーやクラッシュが発生する危険性がありました。␞␞     </para>␞
␝     <para>␟      Fix ways in which an <quote>in place</quote> catalog update could be
      lost (Noah Misch)␟<quote>インプレース</quote>でのカタログ更新が失われる可能性のある方法が修正されました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;fd27b878c">&sect;</ulink>␞
␝     <para>␟      Normal row updates write a new version of the row to preserve
      rollback-ability of the transaction.  However, certain system
      catalog updates are intentionally non-transactional and are done
      with an in-place update of the row.  These patches fix race
      conditions that could cause the effects of an in-place update to be
      lost.  As an example, it was possible to forget having set
      <structname>pg_class</structname>.<structfield>relhasindex</structfield>
      to true, preventing updates of the new index and thus causing index
      corruption.␟通常の行更新では、トランザクションのロールバック可能性を維持するために行の新しいバージョンが書き込まれます。
ただし、一部のシステムカタログ更新は意図的にトランザクションではなく、行のインプレース更新で行われます。
これらのパッチは、インプレース更新の効果が失われる原因となる競合状態を修正します。
例えば、<structname>pg_class</structname>.<structfield>relhasindex</structfield>をtrueに設定し忘れると、新しいインデックスの更新が妨げられ、インデックスの破損を引き起こす可能性がありました。␞␞     </para>␞
␝     <para>␟      Reset catalog caches at end of recovery (Noah Misch)␟リカバリの終了時にカタログキャッシュをリセットするようになりました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;a4668c99f">&sect;</ulink>␞
␝     <para>␟      This prevents scenarios wherein an in-place catalog update could be
      lost due to using stale data from a catalog cache.␟これにより、カタログキャッシュからの古いデータを使用することで、インプレイスカタログ更新が失われるシナリオが回避されます。␞␞     </para>␞
␝     <para>␟      Avoid using parallel query while holding off interrupts
      (Francesco Degrassi, Noah Misch, Tom Lane)␟割り込みを保留している間は、パラレルクエリを使用しないようになりました。
(Francesco Degrassi, Noah Misch, Tom Lane)␞␞      <ulink url="&commit_baseurl;2370582ab">&sect;</ulink>␞
␝     <para>␟      This situation cannot arise normally, but it can be reached with
      test scenarios such as using a SQL-language function as B-tree
      support (which would be far too slow for production usage).  If it
      did occur it would result in an indefinite wait.␟この状況は通常は発生しませんが、SQL言語関数をB-treeサポートとして使用するなどのテストシナリオでは発生する可能性があります（これは実稼働環境での使用には遅すぎます）。
このような状況が発生した場合、無期限の待機が発生しました。␞␞     </para>␞
␝     <para>␟      Ignore not-yet-defined Portals in
      the <structname>pg_cursors</structname> view (Tom Lane)␟<structname>pg_cursors</structname>ビューで未定義のポータルを無視するようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;3daeb539a">&sect;</ulink>␞
␝     <para>␟      It is possible for user-defined code that inspects this view to be
      called while a new cursor is being set up, and if that happens a
      null pointer dereference would ensue.  Avoid the problem by defining
      the view to exclude incompletely-set-up cursors.␟新しいカーソルの設定中に、このビューを検査するユーザ定義コードが呼び出される可能性があり、その場合NULLポインタ間接参照が発生します。
設定が不完全なカーソルを除外するようにビューを定義することでこの問題が回避されます。␞␞     </para>␞
␝     <para>␟      Avoid <quote>unexpected table_index_fetch_tuple call during logical
      decoding</quote> error while decoding a transaction involving
      insertion of a column default value (Takeshi Ideriha, Hou Zhijie)␟列のデフォルト値の挿入を含むトランザクションのデコード中に、<quote>unexpected table_index_fetch_tuple call during logical decoding</quote>エラーが発生しなくなりました。
(Takeshi Ideriha, Hou Zhijie)␞␞      <ulink url="&commit_baseurl;918107759">&sect;</ulink>␞
␝     <para>␟      Reduce memory consumption of logical decoding (Masahiko Sawada)␟ロジカルデコーディングのメモリ使用量が削減されました。
(Masahiko Sawada)␞␞      <ulink url="&commit_baseurl;eef9cc4dc">&sect;</ulink>␞
␝     <para>␟      Use a smaller default block size to store tuple data received during
      logical replication.  This reduces memory wastage, which has been
      reported to be severe while processing long-running transactions,
      even leading to out-of-memory failures.␟論理レプリケーション中に受信したタプルデータを格納するために、より小さいデフォルトブロックサイズを使用するようになりました。
これにより、メモリ不足の障害につながることもあると報告されている、長時間実行されるトランザクション処理中の深刻なメモリ浪費が削減されます。␞␞     </para>␞
␝     <para>␟      Fix behavior of stable functions called from
      a <command>CALL</command> statement's argument list, when
      the <command>CALL</command> is within a
      PL/pgSQL <literal>EXCEPTION</literal> block (Tom Lane)␟PL/pgSQLの<literal>EXCEPTION</literal>ブロック内で<command>CALL</command>文の引数リストから呼び出されるSTABLE関数の動作が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;b5eef7539">&sect;</ulink>␞
␝     <para>␟      As with a similar fix in our previous quarterly releases, this case
      allowed such functions to be passed the wrong snapshot, causing them
      to see stale values of rows modified since the start of the outer
      transaction.␟以前の四半期リリースでの同様の修正と同様に、今回のケースでは、このような関数に間違ったスナップショットが渡され、外部トランザクションの開始以降に変更された行の古い値を参照する可能性がありました。␞␞     </para>␞
␝     <para>␟      Parse <application>libpq</application>'s <literal>keepalives</literal>
      connection option in the same way as other integer-valued options
      (Yuto Sasaki)␟<application>libpq</application>の<literal>keepalives</literal>接続オプションを、他の整数値オプションと同様に解析するようになりました。
(Yuto Sasaki)␞␞      <ulink url="&commit_baseurl;c7a201053">&sect;</ulink>␞
␝     <para>␟      The coding used here rejected trailing whitespace in the option
      value, unlike other cases.  This turns out to be problematic
      in <application>ecpg</application>'s usage, for example.␟ここで使用されたコーディングでは、他の場合とは異なり、オプション値の末尾の空白文字が拒否されていました。
これは、例えば<application>ecpg</application>の使用時に問題となることが判明しました。␞␞     </para>␞
␝     <para>␟      In <application>ecpglib</application>, fix out-of-bounds read when
      parsing incorrect datetime input (Bruce Momjian, Pavel Nekrasov)␟<application>ecpglib</application>が、不正なdatetime入力を解析する際に範囲外の読み取りをしないよう修正されました。
(Bruce Momjian, Pavel Nekrasov)␞␞      <ulink url="&commit_baseurl;2c37cb26f">&sect;</ulink>␞
␝     <para>␟      It was possible to try to read the location just before the start of
      a constant array.  Real-world consequences seem minimal, though.␟定数配列の開始直前の位置を読み取ろうとする可能性がありました。
しかしながら、実世界での影響は最小限にとどまると思われます。␞␞     </para>␞
␝     <para>␟      Fix <application>psql</application>'s describe commands to again
      work with pre-9.4 servers (Tom Lane)␟<application>psql</application>のdescribeコマンドが9.4以前のサーバで再び動作するように修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;923a71584">&sect;</ulink>␞
␝     <para>␟      Commands involving display of an ACL (permissions) column failed
      with very old <productname>PostgreSQL</productname> servers, due to
      use of a function not present in those versions.␟ACL（権限）列の表示を含むコマンドは、非常に古い<productname>PostgreSQL</productname>サーバでこれらのバージョンには存在しない関数を使用していたため失敗していました。␞␞     </para>␞
␝     <para>␟      Avoid hanging if an interval less than 1ms is specified
      in <application>psql</application>'s <literal>\watch</literal>
      command (Andrey Borodin, Michael Paquier)␟<application>psql</application>の<literal>\watch</literal>コマンドで1ミリ秒未満の間隔が指定された場合のハングアップが回避されました。
(Andrey Borodin, Michael Paquier)␞␞      <ulink url="&commit_baseurl;8a6170860">&sect;</ulink>␞
␝     <para>␟      Instead, treat this the same as an interval of zero (no wait between
      executions).␟代わりに、間隔ゼロ（実行間の待ち時間なし）と同じように扱われます。␞␞     </para>␞
␝     <para>␟      Fix failure to find replication password
      in <filename>~/.pgpass</filename> (Tom Lane)␟<filename>~/.pgpass</filename>でレプリケーションパスワードが見つからない問題が修正されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;e2a912909">&sect;</ulink>␞
␝     <para>␟      <application>pg_basebackup</application>
      and <application>pg_receivewal</application> failed to match an entry
      in <filename>~/.pgpass</filename> that
      had <literal>replication</literal> in the database name field, if
      no <option>-d</option> or <option>--dbname</option> switch was
      supplied.  This resulted in an unexpected prompt for password.␟<application>pg_basebackup</application>と<application>pg_receivewal</application>は、<option>-d</option>または<option>--dbname</option>スイッチが指定されていない場合、データベース名フィールドに<literal>replication</literal>を含む<filename>~/.pgpass</filename>のエントリとの一致に失敗していました。
その結果、予期しないパスワードプロンプトが表示されていました。␞␞     </para>␞
␝     <para>␟      In <application>pg_combinebackup</application>, throw an error if an
      incremental backup file is present in a directory that is supposed to
      contain a full backup (Robert Haas)␟<application>pg_combinebackup</application>で、フルバックアップが格納されているディレクトリに増分バックアップファイルが存在する場合、エラーを発生するよう修正されました。
(Robert Haas)␞␞      <ulink url="&commit_baseurl;e36711442">&sect;</ulink>␞
␝     <para>␟      In <application>pg_combinebackup</application>, don't construct
      filenames containing double slashes (Robert Haas)␟<application>pg_combinebackup</application>で、二重スラッシュを含むファイル名を作成しなくなりました。
(Robert Haas)␞␞      <ulink url="&commit_baseurl;0d635b615">&sect;</ulink>␞
␝     <para>␟      This caused no functional problems, but the duplicate slashes were
      visible in error messages, which could create confusion.␟これにより機能的な問題は発生しませんでしたが、重複したスラッシュがエラーメッセージに表示されるため、混乱が生じる可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid trying to reindex temporary tables and indexes
      in <application>vacuumdb</application> and in
      parallel <application>reindexdb</application> (VaibhaveS, Michael
      Paquier, Fujii Masao, Nathan Bossart)␟<application>vacuumdb</application>およびパラレル<application>reindexdb</application>において、一時テーブルとインデックスのインデックス再構築を試みないようになりました。
(VaibhaveS, Michael Paquier, Fujii Masao, Nathan Bossart)␞␞      <ulink url="&commit_baseurl;85cb21df6">&sect;</ulink>␞
␝     <para>␟      Reindexing other sessions' temporary tables cannot work, but the
      check to skip them was missing in some code paths, leading to
      unwanted failures.␟他のセッションの一時テーブルのインデックス再構築は機能しませんが、一部のコードパスでそれらをスキップするチェックが欠落していたため、不要な障害が発生していました。␞␞     </para>␞
␝     <para>␟      Fix incorrect LLVM-generated code on ARM64 platforms (Thomas
      Munro, Anthonin Bonnefoy)␟ARM64プラットフォームでLLVMが生成するコードの誤りが修正されました。
(Thomas Munro, Anthonin Bonnefoy)␞␞      <ulink url="&commit_baseurl;b7467ab71">&sect;</ulink>␞
␝     <para>␟      When using JIT compilation on ARM platforms, the generated code
      could not support relocation distances exceeding 32 bits, allowing
      unlucky placement of generated code to cause server crashes on
      large-memory systems.␟ARMプラットフォームでJITコンパイルを使用する場合、生成されたコードは32ビットを超える再配置距離をサポートできず、生成されたコードの配置ミスにより、大容量メモリシステムでサーバクラッシュが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix a few places that assumed that process start time (represented
      as a <type>time_t</type>) will fit into a <type>long</type> value
      (Max Johnson, Nathan Bossart)␟<type>time_t</type>として表現されるプロセス開始時刻が<type>long</type>値に収まると想定していたいくつかの個所が修正されました。
(Max Johnson, Nathan Bossart)␞␞      <ulink url="&commit_baseurl;a356d23fd">&sect;</ulink>␞
␝     <para>␟      On platforms where <type>long</type> is 32 bits (notably Windows),
      this coding would fail after Y2038.  Most of the failures appear
      only cosmetic, but notably <literal>pg_ctl start</literal> would
      hang.␟<type>long</type>が32ビットのプラットフォーム（特にWindows）では、このコーディングは2038年以降で失敗します。
ほとんどの失敗は表面的な問題にすぎませんが、特に<literal>pg_ctl start</literal>がハングする可能性がありました。␞␞     </para>␞
␝     <para>␟      Update time zone data files to <application>tzdata</application>
      release 2024b (Tom Lane)␟タイムゾーンデータファイルを<application>tzdata</application>リリース2024bに更新しました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;cad65907e">&sect;</ulink>␞
␝     <para>␟      This <application>tzdata</application> release changes the old
      System-V-compatibility zone names to duplicate the corresponding
      geographic zones; for example <literal>PST8PDT</literal> is now an
      alias for <literal>America/Los_Angeles</literal>.  The main visible
      consequence is that for timestamps before the introduction of
      standardized time zones, the zone is considered to represent local
      mean solar time for the named location.  For example,
      in <literal>PST8PDT</literal>, <type>timestamptz</type> input such
      as <literal>1801-01-01 00:00</literal> would previously have been
      rendered as <literal>1801-01-01 00:00:00-08</literal>, but now it is
      rendered as <literal>1801-01-01 00:00:00-07:52:58</literal>.␟この<application>tzdata</application>リリースでは、古いSystem-V互換性ゾーン名を変更して、対応する地理的ゾーンを複製します。
例えば<literal>PST8PDT</literal>は<literal>America/Los_Angeles</literal>の別名になります。
目に見える主な結果は、標準化されたタイムゾーンが導入される前のタイムスタンプの場合、そのゾーンは指定された場所のローカル平均太陽時を表すと見なされることです。
例えば<literal>PST8PDT</literal>では、<type>timestamptz</type>の入力値<literal>1801-01-01 00:00</literal>は、以前は<literal>1801-01-01 00:00:00-08</literal>としてレンダリングされていましたが、現在は<literal>1801-01-01 00:00:00-07:52:58</literal>としてレンダリングされます。␞␞     </para>␞
␝     <para>␟      Also, historical corrections for Mexico, Mongolia, and Portugal.
      Notably, <literal>Asia/Choibalsan</literal> is now an alias
      for <literal>Asia/Ulaanbaatar</literal> rather than being a separate
      zone, mainly because the differences between those zones were found to
      be based on untrustworthy data.␟また、メキシコ、モンゴル、ポルトガルの歴史的修正がおこなわれています。
特に、<literal>Asia/Choibalsan</literal>は現在、独立したゾーンではなく、<literal>Asia/Ulaanbaatar</literal>の別名となっています。
これは主に、これらのゾーン間の違いが信頼できないデータに基づいていることが判明したためです。␞␞     </para>␞
␝ <sect1 id="release-17">␟  <title>Release 17</title>␟  <title>リリース17</title>␞␞␞
␝  <formalpara>␟   <title>Release date:</title>␟   <title>リリース日:</title>␞␞   <para>2024-09-26</para>␞
␝  <sect2 id="release-17-highlights">␟   <title>Overview</title>␟   <title>概要</title>␞␞␞
␝   <para>␟    <productname>PostgreSQL</productname> 17 contains many new features
    and enhancements, including:␟<productname>PostgreSQL</productname> 17には、以下をはじめとする多数の新機能と拡張が含まれています。␞␞   </para>␞
␝     <para>␟      New memory management system for <command>VACUUM</command>, which reduces
      memory consumption and can improve overall vacuuming performance.␟<command>VACUUM</command>の新しいメモリ管理システムにより、メモリ消費量が削減され、バキューム処理全体のパフォーマンスが向上しました。␞␞     </para>␞
␝     <para>␟      New <acronym>SQL/JSON</acronym> capabilities, including constructors,
      identity functions, and the <link
      linkend="functions-sqljson-table"><function>JSON_TABLE()</function></link>
      function, which converts JSON data into a table representation.␟コンストラクタ、ID関数、JSONデータをテーブル表現に変換する<link linkend="functions-sqljson-table"><function>JSON_TABLE()</function></link>関数を含む新しい<acronym>SQL/JSON</acronym>機能。␞␞     </para>␞
␝     <para>␟      Various query performance improvements, including for sequential reads
      using streaming I/O, write throughput under high concurrency, and
      searches over multiple values in a <link linkend="btree">btree</link>
      index.␟ストリーミングI/Oを使用したシーケンシャルリード、高い同時実行時の書き込みスループット、<link linkend="btree">btree</link>インデックス内の複数の値の検索など、さまざまなクエリ性能が向上しました。␞␞     </para>␞
␝     <para>␟      Logical replication enhancements, including:␟下記の論理レプリケーションの強化␞␞      <itemizedlist>␞
␝        <para>␟         Failover control␟フェイルオーバー制御␞␞        </para>␞
␝        <para>␟         <link
          linkend="app-pgcreatesubscriber"><application>pg_createsubscriber</application></link>,
          a utility that creates logical replicas from physical standbys␟物理スタンバイから論理レプリカを作成する<link linkend="app-pgcreatesubscriber"><application>pg_createsubscriber</application></link>ユーティリティ␞␞        </para>␞
␝        <para>␟         <link
          linkend="pgupgrade"><application>pg_upgrade</application></link> now
          preserves logical replication slots on publishers and full
          subscription state on subscribers.  This will allow upgrades
          to future major versions to continue logical replication without
          requiring copy to resynchronize.␟<link linkend="pgupgrade"><application>pg_upgrade</application></link>は、パブリッシャー側の論理レプリケーションスロットと、サブスクライバー側の完全なサブスクリプション状態を保持するようになりました。
これにより、将来のメジャーバージョンへのアップグレードでコピーの再同期を必要とせずに論理レプリケーションを継続できるようになります。␞␞        </para>␞
␝     <para>␟      New client-side connection option, <link
      linkend="libpq-connect-sslnegotiation"><literal>sslnegotiation=direct</literal></link>,
      that performs a direct TLS handshake to avoid a round-trip negotiation.␟新しいクライアント側コネクションオプション<link linkend="libpq-connect-sslnegotiation"><literal>sslnegotiation=direct</literal></link>は、ラウンドトリップネゴシエーションを回避するために直接TLSハンドシェイクを実行します。␞␞     </para>␞
␝     <para>␟      <link
       linkend="app-pgbasebackup"><application>pg_basebackup</application></link>
      now supports incremental backup.␟<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>が増分バックアップをサポートするようになりました。␞␞     </para>␞
␝     <para>␟      <link linkend="sql-copy"><command>COPY</command></link> adds a new option,
      <literal>ON_ERROR ignore</literal>, that allows a copy operation to
      continue in the event of an error.␟<link linkend="sql-copy"><command>COPY</command></link>に、エラーが発生した場合でもコピー操作を継続できるようになる新しいオプション<literal>ON_ERROR ignore</literal>が追加されました。␞␞     </para>␞
␝   <para>␟    The above items and other new features of
    <productname>PostgreSQL</productname> 17 are explained in more detail
    in the sections below.␟<productname>PostgreSQL</productname> 17の上記の項目とその他の新機能は次節でより詳しく説明されます。␞␞   </para>␞
␝␟   <title>Migration to Version 17</title>␟   <title>バージョン17への移行</title>␞␞␞
␝   <para>␟    A dump/restore using <xref linkend="app-pg-dumpall"/> or use of
    <xref linkend="pgupgrade"/> or logical replication is required for
    those wishing to migrate data from any previous release.  See <xref
    linkend="upgrading"/> for general information on migrating to new
    major releases.␟以前のリリースからデータを移行したい時は、どのリリースについても、<xref linkend="app-pg-dumpall"/>を利用したダンプとリストア、あるいは<xref linkend="pgupgrade"/>や論理レプリケーションの使用が必要です。
新たなメジャーバージョンへの移行に関する一般的な情報については<xref linkend="upgrading"/>を参照してください。␞␞   </para>␞
␝   <para>␟    Version 17 contains a number of changes that may affect compatibility
    with previous releases.  Observe the following incompatibilities:␟バージョン17には、以前のバージョンとの互換性に影響するかもしれない多数の変更点が含まれています。
以下の非互換性に注意してください。␞␞   </para>␞
␝     <para>␟     Change functions to use a safe <xref linkend="guc-search-path"/>
     during maintenance operations (Jeff Davis)␟メンテナンス操作中、関数は安全な<xref linkend="guc-search-path"/>を使用するよう変更されました。
(Jeff Davis)␞␞     <ulink url="&commit_baseurl;2af07e2f7">&sect;</ulink>␞
␝     <para>␟     This prevents maintenance operations (<command>ANALYZE</command>,
     <command>CLUSTER</command>, <command>CREATE
     INDEX</command>, <command>CREATE
     MATERIALIZED VIEW</command>, <command>REFRESH
     MATERIALIZED VIEW</command>, <command>REINDEX</command>,
     or <command>VACUUM</command>) from performing unsafe access.
     Functions used by expression indexes and materialized views that
     need to reference non-default schemas must specify a search path
     during function creation.␟これにより、メンテナンス操作(<command>ANALYZE</command>、<command>CLUSTER</command>、<command>CREATE INDEX</command>、<command>CREATE MATERIALIZED VIEW</command>、<command>REFRESH MATERIALIZED VIEW</command>、<command>REINDEX</command>、<command>VACUUM</command>)が安全でないアクセスを実行するのを防ぎます。
デフォルト以外のスキーマを参照する必要がある式インデックスおよびマテリアライズドビューで使用される関数は、関数の作成時に検索パスを指定する必要があります。␞␞     </para>␞
␝     <para>␟     Restrict <literal>ago</literal> to only appear at the end in
     <type>interval</type> values (Joseph Koshakow)␟<literal>ago</literal>が<type>interval</type>型の値の最後にのみ表示されるよう制限されました。
(Joseph Koshakow)␞␞     <ulink url="&commit_baseurl;165d581f1">&sect;</ulink>␞
␝     <para>␟     Also, prevent empty interval units from appearing multiple times.␟また、空のinterval型ユニットが複数回表示されないようにしました。␞␞     </para>␞
␝     <para>␟     Remove server variable old_snapshot_threshold (Thomas Munro)␟サーバパラメータold_snapshot_thresholdが廃止されました。
(Thomas Munro)␞␞     <ulink url="&commit_baseurl;f691f5b80">&sect;</ulink>␞
␝     <para>␟     This variable allowed vacuum to remove rows that potentially could
     be still visible to running transactions, causing "snapshot too
     old" errors later if accessed.  This feature might be re-added
     to <application>PostgreSQL</application> later if an improved
     implementation is found.␟この変数により、実行中のトランザクションからまだ見えている可能性のある行をバキュームで削除することができ、後でアクセスすると「snapshot too old」というエラーが発生しました。
この機能は、改善された実装が見つかった場合、後で<application>PostgreSQL</application>に再度追加される可能性があります。␞␞     </para>␞
␝     <para>␟     Change <link linkend="sql-set-session-authorization"><command>SET
     SESSION AUTHORIZATION</command></link> handling of the initial
     session user's superuser status (Joseph Koshakow)␟初期セッションユーザのスーパーユーザ状態に関する<link linkend="sql-set-session-authorization"><command>SET SESSION AUTHORIZATION</command></link>処理が変更されました。
(Joseph Koshakow)␞␞     <ulink url="&commit_baseurl;a0363ab7a">&sect;</ulink>␞
␝     <para>␟     The new behavior is based on the session user's superuser status at
     the time the <command>SET SESSION AUTHORIZATION</command> command
     is issued, rather than their superuser status at connection time.␟新しい動作は、接続時のスーパーユーザ状態ではなく、<command>SET SESSION AUTHORIZATION</command>コマンドが発行された時点のセッションユーザのスーパーユーザ状態に基づきます。␞␞     </para>␞
␝     <para>␟     Remove feature which simulated per-database users (Nathan Bossart)␟データベースごとのユーザをシミュレートする機能が削除されました。
(Nathan Bossart)␞␞     <ulink url="&commit_baseurl;884eee5bf">&sect;</ulink>␞
␝     <para>␟     The feature, <literal>db_user_namespace</literal>, was rarely used.␟<literal>db_user_namespace</literal>機能はほとんど使用されませんでした。␞␞     </para>␞
␝      <para>␟      Remove <application>adminpack</application> contrib extension
      (Daniel Gustafsson)␟<application>adminpack</application>contrib拡張が削除されました。
(Daniel Gustafsson)␞␞      <ulink url="&commit_baseurl;cc09e6549">&sect;</ulink>␞
␝      <para>␟      This was used by now end-of-life <productname>pgAdmin
      III</productname>.␟これは、現在はサポートが終了した<productname>pgAdmin III</productname>で使用されていました。␞␞      </para>␞
␝     <para>␟     Remove <xref linkend="guc-wal-sync-method"/> value
     <literal>fsync_writethrough</literal> on <systemitem
     class="osname">Windows</systemitem> (Thomas Munro)␟<systemitem class="osname">Windows</systemitem>の<xref linkend="guc-wal-sync-method"/>の値<literal>fsync_writethrough</literal>が削除されました。
(Thomas Munro)␞␞     <ulink url="&commit_baseurl;d0c28601e">&sect;</ulink>␞
␝     <para>␟     This value was the same as <literal>fsync</literal> on <systemitem
     class="osname">Windows</systemitem>.␟この値は、<systemitem class="osname">Windows</systemitem>の<literal>fsync</literal>と同じでした。␞␞     </para>␞
␝     <para>␟     Change file boundary handling of two <acronym>WAL</acronym> file
     name functions (Kyotaro Horiguchi, Andres Freund, Bruce Momjian)␟2つの<acronym>WAL</acronym>ファイル名関数のファイル境界処理が変更されました。
(Kyotaro Horiguchi, Andres Freund, Bruce Momjian)␞␞     <ulink url="&commit_baseurl;344afc776">&sect;</ulink>␞
␝     <para>␟     The functions <link
     linkend="functions-admin-backup-table"><function>pg_walfile_name()</function></link>
     and <function>pg_walfile_name_offset()</function> used to report
     the previous <acronym>LSN</acronym> segment number when the
     <acronym>LSN</acronym> was on a file segment boundary;  it now
     returns the current <acronym>LSN</acronym> segment.␟<link linkend="functions-admin-backup-table"><function>pg_walfile_name()</function></link>関数と<function>pg_walfile_name_offset()</function>関数は、<acronym>LSN</acronym>がファイルセグメント境界上にある場合、以前の<acronym>LSN</acronym>セグメント番号を報告していましたが、今は現在の<acronym>LSN</acronym>セグメントを返すようになりました。␞␞     </para>␞
␝     <para>␟     Remove server variable <literal>trace_recovery_messages</literal>
     since it is no longer needed (Bharath Rupireddy)␟サーバパラメータ<literal>trace_recovery_messages</literal>は不要になったので廃止されました。
(Bharath Rupireddy)␞␞     <ulink url="&commit_baseurl;c7a3e6b46">&sect;</ulink>␞
␝     <para>␟     Remove <link
     linkend="information-schema">information schema</link> column
     <structname>element_types</structname>.<structfield>domain_default</structfield>
     (Peter Eisentraut)␟<link linkend="information-schema">情報スキーマ</link>列の<structname>element_types</structname>.<structfield>domain_default</structfield>が削除されました。
(Peter Eisentraut)␞␞     <ulink url="&commit_baseurl;78806a950">&sect;</ulink>␞
␝     <para>␟     Change <application><xref linkend="pgrowlocks"/></application>
     lock mode output labels (Bruce Momjian)␟<application><xref linkend="pgrowlocks"/></application>のロックモードの出力ラベルが変更されました。
(Bruce Momjian)␞␞     <ulink url="&commit_baseurl;15d5d7405">&sect;</ulink>␞
␝     <para>␟     Remove <structfield>buffers_backend</structfield> and
     <structfield>buffers_backend_fsync</structfield> from <link
     linkend="monitoring-pg-stat-bgwriter-view"><structname>pg_stat_bgwriter</structname></link>
     (Bharath Rupireddy)␟<link linkend="monitoring-pg-stat-bgwriter-view"><structname>pg_stat_bgwriter</structname></link>ビューから<structfield>buffers_backend</structfield>列と<structfield>buffers_backend_fsync</structfield>列が削除されました。
(Bharath Rupireddy)␞␞     <ulink url="&commit_baseurl;74604a37f">&sect;</ulink>␞
␝     <para>␟     These fields are considered redundant to similar columns in <link
     linkend="monitoring-pg-stat-io-view"><structname>pg_stat_io</structname></link>.␟これらのフィールドは、<link linkend="monitoring-pg-stat-io-view"><structname>pg_stat_io</structname></link>ビューの同様の列と重複していると見なされました。␞␞     </para>␞
␝     <para>␟     Rename I/O block read/write timing statistics columns of
     <application><xref linkend="pgstatstatements"/></application>
     (Nazir Bilal Yavuz)␟<application><xref linkend="pgstatstatements"/></application>のI/Oブロック読み取り/書き込みタイミング統計列の名前が変更されました。
(Nazir Bilal Yavuz)␞␞     <ulink url="&commit_baseurl;13d00729d">&sect;</ulink>␞
␝     <para>␟     This renames <structfield>blk_read_time</structfield>
     to <structfield>shared_blk_read_time</structfield>,
     and <structfield>blk_write_time</structfield> to
     <structfield>shared_blk_write_time</structfield>.␟これにより、<structfield>blk_read_time</structfield>が<structfield>shared_blk_read_time</structfield>に、<structfield>blk_write_time</structfield>が<structfield>shared_blk_write_time</structfield>に名前が変更されました。␞␞     </para>␞
␝     <para>␟     Change <link
     linkend="catalog-pg-attribute"><structname>pg_attribute</structname>.<structfield>attstattarget</structfield></link>
     and
     <structname>pg_statistic_ext</structname>.<structfield>stxstattarget</structfield>
     to represent the default statistics target as <literal>NULL</literal>
     (Peter Eisentraut)␟<link linkend="catalog-pg-attribute"><structname>pg_attribute</structname>.<structfield>attstattarget</structfield></link>と<structname>pg_statistic_ext</structname>.<structfield>stxstattarget</structfield>が変更され、デフォルトの統計ターゲットを<literal>NULL</literal>として表すようになりました。
(Peter Eisentraut)␞␞     <ulink url="&commit_baseurl;4f622503d">&sect;</ulink>␞
␝     <para>␟     Rename <link
     linkend="catalog-pg-collation"><structname>pg_collation</structname>.<structfield>colliculocale</structfield></link>
     to <structfield>colllocale</structfield> and
     <link linkend="catalog-pg-database"><structname>pg_database</structname>.<structfield>daticulocale</structfield></link>
     to <structfield>datlocale</structfield> (Jeff Davis)␟<link linkend="catalog-pg-collation"><structname>pg_collation</structname>.<structfield>colliculocale</structfield></link>列の名前が<structfield>colllocale</structfield>に、<link linkend="catalog-pg-database"><structname>pg_database</structname>.<structfield>daticulocale</structfield></link>列の名前が<structfield>datlocale</structfield>に変更されました。
(Jeff Davis)␞␞     <ulink url="&commit_baseurl;f696c0cd5">&sect;</ulink>␞
␝     <para>␟     Rename <link
     linkend="vacuum-progress-reporting"><structname>pg_stat_progress_vacuum</structname></link>
     column <structfield>max_dead_tuples</structfield>
     to <structfield>max_dead_tuple_bytes</structfield>,
     rename <structfield>num_dead_tuples</structfield> to
     <structfield>num_dead_item_ids</structfield>, and add
     <structfield>dead_tuple_bytes</structfield> (Masahiko Sawada)␟<link linkend="vacuum-progress-reporting"><structname>pg_stat_progress_vacuum</structname></link>ビューの<structfield>max_dead_tuples</structfield>列の名前を<structfield>max_dead_tuple_bytes</structfield>に変更し、<structfield>num_dead_tuples</structfield>列の名前を<structfield>num_dead_item_ids</structfield>に変更し、<structfield>dead_tuple_bytes</structfield>列が追加されました。
(Masahiko Sawada)␞␞     <ulink url="&commit_baseurl;667e65aac">&sect;</ulink>␞
␝     <para>␟     Rename <acronym>SLRU</acronym> columns in system view <link
     linkend="monitoring-pg-stat-slru-view"><structname>pg_stat_slru</structname></link>
     (Alvaro Herrera)␟システムビュー<link linkend="monitoring-pg-stat-slru-view"><structname>pg_stat_slru</structname></link>の<acronym>SLRU</acronym>列の名前が変更されました。
(Alvaro Herrera)␞␞     <ulink url="&commit_baseurl;bcdfa5f2e">&sect;</ulink>␞
␝     <para>␟     The column names accepted by <link
     linkend="monitoring-stats-funcs-table"><function>pg_stat_reset_slru()</function></link>
     are also changed.␟<link linkend="monitoring-stats-funcs-table"><function>pg_stat_reset_slru()</function></link>関数で受け付ける列名も変更されました。␞␞     </para>␞
␝  <sect2 id="release-17-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝    <para>␟     Below you will find a detailed account of the changes between
    <productname>PostgreSQL</productname> 17 and the previous major
    release.␟<productname>PostgreSQL</productname> 17と前メジャーリリースとの詳細な変更点を記載しました。␞␞    </para>␞
␝   <sect3 id="release-17-server">␟    <title>Server</title>␟    <title>サーバ</title>␞␞␞
␝    <sect4 id="release-17-optimizer">␟     <title>Optimizer</title>␟     <title>オプティマイザ</title>␞␞␞
␝       <para>␟       Allow the optimizer to improve <acronym>CTE</acronym> plans by
       considering the statistics and sort order of columns referenced in earlier row
       output clauses (Jian Guo, Richard Guo, Tom Lane)␟オプティマイザが以前の行出力句で参照され列の統計情報とソート順序を考慮することで、<acronym>CTE</acronym>実行計画を改善できるようになりました。
(Jian Guo, Richard Guo, Tom Lane)␞␞       <ulink url="&commit_baseurl;f7816aec2">&sect;</ulink>␞
␝       <para>␟       Improve optimization of <literal>IS NOT NULL</literal> and
       <literal>IS NULL</literal> query restrictions (David Rowley,
       Richard Guo, Andy Fan)␟問い合わせの<literal>IS NOT NULL</literal>および<literal>IS NULL</literal>制限による最適化が改善されました。
(David Rowley, Richard Guo, Andy Fan)␞␞       <ulink url="&commit_baseurl;b262ad440">&sect;</ulink>␞
␝       <para>␟       Remove <literal>IS NOT NULL</literal> restrictions from queries on
       <literal>NOT NULL</literal> columns and eliminate scans on
       <literal>NOT NULL</literal> columns if <literal>IS NULL</literal>
       is specified.␟<literal>NOT NULL</literal>列の問い合わせから<literal>IS NOT NULL</literal>制限を削除し、<literal>IS NULL</literal>が指定されている場合、<literal>NOT NULL</literal>列のスキャンを削除します。␞␞       </para>␞
␝       <para>␟       Allow partition pruning on boolean columns on <literal>IS [NOT]
       UNKNOWN</literal> conditionals (David Rowley)␟<literal>IS [NOT] UNKNOWN</literal>条件のboolean列でパーティション除去が可能になりました。
(David Rowley)␞␞       <ulink url="&commit_baseurl;07c36c133">&sect;</ulink>␞
␝       <para>␟       Improve optimization of range values when using containment
       operators &lt;@ and @&gt; (Kim Johan Andersson, Jian He)␟包含演算子&lt;@および@&gt;を使用する場合の範囲値の最適化が改善されました。
(Kim Johan Andersson, Jian He)␞␞       <ulink url="&commit_baseurl;075df6b20">&sect;</ulink>␞
␝       <para>␟       Allow correlated <literal>IN</literal> subqueries to be transformed
       into joins (Andy Fan, Tom Lane)␟相関のある<literal>IN</literal>副問い合わせを結合に変換できるようになりました。
(Andy Fan, Tom Lane)␞␞       <ulink url="&commit_baseurl;9f1337639">&sect;</ulink>␞
␝       <para>␟       Improve optimization of the <literal>LIMIT</literal> clause
       on partitioned tables, inheritance parents, and <literal>UNION
       ALL</literal> queries (Andy Fan, David Rowley)␟パーティションテーブル、継承の親テーブル、および<literal>UNION ALL</literal>問い合わせの<literal>LIMIT</literal>句の最適化が改善されました。
(Andy Fan, David Rowley)␞␞       <ulink url="&commit_baseurl;a8a968a82">&sect;</ulink>␞
␝       <para>␟       Allow query nodes to be run in parallel in more cases (Tom Lane)␟より多くの場合に問い合わせノードを並列で実行できるようになりました。
(Tom Lane)␞␞       <ulink url="&commit_baseurl;e08d74ca1">&sect;</ulink>␞
␝       <para>␟       Allow <literal>GROUP BY</literal> columns to be internally
       ordered to match <literal>ORDER BY</literal> (Andrei Lepikhov,
       Teodor Sigaev)␟<literal>GROUP BY</literal>列を内部的に<literal>ORDER BY</literal>と一致するように並べ替えできるようになりました。
(Andrei Lepikhov, Teodor Sigaev)␞␞       <ulink url="&commit_baseurl;0452b461b">&sect;</ulink>␞
␝       <para>␟       This can be disabled using server variable
       <xref linkend="guc-enable-groupby-reordering"/>.␟これは、サーバパラメータ<xref linkend="guc-enable-groupby-reordering"/>を使用して無効にできます。␞␞       </para>␞
␝       <para>␟       Allow <literal>UNION</literal> (without <literal>ALL</literal>)
       to use MergeAppend (David Rowley)␟<literal>ALL</literal>を使用しない<literal>UNION</literal>でMergeAppendが使用できるようになりました。
(David Rowley)␞␞       <ulink url="&commit_baseurl;66c0185a3">&sect;</ulink>␞
␝       <para>␟       Fix MergeAppend plans to more accurately compute the number of
       rows that need to be sorted (Alexander Kuzmenkov)␟ソートする必要がある行数をより正確に計算するようにMergeAppendプランが修正されました。
(Alexander Kuzmenkov)␞␞       <ulink url="&commit_baseurl;9d1a5354f">&sect;</ulink>␞
␝       <para>␟       Allow  <link linkend="gist">GiST</link> and <link
       linkend="spgist">SP-GiST</link> indexes to be part of incremental
       sorts (Miroslav Bendik)␟<link linkend="gist">GiST</link>および<link linkend="spgist">SP-GiST</link>インデックスがインクリメンタルソートの一部にすることができるようになりました。
(Miroslav Bendik)␞␞       <ulink url="&commit_baseurl;625d5b3ca">&sect;</ulink>␞
␝       <para>␟       This is particularly useful for <literal>ORDER BY</literal>
       clauses where the first column has a GiST and SP-GiST index,
       and other columns do not.␟これは、最初の列にGiSTおよびSP-GiSTインデックスがあり、他の列にはない場合の<literal>ORDER BY</literal>句に特に有用です。␞␞       </para>␞
␝       <para>␟       Add columns to <link
       linkend="view-pg-stats"><structname>pg_stats</structname></link>
       to report range-type histogram information (Egor Rogov, Soumyadeep
       Chakraborty)␟範囲型のヒストグラム情報を報告するために<link linkend="view-pg-stats"><structname>pg_stats</structname></link>ビューに列が追加されました。
(Egor Rogov, Soumyadeep Chakraborty)␞␞       <ulink url="&commit_baseurl;bc3c8db8a">&sect;</ulink>␞
␝    <sect4 id="release-17-indexes">␟     <title>Indexes</title>␟     <title>インデックス</title>␞␞␞
␝       <para>␟       Allow <link linkend="btree">btree</link> indexes to more
       efficiently find a set of values, such as those supplied by
       <literal>IN</literal> clauses using constants (Peter Geoghegan,
       Matthias van de Meent)␟<link linkend="btree">btree</link>インデックスが、定数を使用して<literal>IN</literal>句で提供される値の集合をより効率的に見つけられるようになりました。
(Peter Geoghegan, Matthias van de Meent)␞␞       <ulink url="&commit_baseurl;5bf748b86">&sect;</ulink>␞
␝       <para>␟       Allow <link linkend="brin"><acronym>BRIN</acronym></link> indexes
       to be created using parallel workers (Tomas Vondra, Matthias van
       de Meent)␟並列ワーカーを使用して<link linkend="brin"><acronym>BRIN</acronym></link>インデックスを作成できるようになりました。
(Tomas Vondra, Matthias van de Meent)␞␞       <ulink url="&commit_baseurl;b43757171">&sect;</ulink>␞
␝    <sect4 id="release-17-performance">␟     <title>General Performance</title>␟     <title>性能一般</title>␞␞␞
␝       <para>␟       Allow vacuum to more efficiently remove and freeze tuples (Melanie
       Plageman, Heikki Linnakangas)␟バキュームがより効率的にタプルを削除しフリーズできるようになりました。
(Melanie Plageman, Heikki Linnakangas)␞␞       <ulink url="&commit_baseurl;6dbb49026">&sect;</ulink>␞
␝       <para>␟       <acronym>WAL</acronym> traffic caused by vacuum is also more
       compact.␟バキュームによって発生する<acronym>WAL</acronym>トラフィックもよりコンパクトになりました。␞␞       </para>␞
␝       <para>␟       Allow vacuum to more efficiently store tuple references (Masahiko
       Sawada, John Naylor)␟バキュームがタプル参照をより効率的に格納できるようになりました。
(Masahiko Sawada, John Naylor)␞␞       <ulink url="&commit_baseurl;ee1b30f12">&sect;</ulink>␞
␝       <para>␟       Additionally, vacuum is no longer silently limited to one gigabyte
       of memory when <xref linkend="guc-maintenance-work-mem"/> or <xref
       linkend="guc-autovacuum-work-mem"/> are higher.␟さらに、<xref linkend="guc-maintenance-work-mem"/>や<xref linkend="guc-autovacuum-work-mem"/>がより大きくても、バキュームが暗黙的に1ギガバイトのメモリに制限しなくなりました。␞␞       </para>␞
␝       <para>␟       Optimize vacuuming of relations with no indexes (Melanie Plageman)␟インデックスを持たないリレーションのバキューム処理が最適化されました。
(Melanie Plageman)␞␞       <ulink url="&commit_baseurl;c120550ed">&sect;</ulink>␞
␝       <para>␟       Increase default <xref linkend="guc-vacuum-buffer-usage-limit"/>
       to 2MB (Thomas Munro)␟<xref linkend="guc-vacuum-buffer-usage-limit"/>のデフォルトが2メガバイトに増やされました。
(Thomas Munro)␞␞       <ulink url="&commit_baseurl;98f320eb2">&sect;</ulink>␞
␝       <para>␟       Improve performance when checking roles with many memberships
       (Nathan Bossart)␟多数のメンバシップを持つロールをチェックするパフォーマンスが改善されました。
(Nathan Bossart)␞␞       <ulink url="&commit_baseurl;d365ae705">&sect;</ulink>␞
␝       <para>␟       Improve performance of heavily-contended <acronym>WAL</acronym>
       writes (Bharath Rupireddy)␟競合の激しい<acronym>WAL</acronym>書き込みのパフォーマンスが改善されました。
(Bharath Rupireddy)␞␞       <ulink url="&commit_baseurl;71e4cc6b8">&sect;</ulink>␞
␝       <para>␟       Improve performance when transferring large blocks of data to a
       client (Melih Mutlu)␟大きなデータブロックをクライアントに転送する際のパフォーマンスが改善されました。
(Melih Mutlu)␞␞       <ulink url="&commit_baseurl;c4ab7da60">&sect;</ulink>␞
␝       <para>␟       Allow the grouping of file system reads with the new system variable
       <xref linkend="guc-io-combine-limit"/> (Thomas Munro, Andres Freund,
       Melanie Plageman, Nazir Bilal Yavuz)␟新しいシステムパラメータ<xref linkend="guc-io-combine-limit"/>を使用して、ファイルシステムの読み取りグループ化ができるようになりました。
(Thomas Munro, Andres Freund, Melanie Plageman, Nazir Bilal Yavuz)␞␞       <ulink url="&commit_baseurl;210622c60">&sect;</ulink>␞
␝    <sect4 id="release-17-monitoring">␟     <title>Monitoring</title>␟     <title>監視</title>␞␞␞
␝       <para>␟       Create system view <link
       linkend="monitoring-pg-stat-checkpointer-view"><structname>pg_stat_checkpointer</structname></link>
       (Bharath Rupireddy, Anton A. Melnikov, Alexander Korotkov)␟システムビュー<link linkend="monitoring-pg-stat-checkpointer-view"><structname>pg_stat_checkpointer</structname></link>が追加されました。
(Bharath Rupireddy, Anton A. Melnikov, Alexander Korotkov)␞␞       <ulink url="&commit_baseurl;96f052613">&sect;</ulink>␞
␝       <para>␟       Relevant columns have been removed from <link
       linkend="pg-stat-bgwriter-view"><structname>pg_stat_bgwriter</structname></link>
       and added to this new system view.␟<link linkend="pg-stat-bgwriter-view"><structname>pg_stat_bgwriter</structname></link>から関連する列が削除され、この新しいシステムビューに追加されました。␞␞       </para>␞
␝       <para>␟       Improve control over resetting statistics (Atsushi Torikoshi,
       Bharath Rupireddy)␟統計情報をリセットする制御が改善されました。
(Atsushi Torikoshi, Bharath Rupireddy)␞␞       <ulink url="&commit_baseurl;23c8c0c8f">&sect;</ulink>␞
␝       <para>␟       Allow <link
       linkend="monitoring-stats-funcs-table"><function>pg_stat_reset_shared()</function></link>
       (with no arguments) and
       pg_stat_reset_shared(<literal>NULL</literal>) to reset all
       shared statistics.  Allow pg_stat_reset_shared('slru') and <link
       linkend="monitoring-stats-funcs-table"><function>pg_stat_reset_slru()</function></link>
       (with no arguments) to reset <acronym>SLRU</acronym> statistics,
       which was already possible with pg_stat_reset_slru(NULL).␟<link linkend="monitoring-stats-funcs-table"><function>pg_stat_reset_shared()</function></link>（引数なし）とpg_stat_reset_shared(<literal>NULL</literal>)を使用して、すべての共有統計情報がリセットできるようになりました。
pg_stat_reset_shared('slru')と<link linkend="monitoring-stats-funcs-table"><function>pg_stat_reset_slru()</function></link>（引数なし）を使用して、<acronym>SLRU</acronym>統計情報がリセットできるようになりました。これは、以前からpg_stat_reset_slru(NULL)で可能でした。␞␞       </para>␞
␝       <para>␟       Add log messages related to <acronym>WAL</acronym> recovery from
       backups (Andres Freund)␟バックアップからの<acronym>WAL</acronym>リカバリに関するログメッセージが追加されました。
(Andres Freund)␞␞       <ulink url="&commit_baseurl;1d35f705e">&sect;</ulink>␞
␝       <para>␟       Add <xref linkend="guc-log-connections"/> log line for
       <literal>trust</literal> connections (Jacob Champion)␟<literal>trust</literal>接続で<xref linkend="guc-log-connections"/>ログ行が出力されるようになりました。
(Jacob Champion)␞␞       <ulink url="&commit_baseurl;e48b19c5d">&sect;</ulink>␞
␝       <para>␟       Add log message to report walsender acquisition and release of
       replication slots (Bharath Rupireddy)␟walsenderによるレプリケーションスロットの取得と解放を報告するログメッセージが追加されました。
(Bharath Rupireddy)␞␞       <ulink url="&commit_baseurl;7c3fb505b">&sect;</ulink>␞
␝       <para>␟       This is enabled by the server variable <xref
       linkend="guc-log-replication-commands"/>.␟これは、サーバパラメータ<xref linkend="guc-log-replication-commands"/>によって可能になります。␞␞       </para>␞
␝       <para>␟       Add system view <link
       linkend="view-pg-wait-events"><structname>pg_wait_events</structname></link>
       that reports wait event types (Bertrand Drouvot)␟待機イベントの種類を報告するシステムビュー<link linkend="view-pg-wait-events"><structname>pg_wait_events</structname></link>が追加されました。
(Bertrand Drouvot)␞␞       <ulink url="&commit_baseurl;1e68e43d3">&sect;</ulink>␞
␝       <para>␟       This is useful for adding descriptions
       to wait events reported in <link
       linkend="monitoring-pg-stat-activity-view"><structname>pg_stat_activity</structname></link>.␟これは、<link linkend="monitoring-pg-stat-activity-view"><structname>pg_stat_activity</structname></link>で報告される待機イベントに説明を追加するのに便利です。␞␞       </para>␞
␝       <para>␟       Add <link linkend="view-pg-wait-events">wait events</link> for
       checkpoint delays (Thomas Munro)␟チェックポイント遅延を示す<link linkend="view-pg-wait-events">待機イベント</link>が追加されました。
(Thomas Munro)␞␞       <ulink url="&commit_baseurl;0013ba290">&sect;</ulink>␞
␝       <para>␟       Allow vacuum to report the progress of index processing (Sami
       Imseih)␟バキュームがインデックス処理の進行状況を報告するようになりました。
(Sami Imseih)␞␞       <ulink url="&commit_baseurl;46ebdfe16">&sect;</ulink>␞
␝       <para>␟       This appears in system view <link
       linkend="pg-stat-progress-vacuum-view"><structname>pg_stat_progress_vacuum</structname></link>
       columns <structfield>indexes_total</structfield> and
       <structfield>indexes_processed</structfield>.␟これはシステムビュー<link linkend="pg-stat-progress-vacuum-view"><structname>pg_stat_progress_vacuum</structname></link>の<structfield>indexes_total</structfield>列と<structfield>indexes_processed</structfield>列に表示されます。␞␞       </para>␞
␝    <sect4 id="release-17-privileges">␟     <title>Privileges</title>␟     <title>権限</title>␞␞␞
␝       <para>␟       Allow granting the right to perform maintenance operations
       (Nathan Bossart)␟メンテナンス操作を実行する権限の付与ができるようになりました。
(Nathan Bossart)␞␞       <ulink url="&commit_baseurl;ecb0fd337">&sect;</ulink>␞
␝       <para>␟       The permission can be granted on a per-table basis using the <link
       linkend="ddl-priv-maintain"><literal>MAINTAIN</literal></link>
       privilege and on a per-role basis via the <link
       linkend="predefined-roles"><literal>pg_maintain</literal></link>
       predefined role.  Permitted operations are
       <command>VACUUM</command>, <command>ANALYZE</command>,
       <command>REINDEX</command>, <command>REFRESH MATERIALIZED
       VIEW</command>, <command>CLUSTER</command>, and <command>LOCK
       TABLE</command>.␟この権限は、<link linkend="ddl-priv-maintain"><literal>MAINTAIN</literal></link>権限を使用してテーブルごとに付与することも、<link linkend="predefined-roles"><literal>pg_maintain</literal></link>定義済みロールを使用してロールごとに付与することもできます。
許可される操作は、<command>VACUUM</command>、<command>ANALYZE</command>、<command>REINDEX</command>、<command>REFRESH MATERIALIZED VIEW</command>、<command>CLUSTER</command>、および<command>LOCK TABLE</command>です。␞␞       </para>␞
␝       <para>␟       Allow roles with <link
       linkend="predefined-roles"><literal>pg_monitor</literal></link>
       membership to execute <link
       linkend="functions-info-session-table"><function>pg_current_logfile()</function></link>
       (Pavlo Golub, Nathan Bossart)␟<link linkend="predefined-roles"><literal>pg_monitor</literal></link>メンバシップを持つロールが<link linkend="functions-info-session-table"><function>pg_current_logfile()</function></link>を実行できるようになりました。
(Pavlo Golub, Nathan Bossart)␞␞       <ulink url="&commit_baseurl;8d8afd48d">&sect;</ulink>␞
␝    <sect4 id="release-17-server-config">␟     <title>Server Configuration</title>␟     <title>サーバ設定</title>␞␞␞
␝       <para>␟       Add system variable <xref linkend="guc-allow-alter-system"/>
       to disallow <link linkend="sql-altersystem"><command>ALTER
       SYSTEM</command></link> (Jelte Fennema-Nio, Gabriele Bartolini)␟<link linkend="sql-altersystem"><command>ALTER SYSTEM</command></link>を禁止できるシステムパラメータ<xref linkend="guc-allow-alter-system"/>が追加されました。
(Jelte Fennema-Nio, Gabriele Bartolini)␞␞       <ulink url="&commit_baseurl;d3ae2a24f">&sect;</ulink>␞
␝       <para>␟       Allow <link linkend="sql-altersystem"><command>ALTER
       SYSTEM</command></link> to set unrecognized custom server variables
       (Tom Lane)␟<link linkend="sql-altersystem"><command>ALTER SYSTEM</command></link>で認識されないカスタムサーバパラメータが設定できるようになりました。
(Tom Lane)␞␞       <ulink url="&commit_baseurl;2d870b4ae">&sect;</ulink>␞
␝       <para>␟       This is also possible with <link linkend="sql-grant"><literal>GRANT
       ON PARAMETER</literal></link>.␟<link linkend="sql-grant"><literal>GRANT ON PARAMETER</literal></link>でも設定可能です。␞␞       </para>␞
␝       <para>␟       Add server variable <xref linkend="guc-transaction-timeout"/> to
       restrict the duration of transactions (Andrey Borodin, Japin Li,
       Junwang Zhao, Alexander Korotkov)␟トランザクションの実行時間を制限するサーバパラメータ<xref linkend="guc-transaction-timeout"/>が追加されました。
(Andrey Borodin, Japin Li, Junwang Zhao, Alexander Korotkov)␞␞       <ulink url="&commit_baseurl;51efe38cb">&sect;</ulink>␞
␝       <para>␟       Add a builtin platform-independent collation provider (Jeff Davis)␟プラットフォームに依存しない組み込みの照合順序プロバイダが追加されました。
(Jeff Davis)␞␞       <ulink url="&commit_baseurl;2d819a08a">&sect;</ulink>␞
␝       <para>␟       This supports <literal>C</literal> and <literal>C.UTF-8</literal>
       collations.␟これにより、<literal>C</literal>および<literal>C.UTF-8</literal>の照合順序がサポートされます。␞␞       </para>␞
␝       <para>␟       Add server variable <xref linkend="guc-huge-pages-status"/> to
       report the use of huge pages by Postgres (Justin Pryzby)␟PostgresによるHuge Pagesの使用を報告するサーバパラメータ<xref linkend="guc-huge-pages-status"/>が追加されました。
(Justin Pryzby)␞␞       <ulink url="&commit_baseurl;a14354cac">&sect;</ulink>␞
␝       <para>␟       This is useful when <xref linkend="guc-huge-pages"/> is set to
       <literal>try</literal>.␟これは<xref linkend="guc-huge-pages"/>が<literal>try</literal>に設定されている場合に便利です。␞␞       </para>␞
␝       <para>␟       Add server variable to disable event triggers (Daniel Gustafsson)␟イベントトリガを無効にするサーバパラメータが追加されました。
(Daniel Gustafsson)␞␞       <ulink url="&commit_baseurl;7750fefdb">&sect;</ulink>␞
␝       <para>␟       The setting, <xref linkend="guc-event-triggers"/>, allows for the
       temporary disabling of event triggers for debugging.␟<xref linkend="guc-event-triggers"/>設定により、デバッグのためにイベントトリガを一時的に無効にできます。␞␞       </para>␞
␝       <para>␟       Allow the <link
       linkend="monitoring-pg-stat-slru-view"><acronym>SLRU</acronym></link>
       cache sizes to be configured (Andrey Borodin, Dilip Kumar,
       Alvaro Herrera)␟<link linkend="monitoring-pg-stat-slru-view"><acronym>SLRU</acronym></link>キャッシュサイズ設定できるようになりました。
(Andrey Borodin, Dilip Kumar, Alvaro Herrera)␞␞       <ulink url="&commit_baseurl;53c2a97a9">&sect;</ulink>␞
␝       <para>␟       The new server variables are <xref
       linkend="guc-commit-timestamp-buffers"/>,
       <xref linkend="guc-multixact-member-buffers"/>,
       <xref linkend="guc-multixact-offset-buffers"/>,
       <xref linkend="guc-notify-buffers"/>, <xref
       linkend="guc-serializable-buffers"/>, <xref
       linkend="guc-subtransaction-buffers"/>, and
       <xref linkend="guc-transaction-buffers"/>. <xref
       linkend="guc-commit-timestamp-buffers"/>, <xref
       linkend="guc-transaction-buffers"/>, and <xref
       linkend="guc-subtransaction-buffers"/> scale up automatically with
       <xref linkend="guc-shared-buffers"/>.␟新しいサーバパラメータは、<xref linkend="guc-commit-timestamp-buffers"/>、<xref linkend="guc-multixact-member-buffers"/>、<xref linkend="guc-multixact-offset-buffers"/>、<xref linkend="guc-notify-buffers"/>、<xref linkend="guc-serializable-buffers"/>、<xref linkend="guc-subtransaction-buffers"/>、<xref linkend="guc-transaction-buffers"/>です。
<xref linkend="guc-commit-timestamp-buffers"/>、<xref linkend="guc-transaction-buffers"/>、<xref linkend="guc-subtransaction-buffers"/>は<xref linkend="guc-shared-buffers"/>とともに自動的にスケールアップします。␞␞       </para>␞
␝    <sect4 id="release-17-replication">␟     <title>Streaming Replication and Recovery</title>␟     <title>ストリーミングレプリケーションとリカバリ</title>␞␞␞
␝       <para>␟       Add support for incremental file system backup (Robert Haas,
       Jakub Wartak, Tomas Vondra)␟ファイルシステムの増分バックアップがサポートされました。
(Robert Haas, Jakub Wartak, Tomas Vondra)␞␞       <ulink url="&commit_baseurl;dc2123400">&sect;</ulink>␞
␝       <para>␟       Incremental backups can be created using <link
       linkend="app-pgbasebackup"><application>pg_basebackup</application></link>'s
       new <option>--incremental</option>
       option.  The new application <link
       linkend="app-pgcombinebackup"><application>pg_combinebackup</application></link>
       allows manipulation of base and incremental file system backups.␟増分バックアップは、<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>の新しい<option>--incremental</option>オプションを使用して作成することができます。
新しい<link linkend="app-pgcombinebackup"><application>pg_combinebackup</application></link>アプリケーションでは、基本および増分のファイルシステムバックアップの操作が可能です。␞␞       </para>␞
␝       <para>␟       Allow the creation of <acronym>WAL</acronym> summarization files
       (Robert Haas, Nathan Bossart, Hubert Depesz Lubaczewski)␟<acronym>WAL</acronym>要約ファイルの作成ができるようになりました。
(Robert Haas, Nathan Bossart, Hubert Depesz Lubaczewski)␞␞       <ulink url="&commit_baseurl;174c48050">&sect;</ulink>␞
␝       <para>␟       These files record the block numbers that have changed within an
       <link linkend="datatype-pg-lsn"><acronym>LSN</acronym></link>
       range and are useful for incremental file
       system backups.  This is controlled by the server
       variables <xref linkend="guc-summarize-wal"/> and <xref
       linkend="guc-wal-summary-keep-time"/>, and introspected with <link
       linkend="functions-wal-summary"><function>pg_available_wal_summaries()</function></link>,
       <function>pg_wal_summary_contents()</function>, and
       <function>pg_get_wal_summarizer_state()</function>.␟これらのファイルは、<link linkend="datatype-pg-lsn"><acronym>LSN</acronym></link>範囲内で変更されたブロック番号を記録し、ファイルシステムの増分バックアップに役立ちます。
これは、サーバパラメータの<xref linkend="guc-summarize-wal"/>と<xref linkend="guc-wal-summary-keep-time"/>によって制御され、<link linkend="functions-wal-summary"><function>pg_available_wal_summaries()</function></link>、<function>pg_wal_summary_contents()</function>、および<function>pg_get_wal_summarizer_state()</function>によって状態を観測できます。␞␞       </para>␞
␝       <para>␟       Add the system identifier to file system <link
       linkend="backup-manifest-format">backup manifest</link> files
       (Amul Sul)␟ファイルシステムの<link linkend="backup-manifest-format">バックアップマニフェスト</link>ファイルにシステム識別子が追加されました。
(Amul Sul)␞␞       <ulink url="&commit_baseurl;2041bc427">&sect;</ulink>␞
␝       <para>␟       This helps detect invalid <acronym>WAL</acronym> usage.␟これは、無効な<acronym>WAL</acronym>の使用を検出するのに役立ちます。␞␞       </para>␞
␝       <para>␟       Allow connection string value
       <literal>dbname</literal> to be written when <link
       linkend="app-pgbasebackup"><application>pg_basebackup</application></link>
       writes connection information to
       <filename>postgresql.auto.conf</filename> (Vignesh C, Hayato Kuroda)␟<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>が<filename>postgresql.auto.conf</filename>に接続情報を書き込む時に、接続文字列値<literal>dbname</literal>が書き込まれるようになりました。
(Vignesh C, Hayato Kuroda)␞␞       <ulink url="&commit_baseurl;a145f424d">&sect;</ulink>␞
␝       <para>␟       Add column <link
       linkend="view-pg-replication-slots"><structname>pg_replication_slots</structname>.<structfield>invalidation_reason</structfield></link>
       to report the reason for invalid slots (Shveta Malik, Bharath
       Rupireddy)␟無効なスロットの理由を報告するために、<link linkend="view-pg-replication-slots"><structname>pg_replication_slots</structname>.<structfield>invalidation_reason</structfield></link>列が追加されました。
(Shveta Malik, Bharath Rupireddy)␞␞       <ulink url="&commit_baseurl;007693f2a">&sect;</ulink>␞
␝       <para>␟       Add column <link
       linkend="view-pg-replication-slots"><structname>pg_replication_slots</structname>.<structfield>inactive_since</structfield></link>
       to report slot inactivity duration (Bharath Rupireddy)␟スロットの非アクティブ期間を報告する<link linkend="view-pg-replication-slots"><structname>pg_replication_slots</structname>.<structfield>inactive_since</structfield></link>列が追加されました。
(Bharath Rupireddy)␞␞       <ulink url="&commit_baseurl;a11f330b5">&sect;</ulink>␞
␝       <para>␟       Add function <link
       linkend="functions-replication-table"><function>pg_sync_replication_slots()</function></link>
       to synchronize logical replication slots (Hou Zhijie, Shveta Malik,
       Ajin Cherian, Peter Eisentraut)␟論理レプリケーションスロットを同期させるための<link linkend="functions-replication-table"><function>pg_sync_replication_slots()</function></link>関数が追加されました。
(Hou Zhijie, Shveta Malik, Ajin Cherian, Peter Eisentraut)␞␞       <ulink url="&commit_baseurl;ddd5f4f54">&sect;</ulink>␞
␝       <para>␟       Add the <literal>failover</literal> property to the <link
       linkend="protocol-replication">replication protocol</link> (Hou
       Zhijie, Shveta Malik)␟<link linkend="protocol-replication">レプリケーションプロトコル</link>に<literal>failover</literal>プロパティが追加されました。
(Hou Zhijie, Shveta Malik)␞␞       <ulink url="&commit_baseurl;732924043">&sect;</ulink>␞
␝    <sect4 id="release-17-logical">␟     <title><link linkend="logical-replication">Logical Replication</link></title>␟     <title><link linkend="logical-replication">論理レプリケーション</link></title>␞␞␞
␝       <para>␟       Add application <link
       linkend="app-pgcreatesubscriber"><application>pg_createsubscriber</application></link>
       to create a logical replica from a physical standby server
       (Euler Taveira)␟物理的スタンバイサーバからロジカルレプリカを作成するために、<link linkend="app-pgcreatesubscriber"><application>pg_createsubscriber</application></link>アプリケーションが追加されました。
(Euler Taveira)␞␞       <ulink url="&commit_baseurl;d44032d01">&sect;</ulink>␞
␝       <para>␟       Have <link
       linkend="pgupgrade"><application>pg_upgrade</application></link>
       migrate valid logical slots and subscriptions (Hayato Kuroda,
       Hou Zhijie, Vignesh C, Julien Rouhaud, Shlok Kyal)␟<link linkend="pgupgrade"><application>pg_upgrade</application></link>に有効なロジカルスロットとサブスクリプションを移行させます。
(Hayato Kuroda, Hou Zhijie, Vignesh C, Julien Rouhaud, Shlok Kyal)␞␞       <ulink url="&commit_baseurl;29d0a77fa">&sect;</ulink>␞
␝       <para>␟       This allows logical replication to continue
       quickly after the upgrade.  This only works for old
       <productname>PostgreSQL</productname> clusters that are version
       17 or later.␟これにより、アップグレードの後に論理レプリケーションをすぐに続行できます。
これは、バージョン17以降の古いクラスタにのみ機能します。
<productname>PostgreSQL</productname>␞␞       </para>␞
␝       <para>␟       Enable the failover of <link
       linkend="logical-replication-subscription-slot">logical slots</link>
       (Hou Zhijie, Shveta Malik, Ajin Cherian)␟<link linkend="logical-replication-subscription-slot">ロジカルスロット</link>のフェイルオーバーが有効になりました。
(Hou Zhijie, Shveta Malik, Ajin Cherian)␞␞       <ulink url="&commit_baseurl;c393308b6">&sect;</ulink>␞
␝       <para>␟       This is controlled by an optional fifth argument to <link
       linkend="functions-replication-table"><function>pg_create_logical_replication_slot()</function></link>.␟これは、<link linkend="functions-replication-table"><function>pg_create_logical_replication_slot()</function></link>の5番目のオプション引数で制御されます。␞␞       </para>␞
␝       <para>␟       Add server variable <xref linkend="guc-sync-replication-slots"/>
       to enable failover logical slot synchronization (Shveta Malik,
       Hou Zhijie, Peter Smith)␟フェイルオーバーロジカルスロットの同期を有効にするサーバパラメータ<xref linkend="guc-sync-replication-slots"/>が追加されました。
(Shveta Malik, Hou Zhijie, Peter Smith)␞␞       <ulink url="&commit_baseurl;93db6cbda">&sect;</ulink>␞
␝       <para>␟       Add logical replication failover control to <link
       linkend="sql-createsubscription"><literal>CREATE/ALTER
       SUBSCRIPTION</literal></link> (Shveta Malik, Hou Zhijie, Ajin
       Cherian)␟<link linkend="sql-createsubscription"><literal>CREATE/ALTER SUBSCRIPTION</literal></link>に論理レプリケーションフェイルオーバー制御が追加されました。
(Shveta Malik, Hou Zhijie, Ajin Cherian)␞␞       <ulink url="&commit_baseurl;776621a5e">&sect;</ulink>␞
␝       <para>␟       Allow the application of logical replication changes to use
       <link linkend="hash-index">hash</link> indexes on the subscriber
       (Hayato Kuroda)␟論理レプリケーションの変更適用において、サブスクライバーで<link linkend="hash-index">ハッシュ</link>インデックスが使用できるようになりました。
(Hayato Kuroda)␞␞       <ulink url="&commit_baseurl;edca34243">&sect;</ulink>␞
␝<!--
Author: Masahiko Sawada <msawada@postgresql.org>
2024-04-03 [5bec1d6bc] Improve eviction algorithm in ReorderBuffer using max-he
␟␟Allow the application of logical replication changes to use hash indexes on the subscriber (Hayato Kuroda)␞␞-->␞
␝       <para>␟       Previously only <link linkend="btree">btree</link> indexes could
       be used for this purpose.␟以前は、この目的に使用できるのは<link linkend="btree">btree</link>インデックスのみでした。␞␞       </para>␞
␝       <para>␟       Improve <link linkend="logicaldecoding">logical decoding</link>
       performance in cases where there are many subtransactions
       (Masahiko Sawada)␟サブトランザクションが多数ある場合の<link linkend="logicaldecoding">ロジカルデコーディング</link>の性能が向上しました。
(Masahiko Sawada)␞␞       <ulink url="&commit_baseurl;5bec1d6bc">&sect;</ulink>␞
␝       <para>␟       Restart apply workers if subscription owner's superuser privileges
       are revoked (Vignesh C)␟サブスクリプション所有者のスーパーユーザ権限が取り消された場合は、適用ワーカープロセスが再起動されるようになりました。
(Vignesh C)␞␞       <ulink url="&commit_baseurl;79243de13">&sect;</ulink>␞
␝       <para>␟       This forces reauthentication.␟これにより、再認証が強制されます。␞␞       </para>␞
␝       <para>␟       Add <literal>flush</literal> option to <link
       linkend="functions-replication-table"><function>pg_logical_emit_message()</function></link>
       (Michael Paquier)␟<link linkend="functions-replication-table"><function>pg_logical_emit_message()</function></link>関数に<literal>flush</literal>オプションが追加されました。
(Michael Paquier)␞␞       <ulink url="&commit_baseurl;173b56f1e">&sect;</ulink>␞
␝       <para>␟       This makes the message durable.␟これによりメッセージが永続化されます。␞␞       </para>␞
␝       <para>␟       Allow specification of physical standbys that must be synchronized
       before they are visible to subscribers (Hou Zhijie, Shveta Malik)␟サブスクライバーに表示される前に同期する必要がある物理的スタンバイが指定できるようになりました。
(Hou Zhijie, Shveta Malik)␞␞       <ulink url="&commit_baseurl;bf279ddd1">&sect;</ulink>␞
␝       <para>␟       The new server variable is <xref linkend="guc-synchronized-standby-slots"/>.␟新しいサーバパラメータは<xref linkend="guc-synchronized-standby-slots"/>です。␞␞       </para>␞
␝       <para>␟       Add worker type column to <link
       linkend="monitoring-pg-stat-subscription"><structname>pg_stat_subscription</structname></link>
       (Peter Smith)␟<link linkend="monitoring-pg-stat-subscription"><structname>pg_stat_subscription</structname></link>にworker_type列が追加されました。
(Peter Smith)␞␞       <ulink url="&commit_baseurl;13aeaf079">&sect;</ulink>␞
␝   <sect3 id="release-17-utility">␟    <title>Utility Commands</title>␟    <title>ユーティリティコマンド</title>␞␞␞
␝      <para>␟      Add new <link linkend="sql-copy"><command>COPY</command></link>
      option <literal>ON_ERROR ignore</literal> to discard error rows
      (Damir Belyalov, Atsushi Torikoshi, Alex Shulgin, Jian He, Yugo
      Nagata)␟エラー行を破棄するための新しい<link linkend="sql-copy"><command>COPY</command></link>オプション<literal>ON_ERROR ignore</literal>が追加されました。
(Damir Belyalov, Atsushi Torikoshi, Alex Shulgin, Jian He, Yugo Nagata)␞␞      <ulink url="&commit_baseurl;9e2d87011">&sect;</ulink>␞
␝      <para>␟      The default behavior is <literal>ON_ERROR stop</literal>.␟デフォルトの動作は<literal>ON_ERROR stop</literal>です。␞␞      </para>␞
␝      <para>␟      Add new <command>COPY</command> option
      <literal>LOG_VERBOSITY</literal> which reports <literal>COPY
      FROM</literal> ignored error rows (Bharath Rupireddy)␟<literal>COPY FROM</literal>が無視したエラー行を報告する新しい<command>COPY</command>オプション<literal>LOG_VERBOSITY</literal>が追加されました。
(Bharath Rupireddy)␞␞      <ulink url="&commit_baseurl;f5a227895">&sect;</ulink>␞
␝      <para>␟      Allow <literal>COPY FROM</literal> to report the number of skipped
      rows during processing (Atsushi Torikoshi)␟<literal>COPY FROM</literal>が処理中にスキップした行数を報告できるようになりました。
(Atsushi Torikoshi)␞␞      <ulink url="&commit_baseurl;729439607">&sect;</ulink>␞
␝      <para>␟      This appears in system view column <link
      linkend="copy-progress-reporting"><structname>pg_stat_progress_copy</structname>.<structfield>tuples_skipped</structfield></link>.␟これは、システムビューの列<link linkend="copy-progress-reporting"><structname>pg_stat_progress_copy</structname>.<structfield>tuples_skipped</structfield></link>に表示されます。␞␞      </para>␞
␝      <para>␟      In <literal>COPY FROM</literal>, allow easy specification that all
      columns should be forced null or not null (Zhang Mingli)␟<literal>COPY FROM</literal>で、すべての列を強制的にNULLにするか、NULLにしないかを簡単に指定できるようになりました。
(Zhang Mingli)␞␞      <ulink url="&commit_baseurl;f6d4c9cf1">&sect;</ulink>␞
␝      <para>␟      Allow partitioned tables to have identity columns (Ashutosh Bapat)␟パーティションテーブルでID列を持つことができるようになりました。
(Ashutosh Bapat)␞␞      <ulink url="&commit_baseurl;699586315">&sect;</ulink>␞
␝      <para>␟      Allow <link linkend="ddl-constraints-exclusion">exclusion
      constraints</link> on partitioned tables (Paul A. Jungwirth)␟テーブルパーティションで<link linkend="ddl-constraints-exclusion">排他制約</link>が使用可能になりました。
(Paul A. Jungwirth)␞␞      <ulink url="&commit_baseurl;8c852ba9a">&sect;</ulink>␞
␝      <para>␟      As long as exclusion constraints compare partition key columns
      for equality, other columns can use exclusion constraint-specific
      comparisons.␟排他制約がパーティションキー列の等価性を比較する限り、他の列は排他制約固有の比較を使用できます。␞␞      </para>␞
␝      <para>␟      Add clearer <link linkend="sql-altertable"><command>ALTER
      TABLE</command></link> method to set a column to the default
      statistics target (Peter Eisentraut)␟<link linkend="sql-altertable"><command>ALTER TABLE</command></link>で列統計ターゲットをデフォルトに設定するより明確な方法が追加されました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;4f622503d">&sect;</ulink>␞
␝      <para>␟      The new syntax is <literal>ALTER TABLE ... SET STATISTICS
      DEFAULT</literal>; using <literal>SET STATISTICS -1</literal>
      is still supported.␟新しい構文は<literal>ALTER TABLE ... SET STATISTICS DEFAULT</literal>です。
旧来の<literal>SET STATISTICS -1</literal>は引き続きサポートされています。␞␞      </para>␞
␝      <para>␟      Allow <literal>ALTER TABLE</literal> to change a column's generation
      expression (Amul Sul)␟<literal>ALTER TABLE</literal>で列の生成式を変更できるようになりました。
(Amul Sul)␞␞      <ulink url="&commit_baseurl;5d06e99a3">&sect;</ulink>␞
␝      <para>␟      The syntax is <literal>ALTER TABLE ... ALTER COLUMN ... SET
      EXPRESSION</literal>.␟構文は<literal>ALTER TABLE ... ALTER COLUMN ... SET EXPRESSION</literal>です。␞␞      </para>␞
␝      <para>␟      Allow specification of <link linkend="tableam">table access
      methods</link> on partitioned tables (Justin Pryzby, Soumyadeep
      Chakraborty, Michael Paquier)␟パーティションテーブルで<link linkend="tableam">テーブルアクセスメソッド</link>を指定できるようになりました。
(Justin Pryzby, Soumyadeep Chakraborty, Michael Paquier)␞␞      <ulink url="&commit_baseurl;374c7a229">&sect;</ulink>␞
␝      <para>␟      Add <literal>DEFAULT</literal> setting for <literal>ALTER TABLE
      .. SET ACCESS METHOD</literal> (Michael Paquier)␟<literal>ALTER TABLE .. SET ACCESS METHOD</literal>に<literal>DEFAULT</literal>設定が追加されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;d61a6cad6">&sect;</ulink>␞
␝      <para>␟      Add support for <link linkend="sql-createeventtrigger">event
      triggers</link> that fire at connection time (Konstantin Knizhnik,
      Mikhail Gribkov)␟接続時に起動する<link linkend="sql-createeventtrigger">イベントトリガ</link>がサポートされました。
(Konstantin Knizhnik, Mikhail Gribkov)␞␞      <ulink url="&commit_baseurl;e83d1b0c4">&sect;</ulink>␞
␝      <para>␟      Add event trigger support for <link
      linkend="sql-reindex"><command>REINDEX</command></link> (Garrett
      Thornburg, Jian He)␟<link linkend="sql-reindex"><command>REINDEX</command></link>に対するイベントトリガがサポートされました。
(Garrett Thornburg, Jian He)␞␞      <ulink url="&commit_baseurl;f21848de2">&sect;</ulink>␞
␝      <para>␟      Allow parenthesized syntax for <link
      linkend="sql-cluster"><command>CLUSTER</command></link> options if
      a table name is not specified (Nathan Bossart)␟テーブル名が指定されていない場合でも<link linkend="sql-cluster"><command>CLUSTER</command></link>のオプションで括弧付き構文が可能になりました。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;cdaedfc96">&sect;</ulink>␞
␝       <para>␟       Allow <command>EXPLAIN</command> to report
       optimizer memory usage (Ashutosh Bapat)␟<command>EXPLAIN</command>でオプティマイザのメモリ使用量を報告できるようになりました。
(Ashutosh Bapat)␞␞       <ulink url="&commit_baseurl;5de890e36">&sect;</ulink>␞
␝       <para>␟       The option is called <literal>MEMORY</literal>.␟このオプションは<literal>MEMORY</literal>と呼ばれます。␞␞       </para>␞
␝       <para>␟       Add <command>EXPLAIN</command> option <literal>SERIALIZE</literal>
       to report the cost of converting data for network transmission
       (Stepan Rutz, Matthias van de Meent)␟ネットワーク転送用にデータを変換するコストを報告する<command>EXPLAIN</command>の<literal>SERIALIZE</literal>オプションが追加されました。
(Stepan Rutz, Matthias van de Meent)␞␞       <ulink url="&commit_baseurl;06286709e">&sect;</ulink>␞
␝       <para>␟       Add local I/O block read/write timing statistics to
       <command>EXPLAIN</command>'s <literal>BUFFERS</literal> output
       (Nazir Bilal Yavuz)␟<command>EXPLAIN</command>の<literal>BUFFERS</literal>出力にローカルI/Oブロックの読み取り/書き込みタイミング統計が追加されました。
(Nazir Bilal Yavuz)␞␞       <ulink url="&commit_baseurl;295c36c0c">&sect;</ulink>␞
␝       <para>␟       Improve <command>EXPLAIN</command>'s display of SubPlan nodes and
       output parameters (Tom Lane, Dean Rasheed)␟<command>EXPLAIN</command>のSubPlanノードと出力パラメータの表示が改善されました。
(Tom Lane, Dean Rasheed)␞␞       <ulink url="&commit_baseurl;fd0398fcb">&sect;</ulink>␞
␝       <para>␟       Add <acronym>JIT</acronym> <literal>deform_counter</literal>
       details to <command>EXPLAIN</command> (Dmitry Dolgov)␟<command>EXPLAIN</command>に<acronym>JIT</acronym>の<literal>deform_counter</literal>の詳細が追加されました。
(Dmitry Dolgov)␞␞       <ulink url="&commit_baseurl;5a3423ad8">&sect;</ulink>␞
␝   <sect3 id="release-17-datatypes">␟    <title>Data Types</title>␟    <title>データ型</title>␞␞␞
␝      <para>␟      Allow the <type>interval</type> data type to support
      <literal>+/-infinity</literal> values (Joseph Koshakow, Jian He,
      Ashutosh Bapat)␟<type>interval</type>データ型で<literal>+/-infinity</literal>値がサポートされました。
(Joseph Koshakow, Jian He, Ashutosh Bapat)␞␞      <ulink url="&commit_baseurl;519fc1bd9">&sect;</ulink>␞
␝      <para>␟      Allow the use of an <link
      linkend="datatype-enum"><type>ENUM</type></link> added via <link
      linkend="sql-altertype"><command>ALTER TYPE</command></link> if
      the type was created in the same transaction (Tom Lane)␟同じトランザクション内で作成され<link linkend="sql-altertype"><command>ALTER TYPE</command></link>で追加された<link linkend="datatype-enum"><type>ENUM</type></link>型を使用できるようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;af1d39584">&sect;</ulink>␞
␝      <para>␟      This was previously disallowed.␟これは以前は許可されていませんでした。␞␞      </para>␞
␝      <para>␟      Allow <command>MERGE</command> to modify updatable views (Dean
      Rasheed)␟<command>MERGE</command>が更新可能なビューを変更できるようになりました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;5f2e179bd">&sect;</ulink>␞
␝      <para>␟      Add <literal>WHEN NOT MATCHED BY SOURCE</literal> to
      <command>MERGE</command> (Dean Rasheed)␟<command>MERGE</command>に<literal>WHEN NOT MATCHED BY SOURCE</literal>が追加されました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;0294df2f1">&sect;</ulink>␞
␝      <para>␟      <literal>WHEN NOT MATCHED</literal> on target rows was already
      supported.␟ターゲット行の<literal>WHEN NOT MATCHED</literal>はすでにサポートされていました。␞␞      </para>␞
␝      <para>␟      Allow <command>MERGE</command> to use the
      <literal>RETURNING</literal> clause (Dean Rasheed)␟<command>MERGE</command>で<literal>RETURNING</literal>句を使用できるようになりました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;c649fa24a">&sect;</ulink>␞
␝      <para>␟      The new <literal>RETURNING</literal> function
      <function>merge_action()</function> reports on the
      <acronym>DML</acronym> that generated the row.␟新しい<literal>RETURNING</literal>関数の<function>merge_action()</function>は、行を生成した<acronym>DML</acronym>を報告します。␞␞      </para>␞
␝   <sect3 id="release-17-functions">␟    <title>Functions</title>␟    <title>関数</title>␞␞␞
␝      <para>␟      Add function <link
      linkend="functions-sqljson-table"><function>JSON_TABLE()</function></link>
      to convert <type>JSON</type> data to a table representation (Nikita
      Glukhov, Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Andrew
      Dunstan, Amit Langote, Jian He)␟<type>JSON</type>データをテーブル表現に変換する関数<link linkend="functions-sqljson-table"><function>JSON_TABLE()</function></link>が追加されました。
(Nikita Glukhov, Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Andrew Dunstan, Amit Langote, Jian He)␞␞      <ulink url="&commit_baseurl;de3600452">&sect;</ulink>␞
␝      <para>␟      This function can be used in the <literal>FROM</literal> clause of
      <command>SELECT</command> queries as a tuple source.␟この関数は、<command>SELECT</command>クエリの<literal>FROM</literal>句でタプルソースとして使用できます。␞␞      </para>␞
␝      <para>␟      Add <acronym>SQL/JSON</acronym> constructor functions <link
      linkend="functions-json-creation-table"><function>JSON()</function></link>,
      <function>JSON_SCALAR()</function>, and
      <function>JSON_SERIALIZE()</function> (Nikita Glukhov, Teodor Sigaev,
      Oleg Bartunov, Alexander Korotkov, Andrew Dunstan, Amit Langote)␟<acronym>SQL/JSON</acronym>コンストラクタ関数<link linkend="functions-json-creation-table"><function>JSON()</function></link>、<function>JSON_SCALAR()</function>、<function>JSON_SERIALIZE()</function>が追加されました。
(Nikita Glukhov, Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Andrew Dunstan, Amit Langote)␞␞      <ulink url="&commit_baseurl;03734a7fe">&sect;</ulink>␞
␝      <para>␟      Add <acronym>SQL/JSON</acronym> query functions <link
      linkend="functions-sqljson-querying"><function>JSON_EXISTS()</function></link>,
      <function>JSON_QUERY()</function>, and
      <function>JSON_VALUE()</function> (Nikita Glukhov, Teodor Sigaev,
      Oleg Bartunov, Alexander Korotkov, Andrew Dunstan, Amit Langote,
      Peter Eisentraut, Jian He)␟<acronym>SQL/JSON</acronym>のクエリ関数<link linkend="functions-sqljson-querying"><function>JSON_EXISTS()</function></link>、<function>JSON_QUERY()</function>、<function>JSON_VALUE()</function>が追加されました。
(Nikita Glukhov, Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Andrew Dunstan, Amit Langote, Peter Eisentraut, Jian He)␞␞      <ulink url="&commit_baseurl;aaaf9449e">&sect;</ulink>␞
␝      <para>␟      Add <link linkend="functions-sqljson-path-operators">jsonpath</link>
      methods to convert <type>JSON</type> values to other
      <type>JSON</type> data types (Jeevan Chalke)␟<type>JSON</type>値を他の<type>JSON</type>データ型に変換する<link linkend="functions-sqljson-path-operators">jsonpath</link>メソッドが追加されました。
(Jeevan Chalke)␞␞      <ulink url="&commit_baseurl;66ea94e8e">&sect;</ulink>␞
␝      <para>␟      The jsonpath methods are <function>.bigint()</function>,
      <function>.boolean()</function>, <function>.date()</function>,
      <function>.decimal([precision [, scale]])</function>,
      <function>.integer()</function>, <function>.number()</function>,
      <function>.string()</function>, <function>.time()</function>,
      <function>.time_tz()</function>, <function>.timestamp()</function>,
      and <function>.timestamp_tz()</function>.␟jsonpathメソッドは、<function>.bigint()</function>、<function>.boolean()</function>、<function>.date()</function>、<function>.decimal([precision [, scale]])</function>、<function>.integer()</function>、<function>.number()</function>、<function>.string()</function>、<function>.time()</function>、<function>.time_tz()</function>、<function>.timestamp()</function>、<function>.timestamp_tz()</function>です。␞␞      </para>␞
␝      <para>␟      Add <link
      linkend="functions-formatting-table"><function>to_timestamp()</function></link>
      time zone format specifiers (Tom Lane)␟<link linkend="functions-formatting-table"><function>to_timestamp()</function></link>でタイムゾーン形式指定が追加されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;8ba6fdf90">&sect;</ulink>␞
␝      <para>␟      <literal>TZ</literal> accepts time zone abbreviations or numeric
      offsets, while <literal>OF</literal> accepts only numeric offsets.␟<literal>TZ</literal>はタイムゾーンの略語形または数値オフセットを受け付ける一方、<literal>OF</literal>は数値オフセットのみを受け付けます。␞␞      </para>␞
␝      <para>␟      Allow the session <link linkend="guc-timezone">time zone</link>
      to be specified by <literal>AT LOCAL</literal> (Vik Fearing)␟セッションの<link linkend="guc-timezone">タイムゾーン</link>を<literal>AT LOCAL</literal>で指定できるようになりました。
(Vik Fearing)␞␞      <ulink url="&commit_baseurl;97957fdba">&sect;</ulink>␞
␝      <para>␟      This is useful when converting adding and removing time zones from
      time stamps values, rather than specifying the literal session
      time zone.␟これは、リテラルなセッションタイムゾーンを指定するのではなく、タイムスタンプ値からタイムゾーンを追加および削除して変換する場合に便利です。␞␞      </para>␞
␝      <para>␟      Add functions <link
      linkend="functions-uuid"><function>uuid_extract_timestamp()</function></link>
      and <function>uuid_extract_version()</function> to return
      <acronym>UUID</acronym> information (Andrey Borodin)␟<acronym>UUID</acronym>の情報を返す関数<link linkend="functions-uuid"><function>uuid_extract_timestamp()</function></link>および<function>uuid_extract_version()</function>が追加されました。
(Andrey Borodin)␞␞      <ulink url="&commit_baseurl;794f10f6b">&sect;</ulink>␞
␝      <para>␟      Add functions to generate random numbers in a specified range
      (Dean Rasheed)␟指定された範囲内で乱数を生成する関数が追加されました。
(Dean Rasheed)␞␞      <ulink url="&commit_baseurl;e6341323a">&sect;</ulink>␞
␝      <para>␟      The functions are <link
      linkend="functions-math-random-table"><function>random(min,
      max)</function></link> and they take values of type
      <type>integer</type>, <type>bigint</type>, and <type>numeric</type>.␟関数は<link linkend="functions-math-random-table"><function>random(min, max)</function></link>で、<type>integer</type>、<type>bigint</type>、<type>numeric</type>型の値を取ります。␞␞      </para>␞
␝      <para>␟      Add functions to convert integers to binary and octal strings
      (Eric Radman, Nathan Bossart)␟整数を2進数の文字列と8進数の文字列に変換する関数が追加されました。
(Eric Radman, Nathan Bossart)␞␞      <ulink url="&commit_baseurl;260a1f18d">&sect;</ulink>␞
␝      <para>␟      The functions are <link
      linkend="functions-string-other"><function>to_bin()</function></link>
      and <function>to_oct()</function>.␟関数は<link linkend="functions-string-other"><function>to_bin()</function></link>と<function>to_oct()</function>です。␞␞      </para>␞
␝      <para>␟      Add Unicode informational functions (Jeff Davis)␟ユニコード情報の関数が追加されました。
(Jeff Davis)␞␞      <ulink url="&commit_baseurl;a02b37fc0">&sect;</ulink>␞
␝      <para>␟      Function <link
      linkend="functions-info-version"><function>unicode_version()</function></link>
      returns the Unicode version,
      <function>icu_unicode_version()</function>
      returns the <acronym>ICU</acronym> version, and
      <function>unicode_assigned()</function> returns if the characters
      are assigned Unicode codepoints.␟関数<link linkend="functions-info-version"><function>unicode_version()</function></link>はユニコードバージョンを返し、<function>icu_unicode_version()</function>は<acronym>ICU</acronym>バージョンを返し、<function>unicode_assigned()</function>は文字にユニコードのコードポイントが割り当てられているかどうかを返します。␞␞      </para>␞
␝      <para>␟      Add function <link
      linkend="functions-producing-xml-xmltext"><function>xmltext()</function></link>
      to convert text to a single <type>XML</type> text node (Jim Jones)␟テキストを単一の<type>XML</type>テキストノードに変換する関数<link linkend="functions-producing-xml-xmltext"><function>xmltext()</function></link>が追加されました。
(Jim Jones)␞␞      <ulink url="&commit_baseurl;526fe0d79">&sect;</ulink>␞
␝      <para>␟      Add function <link
      linkend="functions-info-catalog-table"><function>to_regtypemod()</function></link>
      to return the type modifier of a type specification (David Wheeler,
      Erik Wienhold)␟型指定の型修飾子を返す関数<link linkend="functions-info-catalog-table"><function>to_regtypemod()</function></link>が追加されました。
(David Wheeler, Erik Wienhold)␞␞      <ulink url="&commit_baseurl;1218ca995">&sect;</ulink>␞
␝      <para>␟      Add <link
      linkend="functions-info-catalog-table"><function>pg_basetype()</function></link>
      function to return a domain's base type (Steve Chavez)␟ドメインの基本型を返す<link linkend="functions-info-catalog-table"><function>pg_basetype()</function></link>関数が追加されました。
(Steve Chavez)␞␞      <ulink url="&commit_baseurl;b154d8a6d">&sect;</ulink>␞
␝      <para>␟      Add function <link
      linkend="functions-admin-dbsize"><function>pg_column_toast_chunk_id()</function></link>
      to return a value's <link
      linkend="storage-toast"><acronym>TOAST</acronym></link> identifier
      (Yugo Nagata)␟値の<link linkend="storage-toast"><acronym>TOAST</acronym></link>識別子を返す関数<link linkend="functions-admin-dbsize"><function>pg_column_toast_chunk_id()</function></link>が追加されました。
(Yugo Nagata)␞␞      <ulink url="&commit_baseurl;d1162cfda">&sect;</ulink>␞
␝      <para>␟      This returns <literal>NULL</literal> if the value is not stored
      in <acronym>TOAST</acronym>.␟値が<acronym>TOAST</acronym>に格納されていない場合は、<literal>NULL</literal>を返します。␞␞      </para>␞
␝      <para>␟      Allow plpgsql <link
      linkend="plpgsql-declaration-type"><literal>%TYPE</literal></link>
      and <literal>%ROWTYPE</literal> specifications to represent arrays
      of non-array types (Quan Zongliang, Pavel Stehule)␟PL/pgSQLの<link linkend="plpgsql-declaration-type"><literal>%TYPE</literal></link>および<literal>%ROWTYPE</literal>の指定で、非配列型の配列を表現できるようになりました。
(Quan Zongliang, Pavel Stehule)␞␞      <ulink url="&commit_baseurl;5e8674dc8">&sect;</ulink>␞
␝      <para>␟      Allow plpgsql <literal>%TYPE</literal> specification to reference
      composite column (Tom Lane)␟PL/pgSQLの<literal>%TYPE</literal>指定で複合型を参照できるようになりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;43b46aae1">&sect;</ulink>␞
␝      <para>␟      Add libpq function to change role passwords (Joe Conway)␟ロールのパスワードを変更するlibpq関数が追加されました。
(Joe Conway)␞␞      <ulink url="&commit_baseurl;a7be2a6c2">&sect;</ulink>␞
␝      <para>␟      The new function, <link
      linkend="libpq-PQchangePassword"><function>PQchangePassword()</function></link>,
      hashes the new password before sending it to the server.␟新しい関数<link linkend="libpq-PQchangePassword"><function>PQchangePassword()</function></link>は、新しいパスワードをサーバに送信する前にハッシュします。␞␞      </para>␞
␝      <para>␟      Add libpq functions to close portals and prepared statements
      (Jelte Fennema-Nio)␟ポータルとプリペアド文を閉じるためのlibpq関数が追加されました。
(Jelte Fennema-Nio)␞␞      <ulink url="&commit_baseurl;28b572656">&sect;</ulink>␞
␝      <para>␟      The functions are <link
      linkend="libpq-PQclosePrepared"><function>PQclosePrepared()</function></link>,
      <link
      linkend="libpq-PQclosePortal"><function>PQclosePortal()</function></link>,
      <link
      linkend="libpq-PQsendClosePrepared"><function>PQsendClosePrepared()</function></link>,
      and <link
      linkend="libpq-PQsendClosePortal"><function>PQsendClosePortal()</function></link>.␟関数は<link linkend="libpq-PQclosePrepared"><function>PQclosePrepared()</function></link>、<link linkend="libpq-PQclosePortal"><function>PQclosePortal()</function></link>、<link linkend="libpq-PQsendClosePrepared"><function>PQsendClosePrepared()</function></link>、<link linkend="libpq-PQsendClosePortal"><function>PQsendClosePortal()</function></link>です。␞␞      </para>␞
␝      <para>␟      Add libpq <acronym>API</acronym> which allows for blocking and
      non-blocking <link linkend="libpq-cancel">cancel requests</link>,
      with encryption if already in use (Jelte Fennema-Nio)␟すでに使用されている場合は暗号化された、ブロッキングと非ブロッキングの<link linkend="libpq-cancel">キャンセル要求</link>を可能にするlibpq<acronym>API</acronym>が追加されました。
(Jelte Fennema-Nio)␞␞      <ulink url="&commit_baseurl;61461a300">&sect;</ulink>␞
␝      <para>␟      Previously only blocking, unencrypted cancel requests were supported.␟以前は、暗号化されていないブロッキングのキャンセル要求だけがサポートされていました。␞␞      </para>␞
␝      <para>␟      Add libpq function <link
      linkend="libpq-PQsocketPoll"><function>PQsocketPoll()</function></link>
      to allow polling of network sockets (Tristan Partin, Tom Lane)␟ネットワークソケットのポーリングを可能にするlibpq関数<link linkend="libpq-PQsocketPoll"><function>PQsocketPoll()</function></link>が追加されました。
(Tristan Partin, Tom Lane)␞␞      <ulink url="&commit_baseurl;f5e4dedfa">&sect;</ulink>␞
␝      <para>␟      Add libpq function <link
      linkend="libpq-PQsendPipelineSync"><function>PQsendPipelineSync()</function></link>
      to send a pipeline synchronization point (Anton Kirilov)␟パイプライン同期化ポイントを送信するためのlibpq関数<link linkend="libpq-PQsendPipelineSync"><function>PQsendPipelineSync()</function></link>が追加されました。
(Anton Kirilov)␞␞      <ulink url="&commit_baseurl;4794c2d31">&sect;</ulink>␞
␝      <para>␟      This is similar to <link
      linkend="libpq-PQpipelineSync"><function>PQpipelineSync()</function></link>
      but it does not flush to the server unless the size threshold of
      the output buffer is reached.␟これは<link linkend="libpq-PQpipelineSync"><function>PQpipelineSync()</function></link>と似ていますが、出力バッファのサイズがしきい値に達しない限り、サーバにフラッシュしません。␞␞      </para>␞
␝      <para>␟      Add libpq function <link
      linkend="libpq-PQsetChunkedRowsMode"><function>PQsetChunkedRowsMode()</function></link>
      to allow retrieval of results in chunks (Daniel V&eacute;rit&eacute;)␟結果をチャンクで取得できるようにしたlibpq関数<link linkend="libpq-PQsetChunkedRowsMode"><function>PQsetChunkedRowsMode()</function></link>が追加されました。
(Daniel V&eacute;rit&eacute;)␞␞      <ulink url="&commit_baseurl;4643a2b26">&sect;</ulink>␞
␝      <para>␟      Allow <acronym>TLS</acronym> connections without requiring a
      network round-trip negotiation (Greg Stark, Heikki Linnakangas,
      Peter Eisentraut, Michael Paquier, Daniel Gustafsson)␟ネットワークの往復ネゴシエーションを必要としない<acronym>TLS</acronym>接続が利用可能になりました。
(Greg Stark, Heikki Linnakangas, Peter Eisentraut, Michael Paquier, Daniel Gustafsson)␞␞      <ulink url="&commit_baseurl;d39a49c1e">&sect;</ulink>␞
␝      <para>␟      This is enabled with the client-side option <link
      linkend="libpq-connect-sslnegotiation"><literal>sslnegotiation=direct</literal></link>,
      requires <acronym>ALPN</acronym>, and only works on
      <productname>PostgreSQL</productname> 17 and later servers.␟これは、クライアント側オプション<link linkend="libpq-connect-sslnegotiation"><literal>sslnegotiation=direct</literal></link>で有効になり、<acronym>ALPN</acronym>を必要とし、<productname>PostgreSQL</productname> 17以降のサーバでのみ動作します。␞␞      </para>␞
␝      <para>␟      Improve <application>psql</application> display of default and
      empty privileges (Erik Wienhold, Laurenz Albe)␟デフォルトと空の権限の<application>psql</application>表示が改善されました。
(Erik Wienhold, Laurenz Albe)␞␞      <ulink url="&commit_baseurl;d1379ebf4">&sect;</ulink>␞
␝      <para>␟      Command <literal>\dp</literal> now displays <literal>(none)</literal>
      for empty privileges;  default still displays as empty.␟コマンド<literal>\dp</literal>は、空の権限に対して<literal>(none)</literal>と表示されるようになりました。
デフォルトは引き続き空欄のままです。␞␞      </para>␞
␝      <para>␟      Have backslash commands honor <literal>\pset null</literal> (Erik
      Wienhold, Laurenz Albe)␟バックスラッシュコマンドが<literal>\pset null</literal>を尊重するようになりました。
(Erik Wienhold, Laurenz Albe)␞␞      <ulink url="&commit_baseurl;d1379ebf4">&sect;</ulink>␞
␝      <para>␟      Previously <literal>\pset null</literal> was ignored.␟以前は<literal>\pset null</literal>は無視されていました。␞␞      </para>␞
␝      <para>␟      Allow <application>psql</application>'s <literal>\watch</literal>
      to stop after a minimum number of rows returned (Greg Sabino Mullane)␟<application>psql</application>の<literal>\watch</literal>が最小限の行数が返された後に停止できるようになりました。
(Greg Sabino Mullane)␞␞      <ulink url="&commit_baseurl;f347ec76e">&sect;</ulink>␞
␝      <para>␟      The parameter is <literal>min_rows</literal>.␟パラメータは<literal>min_rows</literal>です。␞␞      </para>␞
␝      <para>␟      Allow <application>psql</application> connection attempts to be
      canceled with control-C (Tristan Partin)␟<application>psql</application>の接続試行をCtrl-Cでキャンセルできるようになりました。
(Tristan Partin)␞␞      <ulink url="&commit_baseurl;cafe10565">&sect;</ulink>␞
␝      <para>␟      Allow <application>psql</application> to honor
      <literal>FETCH_COUNT</literal> for non-<command>SELECT</command>
      queries (Daniel V&eacute;rit&eacute;)␟<application>psql</application>が<command>SELECT</command>以外の問い合わせ文に対して<literal>FETCH_COUNT</literal>の設定を反映するようになりました。
(Daniel V&eacute;rit&eacute;)␞␞      <ulink url="&commit_baseurl;90f517821">&sect;</ulink>␞
␝      <para>␟      Improve <application>psql</application> tab completion (Dagfinn
      Ilmari Manns&aring;ker, Gilles Darold, Christoph Heiss, Steve Chavez,
      Vignesh C, Pavel Borisov, Jian He)␟<application>psql</application>のタブ補完が改善されました。
(Dagfinn Ilmari Manns&aring;ker, Gilles Darold, Christoph Heiss, Steve Chavez, Vignesh C, Pavel Borisov, Jian He)␞␞      <ulink url="&commit_baseurl;c951e9042">&sect;</ulink>␞
␝    <sect3 id="release-17-server-apps">␟     <title>Server Applications</title>␟     <title>サーバアプリケーション</title>␞␞␞
␝      <para>␟      Add application <link
      linkend="app-pgwalsummary"><application>pg_walsummary</application></link>
      to dump <acronym>WAL</acronym> summary files (Robert Haas)␟<acronym>WAL</acronym>サマリファイルをダンプする<link linkend="app-pgwalsummary"><application>pg_walsummary</application></link>アプリケーションが追加されました。
(Robert Haas)␞␞      <ulink url="&commit_baseurl;ee1bfd168">&sect;</ulink>␞
␝      <para>␟      Allow <link
      linkend="app-pgdump"><application>pg_dump</application></link>'s
      large objects to be restorable in batches (Tom Lane)␟<link linkend="app-pgdump"><application>pg_dump</application></link>のラージオブジェクトがバッチでリストア可能になりました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;a45c78e32">&sect;</ulink>␞
␝      <para>␟      This allows the restoration of many large objects to avoid
      transaction limits and to be restored in parallel.␟これにより、多数のラージオブジェクトのリストアがトランザクションの制限を回避し、パラレルでのリストアが可能になりました。␞␞      </para>␞
␝      <para>␟      Add <application>pg_dump</application> option
      <option>--exclude-extension</option> (Ayush Vatsa)␟<application>pg_dump</application>に<option>&#45;-exclude-extension</option>オプションが追加されました。
(Ayush Vatsa)␞␞      <ulink url="&commit_baseurl;522ed12f7">&sect;</ulink>␞
␝      <para>␟      Allow <link
      linkend="app-pgdump"><application>pg_dump</application></link>, <link
      linkend="app-pg-dumpall"><application>pg_dumpall</application></link>,
      and <link
      linkend="app-pgrestore"><application>pg_restore</application></link>
      to specify include/exclude objects in a file (Pavel Stehule,
      Daniel Gustafsson)␟<link linkend="app-pgdump"><application>pg_dump</application></link>、<link linkend="app-pg-dumpall"><application>pg_dumpall</application></link>、<link linkend="app-pgrestore"><application>pg_restore</application></link>で、処理対象のオブジェクトを含めるか含めないかの指定を一つのファイルで指定できるようになりました。
(Pavel Stehule, Daniel Gustafsson)␞␞      <ulink url="&commit_baseurl;a5cf808be">&sect;</ulink>␞
␝      The option is called <option>--filter</option>.␟      The option is called <option>--filter</option>.␟このオプションは<option>--filter</option>と呼ばれます。␞␞      </para>␞
␝      Add the <option>--sync-method</option> parameter to several client␟      Add the <option>--sync-method</option> parameter to several client
      applications (Justin Pryzby, Nathan Bossart)␟いくつかのクライアントアプリケーションに<option>&#45;-sync-method</option>パラメータが追加されました。
(Justin Pryzby, Nathan Bossart)␞␞      <ulink url="&commit_baseurl;8c16ad3b4">&sect;</ulink>␞
␝      <para>␟      The applications are <link
      linkend="app-initdb"><application>initdb</application></link>, <link
      linkend="app-pgbasebackup"><application>pg_basebackup</application></link>,
      <link
      linkend="app-pgchecksums"><application>pg_checksums</application></link>,
      <link linkend="app-pgdump"><application>pg_dump</application></link>,
      <link linkend="app-pgrewind"><application>pg_rewind</application></link>,
      and <link
      linkend="pgupgrade"><application>pg_upgrade</application></link>.␟対象となるアプリケーションは、<link linkend="app-initdb"><application>initdb</application></link>、<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>、<link linkend="app-pgchecksums"><application>pg_checksums</application></link>、<link linkend="app-pgdump"><application>pg_dump</application></link>、<link linkend="app-pgrewind"><application>pg_rewind</application></link>、<link linkend="pgupgrade"><application>pg_upgrade</application></link>です。␞␞      </para>␞
␝      <para>␟      Add <link
      linkend="app-pgrestore"><application>pg_restore</application></link>
      option <option>--transaction-size</option> to allow object restores
      in transaction batches (Tom Lane)␟トランザクションバッチでのオブジェクトリストアを可能にする<option>&#45;-transaction-size</option>オプションが<link linkend="app-pgrestore"><application>pg_restore</application></link>に追加されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;959b38d77">&sect;</ulink>␞
␝      <para>␟      This allows the performance benefits of transaction batches without
      the problems of excessively large transaction blocks.␟これにより、トランザクションブロックが大きすぎるという問題が発生することなく、トランザクションバッチの性能上の利点が得られます。␞␞      </para>␞
␝      <para>␟      Change <link
      linkend="pgbench"><application>pgbench</application></link> debug
      mode option from <option>-d</option> to <option>--debug</option>
      (Greg Sabino Mullane)␟<link linkend="pgbench"><application>pgbench</application></link>のデバッグモードオプションが<option>-d</option>から<option>&#45;-debug</option>に変更されました。
(Greg Sabino Mullane)␞␞      <ulink url="&commit_baseurl;3ff01b2b6">&sect;</ulink>␞
␝      <para>␟      Option <option>-d</option> is now used for the database name,
      and the new <option>--dbname</option> option can be used as well.␟<option>-d</option>オプションはデータベース名に使用され、新しい<option>--dbname</option>オプションも使用できるようになりました。␞␞      </para>␞
␝      Add pgbench option <option>--exit-on-abort</option> to exit after␟      Add pgbench option <option>--exit-on-abort</option> to exit after
      any client aborts (Yugo Nagata)␟クライアントのアボート後に終了するpgbenchオプション<option>&#45;-exit-on-abort</option>が追加されました。
(Yugo Nagata)␞␞      <ulink url="&commit_baseurl;3c662643c">&sect;</ulink>␞
␝      <para>␟      Add pgbench command <literal>\syncpipeline</literal> to allow
      sending of sync messages (Anthonin Bonnefoy)␟同期メッセージの送信を可能にする、pgbenchコマンド<literal>\syncpipeline</literal>が追加されました。
(Anthonin Bonnefoy)␞␞      <ulink url="&commit_baseurl;94edfe250">&sect;</ulink>␞
␝      <para>␟      Allow <link
      linkend="pgarchivecleanup"><application>pg_archivecleanup</application></link>
      to remove backup history files (Atsushi Torikoshi)␟Allow<link linkend="pgarchivecleanup"><application>pg_archivecleanup</application></link>でのバックアップ履歴ファイルを削除できるようになりました。
(Atsushi Torikoshi)␞␞      <ulink url="&commit_baseurl;3f8c98d0b">&sect;</ulink>␞
␝      The option is <option>--clean-backup-history</option>.␟      The option is <option>--clean-backup-history</option>.␟オプションは<option>--clean-backup-history</option>です。␞␞      </para>␞
␝      <para>␟      Add some long options to <application>pg_archivecleanup</application>
      (Atsushi Torikoshi)␟<application>pg_archivecleanup</application>にいくつかの長いオプションが追加されました。
(Atsushi Torikoshi)␞␞      <ulink url="&commit_baseurl;dd7c60f19">&sect;</ulink>␞
␝      <option>--dry-run</option>, and <option>--strip-extension</option>.␟      The long options are <option>--debug</option>,
      <option>--dry-run</option>, and <option>--strip-extension</option>.␟長いオプションは<option>--debug</option>、<option>--dry-run</option>、<option>--strip-extension</option>です。␞␞      </para>␞
␝      <para>␟      Allow <link
      linkend="app-pgbasebackup"><application>pg_basebackup</application></link>
      and <link
      linkend="app-pgreceivewal"><application>pg_receivewal</application></link>
      to use dbname in their connection specification (Jelte Fennema-Nio)␟<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>と<link linkend="app-pgreceivewal"><application>pg_receivewal</application></link>の接続指定でdbnameが利用可能になりました。
(Jelte Fennema-Nio)␞␞      <ulink url="&commit_baseurl;cca97ce6a">&sect;</ulink>␞
␝      <para>␟      This is useful for connection poolers that are sensitive to the
      database name.␟これは、データベース名を必要とするコネクションプーラに役立ちます。␞␞      </para>␞
␝      <para>␟      Add <link
      linkend="pgupgrade"><application>pg_upgrade</application></link>
      option <option>--copy-file-range</option> (Thomas Munro)␟<link linkend="pgupgrade"><application>pg_upgrade</application></link>に<option>&#45;-copy-file-range</option>オプションが追加されました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;d93627bcb">&sect;</ulink>␞
␝      <para>␟      This is supported on <systemitem class="osname">Linux</systemitem>
      and <systemitem class="osname">FreeBSD</systemitem>.␟これは<systemitem class="osname">Linux</systemitem>と<systemitem class="osname">FreeBSD</systemitem>でサポートされています。␞␞      </para>␞
␝      <para>␟      Allow <link
      linkend="app-reindexdb"><application>reindexdb</application></link>
      <option>--index</option> to process indexes from different tables
      in parallel (Maxim Orlov, Svetlana Derevyanko, Alexander Korotkov)␟<link linkend="app-reindexdb"><application>reindexdb</application></link><option>&#45;-index</option>で、異なるテーブルのインデックスを並列に処理できるようになりました。
(Maxim Orlov, Svetlana Derevyanko, Alexander Korotkov)␞␞      <ulink url="&commit_baseurl;47f99a407">&sect;</ulink>␞
␝      <para>␟      Allow <link linkend="app-reindexdb">reindexdb</link>,
      <link linkend="app-vacuumdb">vacuumdb</link>, and <link
      linkend="app-clusterdb">clusterdb</link> to process objects in all
      databases matching a pattern (Nathan Bossart)␟<link linkend="app-reindexdb">reindexdb</link>、<link linkend="app-vacuumdb">vacuumdb</link>、<link linkend="app-clusterdb">clusterdb</link>がパターンに一致するすべてのデータベース内のオブジェクトを処理できるようになりました。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;24c928ad9">&sect;</ulink>␞
␝      The new option <option>--all</option> controls this behavior.␟      The new option <option>--all</option> controls this behavior.␟新しいオプション<option>--all</option>が、この動作を制御します。␞␞      </para>␞
␝   <sect3 id="release-17-source-code">␟    <title>Source Code</title>␟    <title>ソースコード</title>␞␞␞
␝      <para>␟      Remove support for <productname>OpenSSL</productname> 1.0.1
      (Michael Paquier)␟<productname>OpenSSL</productname> 1.0.1のサポートが削除されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;8e278b657">&sect;</ulink>␞
␝      <para>␟      Allow tests to pass in <productname>OpenSSL</productname>
      <acronym>FIPS</acronym> mode (Peter Eisentraut)␟<productname>OpenSSL</productname><acronym>FIPS</acronym>モードでテストに合格できるようになりました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;284cbaea7">&sect;</ulink>␞
␝      <para>␟      Use <acronym>CPU AVX</acronym>-512 instructions for bit counting
      (Paul Amonson, Nathan Bossart, Ants Aasma)␟ビットカウントに<acronym>CPU AVX</acronym>-512命令を使用するようになりました。
(Paul Amonson, Nathan Bossart, Ants Aasma)␞␞      <ulink url="&commit_baseurl;792752af4">&sect;</ulink>␞
␝      <para>␟      Require <productname><acronym>LLVM</acronym></productname> version
      10 or later (Thomas Munro)␟<productname><acronym>LLVM</acronym></productname>バージョン10以降が必要になりました。
(Thomas Munro)␞␞      <ulink url="&commit_baseurl;820b5af73">&sect;</ulink>␞
␝      <para>␟      Use native <acronym>CRC</acronym> instructions on 64-bit
      <productname>LoongArch</productname> CPUs (Xudong Yang)␟64ビット<productname>LoongArch</productname>CPUでネイティブ<acronym>CRC</acronym>命令を使用するようになりました。
(Xudong Yang)␞␞      <ulink url="&commit_baseurl;4d14ccd6a">&sect;</ulink>␞
␝      <para>␟      Remove <systemitem class="osname"><acronym>AIX</acronym></systemitem>
      support (Heikki Linnakangas)␟<systemitem class="osname"><acronym>AIX</acronym></systemitem>サポートが削除されました。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;0b16bb877">&sect;</ulink>␞
␝      <para>␟      Remove the <productname>Microsoft Visual
      Studio</productname>-specific <productname>PostgreSQL</productname>
      build option (Michael Paquier)␟<productname>Microsoft Visual Studio</productname>固有の<productname>PostgreSQL</productname>ビルドオプションが削除されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;1301c80b2">&sect;</ulink>␞
␝      <para>␟      <productname>Meson</productname> is now the only available method
      for <productname>Visual Studio</productname> builds.␟<productname>Meson</productname>が<productname>Visual Studio</productname>ビルドで利用可能な唯一の方法になりました。␞␞      </para>␞
␝      Remove configure option <option>--disable-thread-safety</option>␟      Remove configure option <option>--disable-thread-safety</option>
      (Thomas Munro, Heikki Linnakangas)␟configureの<option>&#45;-disable-thread-safety</option>オプションが削除されました。
(Thomas Munro, Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;68a4b58ec">&sect;</ulink>␞
␝      <para>␟      We now assume all supported platforms have sufficient thread support.␟現在では、サポートされているすべてのプラットフォームで十分なスレッドサポートがあることを前提としています。␞␞      </para>␞
␝      <para>␟      Remove <application>configure</application> option
      <option>--with-CC</option> (Heikki Linnakangas)␟<application>configure</application>の<option>&#45;-with-CC</option>オプションが削除されました。
します。
(Heikki Linnakangas)␞␞      <ulink url="&commit_baseurl;1c1eec0f2">&sect;</ulink>␞
␝      <para>␟      Setting the <envar>CC</envar> environment variable is now the only
      supported method for specifying the compiler.␟<envar>CC</envar>環境変数を設定することが、コンパイラを指定するための唯一の方法になりました。␞␞      </para>␞
␝      <para>␟      User-defined data type receive functions will no longer receive
      their data null-terminated (David Rowley)␟ユーザ定義のデータ型受信関数は、NULLで終了するデータを受信しなくなりました。
(David Rowley)␞␞      <ulink url="&commit_baseurl;f0efa5aec">&sect;</ulink>␞
␝      <para>␟      Add incremental <type>JSON</type> parser for use with huge
      <type>JSON</type> documents (Andrew Dunstan)␟巨大な<type>JSON</type>ドキュメントで使用するために、インクリメント<type>JSON</type>パーサが追加されました。
(Andrew Dunstan)␞␞      <ulink url="&commit_baseurl;3311ea86e">&sect;</ulink>␞
␝      <para>␟      Convert top-level <filename>README</filename> file to
      <productname>Markdown</productname> (Nathan Bossart)␟トップレベルの<filename>README</filename>ファイルが<productname>Markdown</productname>に変換されました。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;363eb0599">&sect;</ulink>␞
␝      <para>␟      Remove no longer needed top-level <filename>INSTALL</filename> file
      (Tom Lane)␟不要になったトップレベルの<filename>INSTALL</filename>ファイルが削除されました。
(Tom Lane)␞␞      <ulink url="&commit_baseurl;e2b73f4a4">&sect;</ulink>␞
␝      <para>␟      Remove <application>make</application>'s <literal>distprep</literal>
      option (Peter Eisentraut)␟<application>make</application>の<literal>distprep</literal>オプションが削除されました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;721856ff2">&sect;</ulink>␞
␝      <para>␟      Add  <application>make</application> support for
      <productname>Android</productname> shared libraries (Peter
      Eisentraut)␟<productname>Android</productname>共有ライブラリの<application>make</application>サポートが追加されました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;79b03dbb3">&sect;</ulink>␞
␝      <para>␟      Add backend support for injection points (Michael Paquier)␟バックエンドにインジェクションポイントのサポートが追加されました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;d86d20f0b">&sect;</ulink>␞
␝      <para>␟      This is used for server debugging and they must be enabled at server
      compile time.␟これはサーバのデバッグに使用され、サーバのコンパイル時に有効にする必要があります。␞␞      </para>␞
␝      <para>␟      Add dynamic shared memory registry (Nathan Bossart)␟動的共有メモリレジストリが追加されました。
(Nathan Bossart)␞␞      <ulink url="&commit_baseurl;8b2bcf3f2">&sect;</ulink>␞
␝      <para>␟       This allows shared libraries which are not initialized at startup
       to coordinate dynamic shared memory access.␟これにより、起動時に初期化されていない共有ライブラリが、動的な共有メモリアクセスを調整できるようになります。␞␞      </para>␞
␝      <para>␟      Fix <literal>emit_log_hook</literal> to use the same time value as
      other log records for the same query (Kambam Vinay, Michael Paquier)␟同じ問い合わせの他のログレコードと同じ時間値を使用するように<literal>emit_log_hook</literal>が修正されました。
(Kambam Vinay, Michael Paquier)␞␞      <ulink url="&commit_baseurl;2a217c371">&sect;</ulink>␞
␝      <para>␟      Improve documentation for using <literal>jsonpath</literal> for
      predicate checks (David Wheeler)␟述語チェックに<literal>jsonpath</literal>を使用するための文書が改善されました。
(David Wheeler)␞␞      <ulink url="&commit_baseurl;7014c9a4b">&sect;</ulink>␞
␝   <sect3 id="release-17-modules">␟    <title>Additional Modules</title>␟    <title>追加モジュール</title>␞␞␞
␝      <para>␟      Allow joins with non-join qualifications to be pushed down to
      foreign servers and custom scans (Richard Guo, Etsuro Fujita)␟結合以外の条件を持つ結合を、外部サーバとカスタムスキャンにプッシュダウンできるようになりました。
(Richard Guo, Etsuro Fujita)␞␞      <ulink url="&commit_baseurl;9e9931d2b">&sect;</ulink>␞
␝      <para>␟      Foreign data wrappers and custom scans will need to be modified to
      handle these cases.␟外部データラッパーとカスタムスキャンは、これらのケースを処理できるように修正されている必要があります。␞␞      </para>␞
␝      <para>␟      Allow pushdown of <literal>EXISTS</literal> and <literal>IN</literal>
      subqueries to <xref linkend="postgres-fdw"/> foreign servers
      (Alexander Pyhalov)␟<xref linkend="postgres-fdw"/>の外部サーバに<literal>EXISTS</literal>と<literal>IN</literal>の副問い合わせがプッシュダウンできるようになりました。
(Alexander Pyhalov)␞␞      <ulink url="&commit_baseurl;824dbea3e">&sect;</ulink>␞
␝      <para>␟      Increase the default foreign data wrapper tuple cost (David Rowley,
      Umair Shahid)␟デフォルトの外部データラッパータプルコストが増加しました。
(David Rowley, Umair Shahid)␞␞      <ulink url="&commit_baseurl;cac169d68">&sect;</ulink>␞
␝      <para>␟      This value is used by the optimizer.␟この値はオプティマイザで使用されます。␞␞      </para>␞
␝      <para>␟      Allow <link linkend="dblink"><application>dblink</application></link>
      database operations to be interrupted (Noah Misch)␟<link linkend="dblink"><application>dblink</application></link>のデータベース操作が中断できるようになりました。
(Noah Misch)␞␞      <ulink url="&commit_baseurl;d3c5f37dd">&sect;</ulink>␞
␝      <para>␟      Allow the creation of hash indexes on <application><xref
      linkend="ltree"/></application> columns (Tommy Pavlicek)␟<application><xref linkend="ltree"/></application>列にハッシュインデックスが作成できるようになりました。
(Tommy Pavlicek)␞␞      <ulink url="&commit_baseurl;485f0aa85">&sect;</ulink>␞
␝      <para>␟      This also enables hash join and hash aggregation on
      <application>ltree</application> columns.␟これにより、<application>ltree</application>列でのハッシュ結合とハッシュ集約も可能になります。␞␞      </para>␞
␝      <para>␟      Allow <application><xref linkend="unaccent"/></application> character
      translation rules to contain whitespace and quotes (Michael Paquier)␟<application><xref linkend="unaccent"/></application>の文字変換ルールに空白と引用符を含めることができるようになりました。
(Michael Paquier)␞␞      <ulink url="&commit_baseurl;59f47fb98">&sect;</ulink>␞
␝      <para>␟      The syntax for the <filename>unaccent.rules</filename> file has
      changed.␟<filename>unaccent.rules</filename>ファイルの構文が変更されました。␞␞      </para>␞
␝      <para>␟      Allow <application><xref linkend="amcheck"/></application>
      to check for unique constraint violations using new option
      <option>--checkunique</option> (Anastasia Lubennikova, Pavel Borisov,
      Maxim Orlov)␟新しいオプション<option>&#45;-checkunique</option>を使用して、<application><xref linkend="amcheck"/></application>が一意性制約違反をチェックできるようになりました。
(Anastasia Lubennikova, Pavel Borisov, Maxim Orlov)␞␞      <ulink url="&commit_baseurl;5ae208720">&sect;</ulink>␞
␝      <para>␟      Allow <application><xref linkend="citext"/></application> tests to
      pass in OpenSSL <acronym>FIPS</acronym> mode (Peter Eisentraut)␟OpenSSL<acronym>FIPS</acronym>モードで<application><xref linkend="citext"/></application>テストに合格できるようになりました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;3c551ebed">&sect;</ulink>␞
␝      <para>␟      Allow <application><xref linkend="pgcrypto"/></application> tests
      to pass in OpenSSL <acronym>FIPS</acronym> mode (Peter Eisentraut)␟OpenSSL<acronym>FIPS</acronym>モードで<application><xref linkend="pgcrypto"/></application>テストに合格できるようになりました。
(Peter Eisentraut)␞␞      <ulink url="&commit_baseurl;795592865">&sect;</ulink>␞
␝      <para>␟      Remove some unused <link linkend="spi"><acronym>SPI</acronym></link>
      macros (Bharath Rupireddy)␟いくつかの未使用の<link linkend="spi"><acronym>SPI</acronym></link>マクロが削除されました。
(Bharath Rupireddy)␞␞      <ulink url="&commit_baseurl;75680c3d8">&sect;</ulink>␞
␝      <para>␟      Allow <link linkend="sql-alteroperator"><command>ALTER
      OPERATOR</command></link> to set more optimization attributes
      (Tommy Pavlicek)␟<link linkend="sql-alteroperator"><command>ALTER OPERATOR</command></link>でより多くの最適化属性が設定できるようになりました。
(Tommy Pavlicek)␞␞      <ulink url="&commit_baseurl;2b5154bea">&sect;</ulink>␞
␝      <para>␟      This is useful for extensions.␟これは拡張に役立ちます。␞␞      </para>␞
␝      <para>␟      Allow extensions to define <link
      linkend="xfunc-addin-wait-events">custom wait events</link>
      (Masahiro Ikeda)␟拡張で<link linkend="xfunc-addin-wait-events">カスタム待機イベント</link>が定義できるようになりました。
(Masahiro Ikeda)␞␞      <ulink url="&commit_baseurl;c9af05465">&sect;</ulink>␞
␝      <para>␟      Custom wait events have been added to <application><xref
      linkend="postgres-fdw"/></application> and <application><xref
      linkend="dblink"/></application>.␟<application><xref linkend="postgres-fdw"/></application>と<application><xref linkend="dblink"/></application>にカスタム待機イベントが追加されました。␞␞      </para>␞
␝      <para>␟      Add <application><xref linkend="pgbuffercache"/></application>
      function <function>pg_buffercache_evict()</function> to allow shared
      buffer eviction (Palak Chaturvedi, Thomas Munro)␟共有バッファの削除を可能にする<application><xref linkend="pgbuffercache"/></application>の<function>pg_buffercache_evict()</function>関数が追加されました。
(Palak Chaturvedi, Thomas Munro)␞␞      <ulink url="&commit_baseurl;13453eedd">&sect;</ulink>␞
␝      <para>␟      This is useful for testing.␟これはテストに役立ちます。␞␞      </para>␞
␝       <para>␟       Replace <link linkend="sql-call"><command>CALL</command></link>
       parameters in <application>pg_stat_statements</application> with
       placeholders (Sami Imseih)␟<application>pg_stat_statements</application>内の<link linkend="sql-call"><command>CALL</command></link>パラメータがプレースホルダに置き換えられるようになりました。
(Sami Imseih)␞␞       <ulink url="&commit_baseurl;11c34b342">&sect;</ulink>␞
␝       <para>␟       Replace savepoint names stored in
       <structname>pg_stat_statements</structname> with placeholders
       (Greg Sabino Mullane)␟<structname>pg_stat_statements</structname>に保存されているセーブポイント名がプレースホルダに置き換えられるようになりました。
(Greg Sabino Mullane)␞␞       <ulink url="&commit_baseurl;31de7e60d">&sect;</ulink>␞
␝       <para>␟       This greatly reduces the number of entries needed to record <link
       linkend="sql-savepoint"><command>SAVEPOINT</command></link>,
       <link linkend="sql-release-savepoint"><command>RELEASE
       SAVEPOINT</command></link>, and <link
       linkend="sql-rollback-to"><command>ROLLBACK TO
       SAVEPOINT</command></link> commands.␟これにより、<link linkend="sql-savepoint"><command>SAVEPOINT</command></link>、<link linkend="sql-release-savepoint"><command>RELEASE SAVEPOINT</command></link>、<link linkend="sql-rollback-to"><command>ROLLBACK TO SAVEPOINT</command></link>コマンドを記録するために必要なエントリ数が大幅に削減されます。␞␞       </para>␞
␝       <para>␟       Replace the two-phase commit <acronym>GID</acronym>s stored in
       <structname>pg_stat_statements</structname> with placeholders
       (Michael Paquier)␟<structname>pg_stat_statements</structname>に格納されている2相コミットの<acronym>GID</acronym>がプレースホルダに置き換えられました。
(Michael Paquier)␞␞       <ulink url="&commit_baseurl;638d42a3c">&sect;</ulink>␞
␝       <para>␟       This greatly reduces the number of entries needed to record
       <link linkend="sql-prepare-transaction"><command>PREPARE
       TRANSACTION</command></link>, <link
       linkend="sql-commit-prepared"><command>COMMIT
       PREPARED</command></link>, and <link
       linkend="sql-rollback-prepared"><command>ROLLBACK
       PREPARED</command></link>.␟これにより、<link linkend="sql-prepare-transaction"><command>PREPARE TRANSACTION</command></link>、<link linkend="sql-commit-prepared"><command>COMMIT PREPARED</command></link>、<link linkend="sql-rollback-prepared"><command>ROLLBACK PREPARED</command></link>を記録するために必要なエントリ数が大幅に削減されます。␞␞       </para>␞
␝       <para>␟       Track <link
       linkend="sql-deallocate"><command>DEALLOCATE</command></link>
       in <structname>pg_stat_statements</structname> (Dagfinn Ilmari
       Manns&aring;ker, Michael Paquier)␟<structname>pg_stat_statements</structname>で<link linkend="sql-deallocate"><command>DEALLOCATE</command></link>を追跡するようになりました。
(Dagfinn Ilmari Manns&aring;ker, Michael Paquier)␞␞       <ulink url="&commit_baseurl;bb45156f3">&sect;</ulink>␞
␝       <para>␟       <command>DEALLOCATE</command> names are stored in
       <structname>pg_stat_statements</structname> as placeholders.␟<command>DEALLOCATE</command>名はプレースホルダとして<structname>pg_stat_statements</structname>に保存されます。␞␞       </para>␞
␝       <para>␟       Add local I/O block read/write timing statistics columns of
       <structname>pg_stat_statements</structname> (Nazir Bilal Yavuz)␟<structname>pg_stat_statements</structname>にローカルI/Oブロックの読み取り/書き込みタイミング統計列が追加されました。
(Nazir Bilal Yavuz)␞␞       <ulink url="&commit_baseurl;295c36c0c">&sect;</ulink>␞
␝       <para>␟       The new columns are <structfield>local_blk_read_time</structfield>
       and <structfield>local_blk_write_time</structfield>.␟新しい列は、<structfield>local_blk_read_time</structfield>と<structfield>local_blk_write_time</structfield>です。␞␞       </para>␞
␝       <para>␟       Add <acronym>JIT</acronym> deform_counter details to
       <structname>pg_stat_statements</structname> (Dmitry Dolgov)␟<structname>pg_stat_statements</structname>に<acronym>JIT</acronym>deform_counterの詳細が追加されました。
(Dmitry Dolgov)␞␞       <ulink url="&commit_baseurl;5a3423ad8">&sect;</ulink>␞
␝       <para>␟       Add optional fourth argument (<literal>minmax_only</literal>)
       to <function>pg_stat_statements_reset()</function> to allow for
       the resetting of only min/max statistics (Andrei Zubkov)␟最小/最大統計処理のみをリセットできるように、<function>pg_stat_statements_reset()</function>にオプションの4番目の引数(<literal>minmax_only</literal>)が追加されました。
(Andrei Zubkov)␞␞       <ulink url="&commit_baseurl;dc9f8a798">&sect;</ulink>␞
␝       <para>␟       This argument defaults to <literal>false</literal>.␟この引数のデフォルトは<literal>false</literal>です。␞␞       </para>␞
␝       <para>␟       Add <structname>pg_stat_statements</structname>
       columns <structfield>stats_since</structfield> and
       <structfield>minmax_stats_since</structfield> to track entry
       creation time and last min/max reset time (Andrei Zubkov)␟エントリ作成時刻と最後の最小/最大リセット時刻を追跡するために、<structname>pg_stat_statements</structname>に<structfield>stats_since</structfield>と<structfield>minmax_stats_since</structfield>列が追加されました。
(Andrei Zubkov)␞␞       <ulink url="&commit_baseurl;dc9f8a798">&sect;</ulink>␞
␝  <sect2 id="release-17-acknowledgements">␟   <title>Acknowledgments</title>␟   <title>謝辞</title>␞␞␞
␝   <para>␟    The following individuals (in alphabetical order) have contributed
    to this release as patch authors, committers, reviewers, testers,
    or reporters of issues.␟以下の人々（アルファベット順）はパッチ作者、コミッター、レビューア、テスターあるいは問題の報告者として本リリースに貢献しました。␞␞   </para>␞
