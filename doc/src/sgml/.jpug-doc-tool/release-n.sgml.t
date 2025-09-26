␝ <sect1 id="release-16-4">␟  <title>Release 16.4</title>␟  <title>リリース16.4</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2024-08-08</para>␞
␝  <para>␟   This release contains a variety of fixes from 16.3.
   For information about new features in major release 16, see
   <xref linkend="release-16"/>.␟このリリースは16.3に対し、様々な不具合を修正したものです。
16メジャーリリースにおける新機能については、<xref linkend="release-16"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-16-4-migration">␟   <title>Migration to Version 16.4</title>␟   <title>バージョン16.4への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 16.X.␟16.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, if you are upgrading from a version earlier than 16.3,
    see <xref linkend="release-16-3"/>.␟また、16.3より前のバージョンからアップグレードする場合は、<xref linkend="release-16-3"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-16-4-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Prevent unauthorized code execution
      during <application>pg_dump</application> (Masahiko Sawada)␟<application>pg_dump</application>中の不正なコード実行を防止しました。
(Masahiko Sawada)␞␞     </para>␞
␝     <para>␟      An attacker able to create and drop non-temporary objects could
      inject SQL code that would be executed by a
      concurrent <application>pg_dump</application> session with the
      privileges of the role running <application>pg_dump</application>
      (which is often a superuser).  The attack involves replacing a
      sequence or similar object with a view or foreign table that will
      execute malicious code.  To prevent this, introduce a new server
      parameter <varname>restrict_nonsystem_relation_kind</varname> that
      can disable expansion of non-builtin views as well as access to
      foreign tables, and teach <application>pg_dump</application> to set
      it when available.  Note that the attack is prevented only if
      both <application>pg_dump</application> and the server it is dumping
      from are new enough to have this fix.␟非一時的オブジェクトの作成と削除が可能な攻撃者は、<application>pg_dump</application>を実行しているロール（多くの場合スーパーユーザ）の権限で、並列<application>pg_dump</application>セッションによって実行されるSQLコードを注入することが出来ました。
この攻撃では、シーケンスや同様のオブジェクトを、悪意のあるコードを実行するビューまたは外部テーブルに置き換えます。
これを防ぐために、組み込み以外のビューの展開や外部テーブルへのアクセスを無効にすることができる新しいサーバパラメータ<varname>restrict_nonsystem_relation_kind</varname>を導入し、利用可能な場合にはそれを設定するよう<application>pg_dump</application>に指示します。
この攻撃の防止は、<application>pg_dump</application>とダンプ元のサーバの両方がこの修正を適用できるほど十分新しい場合に限られます。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Noah Misch for reporting this problem.
      (CVE-2024-7348)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたNoah Mischに感謝します。
(CVE-2024-7348)␞␞     </para>␞
␝     <para>␟      Avoid incorrect results from Merge Right Anti Join plans
      (Richard Guo)␟Merge Right Anti Joinプランから生じる不正確な結果を回避しました。
(Richard Guo)␞␞     </para>␞
␝     <para>␟      If the inner relation is known to have unique join keys, the merge
      could misbehave when there are duplicated join keys in the outer
      relation.␟内側のリレーションに一意の結合キーがあることがわかっている場合、外側リレーションに重複した結合キーがあるとマージが誤動作をする可能性がありました。␞␞     </para>␞
␝     <para>␟      Prevent infinite loop in <command>VACUUM</command>
      (Melanie Plageman)␟<command>VACUUM</command>の無限ループを防止しました。
(Melanie Plageman)␞␞     </para>␞
␝     <para>␟      After a disconnected standby server with an old running transaction
      reconnected to the primary, it was possible
      for <command>VACUUM</command> on the primary to get confused about
      which tuples are removable, resulting in an infinite loop.␟古い実行中のトランザクションを持つ切断されたスタンバイサーバがプライマリに再接続されると、プライマリの<command>VACUUM</command>がどのタプルが削除可能であるかについて混乱し、無限ループが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix failure after attaching a table as a partition, if the
      table had previously had inheritance children
      (&Aacute;lvaro Herrera)␟以前、継承ツリーの子テーブルが存在していたテーブルをパーティションとしてアタッチした後に発生する障害を修正しました。
(&Aacute;lvaro Herrera)␞␞     </para>␞
␝     <para>␟      Fix <command>ALTER TABLE DETACH PARTITION</command> for cases
      involving inconsistent index-based constraints
      (&Aacute;lvaro Herrera, Tender Wang)␟一貫性がないインデックスベース制約が関連する場合の<command>ALTER TABLE DETACH PARTITION</command>を修正しました。
(&Aacute;lvaro Herrera, Tender Wang)␞␞     </para>␞
␝     <para>␟      When a partitioned table has an index that is not associated with a
      constraint, but a partition has an equivalent index that is, then
      detaching the partition would misbehave, leaving the ex-partition's
      constraint with an incorrect <structfield>coninhcount</structfield>
      value.  This would cause trouble during any further manipulations of
      that constraint.␟パーティションテーブルに、制約と関連付けられていないインデックスがあり、パーティションに同等の制約を持つインデックスがある場合、パーティションをデタッチすると不正な動作となり、元のパーティションの制約に誤った<structfield>coninhcount</structfield>値が残ります。
これにより、その制約をさらに操作する際に問題が発生していました。␞␞     </para>␞
␝     <para>␟      Fix partition pruning setup during <literal>ALTER TABLE DETACH
      PARTITION CONCURRENTLY</literal> (&Aacute;lvaro Herrera)␟<literal>ALTER TABLE DETACH PARTITION CONCURRENTLY</literal>実行中のパーティションプルーニング設定を修正しました。
(&Aacute;lvaro Herrera)␞␞     </para>␞
␝     <para>␟      The executor assumed that no partition could be detached between
      planning and execution of a query on a partitioned table.  This is
      no longer true since the introduction of <literal>DETACH
      PARTITION</literal>'s <literal>CONCURRENTLY</literal> option, making
      it possible for query execution to fail transiently when that is
      used.␟エグゼキュータは、パーティションテーブルでのクエリの計画と実行の間にパーティションをデタッチできないと想定していました。
<literal>DETACH PARTITION</literal>の<literal>CONCURRENTLY</literal>オプションが導入されてからこれは成り立たなくなり、このオプションが使用する問い合わせの実行が一時的に失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      Correctly update a partitioned table's
      <structname>pg_class</structname>.<structfield>reltuples</structfield>
      field to zero after its last child partition is dropped (Noah Misch)␟パーティションテーブルから最後の子パーティションが削除された後、<structname>pg_class</structname>.<structfield>reltuples</structfield>フィールドを正しくゼロに更新するようにしました。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      The first <command>ANALYZE</command> on such a partitioned table
      must update <structfield>relhassubclass</structfield> as well, and
      that caused the <structfield>reltuples</structfield> update to be
      lost.␟このようなパーティションテーブルの最初の<command>ANALYZE</command>では<structfield>relhassubclass</structfield>も更新する必要があり、これにより<structfield>reltuples</structfield>の更新が失われていました。␞␞     </para>␞
␝     <para>␟      Fix handling of polymorphic output arguments for procedures
      (Tom Lane)␟プロシージャの多様OUT引数の処理を修正しました。
 (Tom Lane)␞␞     </para>␞
␝     <para>␟      The SQL <command>CALL</command> statement did not resolve the
      correct data types for such arguments, leading to errors such
      as <quote>cannot display a value of type anyelement</quote>, or even
      outright crashes.  (But <command>CALL</command>
      in <application>PL/pgSQL</application> worked correctly.)␟SQLの<command>CALL</command>文では、このような引数の正しいデータ型を解決できなかったため、<quote>cannot display a value of type anyelement</quote>などのエラーや、クラッシュを引き起こしました。
（ただし、<application>PL/pgSQL</application>の<command>CALL</command>は正常に動作しました。）␞␞     </para>␞
␝     <para>␟      Fix behavior of stable functions called from
      a <command>CALL</command> statement's argument list (Tom Lane)␟<command>CALL</command>文の引数リストから呼び出されるSTABLE関数の動作を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If the <command>CALL</command> is within an atomic context
      (e.g. there's an outer transaction block), such functions were
      passed the wrong snapshot, causing them to see stale values of rows
      modified since the start of the outer transaction.␟<command>CALL</command>が原子的コンテキスト内にある場合（例えば、外側のトランザクションブロックがある場合）、そのような関数には間違ったスナップショットが渡され、外側トランザクションの開始以降に変更された行の古い値が表示される原因となっていました。␞␞     </para>␞
␝     <para>␟      Fix input of ISO-8601 <quote>extended</quote> time format for
      types <type>time</type> and <type>timetz</type> (Tom Lane)␟<type>time</type>型および<type>timetz</type>型に対するISO-8601<quote>拡張</quote>時間書式の入力を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Re-allow cases such as <literal>T12:34:56</literal>.␟<literal>T12:34:56</literal>などのケースを再度許可しました。␞␞     </para>␞
␝     <para>␟      Detect integer overflow in <type>money</type> calculations
      (Joseph Koshakow)␟<type>money</type>型の計算で整数オーバーフローを検出するようにしました。
(Joseph Koshakow)␞␞     </para>␞
␝     <para>␟      None of the arithmetic functions for the <type>money</type> type
      checked for overflow before, so they would silently give wrong
      answers for overflowing cases.␟これまで<type>money</type>型の算術関数はいずれもオーバーフローをチェックしなかったので、オーバーフローが発生した場合に黙って間違った答えを出していました。␞␞     </para>␞
␝     <para>␟      Fix over-aggressive clamping of the scale argument
      in <function>round(numeric)</function>
      and <function>trunc(numeric)</function> (Dean Rasheed)␟<function>round(numeric)</function>関数と<function>trunc(numeric)</function>関数のスケール引数の過度に積極的な制限を修正しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      These functions clamped their scale argument to +/-2000, but there
      are valid use-cases for it to be larger; the functions returned
      incorrect results in such cases.  Instead clamp to the actual
      allowed range of type <type>numeric</type>.␟これらの関数は、スケール引数を+/-2000に制限しましたが、これより大きい値を使用する有効な使用例があります。
このような場合、関数は誤った結果を返しました。
代わりに、<type>numeric</type>型の実際の許容範囲に制限するようにしました。␞␞     </para>␞
␝     <para>␟      Fix result for <function>pg_size_pretty()</function> when applied to
      the smallest possible <type>bigint</type> value (Joseph Koshakow)␟可能な限り最小の<type>bigint</type>値に適用した場合の<function>pg_size_pretty()</function>の結果を修正しました。
(Joseph Koshakow)␞␞     </para>␞
␝     <para>␟      Prevent <function>pg_sequence_last_value()</function> from failing
      on unlogged sequences on standby servers and on temporary sequences
      of other sessions (Nathan Bossart)␟<function>pg_sequence_last_value()</function>がスタンバイサーバのログに記録されていないシーケンスや他のセッションの一時シーケンスで失敗しないようにしました。
(Nathan Bossart)␞␞     </para>␞
␝     <para>␟      Make it return NULL in these cases instead of throwing an error.␟これらの場合、エラーとはせずNULLを返すようにします。␞␞     </para>␞
␝     <para>␟      Fix parsing of ignored operators
      in <function>websearch_to_tsquery()</function> (Tom Lane)␟<function>websearch_to_tsquery()</function>で無視される演算子の解析を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Per the manual, punctuation in the input
      of <function>websearch_to_tsquery()</function> is ignored except for
      the special cases of dashes and quotes.  However, parentheses and a
      few other characters appearing immediately before
      an <literal>or</literal> could cause <literal>or</literal> to be
      treated as a data word, rather than as an <literal>OR</literal>
      operator as expected.␟マニュアルによると、<function>websearch_to_tsquery()</function>の入力内の句読点は、ダッシュと引用符の特殊な場合を除いて無視されます。
ただし、<literal>or</literal>の直前に括弧や他のいくつかの文字があると、<literal>or</literal>が期待された<literal>OR</literal>演算子ではなく、データ単語として扱われる可能性がありました。␞␞     </para>␞
␝     <para>␟      Detect another integer overflow case while computing new array
      dimensions (Joseph Koshakow)␟新しい配列の次元を計算するときに、別な種類の整数オーバーフローのケースを検出するようにしました。
(Joseph Koshakow)␞␞     </para>␞
␝     <para>␟      Reject applying array
      dimensions <literal>[-2147483648:2147483647]</literal> to an empty
      array.  This is closely related to CVE-2023-5869, but appears
      harmless since the array still ends up empty.␟配列の次元<literal>[-2147483648:2147483647]</literal>を空の配列に適用することを拒否します。
これはCVE-2023-5869と密接に関連していますが、配列は依然として空のままなので無害に見えます。␞␞     </para>␞
␝     <para>␟      Fix unportable usage of <function>strnxfrm()</function> (Jeff Davis)␟<function>strnxfrm()</function>の移植性のない使用法を修正しました。
(Jeff Davis)␞␞     </para>␞
␝     <para>␟      Some code paths for non-deterministic collations could fail with
      errors like <quote>pg_strnxfrm() returned unexpected result</quote>.␟非決定的な照合順序の一部のコードパスには、<quote>pg_strnxfrm() returned unexpected result</quote>のようなエラーで失敗するものがありました。␞␞     </para>␞
␝     <para>␟      Detect another case of a new catalog cache entry becoming stale
      while detoasting its fields (Noah Misch)␟新しいカタログキャッシュエントリが、そのフィールドのTOAST展開中に古くなる別のケースを検出するようにしました。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      An in-place update occurring while we expand out-of-line fields in a
      catalog tuple could be missed, leading to a catalog cache entry that
      lacks the in-place change but is not known to be stale.  This is
      only possible in the <structname>pg_database</structname> catalog,
      so the effects are narrow, but misbehavior is possible.␟カタログタプルの行外フィールドを展開している間に発生したその場での更新は見逃される可能性があり、その場での変更がないものの古くなったことがわからないカタログキャッシュエントリにつながる可能性があります。
これは<structname>pg_database</structname>カタログでのみ可能であるため、影響は限定的ですが、誤動作の可能性があります。␞␞     </para>␞
␝     <para>␟      Correctly check updatability of view columns targeted
      by <literal>INSERT</literal> ... <literal>DEFAULT</literal>
      (Tom Lane)␟<literal>INSERT</literal> ... <literal>DEFAULT</literal>の対象となるビュー列の更新可能性を正しくチェックするようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If such a column is non-updatable, we should give an error reporting
      that.  But the check was missed and then later code would report an
      unhelpful error such as <quote>attribute
      number <replaceable>N</replaceable> not found in view
      targetlist</quote>.␟そのような列が更新不可能な場合は、そのことを報告するエラーを返す必要があります。
しかし、そのチェックは見逃され、後のコードで<quote>attribute number <replaceable>N</replaceable> not found in view targetlist</quote>などの役に立たないエラーが報告されていました。␞␞     </para>␞
␝     <para>␟      Avoid reporting an unhelpful internal error for incorrect recursive
      queries (Tom Lane)␟不正な再帰問い合わせに対して、役に立たない内部エラーを報告しないようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Rearrange the order of error checks so that we throw an on-point
      error when a <command>WITH RECURSIVE</command> query does not have a
      self-reference within the second arm of
      the <literal>UNION</literal>, but does have one self-reference in
      some other place such as <literal>ORDER BY</literal>.␟エラーチェックの順序を変更して、<command>WITH RECURSIVE</command>問い合わせが<literal>UNION</literal>の2番目の枝内に自己参照を持たないが、<literal>ORDER BY</literal>などの他の場所に1つの自己参照を持つ場合に、適切なエラーを発生するようにしました。␞␞     </para>␞
␝     <para>␟      Lock owned sequences during <literal>ALTER TABLE SET
      LOGGED|UNLOGGED</literal> (Noah Misch)␟<literal>ALTER TABLE SET LOGGED|UNLOGGED</literal>の実行中に所有シーケンスをロックするようにしました。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      These commands change the persistence of a table's owned sequences
      along with the table, but they failed to acquire lock on the
      sequences while doing so.  This could result in losing the effects
      of concurrent <function>nextval()</function> calls.␟これらのコマンドは、テーブルとともにテーブルの所有シーケンスの永続性を変更しますが、その際にシーケンス上のロックを取得してませんでした。
その結果、同時実行中の<function>nextval()</function>呼び出しの効果が失われる可能性がありました。␞␞     </para>␞
␝     <para>␟      Don't throw an error if a queued <literal>AFTER</literal> trigger no
      longer exists (Tom Lane)␟キューに入れられた<literal>AFTER</literal>トリガがもはや存在しない場合は、エラーを発生しないようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      It's possible for a transaction to execute an operation that queues
      a deferred <literal>AFTER</literal> trigger for later execution, and
      then to drop the trigger before that happens.  Formerly this led to
      weird errors such as <quote>could not find
      trigger <replaceable>NNNN</replaceable></quote>.  It seems better to
      silently do nothing if the trigger no longer exists at the time when
      it would have been executed.␟トランザクションが、後で実行するために遅延された<literal>AFTER</literal>トリガをキューに入れる操作を実行し、その前にトリガを削除する可能性がありました。
以前は、これにより<quote>could not find trigger <replaceable>NNNN</replaceable></quote>などの奇妙なエラーが発生していました。
トリガが実行されるはずの時点でもはや存在しない場合は、黙って何もしない方が良いようです。␞␞     </para>␞
␝     <para>␟      Fix failure to remove <structname>pg_init_privs</structname> entries
      for column-level privileges when their table is dropped (Tom Lane)␟テーブルが削除されたときに、列レベル権限の<structname>pg_init_privs</structname>エントリを削除できない問題を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If an extension grants some column-level privileges on a table it
      creates, relevant catalog entries would remain behind after the
      extension is dropped.  This was harmless until/unless the table's
      OID was re-used for another relation, when it could interfere with
      what <application>pg_dump</application> dumps for that relation.␟拡張が作成したテーブルに列レベル権限を付与した場合、拡張が削除された後も関連するカタログエントリが残っていました。
これは、テーブルのOIDが別のリレーションに再利用されるまで/もしくは再利用されない限り無害でしたが、再利用されると<application>pg_dump</application>がそのリレーションに対してダンプする内容に干渉する可能性がありました。
ダンプ␞␞     </para>␞
␝     <para>␟      Fix selection of an arbiter index for <literal>ON CONFLICT</literal>
      when the desired index has expressions or predicates (Tom Lane)␟望ましいインデックスに式または述語がある場合、<literal>ON CONFLICT</literal>に対する調停インデックスの選択を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If a query using <literal>ON CONFLICT</literal> accesses the target
      table through an updatable view, it could fail with <quote>there is
      no unique or exclusion constraint matching the ON CONFLICT
      specification</quote>, even though a matching index does exist.␟<literal>ON CONFLICT</literal>を使用する問い合わせが、更新可能なビューを介してターゲットテーブルにアクセスする場合、適合するインデックスが存在する場合でも、<quote>there is no unique or exclusion constraint matching the ON CONFLICT specification</quote>というエラーで失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      Refuse to modify a temporary table of another session
      with <literal>ALTER TABLE</literal> (Tom Lane)␟<literal>ALTER TABLE</literal>を使用して別のセッションの一時テーブルを変更することを拒否するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Permissions checks normally would prevent this case from arising,
      but it is possible to reach it by altering a parent table whose
      child is another session's temporary table.  Throw an error if we
      discover that such a child table belongs to another session.␟通常は権限チェックによってこのケースは発生しませんが、別のセッションの一時テーブルを子テーブルとする親テーブルを変更することによって、このケースに到達する可能性がありました。
このような子のテーブルが別のセッションに属していることが判明した場合は、エラーを発生します。␞␞     </para>␞
␝     <para>␟      Fix handling of extended statistics on expressions
      in <literal>CREATE TABLE LIKE STATISTICS</literal> (Tom Lane)␟<literal>CREATE TABLE LIKE STATISTICS</literal>の式の拡張統計の処理を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      The <literal>CREATE</literal> command failed to adjust column
      references in statistics expressions to the possibly-different
      column numbering of the new table.  This resulted in invalid
      statistics objects that would cause problems later.  A typical
      scenario where renumbering columns is needed is when the source
      table contains some dropped columns.␟<literal>CREATE</literal>コマンドは、統計式内の列参照を、新しいテーブルの番号付けとは異なる可能性のある列番号に調整できませんでした。
その結果、後で問題を引き起こす無効な統計オブジェクトが生成されました。
列の再番号付けが必要になる典型的なシナリオは、ソーステーブルに削除された列が含まれている場合です。␞␞     </para>␞
␝     <para>␟      Fix failure to recalculate sub-queries generated
      from <function>MIN()</function> or <function>MAX()</function>
      aggregates (Tom Lane)␟<function>MIN()</function>または<function>MAX()</function>集約から生成された副問い合わせの再計算の失敗を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      In some cases the aggregate result computed at one row of the outer
      query could be re-used for later rows when it should not be.  This
      has only been seen to happen when the outer query uses
      <literal>DISTINCT</literal> that is implemented with hash
      aggregation, but other cases may exist.␟場合によっては、外部問い合わせの1行で計算された集約結果が、後の行で再利用されるべきではないのに再利用されることがありました。
これは、外部問い合わせがハッシュ集約で実装された<literal>DISTINCT</literal>を使用する場合にのみ発生することが確認されていますが、他のケースも存在する可能性があります。␞␞     </para>␞
␝     <para>␟      Re-forbid underscore in positional parameters (Erik Wienhold)␟位置パラメータでアンダースコアを再度禁止しました。
(Erik Wienhold)␞␞     </para>␞
␝     <para>␟      As of v16 we allow integer literals to contain underscores.
      This change caused input such as <literal>$1_234</literal>
      to be taken as a single token, but it did not work correctly.
      It seems better to revert to the original definition in which a
      parameter symbol is only <literal>$</literal> followed by digits.␟v16では、整数リテラルにアンダースコアを含めることができます。
この変更により、<literal>$1_234</literal>などの入力が単一のトークンと見なされるようになりましたが、正しく動作しませんでした。
パラメータ記号は<literal>$</literal>の後に数字が続くだけの元の定義に戻した方がよさそうです。␞␞     </para>␞
␝     <para>␟      Avoid crashing when a JIT-inlined backend function throws an error
      (Tom Lane)␟JITでインライン化されたバックエンド関数でエラーが発生した時にクラッシュしないようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      The error state can include pointers into the dynamically loaded
      module holding the JIT-compiled code (for error location strings).
      In some code paths the module could get unloaded before the error
      report is processed, leading to SIGSEGV when the location strings
      are accessed.␟エラー状態には、JITコンパイルされたコード（エラー位置の文字列用）を保持する動的にロードされたモジュールへのポインタを含めることができます。
一部のコードパスでは、エラーレポートが処理される前にモジュールがアンロードされ、位置の文字列にアクセスした時にSIGSEGVが発生しました。␞␞     </para>␞
␝     <para>␟      Cope with behavioral changes in <application>libxml2</application>
      version 2.13.x (Erik Wienhold, Tom Lane)␟<application>libxml2</application>バージョン2.13.xでの振る舞い変更に対処しました。
(Erik Wienhold, Tom Lane)␞␞     </para>␞
␝     <para>␟      Notably, we now suppress <quote>chunk is not well balanced</quote>
      errors from <application>libxml2</application>, unless that is the
      only reported error.  This is to make error reports consistent
      between 2.13.x and earlier <application>libxml2</application>
      versions.  In earlier versions, that message was almost always
      redundant or outright incorrect, so 2.13.x substantially reduced the
      number of cases in which it's reported.␟特に、報告されたエラーがそれだけでない限り、<application>libxml2</application>からの<quote>chunk not well balanced</quote>エラーを抑制するようになりました。
これは、2.13.xと以前の<application>libxml2</application>バージョンの間でエラー報告の一貫性を保つためです。
以前のバージョンでは、このメッセージはほとんどの場合冗長であったり、完全に間違っていたため、2.13.xでは報告されるケースの数が大幅に減少しました。␞␞     </para>␞
␝     <para>␟      Fix handling of subtransactions of prepared transactions
      when starting a hot standby server (Heikki Linnakangas)␟ホットスタンバイサーバ起動時の準備されたトランザクションのサブトランザクション処理を修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      When starting a standby's replay at a shutdown checkpoint WAL
      record, transactions that had been prepared but not yet committed on
      the primary are correctly understood as being still in progress.
      But subtransactions of a prepared transaction (created by savepoints
      or <application>PL/pgSQL</application> exception blocks) were not
      accounted for and would be treated as aborted.  That led to
      inconsistency if the prepared transaction was later committed.␟シャットダウンのチェックポイントWALレコードでスタンバイのリプレイを開始する場合、プライマリで準備されたがまだコミットされていないトランザクションは、まだ進行中であると正しく理解されます。
しかし、準備されたトランザクションのサブトランザクション（セーブポイントまたは<application>PL/pgSQL</application>例外ブロックによって作成されたもの）は考慮されず、中止されたものとして扱われました。
このため、準備されたトランザクションが後でコミットされた場合に矛盾が生じました。␞␞     </para>␞
␝     <para>␟      Prevent incorrect initialization of logical replication slots
      (Masahiko Sawada)␟論理レプリケーションスロットの誤った初期設定を防止するようにしました。
(Masahiko Sawada)␞␞     </para>␞
␝     <para>␟      In some cases a replication slot's start point within the WAL stream
      could be set to a point within a transaction, leading to assertion
      failures or incorrect decoding results.␟場合によっては、WALストリーム内のレプリケーションスロットの開始点がトランザクション内のポイントに設定され、アサーションエラーや誤ったデコード結果が発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid <quote>can only drop stats once</quote> error during
      replication slot creation and drop (Floris Van Nee)␟レプリケーションスロットの作成と削除時に<quote>can only drop stats once</quote>というエラーが発生しないようにしました。
(Floris Van Nee)␞␞     </para>␞
␝     <para>␟      Fix resource leakage in logical replication WAL sender (Hou Zhijie)␟論理レプリケーションのWAL senderのリソースリークを修正しました。
(Hou Zhijie)␞␞     </para>␞
␝     <para>␟      The walsender process leaked memory when publishing changes to a
      partitioned table whose partitions have row types physically
      different from the partitioned table's.␟walsenderプロセスは、パーティションテーブルと物理的に異なる行タイプのパーティションテーブルへの変更をパブリッシュするときに、メモリをリークしました。␞␞     </para>␞
␝     <para>␟      Avoid memory leakage after servicing a notify or sinval interrupt
      (Tom Lane)␟notifyまたはsinval割り込みを処理した後のメモリリークを回避しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      The processing functions for these events could switch the current
      memory context to TopMemoryContext, resulting in session-lifespan
      leakage of any data allocated before the incorrect setting gets
      replaced.  There were observable leaks associated with (at least)
      encoding conversion of incoming queries and parameters attached to
      Bind messages.␟これらのイベントの処理関数は、現在のメモリコンテキストをTopMemoryContextに切り替える可能性があり、その結果、誤った設定が置き換えられる前に割り当てられたデータのセッション存続期間のリークが発生します。
（少なくとも）受信した問い合わせとBindメッセージに付加されたパラメータのエンコーディング変換に関連するリークが観察されました。␞␞     </para>␞
␝     <para>␟      Prevent leakage of reference counts for the shared memory block used
      for statistics (Anthonin Bonnefoy)␟統計情報に使用される共有メモリブロックの参照カウントの漏洩を防止しました。
(Anthonin Bonnefoy)␞␞     </para>␞
␝     <para>␟      A new backend process attaching to the statistics shared memory
      incremented its reference count, but failed to decrement the count
      when exiting.  After 2<superscript>32</superscript> sessions had
      been created, the reference count would overflow to zero, causing
      failures in all subsequent backend process starts.␟統計情報の共有メモリに接続する新しいバックエンドプロセスは、参照カウントを増加させましたが、終了時にカウントを減じていませんでした。
2<superscript>32</superscript>セッションが作成された後、参照カウントはゼロにオーバーフローして、その後のすべてのバックエンドプロセスの起動が失敗しました。␞␞     </para>␞
␝     <para>␟      Prevent deadlocks and assertion failures during truncation of the
      multixact SLRU log (Heikki Linnakangas)␟マルチトランザクションのSLRUログの切り捨て中のデッドロックとアサーションエラーを防止しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      A process trying to delete SLRU segments could deadlock with the
      checkpointer process.␟SLRUセグメントを削除しようとするプロセスは、チェックポインタプロセスとデッドロックする可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid possibly missing end-of-input events on Windows sockets
      (Thomas Munro)␟Windowsソケットでの入力終了イベントが失われる可能性を回避しました。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      Windows reports an FD_CLOSE event only once after the remote end of
      the connection disconnects.  With unlucky timing, we could miss that
      report and wait indefinitely, or at least until a timeout elapsed,
      expecting more input.␟Windowsは接続のリモート側が切断された後にFD_CLOSEイベントを1回だけ報告します。
タイミングが悪いと、その報告を見逃して、さらに入力があることを期待して、無期限にまたは少なくともタイムアウトが経過するまで待機する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix buffer overread in JSON parse error reports for incomplete byte
      sequences (Jacob Champion)␟JSON解析エラー報告における不完全なバイトシーケンスに対するバッファのオーバーリードを修正しました。
(Jacob Champion)␞␞     </para>␞
␝     <para>␟      It was possible to walk off the end of the input buffer by a few
      bytes when the last bytes comprise an incomplete multi-byte
      character.  While usually harmless, in principle this could cause a
      crash.␟最後のバイトが不完全なマルチバイト文字で構成している場合、入力バッファの終端から数バイト離れる可能性がありました。
通常は無害ですが、原理的にはクラッシュを引き起こす可能性がありました。
バイト␞␞     </para>␞
␝     <para>␟      Disable creation of stateful TLS session tickets by OpenSSL
      (Daniel Gustafsson)␟OpenSSLによるステートフルTLSセッションチケットの作成を無効にしました。
(Daniel Gustafsson)␞␞     </para>␞
␝     <para>␟      This avoids possible failures with clients that think receipt of
      a session ticket means that TLS session resumption is supported.␟これにより、セッションチケットの受信はTLSセッション再開サポートを意味すると考えるクライアントで発生する可能性のある障害が回避されます。␞␞     </para>␞
␝     <para>␟      When replanning a <application>PL/pgSQL</application> <quote>simple
      expression</quote>, check it's still simple (Tom Lane)␟<application>PL/pgSQL</application>の<quote>単純な式(simple expression)</quote>を再計画する場合、それがまだ単純であることを確認するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Certain fairly-artificial cases, such as dropping a referenced
      function and recreating it as an aggregate, could lead to surprising
      failures such as <quote>unexpected plan node type</quote>.␟参照されている関数を削除して集約として再作成するような、かなり人為的なケースでは、<quote>unexpected plan node type</quote>などの予期せぬ障害が発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix <application>PL/pgSQL</application>'s handling of integer ranges
      containing underscores (Erik Wienhold)␟<application>PL/pgSQL</application>で、アンダースコアを含む整数範囲の処理を修正しました。
(Erik Wienhold)␞␞     </para>␞
␝     <para>␟      As of v16 we allow integer literals to contain underscores,
      but <application>PL/pgSQL</application> failed to handle examples
      such as <literal>FOR i IN 1_001..1_003</literal>.␟v16では整数リテラルにアンダースコアを含めることができますが、<application>PL/pgSQL</application>は<literal>FOR i IN 1_001.1_003</literal>のような例を処理できませんでした。␞␞     </para>␞
␝     <para>␟      Fix recursive <type>RECORD</type>-returning
      <application>PL/Python</application> functions (Tom Lane)␟再帰的に<type>RECORD</type>を返す<application>PL/Python</application>関数を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If we recurse to a new call of the same function that passes a
      different column definition list (<literal>AS</literal> clause), it
      would fail because the inner call would overwrite the outer call's
      idea of what rowtype to return.␟異なる列定義リスト（<literal>AS</literal>句）を渡す同じ関数の新しい呼び出しで再帰する場合、内部呼び出しが外側の呼び出しの返す行型を上書きするため、失敗しました。␞␞     </para>␞
␝     <para>␟      Don't corrupt <application>PL/Python</application>'s
      <literal>TD</literal> dictionary during a recursive trigger call
      (Tom Lane)␟<application>PL/Python</application>で再帰トリガ呼び出し中に<literal>TD</literal>辞書を破壊しないよう修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If a <application>PL/Python</application>-language trigger caused
      another one to be invoked, the <literal>TD</literal> dictionary
      created for the inner one would overwrite the outer
      one's <literal>TD</literal> dictionary.␟<application>PL/Python</application>言語のトリガによって別のトリガが呼び出された場合、内側のトリガのために作成された<literal>TD</literal>辞書が外側のトリガの<literal>TD</literal>辞書を上書きしていました。␞␞     </para>␞
␝     <para>␟      Fix <application>PL/Tcl</application>'s reporting of invalid list
      syntax in the result of a function returning tuple (Erik Wienhold,
      Tom Lane)␟タプルを返す関数の結果で無効なリスト構文を報告する<application>PL/Tcl</application>を修正しました。
(Erik Wienhold, Tom Lane)␞␞     </para>␞
␝     <para>␟      Such a case could result in a crash, or in emission of misleading
      context information that actually refers to the previous Tcl error.␟このようなケースでは、クラッシュが発生したり、実際には以前のTclエラーを参照する誤解を招くようなコンテキスト情報が出力されたりする可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid non-thread-safe usage of <function>strerror()</function>
      in <application>libpq</application> (Peter Eisentraut)␟<application>libpq</application>での<function>strerror()</function>のスレッドセーフではない使用を避けました。
(Peter Eisentraut)␞␞     </para>␞
␝     <para>␟      Certain error messages returned by OpenSSL could become garbled in
      multi-threaded applications.␟OpenSSLによって返される特定のエラーメッセージが、マルチスレッドアプリケーションで文字化けする可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid memory leak within <application>pg_dump</application> during a
      binary upgrade (Daniel Gustafsson)␟バイナリアップグレード処理中の<application>pg_dump</application>でのメモリリークを回避しました。
(Daniel Gustafsson)␞␞     </para>␞
␝     <para>␟      Ensure that <literal>pg_restore</literal> <option>-l</option>
      reports dependent TOC entries correctly (Tom Lane)␟<literal>pg_restore</literal> <option>-l</option>が依存しているTOCエントリを正しく報告するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If <option>-l</option> was specified together with selective-restore
      options such as <option>-n</option> or <option>-N</option>,
      dependent TOC entries such as comments would be omitted from the
      listing, even when an actual restore would have selected them.␟<option>-l</option>が<option>-n</option>や<option>-N</option>などの選択的なリストアオプションと一緒に指定された場合、実際のリストアではそれらを選択されていたとしても、コメントなどの依存TOCエントリはリストから省略されていました。␞␞     </para>␞
␝     <para>␟      Allow <filename>contrib/pg_stat_statements</filename> to distinguish
      among utility statements appearing within SQL-language functions
      (Anthonin Bonnefoy)␟<filename>contrib/pg_stat_statements</filename>がSQL言語関数内に現れるユーティリティ文を区別できるようにしました。
(Anthonin Bonnefoy)␞␞     </para>␞
␝     <para>␟      The SQL-language function executor failed to pass along the query ID
      that is computed for a utility
      (non <command>SELECT</command>/<command>INSERT</command>/<command>UPDATE</command>/<command>DELETE</command>/<command>MERGE</command>)
      statement.␟SQL言語関数のエグゼキュータは、ユーティリティ文（非<command>SELECT</command>/<command>INSERT</command>/<command>UPDATE</command>/<command>DELETE</command>/<command>MERGE</command>）に対して計算された問い合わせ識別子を渡すことに失敗していました。
ユーティリティ␞␞     </para>␞
␝     <para>␟      Avoid <quote>cursor can only scan forward</quote> error
      in <filename>contrib/postgres_fdw</filename> (Etsuro Fujita)␟<filename>contrib/postgres_fdw</filename>で<quote>cursor can only scan forward</quote>エラーを回避しました。
(Etsuro Fujita)␞␞     </para>␞
␝     <para>␟      This error could occur if the remote server is v15 or later
      and a foreign table is mapped to a non-trivial remote view.␟このエラーは、リモートサーバがv15以降で、外部テーブルが単純ではないリモートビューにマッピングされている場合に発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      In <filename>contrib/postgres_fdw</filename>, do not
      send <literal>FETCH FIRST WITH TIES</literal> clauses to the remote
      server (Japin Li)␟<filename>contrib/postgres_fdw</filename>で<literal>FETCH FIRST WITH TIES</literal>句をリモートサーバに送信しないようにしました。
(Japin Li)␞␞     </para>␞
␝     <para>␟      The remote server might not implement this clause, or might
      interpret it differently than we would locally, so don't risk
      attempting remote execution.␟リモートサーバはこの句を実装していないか、ローカルとは異なる解釈をする可能性があるため、リモート実行を避けました。␞␞     </para>␞
␝     <para>␟      Avoid clashing with
      system-provided <filename>&lt;regex.h&gt;</filename> headers
      (Thomas Munro)␟システムが提供する<filename>&lt;regex.h&gt;</filename>ヘッダとの衝突を回避しました。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      This fixes a compilation failure on macOS version 15 and up.␟これにより、macOSバージョン15以降でのコンパイルの失敗が修正されます。␞␞     </para>␞
␝     <para>␟      Fix otherwise-harmless assertion failure in Memoize cost estimation
      (David Rowley)␟Memoizeのコスト推定における、無害なアサーションエラーを修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Fix otherwise-harmless assertion failures in <literal>REINDEX
      CONCURRENTLY</literal> applied to an SP-GiST index (Tom Lane)␟SP-GiSTインデックスに対する<literal>REINDEX CONCURRENTLY</literal>実行での無害なアサーションエラーを修正しました。
(Tom Lane)␞␞     </para>␞
␝ <sect1 id="release-16-3">␟  <title>Release 16.3</title>␟  <title>リリース16.3</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2024-05-09</para>␞
␝  <para>␟   This release contains a variety of fixes from 16.2.
   For information about new features in major release 16, see
   <xref linkend="release-16"/>.␟このリリースは16.2に対し、様々な不具合を修正したものです。
16メジャーリリースにおける新機能については、<xref linkend="release-16"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-16-3-migration">␟   <title>Migration to Version 16.3</title>␟   <title>バージョン16.3への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 16.X.␟16.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, a security vulnerability was found in the system
    views <structname>pg_stats_ext</structname>
    and <structname>pg_stats_ext_exprs</structname>, potentially allowing
    authenticated database users to see data they shouldn't.  If this is
    of concern in your installation, follow the steps in the first
    changelog entry below to rectify it.␟しかしながら、システムビュー<structname>pg_stats_ext</structname>と<structname>pg_stats_ext_exprs</structname>にセキュリティ上の脆弱性が見つかり、認証されたデータベースユーザが、本来見るべきでないデータを見ることができる可能性があります。
これがインストール環境で問題となる場合は、次の最初の変更ログの項目に従って修正してください。␞␞   </para>␞
␝   <para>␟    Also, if you are upgrading from a version earlier than 16.2,
    see <xref linkend="release-16-2"/>.␟また、16.2より前のバージョンからアップグレードする場合は、<xref linkend="release-16-2"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-16-3-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Restrict visibility of <structname>pg_stats_ext</structname> and
      <structname>pg_stats_ext_exprs</structname> entries to the table
      owner (Nathan Bossart)␟<structname>pg_stats_ext</structname>および<structname>pg_stats_ext_exprs</structname>エントリの可視性をテーブル所有者へ制限しました。
(Nathan Bossart)␞␞     </para>␞
␝     <para>␟      These views failed to hide statistics for expressions that involve
      columns the accessing user does not have permission to read.  View
      columns such as <structfield>most_common_vals</structfield> might
      expose security-relevant data.  The potential interactions here are
      not fully clear, so in the interest of erring on the side of safety,
      make rows in these views visible only to the owner of the associated
      table.␟これらのビューは、アクセスするユーザに読み取る権限のない列を含む式の統計情報を隠すことができませんでした。
<structfield>most_common_vals</structfield>などのビュー列で、セキュリティ関連データが公開される可能性がありました。
ここでの潜在的な相互作用は完全には明らかではないため、安全を優先するために、これらのビューの行を、関連するテーブルの所有者のみに表示するようにしました。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Lukas Fittl for reporting this problem.
      (CVE-2024-4317)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたLukas Fittlに感謝します。
(CVE-2024-4317)␞␞     </para>␞
␝     <para>␟      By itself, this fix will only fix the behavior in newly initdb'd
      database clusters.  If you wish to apply this change in an existing
      cluster, you will need to do the following:␟この修正では、新しくinitdbされたデータベースクラスタの動作のみが修正されます。
既存のクラスタにこの変更を適用したい場合は、次の手順を実行する必要があります。␞␞     </para>␞
␝       <para>␟        Find the SQL script <filename>fix-CVE-2024-4317.sql</filename> in
        the <replaceable>share</replaceable> directory of
        the <productname>PostgreSQL</productname> installation (typically
        located someplace like <filename>/usr/share/postgresql/</filename>).
        Be sure to use the script appropriate to
        your <productname>PostgreSQL</productname> major version.
        If you do not see this file, either your version is not vulnerable
        (only v14&ndash;v16 are affected) or your minor version is too
        old to have the fix.␟<productname>PostgreSQL</productname>がインストールされた<replaceable>share</replaceable>ディレクトリ（通常は<filename>/usr/share/postgresql/</filename>のような場所）にあるSQLスクリプト<filename>fix-CVE-2024-4317.sql</filename>を見つけてください。
必ず、<productname>PostgreSQL</productname>のメジャーバージョンに適したスクリプトを使用してください。
このファイルが見つからない場合は、あなたのバージョンが脆弱ではない（v14&ndash;v16だけが影響を受ける）か、マイナーバージョンが古すぎて修正されていません。␞␞       </para>␞
␝       <para>␟        In <emphasis>each</emphasis> database of the cluster, run
        the <filename>fix-CVE-2024-4317.sql</filename> script as superuser.
        In <application>psql</application> this would look like␟クラスタの<emphasis>各</emphasis>データベースで、スーパーユーザとして<filename>fix-CVE-2024-4317.sql</filename>スクリプトを実行します。
<application>psql</application>では以下のようになります。␞␞<programlisting>␞
␝</programlisting>␟        (adjust the file path as appropriate).  Any error probably indicates
        that you've used the wrong script version.  It will not hurt to run
        the script more than once.␟（ファイルパスは適宜調整してください）。
エラーが出た場合は、おそらく間違ったスクリプトバージョンを使用したことを示しています。
スクリプトを複数回実行しても問題ありません。␞␞       </para>␞
␝       <para>␟        Do not forget to include the <literal>template0</literal>
        and <literal>template1</literal> databases, or the vulnerability
        will still exist in databases you create later.  To
        fix <literal>template0</literal>, you'll need to temporarily make
        it accept connections.  Do that with␟<literal>template0</literal>と<literal>template1</literal>データベースを含めることを忘れないでください。
そうしないと、後で作成するデータベースに脆弱性が残ったままになります。
<literal>template0</literal>を修正するには、一時的に接続を受け付けるようにする必要があります。
これは、下記のコマンドで行います。␞␞<programlisting>␞
␝</programlisting>␟        and then after fixing <literal>template0</literal>, undo it with␟そして<literal>template0</literal>を修正した後、接続受け付けを元に戻します。␞␞<programlisting>␞
␝     <para>␟      Fix <command>INSERT</command> from
      multiple <command>VALUES</command> rows into a target column that is
      a domain over an array or composite type (Tom Lane)␟複数の<command>VALUES</command>行から、配列または複合型を元にしたドメイン型である対象列への<command>INSERT</command>を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Such cases would either fail with surprising complaints about
      mismatched datatypes, or insert unexpected coercions that could lead
      to odd results.␟このようなケースでは、データ型の不一致に関する予期せぬエラーで失敗するか、予期しない強制が挿入されて奇妙な結果が生じる可能性がありました。␞␞     </para>␞
␝     <para>␟      Require <literal>SELECT</literal> privilege on the target table
      for <command>MERGE</command> with a <literal>DO NOTHING</literal>
      clause (&Aacute;lvaro Herrera)␟<literal>DO NOTHING</literal>句を持つ<command>MERGE</command>では、対象テーブルに対する<literal>SELECT</literal>権限が必要です。
(&Aacute;lvaro Herrera)␞␞     </para>␞
␝     <para>␟      <literal>SELECT</literal> privilege would be required in all
      practical cases anyway, but require it even if the query reads no
      columns of the target table.  This avoids an edge case in
      which <command>MERGE</command> would require no privileges whatever,
      which seems undesirable even when it's a do-nothing command.␟<literal>SELECT</literal>権限は、すべての実用的なケースで必要になりますが、対象テーブルの列を読み取らない問い合わせの場合でも必要です。
これにより、<command>MERGE</command>がDO NOTHINGコマンドであっても望ましくないと思われる、何の権限も必要としないというエッジケースを回避しました。␞␞     </para>␞
␝     <para>␟      Fix handling of self-modified tuples in <command>MERGE</command>
      (Dean Rasheed)␟<command>MERGE</command>における自己修正タプルの処理を修正しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      Throw an error if a target row joins to more than one source row, as
      required by the SQL standard.  (The previous coding could silently
      ignore this condition if a concurrent update was involved.)  Also,
      throw a non-misleading error if a target row is already updated by a
      later command in the current transaction, thanks to
      a <literal>BEFORE</literal> trigger or a volatile function used in
      the query.␟標準SQLの要件に従って、ターゲット行が複数のソース行と結合される場合はエラーが発生します。
（以前のコーディングでは、同時更新が含まれる場合、この条件を黙って無視することができました。）
また、<literal>BEFORE</literal>トリガまたは問い合わせで使用される揮発性関数によって、対象行が現在のトランザクション内の後のコマンドによってすでに更新されている場合は、誤解を招かないようにエラーが発生します。␞␞     </para>␞
␝     <para>␟      Fix incorrect pruning of NULL partition when a table is partitioned
      on a boolean column and the query has a boolean <literal>IS
      NOT</literal> clause (David Rowley)␟テーブルがboolean型の列でパーティション化され、問い合わせにboolean型の<literal>IS NOT</literal>句がある場合の誤ったNULLパーティション除去を修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      A NULL value satisfies a clause such
      as <literal><replaceable>boolcol</replaceable> IS NOT
      FALSE</literal>, so pruning away a partition containing NULLs
      yielded incorrect answers.␟NULL値は<literal><replaceable>boolcol</replaceable> IS NOT FALSE</literal>のような句を満たすので、NULLを含むパーティションを除去すると誤った結果が生じていました。␞␞     </para>␞
␝     <para>␟      Make <command>ALTER FOREIGN TABLE SET SCHEMA</command> move any
      owned sequences into the new schema (Tom Lane)␟<command>ALTER FOREIGN TABLE SET SCHEMA</command>の実行で、所有するシーケンスを新しいスキーマに移動するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Moving a regular table to a new schema causes any sequences owned by
      the table to be moved to that schema too (along with indexes and
      constraints).  This was overlooked for foreign tables, however.␟通常のテーブルを新しいスキーマに移動すると、テーブルが所有するシーケンスも（インデックスや制約も一緒に）そのスキーマに移動されます。
しかし、外部テーブルではこれが見落とされていました。␞␞     </para>␞
␝     <para>␟      Make <command>ALTER TABLE ... ADD COLUMN</command> create
      identity/serial sequences with the same persistence as their owning
      tables (Peter Eisentraut)␟<command>ALTER TABLE ... ADD COLUMN</command>で、所有するテーブルと同じ永続性を持つIDENTITY/シリアルシーケンスを作成できるようにしました。
(Peter Eisentraut)␞␞     </para>␞
␝     <para>␟      <command>CREATE UNLOGGED TABLE</command> will make any owned
      sequences be unlogged too.  <command>ALTER TABLE</command> missed
      that consideration, so that an added identity column would have a
      logged sequence, which seems pointless.␟<command>CREATE UNLOGGED TABLE</command>を使用すると、所有するシーケンスもWAL出力されなくなります。
<command>ALTER TABLE</command>はこの点を考慮しなかったので、追加された識別列はWAL出力のあるシーケンスが含まれることになり、これは無意味なことでした。␞␞     </para>␞
␝     <para>␟      Improve <command>ALTER TABLE ... ALTER COLUMN TYPE</command>'s error
      message when there is a dependent function or publication (Tom Lane)␟依存する関数またはパブリケーションがある場合の<command>ALTER TABLE ... ALTER COLUMN TYPE</command>のエラーメッセージを改善しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      In <command>CREATE DATABASE</command>, recognize strategy keywords
      case-insensitively for consistency with other options (Tomas Vondra)␟<command>CREATE DATABASE</command>コマンドで、他のオプションとの整合性を保つために、strategyキーワードを大文字と小文字を区別せずに認識するようにしました。
(Tomas Vondra)␞␞     </para>␞
␝     <para>␟      Fix <command>EXPLAIN</command>'s counting of heap pages accessed by
      a bitmap heap scan (Melanie Plageman)␟ビットマップヒープスキャンによってアクセスされたヒープページの<command>EXPLAIN</command>のカウントを修正しました。
(Melanie Plageman)␞␞     </para>␞
␝     <para>␟      Previously, heap pages that contain no visible tuples were not
      counted; but it seems more consistent to count all pages returned by
      the bitmap index scan.␟以前は、可視タプルを含まないヒープページはカウントされませんでしたが、ビットマップインデックススキャンによって返されるすべてのページをカウントする方がより一貫性があります。␞␞     </para>␞
␝     <para>␟      Fix <command>EXPLAIN</command>'s output for subplans
      in <command>MERGE</command> (Dean Rasheed)␟<command>MERGE</command>におけるサブプランの<command>EXPLAIN</command>の出力を修正しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      <command>EXPLAIN</command> would sometimes fail to properly display
      subplan Params referencing variables in other parts of the plan tree.␟<command>EXPLAIN</command>は、プランツリーの他の部分にある変数を参照するサブプランパラメータを正しく表示できないことがありました。␞␞     </para>␞
␝     <para>␟      Avoid deadlock during removal of orphaned temporary tables
      (Mikhail Zhilin)␟孤立した一時テーブルの削除中のデッドロックを回避しました。
(Mikhail Zhilin)␞␞     </para>␞
␝     <para>␟      If the session that creates a temporary table crashes without
      removing the table, autovacuum will eventually try to remove the
      orphaned table.  However, an incoming session that's been assigned
      the same temporary namespace will do that too.  If a temporary table
      has a dependency (such as an owned sequence) then a deadlock could
      result between these two cleanup attempts.␟一時テーブルを作成したセッションがテーブルを削除せずにクラッシュした場合、自動バキュームは最終的に孤立したテーブルを削除しようとします。
しかし、同じ一時的な名前空間を割り当てられた受信セッションも同様に削除しようとします。
一時テーブルに依存関係（所有されたシーケンスなど）がある場合、これら2つのクリーンアップ試行の間にデッドロックが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix updating of visibility map state in <command>VACUUM</command>
      with the <literal>DISABLE_PAGE_SKIPPING</literal> option (Heikki
      Linnakangas)␟<literal>DISABLE_PAGE_SKIPPING</literal>オプションを使用した<command>VACUUM</command>での可視性マップ状態の更新を修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      Due to an oversight, this mode caused all heap pages to be dirtied,
      resulting in excess I/O.  Also, visibility map bits that were
      incorrectly set would not get cleared.␟見落としにより、このモードではすべてのヒープページがダーティになり、過剰なI/Oが発生しました。
また、誤って設定された可視性マップビットはクリアされませんでした。␞␞     </para>␞
␝     <para>␟      Avoid race condition while examining per-relation frozen-XID values
      (Noah Misch)␟リレーションごとの凍結されたXID値を調べる際の競合状態を回避します。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      <command>VACUUM</command>'s computation of per-database frozen-XID
      values from per-relation values could get confused by a concurrent
      update of those values by another <command>VACUUM</command>.␟<command>VACUUM</command>によるリレーション単位の値からのデータベース単位の凍結されたXID値の計算が、別の<command>VACUUM</command>によるそれらの値の同時更新によって混乱する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix buffer usage reporting for parallel vacuuming (Anthonin Bonnefoy)␟並列バキューム処理のバッファ使用レポートを修正しました。
(Antonin Bonnefoy)␞␞     </para>␞
␝     <para>␟      Buffer accesses performed by parallel workers were not getting
      counted in the statistics reported in <literal>VERBOSE</literal>
      mode.␟並列ワーカーによって実行されたバッファアクセスは、<literal>VERBOSE</literal>モードで報告される統計にカウントされませんでした。␞␞     </para>␞
␝     <para>␟      Ensure that join conditions generated from equivalence classes are
      applied at the correct plan level (Tom Lane)␟同値クラスから生成された結合条件が正しい計画レベルで適用されるようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      In versions before <productname>PostgreSQL</productname> 16, it was
      possible for generated conditions to be evaluated below outer joins
      when they should be evaluated above (after) the outer join, leading
      to incorrect query results.  All versions have a similar hazard when
      considering joins to <command>UNION ALL</command> trees that have
      constant outputs for the join column in
      some <command>SELECT </command> arms.␟<productname>PostgreSQL</productname>16より前のバージョンでは、生成された条件が外部結合の上(後)で評価されるべきところを下で評価される可能性があり、不正な問い合わせ結果をもたらしていました。
一部の<command>SELECT</command>アームの結合列に定数出力を持つ<command>UNION ALL</command>ツリーへの結合を検討する場合、すべてのバージョンで同様の危険性がありました。␞␞     </para>␞
␝     <para>␟      Fix <quote>could not find pathkey item to sort</quote> errors
      occurring while planning aggregate functions with <literal>ORDER
      BY</literal> or <literal>DISTINCT</literal> options (David Rowley)␟<literal>ORDER BY</literal>または<literal>DISTINCT</literal>オプションを指定した集約関数の計画中に発生する<quote>could not find pathkey item to sort</quote>エラーを修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      This is similar to a fix applied in 16.1, but it solves the problem
      for parallel plans.␟これは、16.1で適用された修正と同様ですが、並列計画の問題を解決します。␞␞     </para>␞
␝     <para>␟      Prevent potentially-incorrect optimization of some window functions
      (David Rowley)␟一部のウィンドウ関数の誤った最適化の可能性を防止しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Disable <quote>run condition</quote> optimization
      of <function>ntile()</function> and <function>count()</function>
      with non-constant arguments.  This avoids possible misbehavior with
      sub-selects, typically leading to errors like <quote>WindowFunc not
      found in subplan target lists</quote>.␟非定数引数を使用する<function>ntile()</function>と<function>count()</function>の<quote>実行条件</quote>最適化を無効にします。
これにより、典型的には<quote>WindowFunc not found in subplan target lists</quote>のようなエラーを引き起こす副SELECTで誤動作する可能性を防ぎます。␞␞     </para>␞
␝     <para>␟      Avoid unnecessary use of moving-aggregate mode with a non-moving
      window frame (Vallimaharajan G)␟移動しないウィンドウフレームでの移動集約モードを不必要に使用しないようにしました。
(Vallimaharajan G)␞␞     </para>␞
␝     <para>␟      When a plain aggregate is used as a window function, and the window
      frame start is specified as <literal>UNBOUNDED PRECEDING</literal>,
      the frame's head cannot move so we do not need to use the special
      (and more expensive) moving-aggregate mode.  This optimization was
      intended all along, but due to a coding error it never triggered.␟通常の集約関数をウィンドウ関数として使用し、ウィンドウフレームの開始が<literal>UNBOUNDED PRECEDING</literal>に指定されている場合、フレームの先頭は移動できないため、特別な（より高価な）移動集約モードを使用する必要はありません。
この最適化は当初から意図されていましたが、コーディングエラーのためにトリガされていませんでした。␞␞     </para>␞
␝     <para>␟      Avoid use of already-freed data while planning partition-wise joins
      under GEQO (Tom Lane)␟GEQOの下でパーティションごとの結合を計画する際に、解放済みデータの使用を避けるようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This would typically end in a crash or unexpected error message.␟これは通常、クラッシュまたは予期しないエラーメッセージで終了していました。␞␞     </para>␞
␝     <para>␟      Avoid freeing still-in-use data in Memoize (Tender Wang, Andrei
      Lepikhov)␟Memoizeで使用中のデータを解放しないようにしました。
(Tender Wang, Andrei Lepikhov)␞␞     </para>␞
␝     <para>␟      In production builds this error frequently didn't cause any
      problems, as the freed data would most likely not get overwritten
      before it was used.␟製品ビルドでは、解放されたデータは使用される前に上書きされる可能性は低いため、このエラーによって問題が起きることはほとんどありませんでした。␞␞     </para>␞
␝     <para>␟      Fix incorrectly-reported statistics kind codes in <quote>requested
      statistics kind <replaceable>X</replaceable> is not yet
      built</quote> error messages (David Rowley)␟<quote>requested statistics kind <replaceable>X</replaceable> is not yet built</quote>というエラーメッセージで誤ってレポートされていた統計の種類コードを修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Use a hash table instead of linear search for <quote>catcache
      list</quote> objects (Tom Lane)␟<quote>catcache list</quote>オブジェクトに対して、線形検索ではなくハッシュテーブルを使用するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This change solves performance problems that were reported for
      certain operations in installations with many thousands of roles.␟この変更により、数千のロールを持つインストールで特定の操作に関して報告されていたパフォーマンスの問題が解決されます。␞␞     </para>␞
␝     <para>␟      Be more careful with <type>RECORD</type>-returning functions
      in <literal>FROM</literal> (Tom Lane)␟<literal>FROM</literal>で<type>RECORD</type>を返す関数に対して、より注意を払うようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      The output columns of such a function call must be defined by
      an <literal>AS</literal> clause that specifies the column names and
      data types.  If the actual function output value doesn't match that,
      an error is supposed to be thrown at runtime.  However, some code
      paths would examine the actual value prematurely, and potentially
      issue strange errors or suffer assertion failures if it doesn't
      match expectations.␟このような関数呼び出しの出力列は、列名とデータ型を指定する<literal>AS</literal>句で定義する必要があります。
実際の関数の出力値がこれに一致しない場合、実行時にエラーが発生することになっています。
しかし、一部のコードパスでは、実際の値を早期に調べてしまい、期待と一致しない場合に奇妙なエラーを発生させたり、アサーションエラーを引き起こしたりする可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix confusion about the return rowtype of SQL-language procedures
      (Tom Lane)␟行型を返すSQL言語プロシージャに関する混乱を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      A procedure implemented in SQL language that returns a single
      composite-type column would cause an assertion failure or core dump.␟単一の複合型列を返すSQL言語で実装されたプロシージャでは、アサーションエラーまたはコアダンプを引き起こしていました。␞␞     </para>␞
␝     <para>␟      Add protective stack depth checks to some recursive functions
      (Egor Chindyaskin)␟いくつかの再帰関数に保護的なスタック深さ検査を追加しました。
(Egor Chindyaskin)␞␞     </para>␞
␝     <para>␟      Fix mis-rounding and overflow hazards
      in <function>date_bin()</function> (Moaaz Assali)␟<function>date_bin()</function>の丸め間違いとオーバーフローの危険性を修正しました。
(Moaaz Assali)␞␞     </para>␞
␝     <para>␟      In the case where the source timestamp is before the origin
      timestamp and their difference is already an exact multiple of the
      stride, the code incorrectly subtracted the stride anyway.  Also,
      detect some integer-overflow cases that would have produced
      incorrect results.␟sourceのタイムスタンプがoriginタイムスタンプより前で、その差がすでにstrideの正確な倍数である場合、コードは誤ってstrideを減算していました。
また、不正な結果を生じる可能性のある整数オーバーフローのケースもいくつか検出しました。␞␞     </para>␞
␝     <para>␟      Detect integer overflow when adding or subtracting
      an <type>interval</type> to/from a <type>timestamp</type>
      (Joseph Koshakow)␟<type>timestamp</type>に<type>interval</type>を加算または減算する際に、整数オーバーフローを検出するようにしました。
(Joseph Koshakow)␞␞     </para>␞
␝     <para>␟      Some cases that should cause an out-of-range error produced an
      incorrect result instead.␟範囲外エラーを発生すべき一部のケースでは、代わりに誤った結果が生成されていました。␞␞     </para>␞
␝     <para>␟      Avoid race condition in <function>pg_get_expr()</function>
      (Tom Lane)␟<function>pg_get_expr()</function>における競合状態を回避しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If the relation referenced by the argument is dropped concurrently,
      the function's intention is to return NULL, but sometimes it failed
      instead.␟引数が参照するリレーションが同時に削除された場合、関数はNULLを返すべきところですが、エラーになっていました。␞␞     </para>␞
␝     <para>␟      Fix detection of old transaction IDs in XID status functions
      (Karina Litskevich)␟XIDステータス関数での古いトランザクションIDの検出を修正しました。
(Karina Litskevich)␞␞     </para>␞
␝     <para>␟      Transaction IDs more than 2<superscript>31</superscript>
      transactions in the past could be misidentified as recent,
      leading to misbehavior of <function>pg_xact_status()</function>
      or <function>txid_status()</function>.␟2<superscript>31</superscript>を超えるトランザクションIDが最近のものとして誤って識別され、<function>pg_xact_status()</function>または<function>txid_status()</function>の誤動作につながる可能性がありました。␞␞     </para>␞
␝     <para>␟      Ensure that a table's freespace map won't return a page that's past
      the end of the table (Ronan Dunklau)␟テーブルの空き領域マップがテーブルの終端を越えたページを返さないようにしました。
(Ronan Dunklau)␞␞     </para>␞
␝     <para>␟      Because the freespace map isn't WAL-logged, this was possible in
      edge cases involving an OS crash, a replica promote, or a PITR
      restore.  The result would be a <quote>could not read block</quote>
      error.␟空き領域マップはWALに記録されないため、OSのクラッシュ、レプリカの昇格、PITRリストアなどの場合に発生する可能性がありました。
その結果<quote>could not read block</quote>エラーになります。␞␞     </para>␞
␝     <para>␟      Fix file descriptor leakage when an error is thrown while waiting
      in <function>WaitEventSetWait</function> (Etsuro Fujita)␟<function>WaitEventSetWait</function>で待機中にエラーが発生した場合のファイル記述子のリークを修正しました。
(Etsuro Fujita)␞␞     </para>␞
␝     <para>␟      Avoid corrupting exception stack if an FDW implements async append
      but doesn't configure any wait conditions for the Append plan node
      to wait for (Alexander Pyhalov)␟FDWが非同期Appendを実装しているが、Append計画ノードが待機する待機条件を設定していない場合の例外スタック破損を回避します。
(Alexander Pyhalov)␞␞     </para>␞
␝     <para>␟      Throw an error if an index is accessed while it is being reindexed
      (Tom Lane)␟インデックスの再作成中にインデックスにアクセスされた場合、エラーが発生するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Previously this was just an assertion check, but promote it into a
      regular runtime error.  This will provide a more on-point error
      message when reindexing a user-defined index expression that
      attempts to access its own table.␟以前は単なるアサーションチェックでしたが、通常のランタイムエラーに昇格しました。
これにより、ユーザ定義のインデックス式のインデックスを再作成する際に、より適切なエラーメッセージが提供されるようになります。␞␞     </para>␞
␝     <para>␟      Ensure that index-only scans on <type>name</type> columns return a
      fully-padded value (David Rowley)␟<type>name</type>型列のインデックスオンリースキャンが完全に埋め込まれた値を返すようにしました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      The value physically stored in the index is truncated, and
      previously a pointer to that value was returned to callers.  This
      provoked complaints when testing under valgrind.  In theory it could
      result in crashes, though none have been reported.␟インデックスに物理的に格納された値は切り捨てられ、以前はその値へのポインタが呼び出し元に返されていました。
これにより、valgrindでテストしたときに苦情が発生しました。
理論的にはクラッシュを引き起こす可能性がありますが、報告はありませんでした。␞␞     </para>␞
␝     <para>␟      Fix race condition that could lead to reporting an incorrect
      conflict cause when invalidating a replication slot (Bertrand
      Drouvot)␟レプリケーションスロットの無効化時に誤った競合原因を報告する可能性がある競合状態を修正しました。
(Bertrand Drouvot)␞␞     </para>␞
␝     <para>␟      Fix race condition in deciding whether a table sync operation is
      needed in logical replication (Vignesh C)␟論理レプリケーションでテーブル同期操作が必要かどうかを判断する際の競合状態を修正しました。
(Vignesh C)␞␞     </para>␞
␝     <para>␟      An invalidation event arriving while a subscriber identifies which
      tables need to be synced would be forgotten about, so that any
      tables newly in need of syncing might not get processed in a timely
      fashion.␟サブスクライバーが同期化が必要なテーブルを識別している間に到着した無効化イベントが忘れ去られるため、新たに同期化が必要なテーブルがタイムリーに処理されない可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix crash with DSM allocations larger than 4GB (Heikki Linnakangas)␟4GBを超えるDSMの割り当てによるクラッシュを修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      Disconnect if a new server session's client socket cannot be put
      into non-blocking mode (Heikki Linnakangas)␟新しいサーバセッションのクライアントソケットが非ブロッキングモードにできない場合は切断します。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      It was once theoretically possible for us to operate with a socket
      that's in blocking mode; but that hasn't worked fully in a long
      time, so fail at connection start rather than misbehave later.␟以前は、理論的にはブロッキングモードのソケットで動作することが可能でしたが、長い間完全には機能していなかったため、後で誤動作するのではなく接続開始時に失敗するようにしました。␞␞     </para>␞
␝     <para>␟      Fix inadequate error reporting
      with <application>OpenSSL</application> 3.0.0 and later (Heikki
      Linnakangas, Tom Lane)␟<application>OpenSSL</application>3.0.0以降での不適切なエラー報告を修正しました。
(Heikki Linnakangas, Tom Lane)␞␞     </para>␞
␝     <para>␟      System-reported errors passed through by OpenSSL were reported with
      a numeric error code rather than anything readable.␟OpenSSLによってシステムから報告されたエラーは、読み取り可能なものではなく、数値のエラーコードで報告されていました。␞␞     </para>␞
␝     <para>␟      Fix thread-safety of error reporting
      for <function>getaddrinfo()</function> on Windows (Thomas Munro)␟Windowsの<function>getaddrinfo()</function>関数のエラー報告のスレッド安全性を修正しました。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      A multi-threaded <application>libpq</application> client program
      could get an incorrect or corrupted error message after a network
      lookup failure.␟マルチスレッドの<application>libpq</application>クライアントプログラムは、ネットワーク検索が失敗した後に、誤ったエラーメッセージや破損したエラーメッセージを受け取る可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid concurrent calls to <function>bindtextdomain()</function>
      in <application>libpq</application>
      and <application>ecpglib</application> (Tom Lane)␟<application>libpq</application>と<application>ecpglib</application>の<function>bindtextdomain()</function>への同時呼び出しを避けました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Although GNU <application>gettext</application>'s implementation
      seems to be fine with concurrent calls, the version available on
      Windows is not.␟GNU <application>gettext</application>の実装では同時呼び出しは問題がないようですが、Windowsで利用可能なバージョンはそうではありませんでした。␞␞     </para>␞
␝     <para>␟      Fix crash in <application>ecpg</application>'s preprocessor if
      the program tries to redefine a macro that was defined on the
      preprocessor command line (Tom Lane)␟<application>ecpg</application>のプリプロセッサで、プログラムがプリプロセッサのコマンドラインで定義されたマクロを再定義しようとした場合のクラッシュを修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      In <application>ecpg</application>, avoid issuing
      false <quote>unsupported feature will be passed to server</quote>
      warnings (Tom Lane)␟<application>ecpg</application>で誤った<quote>unsupported feature will be passed to server</quote>警告を出さないようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Ensure that the string result
      of <application>ecpg</application>'s <function>intoasc()</function>
      function is correctly zero-terminated (Oleg Tselebrovskiy)␟<application>ecpg</application>の<function>intoasc()</function>関数の文字列結果が正しくゼロで終了するようにしました。
(Oleg Tselebrovskiy)␞␞     </para>␞
␝     <para>␟      In <application>initdb</application>'s <option>-c</option> option,
      match parameter names case-insensitively (Tom Lane)␟<application>initdb</application>の<option>-c</option>オプションで、大文字小文字を区別せずにパラメータ名を照合するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      The server treats parameter names case-insensitively, so this code
      should too.  This avoids putting redundant entries into the
      generated <filename>postgresql.conf</filename> file.␟サーバはパラメータ名を大文字小文字を区別せずに処理するので、このコードも同様に処理する必要があります。
これにより、生成された<filename>postgresql.conf</filename>ファイルに冗長なエントリの挿入が避けられます。␞␞     </para>␞
␝     <para>␟      In <application>psql</application>, avoid leaking a query result
      after the query is cancelled (Tom Lane)␟<application>psql</application>で、問い合わせがキャンセルされた後に問い合わせ結果を漏らさないようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This happened only when cancelling a non-last query in a query
      string made with <literal>\;</literal> separators.␟これは、<literal>\;</literal>区切り文字を使用して作成された問い合わせ文字列内で最後でない問い合わせをキャンセルした場合にのみ発生しました。␞␞     </para>␞
␝     <para>␟      Fix <application>pg_dumpall</application> so that role comments, if
      present, will be dumped regardless of the setting
      of <option>--no-role-passwords</option> (Daniel Gustafsson,
      &Aacute;lvaro Herrera)␟ロールコメントが存在する場合、<option>--no-role-passwords</option>の設定に関係なくロールコメントがダンプされるよう<application>pg_dumpall</application>を修正しました。
(Daniel Gustafsson, &Aacute;lvaro Herrera)␞␞     </para>␞
␝     <para>␟      Skip files named <filename>.DS_Store</filename>
      in <application>pg_basebackup</application>,
      <application>pg_checksums</application>,
      and <application>pg_rewind</application> (Daniel Gustafsson)␟<application>pg_basebackup</application>、<application>pg_checksums</application>、<application>pg_rewind</application>で<filename>.DS_Store</filename>という名前のファイルをスキップするようにしました。
(Daniel Gustafsson)␞␞     </para>␞
␝     <para>␟      This avoids problems on macOS, where the Finder may create such
      files.␟これにより、Finderがそのようなファイルを作成する可能性があるmacOSでの問題を回避できます。␞␞     </para>␞
␝     <para>␟      Fix <application>PL/pgSQL</application>'s parsing of single-line
      comments (<literal>--</literal>-style comments) following
      expressions (Erik Wienhold, Tom Lane)␟<application>PL/pgSQL</application>の式の後に続く単一行コメント（<literal>--</literal>形式のコメント）の解析を修正しました。
(Erik Wienhold, Tom Lane)␞␞     </para>␞
␝     <para>␟      This mistake caused parse errors if such a comment followed
      a <literal>WHEN</literal> expression in
      a <application>PL/pgSQL</application> <command>CASE</command>
      statement.␟この間違いにより、<application>PL/pgSQL</application> <command>CASE</command>ステートメントの<literal>WHEN</literal>式の後にこのようなコメントが続くと、解析エラーが発生していました。␞␞     </para>␞
␝     <para>␟      In <filename>contrib/amcheck</filename>, don't report false match
      failures due to short- versus long-header values (Andrey Borodin,
      Michael Zhilin)␟<filename>contrib/amcheck</filename>で、短いヘッダ値と長いヘッダ値による誤った一致失敗を報告しないようにしました。
(Andrey Borodin, Michael Zhilin)␞␞     </para>␞
␝     <para>␟      A variable-length datum in a heap tuple or index tuple could have
      either a short or a long header, depending on compression parameters
      that applied when it was made.  Treat these cases as equivalent
      rather than complaining if there's a difference.␟ヒープタプルまたはインデックスタプル内の可変長データは、作成時に適用された圧縮パラメータに応じて、短いヘッダまたは長いヘッダのいずれかを持つことができます。
違いがあると文句を言うのではなく、これらのケースを同等として扱うようにしました。␞␞     </para>␞
␝     <para>␟      Fix bugs in BRIN output functions (Tomas Vondra)␟BRIN出力関数のバグを修正しました。
(Tomas Vondra)␞␞     </para>␞
␝     <para>␟      These output functions are only used for displaying index entries
      in <filename>contrib/pageinspect</filename>, so the errors are of
      limited practical concern.␟これらの出力関数は<filename>contrib/pageinspect</filename>内のインデックスエントリを表示するためにのみ使用されるため、エラーは実用上の問題にはなりませんでした。␞␞     </para>␞
␝     <para>␟      In <filename>contrib/postgres_fdw</filename>, avoid emitting
      requests to sort by a constant (David Rowley)␟<filename>contrib/postgres_fdw</filename>では、定数によるソート要求を発行しないようにしました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      This could occur in cases involving <literal>UNION ALL</literal>
      with constant-emitting subqueries.  Sorting by a constant is useless
      of course, but it also risks being misinterpreted by the remote
      server, leading to <quote>ORDER BY
      position <replaceable>N</replaceable> is not in select list</quote>
      errors.␟これは、定数を発行する副問い合わせと<literal>UNION ALL</literal>を含む場合に発生する可能性がありました。
定数によるソートはもちろん無意味ですが、リモートサーバが誤って解釈して<quote>ORDER BY position <replaceable>N</replaceable> is not in select list</quote>エラーを出す危険性もありました。␞␞     </para>␞
␝     <para>␟      Make <filename>contrib/postgres_fdw</filename> set the remote
      session's time zone to <literal>GMT</literal>
      not <literal>UTC</literal> (Tom Lane)␟<filename>contrib/postgres_fdw</filename>がリモートセッションのタイムゾーンを<literal>UTC</literal>ではなく<literal>GMT</literal>に設定するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This should have the same results for practical purposes.
      However, <literal>GMT</literal> is recognized by hard-wired code in
      the server, while <literal>UTC</literal> is looked up in the
      timezone database.  So the old code could fail in the unlikely event
      that the remote server's timezone database is missing entries.␟これは、実用上は同じ結果になるはずです。
しかし、<literal>GMT</literal>はサーバのハードコードされたコードによって認識され、<literal>UTC</literal>はタイムゾーンデータベースで検索されます。
したがって、リモートサーバのタイムゾーンデータベースにエントリがないというまれなケースでは、古いコードが失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      In <filename>contrib/xml2</filename>, avoid use of library functions
      that have been deprecated in recent versions
      of <application>libxml2</application> (Dmitry Koval)␟<filename>contrib/xml2</filename>において、<application>libxml2</application>の最近のバージョンで非推奨となったライブラリ関数の使用を避けるようにしました。
(Dmitry Koval)␞␞     </para>␞
␝     <para>␟      Fix incompatibility with LLVM 18 (Thomas Munro, Dmitry Dolgov)␟LLVM 18との非互換性を修正しました。
(Thomas Munro, Dmitry Dolgov)␞␞     </para>␞
␝     <para>␟      Allow <literal>make check</literal> to work with
      the <application>musl</application> C library (Thomas Munro, Bruce
      Momjian, Tom Lane)␟<literal>make check</literal>が<application>musl</application>Cライブラリで動作するようにしました。
(Thomas Munro, Bruce Momjian, Tom Lane)␞␞     </para>␞
␝ <sect1 id="release-16-2">␟  <title>Release 16.2</title>␟  <title>リリース16.2</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2024-02-08</para>␞
␝  <para>␟   This release contains a variety of fixes from 16.1.
   For information about new features in major release 16, see
   <xref linkend="release-16"/>.␟このリリースは16.1に対し、様々な不具合を修正したものです。
16メジャーリリースにおける新機能については、<xref linkend="release-16"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-16-2-migration">␟   <title>Migration to Version 16.2</title>␟   <title>バージョン16.2への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 16.X.␟16.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, one bug was fixed that could have resulted in corruption of
    GIN indexes during concurrent updates.  If you suspect such
    corruption, reindex affected indexes after installing this update.␟しかしながら、同時更新中にGINインデックスの破損を引き起こす可能性があるバグが1件修正されました。
このような破損が疑われる場合は、この更新をインストールした後で、影響を受けるインデックスを再作成してください。␞␞   </para>␞
␝   <para>␟    Also, if you are upgrading from a version earlier than 16.1,
    see <xref linkend="release-16-1"/>.␟また、16.1より前のバージョンからアップグレードする場合は、<xref linkend="release-16-1"/>を参照してください。␞␞   </para>␞
␝  <sect2 id="release-16-2-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Tighten security restrictions within <command>REFRESH MATERIALIZED
      VIEW CONCURRENTLY</command> (Heikki Linnakangas)␟<command>REFRESH MATERIALIZED VIEW CONCURRENTLY</command>内のセキュリティ制限を強化しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      One step of a concurrent refresh command was run under weak security
      restrictions.  If a materialized view's owner could persuade a
      superuser or other high-privileged user to perform a concurrent
      refresh on that view, the view's owner could control code executed
      with the privileges of the user running <command>REFRESH</command>.
      Fix things so that all user-determined code is run as the view's
      owner, as expected.␟同時リフレッシュコマンドの1つのステップが弱いセキュリティ制限の下で実行されていました。
マテリアライズドビューの所有者がスーパーユーザまたは他の高い権限を持つユーザに、そのビューに対して同時リフレッシュを実行するよう説得できる場合、そのビューの所有者が<command>REFRESH</command>を実行しているユーザの権限で実行されるコードを制御できました。
ユーザが決定したすべてのコードが、期待どおりにビューの所有者として実行されるよう修正しました。␞␞     </para>␞
␝     <para>␟      The only known exploit for this error does not work
      in <productname>PostgreSQL</productname> 16.0 and later, so it may
      be that v16 is not vulnerable in practice.␟このエラーに対する唯一の既知のセキュリティ上の弱点は<productname>PostgreSQL</productname>16.0以降では動作しないため、v16は実際には脆弱ではない可能性があります。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks Pedro
      Gallegos for reporting this problem.
      (CVE-2024-0985) <!-- not CVE-2023-5869 as claimed in commit msg -->␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたPedro Gallegosに感謝します。
(CVE-2024-0985)<!-- commit msgで指摘されたCVE-2023-5869ではありません。 -->␞␞     </para>␞
␝     <para>␟      Fix memory leak when performing JIT inlining (Andres Freund,
      Daniel Gustafsson)␟JITインライン化を実行する時のメモリリークを修正しました。
(Andres Freund, Daniel Gustafsson)␞␞     </para>␞
␝     <para>␟      There have been multiple reports of backend processes suffering
      out-of-memory conditions after sufficiently many JIT compilations.
      This fix should resolve that.␟多数のJITコンパイルの後に、バックエンドプロセスがメモリ不足の状態に陥るという複数の報告がありました。
この修正により、この問題が解決されます。␞␞     </para>␞
␝     <para>␟      Avoid generating incorrect partitioned-join plans (Richard Guo)␟不正なパーティション結合のプランが生成されないようにしました。
 (Richard Guo)␞␞     </para>␞
␝     <para>␟      Some uncommon situations involving lateral references could create
      incorrect plans.  Affected queries could produce wrong answers, or
      odd failures such as <quote>variable not found in subplan target
      list</quote>, or executor crashes.␟LATERAL参照を含む一部の特殊な状況では、誤ったプランが作成される可能性がありました。
影響を受ける問い合わせは、間違った答えを出したり、<quote>variable not found in subplan target list</quote>などの奇妙なエラーを出したり、エグゼキュータのクラッシュしたりする可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix incorrect wrapping of subquery output expressions in
      PlaceHolderVars (Tom Lane)␟PlaceHolderVars内の副問い合わせ出力式の不正なラッピングを修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This fixes incorrect results when a subquery is underneath an outer
      join and has an output column that laterally references something
      outside the outer join's scope.  The output column might not appear
      as NULL when it should do so due to the action of the outer join.␟これにより、副問い合わせが外部結合の下にあり、出力列が外部結合の範囲外にあるものをLATERAL参照している場合の不正な結果が修正されます。
出力列は、外部結合の動作により、NULLとして表示されるはずなのにNULLとして表示されないことがありました。␞␞     </para>␞
␝     <para>␟      Fix misprocessing of window function run conditions (Richard Guo)␟ウィンドウ関数の実行条件の誤った処理を修正しました。
(Richard Guo)␞␞     </para>␞
␝     <para>␟      This oversight could lead to <quote>WindowFunc not found in subplan
      target lists</quote> errors.␟この見落としにより、<quote>WindowFunc not found in subplan target lists</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix detection of inner-side uniqueness for Memoize plans
      (Richard Guo)␟Memoizeプランの内側の一意性検出を修正しました。
(Richard Guo)␞␞     </para>␞
␝     <para>␟      This mistake could lead to <quote>cache entry already
      complete</quote> errors.␟この間違いにより<quote>cache entry already complete</quote>というエラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix computation of nullingrels when constant-folding field selection
      (Richard Guo)␟定数畳み込みフィールド選択時のnullingrelsの計算を修正しました。
(Richard Guo)␞␞     </para>␞
␝     <para>␟      Failure to do this led to errors like <quote>wrong varnullingrels
      (b) (expected (b 3)) for Var 2/2</quote>.␟これを行わないと、<quote>wrong varnullingrels (b) (expected (b 3)) for Var 2/2</quote>のようなエラーが発生しました。␞␞     </para>␞
␝     <para>␟      Skip inappropriate actions when <command>MERGE</command> causes a
      cross-partition update (Dean Rasheed)␟<command>MERGE</command>によるパーティション間の更新が発生する場合に、不適切なアクションをおこなわないようにしました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      When executing a <literal>MERGE UPDATE</literal> action on a
      partitioned table, if the <literal>UPDATE</literal> is turned into
      a <literal>DELETE</literal> and <literal>INSERT</literal> due to
      changing a partition key column, skip firing <literal>AFTER
      UPDATE ROW</literal> triggers, as well as other post-update actions
      such as RLS checks.  These actions would typically fail, which is
      why a regular <literal>UPDATE</literal> doesn't do them in such
      cases; <literal>MERGE</literal> shouldn't either.␟パーティションテーブルで<literal>MERGE UPDATE</literal>アクションを実行するとき、パーティションキー列の変更により<literal>UPDATE</literal>が<literal>DELETE</literal>と<literal>INSERT</literal>に変わった場合、<literal>AFTER UPDATE ROW</literal>トリガの起動や、RLSチェックなどの他のUPDATE後アクションの起動をスキップします。
これらのアクションは通常失敗するため、通常の<literal>UPDATE</literal>ではこのような場合にこれらを行いません。
<literal>MERGE</literal>もそうすべきではありません。␞␞     </para>␞
␝     <para>␟      Cope with <literal>BEFORE ROW DELETE</literal> triggers in
      cross-partition <command>MERGE</command> updates (Dean Rasheed)␟パーティションにまたがる<command>MERGE</command>の更新で<literal>BEFORE ROW DELETE</literal>トリガを処理するようにしました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      If such a trigger attempted to prevent the update by returning
      NULL, <command>MERGE</command> would suffer an error or assertion
      failure.␟このようなトリガがNULLを返すことで更新を阻止しようとした場合、<command>MERGE</command>はエラーかアサーションエラーを引き起こしてました。␞␞     </para>␞
␝     <para>␟      Prevent access to a no-longer-pinned buffer in <literal>BEFORE ROW
      UPDATE</literal> triggers (Alexander Lakhin, Tom Lane)␟<literal>BEFORE ROW UPDATE</literal>トリガで、固定されていないバッファへのアクセスを防止しました。
(Alexander Lakhin, Tom Lane)␞␞     </para>␞
␝     <para>␟      If the tuple being updated had just been updated and moved to
      another page by another session, there was a narrow window where
      we would attempt to fetch data from the new tuple version without
      any pin on its buffer.  In principle this could result in garbage
      data appearing in non-updated columns of the proposed new tuple.
      The odds of problems in practice seem rather low, however.␟更新中のタプルが別のセッションによって更新されてから別のページに移動された場合、バッファ上の固定されていない新しいタプルバージョンからデータをフェッチしようとする狭い期間がありました。
これにより、原理的には提案された新しいタプルの更新されていない列にガベージデータが表示される可能性がありました。
しかし、実際に問題が発生する可能性はかなり低いと見られます。␞␞     </para>␞
␝     <para>␟      Avoid requesting an oversize shared-memory area in parallel hash
      join (Thomas Munro, Andrei Lepikhov, Alexander Korotkov)␟パラレルハッシュ結合で、サイズが大きすぎる共有メモリ領域を要求しないようにしました。
(Thomas Munro, Andrei Lepikhov, Alexander Korotkov)␞␞     </para>␞
␝     <para>␟      The limiting value was too large, allowing <quote>invalid DSA memory
      alloc request size</quote> errors to occur with sufficiently large
      expected hash table sizes.␟制限値が大きすぎるため、予想されるハッシュテーブルのサイズが十分に大きい場合に<quote>invalid DSA memory alloc request size</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix corruption of local buffer state when an error occurs while
      trying to extend a temporary table (Tender Wang)␟一時テーブルを拡張しようとしてエラーが発生する場合のローカルバッファ状態の破損を修正しました。
(Tender Wang)␞␞     </para>␞
␝     <para>␟      Fix use of wrong tuple slot while
      evaluating <literal>DISTINCT</literal> aggregates that have multiple
      arguments (David Rowley)␟複数の引数を持つ<literal>DISTINCT</literal>が指定された集約を評価する際の間違ったタプルスロットの使用を修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      This mistake could lead to errors such as <quote>attribute 1 of type
      record has wrong type</quote>.␟この間違いは、<quote>attribute 1 of type record has wrong type</quote>といったエラーにつながる可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid assertion failures in <function>heap_update()</function>
      and <function>heap_delete()</function> when a tuple to be updated by
      a foreign-key enforcement trigger fails the extra visibility
      crosscheck (Alexander Lakhin)␟外部キー強制トリガによって更新されるタプルが追加の可視性クロスチェックに失敗した場合、<function>heap_update()</function>と<function>heap_delete()</function>でのアサーションエラーを回避します。
(Alexander Lakhin)␞␞     </para>␞
␝     <para>␟      This error had no impact in non-assert builds.␟このエラーは、非アサートビルドには影響しませんでした。␞␞     </para>␞
␝     <para>␟      Fix overly tight assertion
      about <varname>false_positive_rate</varname> parameter of
      BRIN bloom operator classes (Alexander Lakhin)␟BRINブルーム演算子クラスの<varname>false_positive_rate</varname>パラメータに関する過度に厳密なアサーションを修正しました。
(Alexander Lakhin)␞␞     </para>␞
␝     <para>␟      This error had no impact in non-assert builds, either.␟このエラーは、非アサートビルドにも影響しませんでした。␞␞     </para>␞
␝     <para>␟      Fix possible failure during <command>ALTER TABLE ADD
      COLUMN</command> on a complex inheritance tree (Tender Wang)␟複雑な継承ツリーでの<command>ALTER TABLE ADD COLUMN</command>の際に起こりうるエラーを修正しました。
(Tender Wang)␞␞     </para>␞
␝     <para>␟      If a grandchild table would inherit the new column via multiple
      intermediate parents, the command failed with <quote>tuple already
      updated by self</quote>.␟もし、孫テーブルが複数の中間の親テーブルを介して新しい列を継承する場合、コマンドは<quote>tuple already updated by self</quote>というエラーで失敗していました。␞␞     </para>␞
␝     <para>␟      Fix problems with duplicate token names in <command>ALTER TEXT
      SEARCH CONFIGURATION ... MAPPING</command> commands (Tender Wang,
      Michael Paquier)␟<command>ALTER TEXT SEARCH CONFIGURATION ... MAPPING</command>コマンドでトークン名が重複する問題を修正しました。
(Tender Wang, Michael Paquier)␞␞     </para>␞
␝     <para>␟      Fix <command>DROP ROLE</command> with duplicate role names
      (Michael Paquier)␟<command>DROP ROLE</command>で重複したロール名を指定した場合について修正しました。
(Michael Paquier)␞␞     </para>␞
␝     <para>␟      Previously this led to a <quote>tuple already updated by
      self</quote> failure.  Instead, ignore the duplicate.␟以前は、これにより<quote>tuple already updated by self</quote>エラーが発生していました。
代わりに、重複を無視するようにしました。␞␞     </para>␞
␝     <para>␟      Properly lock the associated table during <command>DROP
      STATISTICS</command> (Tomas Vondra)␟<command>DROP STATISTICS</command>の実行中に、関連するテーブルを適切にロックするようにしました。
(Tomas Vondra)␞␞     </para>␞
␝     <para>␟      Failure to acquire the lock could result in <quote>tuple
      concurrently deleted</quote> errors if the <command>DROP</command>
      executes concurrently with <command>ANALYZE</command>.␟ロックの取得に失敗すると、<command>ANALYZE</command>と同時に<command>DROP</command>が実行された場合に<quote>tuple concurrently deleted</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix function volatility checking for <literal>GENERATED</literal>
      and <literal>DEFAULT</literal> expressions (Tom Lane)␟<literal>GENERATED</literal>式と<literal>DEFAULT</literal>式での関数の揮発性検査を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      These places could fail to detect insertion of a volatile function
      default-argument expression, or decide that a polymorphic function
      is volatile although it is actually immutable on the datatype of
      interest.  This could lead to improperly rejecting or accepting
      a <literal>GENERATED</literal> clause, or to mistakenly applying the
      constant-default-value optimization in <command>ALTER TABLE ADD
      COLUMN</command>.␟これらの場所では、デフォルト引数式への揮発性関数の挿入を検出できなかったり、多様関数が実際には対象のデータ型では不変であるにもかかわらず揮発性であると判断したりする可能性がありました。
これにより、<literal>GENERATED</literal>句を不適切に拒否または受け入れたり、<command>ALTER TABLE ADD COLUMN</command>の定数デフォルト値の最適化が誤って適用されたりする可能性がありました。␞␞     </para>␞
␝     <para>␟      Detect that a new catalog cache entry became stale while detoasting
      its fields (Tom Lane)␟フィールドをTOASTから展開する時に新しいカタログキャッシュエントリが古くなったことを検出します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      We expand any out-of-line fields in a catalog tuple before inserting
      it into the catalog caches.  That involves database access which
      might cause invalidation of catalog cache entries &mdash; but the
      new entry isn't in the cache yet, so we would miss noticing that it
      should get invalidated.  The result is a race condition in which an
      already-stale cache entry could get made, and then persist
      indefinitely.  This would lead to hard-to-predict misbehavior.
      Fix by rechecking the tuple's visibility after detoasting.␟カタログキャッシュに挿入する前に、カタログタプル内の任意の行外フィールドを展開します。
これは、カタログキャッシュエントリが無効になる可能性があるデータベースアクセスを伴いますが、新しいエントリはまだキャッシュにないので、無効化すべき必要があることに気づかないでしょう。
その結果、既に古いキャッシュエントリが作成され、永続化されるかもしれない競合状態が発生します。
これは、予測が困難な誤動作を引き起こすことになります。
TOAST展開後にタプルの可視性を再確認することで修正します。␞␞     </para>␞
␝     <para>␟      Fix edge-case integer overflow detection bug on some platforms (Dean
      Rasheed)␟一部のプラットフォームでのエッジケースの整数オーバーフロー検出不具合を修正しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      Computing <literal>0 - INT64_MIN</literal> should result in an
      overflow error, and did on most platforms.  However, platforms with
      neither integer overflow builtins nor 128-bit integers would fail to
      spot the overflow, instead returning <literal>INT64_MIN</literal>.␟<literal>0 - INT64_MIN</literal>の計算はオーバーフローエラーとなるべきで、ほとんどのプラットフォームではそのようになっていました。
しかし、組み込みの整数オーバーフローも128ビット整数もないプラットフォームでは、オーバーフローを検出できず、代わりに<literal>INT64_MIN</literal>を返していました。␞␞     </para>␞
␝     <para>␟      Detect Julian-date overflow when adding or subtracting
      an <type>interval</type> to/from a <type>timestamp</type> (Tom Lane)␟<type>timestamp</type>型に<type>interval</type>型を加算または減算するときに、ユリウス日付のオーバーフローを検出します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Some cases that should cause an out-of-range error produced an
      incorrect result instead.␟範囲外エラーが発生するはずのいくつかのケースで、代わりに誤った結果が生成されていました。␞␞     </para>␞
␝     <para>␟      Add more checks for overflow in <function>interval_mul()</function>
      and <function>interval_div()</function> (Dean Rasheed)␟<function>interval_mul()</function>と<function>interval_div()</function>でオーバーフローの検査をさらに追加しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      Some cases that should cause an out-of-range error produced an
      incorrect result instead.␟範囲外エラーが発生するはずのいくつかのケースで、誤った結果が生成されていました。␞␞     </para>␞
␝     <para>␟      Allow <function>scram_SaltedPassword()</function> to be interrupted
      (Bowen Shi)␟<function>scram_SaltedPassword()</function>関数を割り込み可能にしました。
(Bowen Shi)␞␞     </para>␞
␝     <para>␟      With large <varname>scram_iterations</varname> values, this function
      could take a long time to run.  Allow it to be interrupted by query
      cancel requests.␟大きな<varname>scram_iterations</varname>の値では、この関数の実行に長い時間がかかる可能性がありました。
問い合わせのキャンセル要求によって中断できるようにしました。␞␞     </para>␞
␝     <para>␟      Ensure cached statistics are discarded after a change
      to <varname>stats_fetch_consistency</varname> (Shinya Kato)␟<varname>stats_fetch_consistency</varname>の変更後にキャッシュされた統計情報を破棄するようにしました。
(Shinya Kato)␞␞     </para>␞
␝     <para>␟      In some code paths, it was possible for stale statistics to be
      returned.␟一部のコードパスで、古い統計情報が返される可能性がありました。␞␞     </para>␞
␝     <para>␟      Make the <structname>pg_file_settings</structname> view check
      validity of unapplied values for settings
      with <literal>backend</literal>
      or <literal>superuser-backend</literal> context (Tom Lane)␟<structname>pg_file_settings</structname>ビューで、<literal>backend</literal>または<literal>superuser-backend</literal>コンテキストの設定に対して、未適用の値の有効性を検査するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Invalid values were not noted in the view as intended.  This escaped
      detection because there are very few settings in these groups.␟無効な値は意図したようにビューに記録されませんでした。
これらのグループには設定がほとんどないため、この問題は検出されませんでした。␞␞     </para>␞
␝     <para>␟      Match collation too when matching an existing index to a new
      partitioned index (Peter Eisentraut)␟既存のインデックスを新しいパーティションインデックスと一致させる場合に、照合順序も一致させます。
(Peter Eisentraut)␞␞     </para>␞
␝     <para>␟      Previously we could accept an index that has a different collation
      from the corresponding element of the partition key, possibly
      leading to misbehavior.␟以前は、パーティションキーの対応する要素と異なる照合順序を持つインデックスを受け入れることができ、誤動作につながる可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid failure if a child index is dropped concurrently
      with <command>REINDEX INDEX</command> on a partitioned index
      (Fei Changhong)␟パーティションインデックスに対する<command>REINDEX INDEX</command>で、子インデックスが同時に削除された場合のエラーを回避します。
(Fei Changhong)␞␞     </para>␞
␝     <para>␟      Fix insufficient locking when cleaning up an incomplete split of
      a GIN index's internal page (Fei Changhong, Heikki Linnakangas)␟GINインデックスの内部ページの不完全な分割をクリーンアップする際の不十分なロックを修正しました。
(Fei Changhong, Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      The code tried to do this with shared rather than exclusive lock on
      the buffer.  This could lead to index corruption if two processes
      attempted the cleanup concurrently.␟このコードは、バッファの排他ロックではなく共有ロックを使用してこれを行おうとしました。
このため、2 つのプロセスが同時にクリーンアップを試みた場合に、インデックスが壊れる可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid premature release of buffer pin in GIN index insertion
      (Tom Lane)␟GINインデックスの挿入におけるバッファピンの早期解放を回避しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If an index root page split occurs concurrently with our own
      insertion, the code could fail with <quote>buffer NNNN is not owned
      by resource owner</quote>.␟インデックスのルートページの分割が、自身の挿入と同時に起こった場合、コードは<quote>buffer NNNN is not owned by resource owner</quote>で失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid failure with partitioned SP-GiST indexes (Tom Lane)␟パーティションテーブルに対するSP-GiSTインデックスのエラーを回避しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Trying to use an index of this kind could lead to <quote>No such
      file or directory</quote> errors.␟この種のインデックスを使用しようとすると、<quote>No such file or directory</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix ownership tests for large objects (Tom Lane)␟ラージオブジェクトの所有者検査を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Operations on large objects that require ownership privilege failed
      with <quote>unrecognized class ID: 2613</quote>, unless run by a
      superuser.␟所有者権限を必要とするラージオブジェクト操作は、スーパーユーザによって実行されない限り、<quote>unrecognized class ID: 2613</quote>で失敗していました。␞␞     </para>␞
␝     <para>␟      Fix ownership change reporting for large objects (Tom Lane)␟ラージオブジェクトの所有者変更の報告を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      A no-op <command>ALTER LARGE OBJECT OWNER</command> command (that
      is, one selecting the existing owner) passed the wrong class ID to
      the <varname>PostAlterHook</varname>, probably confusing any
      extension using that hook.␟何も実行されない<command>ALTER LARGE OBJECT OWNER</command>コマンド（すなわち、既存の所有者を選択するコマンド）は、間違ったクラスIDを<varname>PostAlterHook</varname>に渡したため、そのフックを使用する拡張機能を混乱する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix reporting of I/O timing data in <literal>EXPLAIN
      (BUFFERS)</literal> (Michael Paquier)␟<literal>EXPLAIN (BUFFERS)</literal>でのI/Oタイミングデータの報告を修正しました。
(Michael Paquier)␞␞     </para>␞
␝     <para>␟      The numbers labeled as <quote>shared/local</quote> actually refer
      only to shared buffers, so change that label
      to <quote>shared</quote>.␟<quote>shared/local</quote>とラベル付けされた数値は実際には共有バッファのみを参照するため、ラベルを<quote>shared</quote>に変更しました。␞␞     </para>␞
␝     <para>␟      Ensure durability of <command>CREATE DATABASE</command> (Noah Misch)␟<command>CREATE DATABASE</command>の耐久性を保証します。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      If an operating system crash occurred during or shortly
      after <command>CREATE DATABASE</command>, recovery could fail, or
      subsequent connections to the new database could fail.  If a base
      backup was taken in that window, similar problems could be observed
      when trying to use the backup.  The symptom would be that the
      database directory, <filename>PG_VERSION</filename> file, or
      <filename>pg_filenode.map</filename> file was missing or empty.␟<command>CREATE DATABASE</command>の実行中またはその直後にオペレーティングシステムのクラッシュが発生した場合、リカバリが失敗したり、新しいデータベースへの後続の接続が失敗したりする可能性がありました。
その時間帯にベースバックアップが取られた場合、バックアップを使用しようとすると同様の問題が発生する可能性がありました。
症状は、データベースディレクトリ、<filename>PG_VERSION</filename>ファイル、または<filename>pg_filenode.map</filename>ファイルが存在しないか、空であることでした。␞␞     </para>␞
␝     <para>␟      Add more <literal>LOG</literal> messages when starting and ending
      recovery from a backup (Andres Freund)␟バックアップからのリカバリ開始時と終了時に、<literal>LOG</literal>メッセージをより多く出すようにしました。
(Andres Freund)␞␞     </para>␞
␝     <para>␟      This change provides additional information in the postmaster log
      that may be useful for diagnosing recovery problems.␟この変更により、リカバリの問題の診断に役立つ追加情報がpostmasterログに提供されます。␞␞     </para>␞
␝     <para>␟      Prevent standby servers from incorrectly processing dead index
      tuples during subtransactions (Fei Changhong)␟スタンバイサーバがサブトランザクション中にデッドインデックスタプルを誤って処理しないようにしました。
(Fei Changhong)␞␞     </para>␞
␝     <para>␟      The <structfield>startedInRecovery</structfield> flag was not
      correctly set for a subtransaction.  This affects only processing of
      dead index tuples.  It could allow a query in a subtransaction to
      ignore index entries that it should return (if they are already dead
      on the primary server, but not dead to the standby transaction), or
      to prematurely mark index entries as dead that are not yet dead on
      the primary.  It is not clear that the latter case has any serious
      consequences, but it's not the intended behavior.␟サブトランザクションの<structfield>startedInRecovery</structfield>フラグが正しく設定されていませんでした。
これは、デッドインデックスタプルの処理にのみ影響します。
これにより、サブトランザクション内の問い合わせが、返すべきインデックスエントリを無視したり（プライマリサーバでは既にデッドになっているが、スタンバイトランザクションではまだデッドになっていない場合）、プライマリでまだデッドになっていないインデックスエントリを早まってデッドとマークしたりする可能性がありました。
後者の場合に重大な結果が生じるかどうかは明らかではないが、意図された動作ではありません。␞␞     </para>␞
␝     <para>␟      Fix signal handling in walreceiver processes (Heikki Linnakangas)␟walreceiverプロセスのシグナル処理を修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      Revert a change that made walreceivers non-responsive
      to <systemitem>SIGTERM</systemitem> while waiting for the
      replication connection to be established.␟レプリケーション接続確立の待機中に、walreceiversが<systemitem>SIGTERM</systemitem>に応答しないようにする変更を元に戻しました。␞␞     </para>␞
␝     <para>␟      Fix integer overflow hazard in checking whether a record will fit
      into the WAL decoding buffer (Thomas Munro)␟レコードがWALデコードバッファに収まるかどうかの検査での整数オーバーフローの危険性を修正しました。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      This bug appears to be only latent except when running a
      32-bit <productname>PostgreSQL</productname> build on a 64-bit
      platform.␟この不具合は、64ビットプラットフォーム上で32ビット<productname>PostgreSQL</productname>ビルドを実行する場合を除き、潜在的なものにすぎないようです。␞␞     </para>␞
␝     <para>␟      Fix deadlock between a logical replication apply worker, its
      tablesync worker, and a session process trying to alter the
      subscription (Shlok Kyal)␟論理レプリケーション適用ワーカー、そのテーブル同期ワーカー、およびサブスクリプションを変更しようとするセッションプロセス間のデッドロックを修正しました。
(Shlok Kyal)␞␞     </para>␞
␝     <para>␟      One edge of the deadlock loop did not involve a lock wait, so the
      deadlock went undetected and would persist until manual
      intervention.␟デッドロック・ループの一方のエッジにはロック待機が含まれていなかったため、デッドロックは検出されず、手動で介入するまで持続しました。␞␞     </para>␞
␝     <para>␟      Ensure that column default values are correctly transmitted by
      the <application>pgoutput</application> logical replication plugin
      (Nikhil Benesch)␟<application>pgoutput</application>論理レプリケーションプラグインによって列のデフォルト値が正しく転送されるようにしました。
(Nikhil Benesch)␞␞     </para>␞
␝     <para>␟      <command>ALTER TABLE ADD COLUMN</command> with a constant default
      value for the new column avoids rewriting existing tuples, instead
      expecting that reading code will insert the correct default into a
      tuple that lacks that column.  If replication was subsequently
      initiated on the table, <application>pgoutput</application> would
      transmit NULL instead of the correct default for such a column,
      causing incorrect replication on the subscriber.␟新しい列にデフォルトの定数値を持つ<command>ALTER TABLE ADD COLUMN</command>は、既存のタプルの書き換えを回避し、代わりに読み取りコードがその列を欠いたタプルに正しいデフォルトを挿入することを期待していました。
その後、テーブルでレプリケーションが開始された場合、<application>pgoutput</application>はそのような列の正しいデフォルトの代わりにNULLを送信したため、サブスクライバーで誤ったレプリケーションを引き起こしていました。␞␞     </para>␞
␝     <para>␟      Fix failure of logical replication's initial sync for a table with
      no columns (Vignesh C)␟列のないテーブルに対する論理レプリケーションの初期同期の失敗を修正しました。
(Vignesh C)␞␞     </para>␞
␝     <para>␟      This case generated an improperly-formatted <command>COPY</command>
      command.␟このケースでは、不適切な形式の<command>COPY</command>コマンドが生成されていました。␞␞     </para>␞
␝     <para>␟      Re-validate a subscription's connection string before use (Vignesh C)␟使用前にサブスクリプションの接続文字列を再検証します。
(Vignesh C)␞␞     </para>␞
␝     <para>␟      This is meant to detect cases where a subscription was created
      without a password (which is allowed to superusers) but then the
      subscription owner is changed to a non-superuser.␟これは、パスワードなしでサブスクリプションが作成された（スーパーユーザに許可されている）が、その後、サブスクリプションの所有者がスーパーユーザ以外に変更された場合を検出することを目的にしています。␞␞     </para>␞
␝     <para>␟      Return the correct status code when a new client disconnects without
      responding to the server's password challenge (Liu Lang, Tom Lane)␟新しいクライアントがサーバのパスワードチャレンジに応答せずに接続を切断した場合に正しいステータスコードを返すようにしました。
(Liu Lang, Tom Lane)␞␞     </para>␞
␝     <para>␟      In some cases we'd treat this as a loggable error, which was not the
      intention and tends to create log spam, since common clients
      like <application>psql</application> frequently do this.  It may
      also confuse extensions that
      use <varname>ClientAuthentication_hook</varname>.␟場合によっては、これをログに記録可能なエラーとして処理しますが、これは意図したものではなく、<application>psql</application>のような一般的なクライアントが頻繁に行うため、ログスパムを生成する傾向がありました。
また、<varname>ClientAuthentication_hook</varname>を使用する拡張も混乱させる可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix incompatibility with <application>OpenSSL</application> 3.2
      (Tristan Partin, Bo Andreson)␟<application>OpenSSL</application> 3.2との非互換性を修正しました。
(Tristan Partin, Bo Andreson)␞␞     </para>␞
␝     <para>␟      Use the BIO <quote>app_data</quote> field for our private storage,
      instead of assuming it's okay to use the <quote>data</quote> field.
      This mistake didn't cause problems before, but with 3.2 it leads
      to crashes and complaints about double frees.␟<quote>data</quote>フィールドを使用しても問題ないと仮定するのではなく、プライベートストレージにBIOの<quote>app_data</quote>フィールドを使用します。
この間違いは以前は問題を引き起こさなかったが、3.2ではクラッシュや二重解放に関するエラーを引き起こしていました。␞␞     </para>␞
␝     <para>␟      Be more wary about <application>OpenSSL</application> not
      setting <varname>errno</varname> on error (Tom Lane)␟<application>OpenSSL</application>がエラー時に<varname>errno</varname>を設定しないことについて、より注意するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      If <varname>errno</varname> isn't set, assume the cause of the
      reported failure is read EOF.  This fixes rare cases of strange
      error reports like <quote>could not accept SSL connection:
      Success</quote>.␟<varname>errno</varname>が設定されていない場合、報告された失敗の原因はEOFの読み込みであると想定していました。
これにより、<quote>could not accept SSL connection: Success</quote>のような奇妙なエラーレポートの稀なケースが修正されます。␞␞     </para>␞
␝     <para>␟      Fix file descriptor leakage when a foreign data
      wrapper's <function>ForeignAsyncRequest</function> function fails
      (Heikki Linnakangas)␟外部データラッパーの<function>ForeignAsyncRequest</function>関数が失敗したときのファイル記述子のリークを修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      Fix minor memory leak in connection string validation
      for <command>CREATE SUBSCRIPTION</command> (Jeff Davis)␟<command>CREATE SUBSCRIPTION</command>の接続文字列検証における軽微なメモリリークを修正しました。
(Jeff Davis)␞␞     </para>␞
␝     <para>␟      Report <systemitem>ENOMEM</systemitem> errors from file-related system
      calls as <literal>ERRCODE_OUT_OF_MEMORY</literal>,
      not <literal>ERRCODE_INTERNAL_ERROR</literal> (Alexander Kuzmenkov)␟ファイル関連のシステムコールによる<systemitem>ENOMEM</systemitem>エラーを<literal>ERRCODE_INTERNAL_ERROR</literal>ではなく<literal>ERRCODE_OUT_OF_MEMORY</literal>として報告するようにしました。
(Alexander Kuzmenkov)␞␞     </para>␞
␝     <para>␟      In <application>PL/pgSQL</application>, support SQL commands that
      are <command>CREATE FUNCTION</command>/<command>CREATE
      PROCEDURE</command> with SQL-standard bodies (Tom Lane)␟<application>PL/pgSQL</application>で、標準SQL本体を持つ<command>CREATE FUNCTION</command>/<command>CREATE PROCEDURE</command>をサポートしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Previously, such cases failed with parsing errors due to the
      semicolon(s) appearing in the function body.␟以前は、関数本体にセミコロンがあるため、このようなケースは解析エラーで失敗していました。␞␞     </para>␞
␝     <para>␟      Fix <application>libpq</application>'s
      handling of errors in pipelines (&Aacute;lvaro Herrera)␟パイプライン内の<application>libpq</application>のエラー処理を修正しました。
(&Aacute;lvaro Herrera)␞␞     </para>␞
␝     <para>␟      The pipeline state could get out of sync if an error is returned
      for reasons other than a query problem (for example, if the
      connection is lost).  Potentially this would lead to a busy-loop in
      the calling application.␟問い合わせの問題以外の理由でエラーが返された場合（たとえば、接続が失われた場合）、パイプラインの状態が同期しなくなる可能性があります。
これにより、呼び出し側アプリケーションでビジーループが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Make <application>libpq</application>'s
      <function>PQsendFlushRequest()</function> function flush the client
      output buffer under the same rules as
      other <literal>PQsend</literal> functions (Jelte Fennema-Nio)␟<application>libpq</application>の<function>PQsendFlushRequest()</function>関数を、他の<literal>PQsend</literal>関数と同じ規則に従って、クライアント出力バッファをフラッシュするようにしました。
(Jelte Fennema-Nio)␞␞     </para>␞
␝     <para>␟      In pipeline mode, it may still be necessary to
      call <function>PQflush()</function> as well; but this change removes
      some inconsistency.␟パイプラインモードでは、引き続き<function>PQflush()</function>を呼び出す必要がある場合がありますが、この変更により、一部の不整合が解消されます。␞␞     </para>␞
␝     <para>␟      Avoid race condition when <application>libpq</application>
      initializes OpenSSL support concurrently in two different threads
      (Willi Mann, Michael Paquier)␟<application>libpq</application>が2つの異なるスレッドでOpenSSLサポートを同時に初期化する場合の競合状態を回避します。
(Willi Mann, Michael Paquier)␞␞     </para>␞
␝     <para>␟      Fix timing-dependent failure in GSSAPI data transmission (Tom Lane)␟GSSAPIデータ送信におけるタイミング依存の障害を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      When using GSSAPI encryption in non-blocking
      mode, <application>libpq</application> sometimes failed
      with <quote>GSSAPI caller failed to retransmit all data needing to
      be retried</quote>.␟非ブロッキングモードでGSSAPI暗号化を使用すると、<application>libpq</application>が<quote>GSSAPI caller failed to retransmit all data needing to be retried</quote>というエラーを返すことがありました。␞␞     </para>␞
␝     <para>␟      Change <application>initdb</application> to always un-comment
      the <filename>postgresql.conf</filename> entries for
      the <literal>lc_<replaceable>xxx</replaceable></literal> parameters
      (Kyotaro Horiguchi)␟<filename>postgresql.conf</filename>の<literal>lc_<replaceable>xxx</replaceable></literal>パラメータのエントリを常にコメント解除するよう<application>initdb</application>を変更しました。
(Kyotaro Horiguchi)␞␞     </para>␞
␝     <para>␟      <application>initdb</application> used to work this way before v16,
      and now it does again.  The change
      caused <application>initdb</application>'s <option>--no-locale</option>
      option to not have the intended effect
      on <varname>lc_messages</varname>.␟<application>initdb</application>はv16より前はこの方法で動作していましたが、現在は再びこの方法で動作するようになりました。
以前の変更により、<application>initdb</application>の<option>--no-locale</option>オプションが<varname>lc_messages</varname>に意図した効果を及ぼさなくなっていました。␞␞     </para>␞
␝     <para>␟      In <application>pg_dump</application>, don't dump RLS policies or
      security labels for extension member objects (Tom Lane, Jacob
      Champion)␟<application>pg_dump</application>では、拡張メンバオブジェクトのRLSポリシーやセキュリティラベルをダンプしません。
(Tom Lane, Jacob Champion)␞␞     </para>␞
␝     <para>␟      Previously, commands would be included in the dump to set these
      properties, which is really incorrect since they should be
      considered as internal affairs of the extension.  Moreover, the
      restoring user might not have adequate privilege to set them, and
      indeed the dumping user might not have enough privilege to dump them
      (since dumping RLS policies requires acquiring lock on their table).␟以前は、これらのプロパティを設定するためのコマンドがダンプに含まれていましたが、これらは拡張の内部的な問題と考えるべきでまったく正しくありませんでした。
さらに、復元するユーザにはそれらを設定するための十分な権限がない可能性があり、ダンプするユーザにはそれらをダンプするための十分な権限が可能性があります（RLSポリシーのダンプには、それらのテーブルのロックを取得する必要があるため）。␞␞     </para>␞
␝     <para>␟      In <application>pg_dump</application>, don't dump an extended
      statistics object if its underlying table isn't being dumped
      (Rian McGuire, Tom Lane)␟<application>pg_dump</application>では、その元となるテーブルがダンプされていない場合、拡張統計オブジェクトをダンプしません。
(Rian McGuire, Tom Lane)␞␞     </para>␞
␝     <para>␟      This conforms to the behavior for other dependent objects such as
      indexes.␟これは、インデックスなどの他の依存オブジェクトの動作に準拠します。␞␞     </para>␞
␝     <para>␟      Properly detect out-of-memory in one code path
      in <application>pg_dump</application> (Daniel Gustafsson)␟<application>pg_dump</application>の1つのコードパスでメモリ不足を適切に検出します。
(Daniel Gustafsson)␞␞     </para>␞
␝     <para>␟      Make it an error for a <application>pgbench</application> script to
      end with an open pipeline (Anthonin Bonnefoy)␟<application>pgbench</application>スクリプトが開いたままのパイプラインで終了することをエラーにします。
(Anthonin Bonnefoy)␞␞     </para>␞
␝     <para>␟      Previously, <application>pgbench</application> would behave oddly if
      a <command>\startpipeline</command> command lacked a
      matching <command>\endpipeline</command>.  This seems like a
      scripting mistake rather than a case
      that <application>pgbench</application> needs to handle nicely, so
      throw an error.␟以前は、<command>\startpipeline</command>コマンドに対応する<command>\endpipeline</command>がない場合、<application>pgbench</application>は奇妙な動作をしていました。
これは<application>pgbench</application>が適切に処理する必要があるエラーではなく、スクリプトの間違いのようなのでエラーを投げるようにしました。␞␞     </para>␞
␝     <para>␟      Fix crash in <filename>contrib/intarray</filename> if an array with
      an element equal to <literal>INT_MAX</literal> is inserted into
      a <literal>gist__int_ops</literal> index
      (Alexander Lakhin, Tom Lane)␟<literal>INT_MAX</literal>と等しい要素を持つ配列が<literal>gist__int_ops</literal>インデックスに挿入された場合に発生する<filename>contrib/intarray</filename>のクラッシュを修正しました。
(Alexander Lakhin, Tom Lane)␞␞     </para>␞
␝     <para>␟      Report a better error
      when <filename>contrib/pageinspect</filename>'s
      <function>hash_bitmap_info()</function> function is applied to a
      partitioned hash index (Alexander Lakhin, Michael Paquier)␟<filename>contrib/pageinspect</filename>の<function>hash_bitmap_info()</function>関数をパーティション化されたハッシュインデックスに適用した場合に、より適切なエラーを報告するようにしました。
(Alexander Lakhin, Michael Paquier)␞␞     </para>␞
␝     <para>␟      Report a better error
      when <filename>contrib/pgstattuple</filename>'s
      <function>pgstathashindex()</function> function is applied to a
      partitioned hash index (Alexander Lakhin)␟<filename>contrib/pgstattuple</filename>の<function>pgstathashindex()</function>関数をパーティション化されたハッシュインデックスに適用した場合に、より適切なエラーを報告するようにしました。
(Alexander Lakhin)␞␞     </para>␞
␝     <para>␟      On Windows, suppress autorun options when launching subprocesses
      in <application>pg_ctl</application>
      and <application>pg_regress</application> (Kyotaro Horiguchi)␟Windowsでは、<application>pg_ctl</application>と<application>pg_regress</application>でサブプロセスを起動する際に自動起動オプションを抑制します。
(Kyotaro Horiguchi)␞␞     </para>␞
␝     <para>␟      When launching a child process via <filename>cmd.exe</filename>,
      pass the <option>/D</option> flag to prevent executing any autorun
      commands specified in the registry.  This avoids possibly-surprising
      side effects.␟<filename>cmd.exe</filename>経由で子プロセスを起動する場合、<option>/D</option>フラグを渡して、レジストリで指定された自動実行コマンドの実行を防ぎます。
これにより、予期しない副作用が回避できます。␞␞     </para>␞
␝     <para>␟      Move <function>is_valid_ascii()</function>
      from <filename>mb/pg_wchar.h</filename>
      to <filename>utils/ascii.h</filename> (Jubilee Young)␟<function>is_valid_ascii()</function>を<filename>mb/pg_wchar.h</filename>から<filename>utils/ascii.h</filename>に移動しました。
(Jubilee Young)␞␞     </para>␞
␝     <para>␟      This change avoids the need to
      include <filename>&lt;simd.h&gt;</filename>
      in <filename>pg_wchar.h</filename>, which was causing problems for
      some third-party code.␟この変更により、一部のサードパーティコードで問題を引き起こしていた<filename>&lt;simd.h&gt;</filename>を<filename>pg_wchar.h</filename>に含める必要がなくなりました。␞␞     </para>␞
␝     <para>␟      Fix compilation failures with <application>libxml2</application>
      version 2.12.0 and later (Tom Lane)␟<application>libxml2</application>バージョン2.12.0以降でのコンパイル失敗を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Fix compilation failure of <literal>WAL_DEBUG</literal> code on
      Windows (Bharath Rupireddy)␟Windowsでの<literal>WAL_DEBUG</literal>コードのコンパイル失敗を修正しました。
(Bharath Rupireddy)␞␞     </para>␞
␝     <para>␟      Suppress compiler warnings from Python's header files
      (Peter Eisentraut, Tom Lane)␟Python のヘッダファイルからのコンパイラ警告を抑制します。
(Peter Eisentraut, Tom Lane)␞␞     </para>␞
␝     <para>␟      Our preferred compiler options provoke warnings about constructs
      appearing in recent versions of Python's header files.  When using
      <application>gcc</application>, we can suppress these warnings with
      a pragma.␟私たちが推奨するコンパイラオプションは、最新バージョンのPythonのヘッダファイルに現れる構造体について警告を発します。
<application>gcc</application>を使用する場合、プラグマでこれらの警告を抑制できます。␞␞     </para>␞
␝     <para>␟      Avoid deprecation warning when compiling with LLVM 18 (Thomas Munro)␟LLVM 18でのコンパイル時の非推奨警告を回避します。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      Update time zone data files to <application>tzdata</application>
      release 2024a for DST law changes in Greenland, Kazakhstan, and
      Palestine, plus corrections for the Antarctic stations Casey and
      Vostok.  Also historical corrections for Vietnam, Toronto, and
      Miquelon.␟タイムゾーンデータファイルをグリーンランド、カザフスタン、パレスチナでの夏時間法の変更に加え、南極観測点のケイシーとヴォストークを修正した<application>tzdata</application>リリース2024aに更新しました。
また、ベトナム、トロント、ミクロン島の歴史的修正も行われています。␞␞     </para>␞
␝ <sect1 id="release-16-1">␟  <title>Release 16.1</title>␟  <title>リリース16.1</title>␞␞␞
␝  <formalpara>␟  <title>Release date:</title>␟  <title>リリース日:</title>␞␞  <para>2023-11-09</para>␞
␝  <para>␟   This release contains a variety of fixes from 16.0.
   For information about new features in major release 16, see
   <xref linkend="release-16"/>.␟このリリースは16.0に対し、様々な不具合を修正したものです。
16メジャーリリースにおける新機能については、<xref linkend="release-16"/>を参照してください。␞␞  </para>␞
␝  <sect2 id="release-16-1-migration">␟   <title>Migration to Version 16.1</title>␟   <title>バージョン16.1への移行</title>␞␞␞
␝   <para>␟    A dump/restore is not required for those running 16.X.␟16.Xからの移行ではダンプ/リストアは不要です。␞␞   </para>␞
␝   <para>␟    However, several mistakes have been discovered that could lead to
    certain types of indexes yielding wrong search results or being
    unnecessarily inefficient.  It is advisable
    to <command>REINDEX</command> potentially-affected indexes after
    installing this update.  See the fourth through seventh changelog
    entries below.␟しかし、特定の種類のインデックスで間違った検索結果を生成したり、不必要に非効率的になる可能性があるいくつかの間違いが発見されています。
この更新をインストールした後、影響を受ける可能性のあるインデックスに対して<command>REINDEX</command>コマンドの実行をお勧めします。
以下の4番目から7番目の変更ログエントリを参照してください。␞␞   </para>␞
␝  <sect2 id="release-16-1-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝     <para>␟      Fix handling of unknown-type arguments
      in <literal>DISTINCT</literal> <type>"any"</type> aggregate
      functions (Tom Lane)␟<literal>DISTINCT</literal>を付けた<type>"any"</type>型の引数を取る集約関数の不明なデータ型引数の処理を修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This error led to a <type>text</type>-type value being interpreted
      as an <type>unknown</type>-type value (that is, a zero-terminated
      string) at runtime.  This could result in disclosure of server
      memory following the <type>text</type> value.␟このエラーにより、実行時に<type>text</type>型の値が<type>unknown</type>型の値（つまり、ゼロ終端文字列）として解釈されました。
その結果、<type>text</type>型値の後ろのサーバメモリが公開される可能性がありました。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks Jingzhou Fu
      for reporting this problem.
      (CVE-2023-5868)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたJingzhou Fu氏に感謝します。
(CVE-2023-5868)␞␞     </para>␞
␝     <para>␟      Detect integer overflow while computing new array dimensions
      (Tom Lane)␟新しい配列の次元を計算するときに整数オーバーフローを検出します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      When assigning new elements to array subscripts that are outside the
      current array bounds, an undetected integer overflow could occur in
      edge cases.  Memory stomps that are potentially exploitable for
      arbitrary code execution are possible, and so is disclosure of
      server memory.␟現在の配列の境界外にある配列添字に新しい要素を割り当てると、エッジケースで検出されない整数オーバーフローが発生する可能性がありました。
任意のコード実行に悪用される可能性のあるメモリ上書きや、サーバメモリの漏洩も可能でした。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks Pedro
      Gallegos for reporting this problem.
      (CVE-2023-5869)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたPedro Gallegosに感謝します。
(CVE-2023-5869)␞␞     </para>␞
␝     <para>␟      Prevent the <literal>pg_signal_backend</literal> role from
      signalling background workers and autovacuum processes
      (Noah Misch, Jelte Fennema-Nio)␟<literal>pg_signal_backend</literal>ロールがバックグラウンドワーカーと自動バキュームプロセスにシグナルを送信しないようにします。
(Noah Misch, Jelte Fennema-Nio)␞␞     </para>␞
␝     <para>␟      The documentation says that <literal>pg_signal_backend</literal>
      cannot issue signals to superuser-owned processes.  It was able to
      signal these background processes, though, because they advertise a
      role OID of zero.  Treat that as indicating superuser ownership.
      The security implications of cancelling one of these process types
      are fairly small so far as the core code goes (we'll just start
      another one), but extensions might add background workers that are
      more vulnerable.␟ドキュメントには、<literal>pg_signal_backend</literal>はスーパーユーザ所有のプロセスにシグナルを発行できないと書かれています。
しかし、これらのバックグラウンドプロセスロールはOIDをゼロと自称していたので、シグナルを送信できました。
これをスーパーユーザ所有のプロセスとして扱うようにしました。
これらのプロセスタイプの1つを取り消すことによるセキュリティへの影響は、コアコードに関する限りかなり小さいですが（別のプロセスを開始するだけです）、拡張ではより脆弱なバックグラウンドワーカーが追加される可能性があります。␞␞     </para>␞
␝     <para>␟      Also ensure that the <varname>is_superuser</varname> parameter is
      set correctly in such processes.  No specific security consequences
      are known for that oversight, but it might be significant for some
      extensions.␟また、そのようなプロセスでは<varname>is_superuser</varname>パラメータが正しく設定されていることを確認するようにしました。
この見落としによるセキュリティ上の具体的な影響は不明ですが、一部の拡張では重大な影響があるかもしれません。␞␞     </para>␞
␝     <para>␟      The <productname>PostgreSQL</productname> Project thanks
      Hemanth Sandrana and Mahendrakar Srinivasarao
      for reporting this problem.
      (CVE-2023-5870)␟<productname>PostgreSQL</productname>プロジェクトは、本問題を報告してくれたHemanth SandranaとMahendrakar Srinivasaraoに感謝します。
(CVE-2023-5870)␞␞     </para>␞
␝     <para>␟      Fix misbehavior during recursive page split in GiST index build
      (Heikki Linnakangas)␟GiSTインデックス構築時の再帰的なページ分割時の誤動作を修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      Fix a case where the location of a page downlink was incorrectly
      tracked, and introduce some logic to allow recovering from such
      situations rather than silently doing the wrong thing.  This error
      could result in incorrect answers from subsequent index searches.
      It may be advisable to reindex all GiST indexes after installing
      this update.␟ページのダウンリンク位置が誤って追跡されるケースを修正し、そのような状況から回復するためのロジックを導入しました。
このエラーにより、後続のインデックス検索で間違った結果が得られる可能性があります。
この更新をインストールした後に、すべてのGiSTインデックスを再作成することをお勧めします。␞␞     </para>␞
␝     <para>␟      Prevent de-duplication of btree index entries
      for <type>interval</type> columns (Noah Misch)␟<type>interval</type>型列のbtreeインデックスエントリの重複を防止しました。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      There are <type>interval</type> values that are distinguishable but
      compare equal, for example <literal>24:00:00</literal>
      and <literal>1 day</literal>.  This breaks assumptions made by btree
      de-duplication, so <type>interval</type> columns need to be excluded
      from de-duplication.  This oversight can cause incorrect results
      from index-only scans.  Moreover, after
      updating <application>amcheck</application> will report an error for
      almost all such indexes.  Users should reindex any btree indexes
      on <type>interval</type> columns.␟例えば<literal>24:00:00</literal>と<literal>1 day</literal>のように、区別はできるが比較すると等しい<type>interval</type>型の値があります。
これはbtree重複排除による想定を破るため、<type>interval</type>型列は重複排除から除外する必要があります。
この見落としにより、インデックスオンリースキャンで誤った結果が生成される可能性があります。
さらに、更新後の<application>amcheck</application>は、このようなインデックスのほとんどすべてに対してエラーを報告します。
ユーザは<type>interval</type>型列のbtreeインデックスを再作成する必要があります。␞␞     </para>␞
␝     <para>␟      Process <type>date</type> values more sanely in
      BRIN <literal>datetime_minmax_multi_ops</literal> indexes
      (Tomas Vondra)␟<literal>datetime_minmax_multi_ops</literal>のBRINインデックスで、<type>date</type>型の値をより適切に処理するようにしました。
(Tomas Vondra)␞␞     </para>␞
␝     <para>␟      The distance calculation for dates was backward, causing poor
      decisions about which entries to merge.  The index still produces
      correct results, but is much less efficient than it should be.
      Reindexing BRIN <literal>minmax_multi</literal> indexes
      on <type>date</type> columns is advisable.␟日付の距離計算が逆方向であったため、どのエントリをマージするかの判断が不適切でした。
インデックスは依然として正しい結果を生成しますが、本来あるべき状態より大幅に非効率でした。
<type>date</type>型列の<literal>minmax_multi</literal>のBRINインデックスの再作成を推奨します。␞␞     </para>␞
␝     <para>␟      Process large <type>timestamp</type> and <type>timestamptz</type>
      values more sanely in
      BRIN <literal>datetime_minmax_multi_ops</literal> indexes
      (Tomas Vondra)␟<literal>datetime_minmax_multi_ops</literal>のBRINインデックスで、大きな<type>timestamp</type>型と<type>timestamptz</type>型の値をより適切に処理します。
(Tomas Vondra)␞␞     </para>␞
␝     <para>␟      Infinities were mistakenly treated as having distance zero rather
      than a large distance from other values, causing poor decisions
      about which entries to merge.  Also, finite-but-very-large values
      (near the endpoints of the representable timestamp range) could
      result in internal overflows, again causing poor decisions.  The
      index still produces correct results, but is much less efficient
      than it should be.  Reindexing BRIN <literal>minmax_multi</literal>
      indexes on <type>timestamp</type> and <type>timestamptz</type>
      columns is advisable if the column contains, or has contained,
      infinities or large finite values.␟無限大は、他の値からの大きな距離ではなく、距離がゼロであると誤って処理されたため、どのエントリをマージするか不適切な判断をしていました。
また、有限であるが非常に大きい値（表現可能なタイムスタンプ範囲の終点付近）は、内部オーバーフローを引き起こす可能性があり、これもまた不適切な判断の原因となりました。
インデックスは依然として正しい結果を生成しますが、本来あるべき状態より大幅に非効率でした。
<type>timestamp</type>型および<type>timestamptz</type>型の列に無限大または大きな有限値が含まれているか、含まれていた場合は、<literal>minmax_multi</literal>のBRINインデックスの再作成を推奨します。␞␞     </para>␞
␝     <para>␟      Avoid calculation overflows in
      BRIN <literal>interval_minmax_multi_ops</literal> indexes with
      extreme interval values (Tomas Vondra)␟極端なinterval型の値を持つ<literal>interval_minmax_multi_ops</literal>のBRINインデックスでの計算オーバーフローを回避します。
(Tomas Vondra)␞␞     </para>␞
␝     <para>␟      This bug might have caused unexpected failures while trying to
      insert large interval values into such an index.␟このバグは、このようなインデックスに大きなinterval型の値を挿入しようとすると、予期しない障害を引き起こす可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix partition step generation and runtime partition pruning for
      hash-partitioned tables with multiple partition keys (David Rowley)␟複数のパーティションキーを持つハッシュパーティションテーブルに対するパーティションステップ生成と実行時パーティション除去を修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Some cases involving an <literal>IS NULL</literal> condition on one
      of the partition keys could result in a crash.␟パーティションキーの1つに<literal>IS NULL</literal>条件がある場合、クラッシュすることがありました。␞␞     </para>␞
␝     <para>␟      Fix inconsistent rechecking of concurrently-updated rows
      during <command>MERGE</command> (Dean Rasheed)␟<command>MERGE</command>中に同時に更新された行の不整合な再チェックを修正しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      In <literal>READ COMMITTED</literal> mode, an update that finds that
      its target row was just updated by a concurrent transaction will
      recheck the query's <literal>WHERE</literal> conditions on the
      updated row.  <command>MERGE</command> failed to ensure that the
      proper rows of other joined tables were used during this recheck,
      possibly resulting in incorrect decisions about whether the
      newly-updated row should be updated again
      by <command>MERGE</command>.␟<literal>READ COMMITTED</literal>モードでは、ターゲット行が同時実行トランザクションによって更新されたことが判明した更新は、更新された行に対して問い合わせの<literal>WHERE</literal>条件を再チェックします。
<command>MERGE</command>は、この再チェック中に他の結合テーブルの適切な行が使用されることを確認できず、その結果、新しく更新された行が<command>MERGE</command>によって再度更新されるべきかどうかについて誤った判断をする可能性がありました。␞␞     </para>␞
␝     <para>␟      Correctly identify the target table in an
      inherited <command>UPDATE</command>/<command>DELETE</command>/<command>MERGE</command>
      even when the parent table is excluded by constraints (Amit Langote,
      Tom Lane)␟親テーブルが制約によって除外されている場合でも、継承された<command>UPDATE</command>/<command>DELETE</command>/<command>MERGE</command>のターゲットテーブルを正しく識別します。
(Amit Langote, Tom Lane)␞␞     </para>␞
␝     <para>␟      If the initially-named table is excluded by constraints, but not all
      its inheritance descendants are, the first non-excluded descendant
      was identified as the primary target table.  This would lead to
      firing statement-level triggers associated with that table, rather
      than the initially-named table as should happen.  In v16, the same
      oversight could also lead to <quote>invalid perminfoindex 0 in RTE
      with relid NNNN</quote> errors.␟最初に指定されたテーブルが制約によって除外されているが、その継承されたすべての子孫が除外されていない場合、除外されていない最初の子孫が主ターゲットテーブルとして識別されました。
これにより、最初に指定されたテーブルではなく、そのテーブルに関連付けられた文レベルのトリガを起動することになります。
v16では、同じ見落としによって<quote>invalid perminfoindex 0 in RTE with relid NNNN</quote>というエラーが発生する可能性もありました。␞␞     </para>␞
␝     <para>␟      Fix edge case in btree mark/restore processing of ScalarArrayOpExpr
      clauses (Peter Geoghegan)␟ScalarArrayOpExpr句のbtreeマーク/リストア処理でのエッジケースを修正しました。
(Peter Geoghegan)␞␞     </para>␞
␝     <para>␟      When restoring an indexscan to a previously marked position, the
      code could miss required setup steps if the scan had advanced
      exactly to the end of the matches for a ScalarArrayOpExpr (that is,
      an <literal>indexcol = ANY(ARRAY[])</literal>) clause.  This could
      result in missing some rows that should have been fetched.␟インデックススキャンを以前にマークされた位置にリストアする場合、スキャンがScalarArrayOpExpr(つまり、<literal>indexcol = ANY(ARRAY</literal>)句の一致の最後まで正確に進んだ場合、コードは必要なセットアップ手順を見逃す可能性がありました。
その結果、取得されるべき行が欠落する可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix intra-query memory leak in Memoize execution
      (Orlov Aleksej, David Rowley)␟Memoize実行時の問い合わせ内部のメモリリークを修正しました。
(Orlov Aleksej, David Rowley)␞␞     </para>␞
␝     <para>␟      Fix intra-query memory leak when a set-returning function repeatedly
      returns zero rows (Tom Lane)␟集合を返す関数が繰り返しゼロ行を返す場合の問い合わせ内部のメモリリークを修正しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Don't crash if <function>cursor_to_xmlschema()</function> is applied
      to a non-data-returning Portal (Boyu Yang)␟<function>cursor_to_xmlschema()</function>関数がデータを返さないPortalに適用された場合にクラッシュしないようにしました。
(Boyu Yang)␞␞     </para>␞
␝     <para>␟      Fix improper sharing of origin filter condition across
      successive <function>pg_logical_slot_get_changes()</function> calls
      (Hou Zhijie)␟連続した<function>pg_logical_slot_get_changes()</function>関数の呼び出し間でのオリジンフィルタ条件の不適切な共有を修正しました。
(Hou Zhijie)␞␞     </para>␞
␝     <para>␟      The origin condition set by one call of this function would be
      re-used by later calls that did not specify the origin argument.
      This was not intended.␟この関数の1回の呼び出しで設定されたオリジン条件は、オリジン引数を指定しなかった後続の呼び出しで再利用されていました。
これは意図されたものではありません。␞␞     </para>␞
␝     <para>␟      Throw the intended error if <function>pgrowlocks()</function> is
      applied to a partitioned table (David Rowley)␟<function>pgrowlocks()</function>関数がパーティションテーブルに適用された場合に、意図したエラーが発生します。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Previously, a not-on-point complaint <quote>only heap AM is
      supported</quote> would be raised.␟以前は、<quote>only heap AM is supported</quote>という的外れなエラーが発生していました。␞␞     </para>␞
␝     <para>␟      Handle invalid indexes more cleanly in assorted SQL functions
      (Noah Misch)␟様々なSQL関数で無効なインデックスをよりきれいに処理します。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      Report an error if <function>pgstatindex()</function>,
      <function>pgstatginindex()</function>,
      <function>pgstathashindex()</function>,
      or <function>pgstattuple()</function> is applied to an invalid
      index.  If <function>brin_desummarize_range()</function>,
      <function>brin_summarize_new_values()</function>,
      <function>brin_summarize_range()</function>,
      or <function>gin_clean_pending_list()</function> is applied to an
      invalid index, do nothing except to report a debug-level message.
      Formerly these functions attempted to process the index, and might
      fail in strange ways depending on what the failed <command>CREATE
      INDEX</command> had left behind.␟<function>pgstatindex()</function>、<function>pgstatginindex()</function>、<function>pgstathashindex()</function>、<function>pgstattuple()</function>が無効なインデックスに適用された場合にエラーを報告します。
<function>brin_desummarize_range()</function>、<function>brin_summarize_new_values()</function>、<function>brin_summarize_range()</function>、または<function>gin_clean_pending_list()</function>が無効なインデックスに適用された場合、デバッグレベルのメッセージを報告する以外は何も行われません。
以前は、これらの関数はインデックスを処理しようとしていましたが、失敗した<command>CREATE INDEX</command>が残したものによっては、奇妙な方法で失敗する可能性がありました。␞␞     </para>␞
␝     <para>␟      Avoid premature memory allocation failure with long inputs
      to <function>to_tsvector()</function> (Tom Lane)␟<function>to_tsvector()</function>への長い入力に対する早すぎるメモリ割り当てエラーを回避します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Fix over-allocation of the constructed <type>tsvector</type>
      in <function>tsvectorrecv()</function> (Denis Erokhin)␟<function>tsvectorrecv()</function>関数で構築された<type>tsvector</type>の過剰割り当てを修正しました。
(Denis Erokhin)␞␞     </para>␞
␝     <para>␟      If the incoming vector includes position data, the binary receive
      function left wasted space (roughly equal to the size of the
      position data) in the finished <type>tsvector</type>.  In extreme
      cases this could lead to <quote>maximum total lexeme length
      exceeded</quote> failures for vectors that were under the length
      limit when emitted.  In any case it could lead to wasted space
      on-disk.␟受信ベクトルに位置データが含まれている場合、バイナリ受信関数は、完成した<type>tsvector</type>内に無駄なスペース（位置データのサイズとほぼ等しい）を残していました。
極端な場合、これにより出力時に長さ制限を下回っていたベクトルに対して<quote>maximum total lexeme length exceeded</quote>エラーを引き起こす可能性がありました。
いずれにしても、ディスク上のスペースが無駄になる可能性がありました。␞␞     </para>␞
␝     <para>␟      Improve checks for corrupt PGLZ compressed data (Flavien Guedez)␟破損したPGLZ圧縮データの検査を改善しました。
(Flavien Guedez)␞␞     </para>␞
␝     <para>␟      Fix <command>ALTER SUBSCRIPTION</command> so that a commanded change
      in the <literal>run_as_owner</literal> option is actually applied
      (Hou Zhijie)␟<literal>run_as_owner</literal>オプションのコマンドによる変更が実際に適用されるように<command>ALTER SUBSCRIPTION</command>を修正しました。
(Hou Zhijie)␞␞     </para>␞
␝     <para>␟      Fix bulk table insertion into partitioned tables (Andres Freund)␟パーティションテーブルへの一括テーブル挿入を修正しました。
(Andres Freund)␞␞     </para>␞
␝     <para>␟      Improper sharing of insertion state across partitions could result
      in failures during <command>COPY FROM</command>, typically
      manifesting as <quote>could not read block NNNN in file XXXX: read
      only 0 of 8192 bytes</quote> errors.␟パーティション間での挿入状態の不適切な共有により、<command>COPY FROM</command>中に障害が発生する可能性があり、典型的には<quote>could not read block NNNN in file XXXX: read only 0 of 8192 bytes</quote>というエラーとして表示されます。␞␞     </para>␞
␝     <para>␟      In <command>COPY FROM</command>, avoid evaluating column default
      values that will not be needed by the command (Laurenz Albe)␟<command>COPY FROM</command>で、コマンドが必要としない列のデフォルト値を評価しないようにします。
(Laurenz Albe)␞␞     </para>␞
␝     <para>␟      This avoids a possible error if the default value isn't actually
      valid for the column, or if the default's expression would fail in
      the current execution context.  Such edge cases sometimes arise
      while restoring dumps, for example.  Previous releases did not fail
      in this situation, so prevent v16 from doing so.␟これにより、デフォルト値が実際にはその列に対して有効でない場合や、デフォルトの式が現在の実行コンテキストで失敗する場合に発生する可能性のあるエラーを回避できます。
このようなエッジケースは、例えばダンプのリストア時などに発生することがありました。
以前のリリースではこのような状況で失敗しなかったので、v16でもこのような状況を回避します。␞␞     </para>␞
␝     <para>␟      In <command>COPY FROM</command>, fail cleanly when an unsupported
      encoding conversion is needed (Tom Lane)␟<command>COPY FROM</command>で、サポートされていないエンコーディング変換が必要な場合にちゃんと失敗するようにしました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Recent refactoring accidentally removed the intended error check for
      this, such that it ended in <quote>cache lookup failed for function
      0</quote> instead of a useful error message.␟最近のリファクタリングで、これに対する意図したエラーチェックが誤って削除されたため、有用なエラーメッセージではなく<quote>cache lookup failed for function 0</quote>というエラーで終了していました。␞␞     </para>␞
␝     <para>␟      Avoid crash in <command>EXPLAIN</command> if a parameter marked to
      be displayed by <command>EXPLAIN</command> has a NULL boot-time
      value (Xing Guo, Aleksander Alekseev, Tom Lane)␟<command>EXPLAIN</command>によって表示されるようにマークされたパラメータの起動時の値がNULLである場合、<command>EXPLAIN</command>でのクラッシュを回避します。
(Xing Guo, Aleksander Alekseev, Tom Lane)␞␞     </para>␞
␝     <para>␟      No built-in parameter fits this description, but an extension could
      define such a parameter.␟この説明に当てはまる組み込みパラメータはありませんが、拡張機能でそのようなパラメータを定義できます。␞␞     </para>␞
␝     <para>␟      Ensure we have a snapshot while dropping <literal>ON COMMIT
      DROP</literal> temp tables (Tom Lane)␟<literal>ON COMMIT DROP</literal>での一時テーブル削除中にスナップショットがあることを確認します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      This prevents possible misbehavior if any catalog entries for the
      temp tables have fields wide enough to require toasting (such as a
      very complex <literal>CHECK</literal> condition).␟これにより、一時テーブルのカタログエントリにTOASTを必要とするような大きな幅のフィールドがある場合（非常に複雑な<literal>CHECK</literal>条件など）に起こりうる誤動作を防ぐことができます。␞␞     </para>␞
␝     <para>␟      Avoid improper response to shutdown signals in child processes
      just forked by <function>system()</function> (Nathan Bossart)␟<function>system()</function>でフォークされたばかりの子プロセスのシャットダウン信号に対する不適切な応答を回避します。
(Nathan Bossart)␞␞     </para>␞
␝     <para>␟      This fix avoids a race condition in which a child process that has
      been forked off by <function>system()</function>, but hasn't yet
      exec'd the intended child program, might receive and act on a signal
      intended for the parent server process.  That would lead to
      duplicate cleanup actions being performed, which will not end well.␟この修正により、<function>system()</function>によってフォークされたが、まだ目的の子プログラムを実行していない子プロセスが、親サーバプロセス用に意図されたシグナルを受け取って処理する可能性がある競合状態が回避されます。
これにより、重複したクリーンアップ処理が実行され、好ましくない結果になっていました。␞␞     </para>␞
␝     <para>␟      Cope with torn reads of <filename>pg_control</filename> in frontend
      programs (Thomas Munro)␟フロントエンドプログラムで<filename>pg_control</filename>の破損した読み込みに対処します。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      On some file systems, reading <filename>pg_control</filename> may
      not be an atomic action when the server concurrently writes that
      file.  This is detectable via a bad CRC.  Retry a few times to see
      if the file becomes valid before we report error.␟一部のファイルシステムでは、サーバが同時にそのファイルに書き込む場合、<filename>pg_control</filename>の読み込みがアトミックな動作にならないことがあります。
これは、不正なCRCによって検出できます。
エラーを報告する前に、数回試行してファイルが有効になるかどうかを確認するようにしました。␞␞     </para>␞
␝     <para>␟      Avoid torn reads of <filename>pg_control</filename> in relevant SQL
      functions (Thomas Munro)␟関連するSQL関数で<filename>pg_control</filename>の破損した読み込みを回避します。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      Acquire the appropriate lock before
      reading <filename>pg_control</filename>, to ensure we get a
      consistent view of that file.␟<filename>pg_control</filename>を読み込む前に適切なロックを取得して、そのファイルの一貫したビューを確保しました。␞␞     </para>␞
␝     <para>␟      Fix <quote>could not find pathkey item to sort</quote> errors
      occurring while planning aggregate functions with <literal>ORDER
      BY</literal> or <literal>DISTINCT</literal> options (David Rowley)␟<literal>ORDER BY</literal>または<literal>DISTINCT</literal>オプションを使用した集約関数の計画時に発生する<quote>could not find pathkey item to sort</quote>というエラーを修正しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Avoid integer overflow when computing size of backend activity
      string array (Jakub Wartak)␟バックエンドアクティビティの文字列配列のサイズを計算する際の整数オーバーフローを回避します。
(Jakub Wartak)␞␞     </para>␞
␝     <para>␟      On 64-bit machines we will allow values
      of <varname>track_activity_query_size</varname> large enough to
      cause 32-bit overflow when multiplied by the allowed number of
      connections.  The code actually allocating the per-backend local
      array was careless about this though, and allocated the array
      incorrectly.␟64ビットマシンでは、許可された接続数を乗算したときに32ビットオーバーフローが発生するような大きな<varname>track_activity_query_size</varname>の値を許可します。
しかし、バックエンドごとのローカル配列を実際に割り当てるコードは、この点について不注意で、配列を誤って割り当てていました。␞␞     </para>␞
␝     <para>␟      Fix briefly showing inconsistent progress statistics
      for <command>ANALYZE</command> on inherited tables
      (Heikki Linnakangas)␟継承テーブルでの<command>ANALYZE</command>に対する一貫性のない進捗状況統計が一時的に表示される問題を修正しました。
(Heikki Linnakangas)␞␞     </para>␞
␝     <para>␟      The block-level counters should be reset to zero at the same time we
      update the current-relation field.␟ブロックレベルカウンタは、現在のリレーションフィールドを更新すると同時にゼロにリセットされる必要がありました。␞␞     </para>␞
␝     <para>␟      Fix the background writer to report any WAL writes it makes to the
      statistics counters (Nazir Bilal Yavuz)␟統計カウンタにWAL書き込みを報告するようにバックグラウンドライタを修正しました。
(Nazir Bilal Yavuz)␞␞     </para>␞
␝     <para>␟      Fix confusion about forced-flush behavior
      in <function>pgstat_report_wal()</function>
      (Ryoga Yoshida, Michael Paquier)␟<function>pgstat_report_wal()</function>の強制フラッシュ動作に関する混乱を修正しました。
(Ryoga Yoshida, Michael Paquier)␞␞     </para>␞
␝     <para>␟      This could result in some statistics about WAL I/O being forgotten
      in a shutdown.␟これにより、シャットダウン時にWAL I/Oに関する一部の統計情報が忘れられる可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix statistics tracking of temporary-table extensions (Karina
      Litskevich, Andres Freund)␟一時テーブルの拡張に関する統計追跡を修正しました。
(Karina Litskevich, Andres Freund)␞␞     </para>␞
␝     <para>␟      These were counted as normal-table writes when they should be
      counted as temp-table writes.␟これらは、一時テーブル書き込みとしてカウントされるべきときに、通常のテーブル書き込みとしてカウントされていました。␞␞     </para>␞
␝     <para>␟      When <varname>track_io_timing</varname> is enabled, include the
      time taken by relation extension operations as write time
      (Nazir Bilal Yavuz)␟<varname>track_io_timing</varname>が有効な場合、リレーション拡張操作にかかった時間を書き込み時間として含めます。
(Nazir Bilal Yavuz)␞␞     </para>␞
␝     <para>␟      Track the dependencies of cached <command>CALL</command> statements,
      and re-plan them when needed (Tom Lane)␟キャッシュされた<command>CALL</command>文の依存関係を追跡し、必要な場合に再計画します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      DDL commands, such as replacement of a function that has been
      inlined into a <command>CALL</command> argument, can create the need
      to re-plan a <command>CALL</command> that has been cached by
      PL/pgSQL.  That was not happening, leading to misbehavior or strange
      errors such as <quote>cache lookup failed</quote>.␟<command>CALL</command>の引数でインライン化された関数を置き換えるDDLコマンドは、PL/pgSQLによってキャッシュされている<command>CALL</command>を再計画する必要性を生じさせます。
これが行なわれなかったため、誤動作や<quote>cache lookup failed</quote>などの奇妙なエラーが発生していました。␞␞     </para>␞
␝     <para>␟      Avoid a possible pfree-a-NULL-pointer crash after an error in
      OpenSSL connection setup (Sergey Shinderuk)␟OpenSSL接続のセットアップでエラーが発生した後のpfree-a-NULL-pointerクラッシュの可能性を回避します。
(Sergey Shinderuk)␞␞     </para>␞
␝     <para>␟      Track nesting depth correctly when
      inspecting <type>RECORD</type>-type Vars from outer query levels
      (Richard Guo)␟外部問い合わせレベルから<type>RECORD</type>型のVarsを検査する際に正しくネストの深さを追跡します。
(Richard Guo)␞␞     </para>␞
␝     <para>␟      This oversight could lead to assertion failures, core dumps,
      or <quote>bogus varno</quote> errors.␟この見落としにより、アサーションエラー、コアダンプ、または<quote>bogus varno</quote>エラーが発生する可能性がありました。␞␞     </para>␞
␝     <para>␟      Track hash function and negator function dependencies of
      ScalarArrayOpExpr plan nodes (David Rowley)␟ScalarArrayOpExprプランノードのハッシュ関数と否定関数の依存関係を追跡します。
(David Rowley)␞␞     </para>␞
␝     <para>␟      In most cases this oversight was harmless, since these functions
      would be unlikely to disappear while the node's original operator
      remains present.␟ほとんどの場合、ノードの元の演算子が存在している間はこれらの関数が消滅する可能性が低いため、この見落としは無害でした。␞␞     </para>␞
␝     <para>␟      Fix error-handling bug in <type>RECORD</type> type cache management
      (Thomas Munro)␟<type>RECORD</type>型のキャッシュ管理におけるエラー処理のバグを修正しました。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      An out-of-memory error occurring at just the wrong point could leave
      behind inconsistent state that would lead to an infinite loop.␟メモリ不足エラーが不適切な時点で発生すると、無限ループにつながる一貫性のない状態を残す可能性がありました。␞␞     </para>␞
␝     <para>␟      Treat out-of-memory failures as fatal while reading WAL
      (Michael Paquier)␟WALの読み込み中のメモリ不足エラーを致命的なエラーとして扱います。
(Michael Paquier)␞␞     </para>␞
␝     <para>␟      Previously this would be treated as a bogus-data condition, leading
      to the conclusion that we'd reached the end of WAL, which is
      incorrect and could lead to inconsistent WAL replay.␟以前は、これは偽のデータ状態として扱われ、WALの終わりに達したという結論に至りましたが、これは誤りであり、一貫性のないWAL再生につながる可能性がありました。␞␞     </para>␞
␝     <para>␟      Fix possible recovery failure due to trying to allocate memory based
      on a bogus WAL record length field (Thomas Munro, Michael Paquier)␟不正なWALレコード長フィールドに基づいてメモリを割り当てようとしたために起こりうるリカバリ失敗を修正しました。
(Thomas Munro, Michael Paquier)␞␞     </para>␞
␝     <para>␟      Fix <quote>could not duplicate handle</quote> error occurring on
      Windows when <varname>min_dynamic_shared_memory</varname> is set
      above zero (Thomas Munro)␟<varname>min_dynamic_shared_memory</varname>が0より大きく設定された場合にWindowsで発生する<quote>could not duplicate handle</quote>エラーを修正しました。
(Thomas Munro)␞␞     </para>␞
␝     <para>␟      Fix order of operations in <function>GenericXLogFinish</function>
      (Jeff Davis)␟<function>GenericXLogFinish</function>の処理順序を修正しました。
(Jeff Davis)␞␞     </para>␞
␝     <para>␟      This code violated the conditions required for crash safety by
      writing WAL before marking changed buffers dirty.  No core code uses
      this function, but extensions do (<filename>contrib/bloom</filename>
      does, for example).␟このコードは、変更されたバッファをダーティにマークする前にWALを書き込むことで、クラッシュ安全性に必要な条件に違反していました。
この関数はコアコードでは使用されませんが、拡張では使用されます（例えば<filename>contrib/bloom</filename>では使用されます）。␞␞     </para>␞
␝     <para>␟      Remove incorrect assertion in PL/Python exception handling
      (Alexander Lakhin)␟PL/Python例外処理での誤ったアサーションを削除しました。
(Alexander Lakhin)␞␞     </para>␞
␝     <para>␟      Fix <application>pg_dump</application> to dump the
      new <literal>run_as_owner</literal> option of subscriptions
      (Philip Warner)␟サブスクリプションの新しい<literal>run_as_owner</literal>オプションをダンプするように<application>pg_dump</application>を修正しました。
(Philip Warner)␞␞     </para>␞
␝     <para>␟      Due to this oversight, subscriptions would always be restored
      with <literal>run_as_owner</literal> set
      to <literal>false</literal>, which is not equivalent to their
      behavior in pre-v16 releases.␟この見落としのため、サブスクリプションは常に<literal>run_as_owner</literal>が<literal>false</literal>に設定された状態でリストアされていました。
これはv16より前のリリースでの動作と同等ではありません。␞␞     </para>␞
␝     <para>␟      Fix <application>pg_restore</application> so that selective restores
      will include both table-level and column-level ACLs for selected
      tables (Euler Taveira, Tom Lane)␟選択的リストアが選択されたテーブルのテーブルレベルと列レベルの両方のACLを含むように<application>pg_restore</application>を修正しました。
(Euler Taveira, Tom Lane)␞␞     </para>␞
␝     <para>␟      Formerly, only the table-level ACL would get restored if both types
      were present.␟以前は、両方のタイプが存在する場合、テーブルレベルのACLのみがリストアされていました。␞␞     </para>␞
␝     <para>␟      Add logic to <application>pg_upgrade</application> to check for use
      of <type>abstime</type>, <type>reltime</type>,
      and <type>tinterval</type> data types (&Aacute;lvaro Herrera)␟<application>pg_upgrade</application>に、<type>abstime</type>、<type>reltime</type>、<type>tinterval</type>のデータ型の使用を検査するロジックを追加します。
(&Aacute;lvaro Herrera)␞␞     </para>␞
␝     <para>␟      These obsolete data types were removed
      in <productname>PostgreSQL</productname> version 12, so check to
      make sure they aren't present in an older database before claiming
      it can be upgraded.␟これらの旧式のデータ型は<productname>PostgreSQL</productname>バージョン12で削除されたため、アップグレード可能であると主張する前に、古いデータベースに存在しないことを確認します。␞␞     </para>␞
␝     <para>␟      Avoid false <quote>too many client connections</quote> errors
      in <application>pgbench</application> on Windows (Noah Misch)␟Windows上の<application>pgbench</application>での誤った<quote>too many client connections</quote>エラーを回避しました。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      Fix <application>vacuumdb</application>'s handling of
      multiple <option>-N</option> switches (Nathan Bossart, Kuwamura
      Masaki)␟<application>vacuumdb</application>の複数の<option>-N</option>スイッチの処理を修正しました。
(Nathan Bossart, Kuwamura Masaki)␞␞     </para>␞
␝     <para>␟      Multiple <option>-N</option> switches should exclude tables
      in multiple schemas, but in fact excluded nothing due to faulty
      construction of a generated query.␟複数の<option>-N</option>スイッチは複数のスキーマ内のテーブルを除外するはずですが、生成された問い合わせの構築に誤りがあったため、実際には何も除外されませんでした。␞␞     </para>␞
␝     <para>␟      Fix <application>vacuumdb</application> to honor
      its <option>--buffer-usage-limit</option> option in analyze-only
      mode (Ryoga Yoshida, David Rowley)␟<application>vacuumdb</application>がANALYZEのみのモードで<option>--buffer-usage-limit</option>オプションを適切に処理するよう修正しました。
(Ryoga Yoshida, David Rowley)␞␞     </para>␞
␝     <para>␟      In <filename>contrib/amcheck</filename>, do not report interrupted
      page deletion as corruption (Noah Misch)␟<filename>contrib/amcheck</filename>では、中断されたページ削除を破損として報告しないようにしました。
(Noah Misch)␞␞     </para>␞
␝     <para>␟      This fix prevents false-positive reports of <quote>the first child
      of leftmost target page is not leftmost of its
      level</quote>, <quote>block NNNN is not leftmost</quote>
      or <quote>left link/right link pair in index XXXX not in
      agreement</quote>.  They appeared
      if <application>amcheck</application> ran after an unfinished btree
      index page deletion and before <command>VACUUM</command> had cleaned
      things up.␟この修正により、<quote>the first child of leftmost target page is not leftmost of its level</quote>、<quote>block NNNN is not leftmost</quote>、<quote>left link/right link pair in index XXXX is not in agreement</quote>という誤検出の報告が出なくなりました。
これらの報告は、未完了のbtreeインデックスページの削除後、<command>VACUUM</command>がクリーンアップする前に<application>amcheck</application>が実行された場合に表示されました。␞␞     </para>␞
␝     <para>␟      Fix failure of <filename>contrib/btree_gin</filename> indexes
      on <type>interval</type> columns,
      when an indexscan using the <literal>&lt;</literal>
      or <literal>&lt;=</literal> operator is performed (Dean Rasheed)␟<filename>contrib/btree_gin</filename>で、<literal>&lt;</literal>または<literal>&lt;=</literal>演算子を使用して<type>interval</type>列にインデックスに対するインデックススキャンが実行された場合の失敗を修正しました。
(Dean Rasheed)␞␞     </para>␞
␝     <para>␟      Such an indexscan failed to return all the entries it should.␟このようなインデックススキャンは、返されるべきすべてのエントリを返すことができませんでした。␞␞     </para>␞
␝     <para>␟      Add support for LLVM 16 and 17 (Thomas Munro, Dmitry Dolgov)␟LLVM 16と17のサポートを追加しました。
(Thomas Munro, Dmitry Dolgov)␞␞     </para>␞
␝     <para>␟      Suppress assorted build-time warnings on
      recent <productname>macOS</productname> (Tom Lane)␟最近の<productname>macOS</productname>での様々なビルド時の警告を抑制します。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      <productname>Xcode 15</productname> (released
      with <productname>macOS Sonoma</productname>) changed the linker's
      behavior in a way that causes many duplicate-library warnings while
      building <productname>PostgreSQL</productname>.  These were
      harmless, but they're annoying so avoid citing the same libraries
      twice.  Also remove use of the <option>-multiply_defined
      suppress</option> linker switch, which apparently has been a no-op
      for a long time, and is now actively complained of.␟<productname>Xcode 15</productname>（<productname>macOS Sonoma</productname>とともにリリース）では、リンカの動作が変更され、<productname>PostgreSQL</productname>のビルド時に多数の重複ライブラリ警告が発生するようになりました。
これらは無害でしたが、煩わしいので、同じライブラリを2回引用することは避けるようにしました。
また、<option>-multiply_defined suppress</option>リンカスイッチの使用を削除しました。
これは長い間何も実行されていなかったようで、現在は積極的に警告が出ています。␞␞     </para>␞
␝     <para>␟      When building <filename>contrib/unaccent</filename>'s rules file,
      fall back to using <literal>python</literal>
      if <literal>--with-python</literal> was not given and make
      variable <literal>PYTHON</literal> was not set (Japin Li)␟<filename>contrib/unaccent</filename>のルールファイルをビルドする際、<literal>--with-python</literal>が指定されておらず、make変数<literal>PYTHON</literal>が設定されていなければ、<literal>python</literal>を使うようにフォールバックします。
(Japin Li)␞␞     </para>␞
␝     <para>␟      Remove <literal>PHOT</literal> (Phoenix Islands Time) from the
      default timezone abbreviations list (Tom Lane)␟デフォルトのタイムゾーンの略語リストから<literal>PHOT</literal>（フェニックス諸島時間）を削除しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Presence of this abbreviation in the default list can cause failures
      on recent Debian and Ubuntu releases, as they no longer install the
      underlying tzdb entry by default.  Since this is a made-up
      abbreviation for a zone with a total human population of about two
      dozen, it seems unlikely that anyone will miss it.  If someone does,
      they can put it back via a custom abbreviations file.␟デフォルトのリストにこの略語があると、最近のDebianやUbuntuのリリースでは、基礎となるtzdbエントリがデフォルトでインストールされなくなっているため、エラーが発生する可能性があります。
これは、人口が約24人のゾーン用の略語なので、それを見逃す人はまずいないでしょう。
もし見逃した場合でも、カスタム略語ファイルを使用して元に戻すことができます。␞␞     </para>␞
␝ <sect1 id="release-16">␟  <title>Release 16</title>␟  <title>リリース16</title>␞␞␞
␝  <formalpara>␟   <title>Release date:</title>␟   <title>リリース日:</title>␞␞   <para>2023-09-14</para>␞
␝  <sect2 id="release-16-highlights">␟   <title>Overview</title>␟   <title>概要</title>␞␞␞
␝   <para>␟    <productname>PostgreSQL</productname> 16 contains many new features
    and enhancements, including:␟<productname>PostgreSQL</productname> 16には、以下をはじめとする多数の新機能と拡張が含まれます。␞␞   </para>␞
␝     <para>␟      Allow parallelization of <literal>FULL</literal> and internal right <literal>OUTER</literal> hash joins␟<literal>FULL</literal>ハッシュ結合および内部右<literal>OUTER</literal>ハッシュ結合で並列処理ができるようになりました。␞␞     </para>␞
␝     <para>␟      Allow logical replication from standby servers␟スタンバイサーバからの論理レプリケーションができるようになりました。␞␞     </para>␞
␝     <para>␟      Allow logical replication subscribers to apply large transactions in parallel␟論理レプリケーションのサブスクライバーで大規模なトランザクションを並列に適用できるようになりました。␞␞     </para>␞
␝     <para>␟      Allow monitoring of <acronym>I/O</acronym> statistics using the new <structname>pg_stat_io</structname> view␟新しい<structname>pg_stat_io</structname>ビューを使用した<acronym>I/O</acronym>統計情報の監視ができるようになりました。␞␞     </para>␞
␝     <para>␟      Add <acronym>SQL/JSON</acronym> constructors and identity functions␟<acronym>SQL/JSON</acronym>コンストラクタと識別関数を追加しました。␞␞     </para>␞
␝     <para>␟      Improve performance of vacuum freezing␟バキューム凍結の性能を改善しました。␞␞     </para>␞
␝     <para>␟      Add support for regular expression matching of user and database names in <filename>pg_hba.conf</filename>, and user names in <filename>pg_ident.conf</filename>␟<filename>pg_hba.conf</filename>のユーザ名とデータベース名、および<filename>pg_ident.conf</filename>のユーザ名の正規表現マッチングがサポートされました。␞␞     </para>␞
␝   <para>␟    The above items and other new features of
    <productname>PostgreSQL</productname> 16 are explained in more detail
    in the sections below.␟<productname>PostgreSQL</productname> 16の上記の項目とその他の新機能は次節でより詳しく説明されます。␞␞   </para>␞
␝␟   <title>Migration to Version 16</title>␟   <title>バージョン16への移行</title>␞␞␞
␝   <para>␟    A dump/restore using <xref linkend="app-pg-dumpall"/> or use of
    <xref linkend="pgupgrade"/> or logical replication is required for
    those wishing to migrate data from any previous release.  See <xref
    linkend="upgrading"/> for general information on migrating to new
    major releases.␟以前のリリースからデータを移行したい時は、どのリリースについても、<xref linkend="app-pg-dumpall"/>を利用したダンプとリストア、あるいは<xref linkend="pgupgrade"/>や論理レプリケーションの使用が必要です。
新たなメジャーバージョンへの移行に関する一般的な情報については<xref linkend="upgrading"/>を参照してください。␞␞   </para>␞
␝   <para>␟    Version 16 contains a number of changes that may affect compatibility
    with previous releases.  Observe the following incompatibilities:␟バージョン16には、以前のバージョンとの互換性に影響するかもしれない多数の変更点が含まれています。以下の非互換性に注意してください。␞␞   </para>␞
␝     <para>␟      Change assignment rules for <link
      linkend="plpgsql-open-bound-cursor"><application>PL/pgSQL</application></link>
      bound cursor variables (Tom Lane)␟<link linkend="plpgsql-open-bound-cursor"><application>PL/pgSQL</application></link>のバウンドカーソル変数の割り当て規則が変更されました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Previously, the string value of such variables
      was set to match the variable name during cursor
      assignment;  now it will be assigned during <link
      linkend="plpgsql-cursor-opening"><command>OPEN</command></link>,
      and will not match the variable name.  To restore the previous
      behavior, assign the desired portal name to the cursor variable
      before <command>OPEN</command>.␟以前は、このような変数の文字列値は、カーソル割り当て時に変数名に一致するように設定されていました。
これからは、<link linkend="plpgsql-cursor-opening"><command>OPEN</command></link>時に割り当てられ、変数名と一致しません。
以前の動作に戻すには、<command>OPEN</command>の前にカーソル変数に目的のポータル名を割り当ててください。␞␞     </para>␞
␝     <para>␟      Disallow <link linkend="sql-createindex"><literal>NULLS NOT
      DISTINCT</literal></link> indexes for primary keys (Daniel
      Gustafsson)␟主キーに対する<link linkend="sql-createindex"><literal>NULLS NOT DISTINCT</literal></link>インデックスを禁止しました。
(Daniel Gustafsson)␞␞     </para>␞
␝     <para>␟      Change <link linkend="sql-reindex"><command>REINDEX
      DATABASE</command></link> and <link
      linkend="app-reindexdb"><application>reindexdb</application></link>
      to not process indexes on system catalogs (Simon Riggs)␟<link linkend="sql-reindex"><command>REINDEX DATABASE</command></link>と<link linkend="app-reindexdb"><application>reindexdb</application></link>がシステムカタログのインデックスを処理しないように変更しました。
(Simon Riggs)␞␞     </para>␞
␝     <para>␟      Processing such indexes is still possible using <command>REINDEX
      SYSTEM</command> and <link linkend="app-reindexdb"><command>reindexdb
      --system</command></link>.␟このようなインデックスの処理は、<command>REINDEX SYSTEM</command>と<link linkend="app-reindexdb"><command>reindexdb --system</command></link>を使用して引き続き可能です。␞␞     </para>␞
␝     <para>␟      Tighten <link
      linkend="ddl-generated-columns"><literal>GENERATED</literal></link>
      expression restrictions on inherited and partitioned tables (Amit
      Langote, Tom Lane)␟継承テーブルとパーティションテーブルに対する<link linkend="ddl-generated-columns"><literal>GENERATED</literal></link>式の制限を強化しました。
(Amit Langote, Tom Lane)␞␞     </para>␞
␝     <para>␟      Columns of parent/partitioned and child/partition tables must all
      have the same generation status, though now the actual generation
      expressions can be different.␟親テーブル(パーティションテーブル)と子テーブル(パーティション)の列はすべて同じ生成状態を持つ必要があります。しかし、実際の生成式は異なっていても構いません。␞␞     </para>␞
␝     <para>␟      Remove <link
      linkend="pgwalinspect"><application>pg_walinspect</application></link>
      functions
      <function>pg_get_wal_records_info_till_end_of_wal()</function>
      and <function>pg_get_wal_stats_till_end_of_wal()</function>
      (Bharath Rupireddy)␟<link linkend="pgwalinspect"><application>pg_walinspect</application></link>関数<function>pg_get_wal_records_info_till_end_of_wal()</function>と<function>pg_get_wal_stats_till_end_of_wal()</function>を削除しました。
(Bharath Rupireddy)␞␞     </para>␞
␝     <para>␟      Rename server variable
      <varname>force_parallel_mode</varname> to <link
      linkend="guc-debug-parallel-query"><varname>debug_parallel_query</varname></link>
      (David Rowley)␟サーバパラメータ<varname>force_parallel_mode</varname>を<link linkend="guc-debug-parallel-query"><varname>debug_parallel_query</varname></link>に変更しました。
(David Rowley)␞␞     </para>␞
␝     <para>␟      Remove the ability to <link linkend="sql-createview">create
      views</link> manually with <literal>ON SELECT</literal> rules
      (Tom Lane)␟<literal>ON SELECT</literal>ルールを使用した<link linkend="sql-createview">create views</link>を禁止しました。
(Tom Lane)␞␞     </para>␞
␝     <para>␟      Remove the server variable
      <varname>vacuum_defer_cleanup_age</varname> (Andres Freund)␟サーバパラメータ<varname>vacuum_defer_cleanup_age</varname>を削除しました。
(Andres Freund)␞␞     </para>␞
␝     <para>␟      This has been unnecessary since <link
      linkend="guc-hot-standby-feedback"><varname>hot_standby_feedback</varname></link>
      and <link linkend="streaming-replication-slots">replication
      slots</link> were added.␟<link linkend="guc-hot-standby-feedback"><varname>hot_standby_feedback</varname></link>と<link linkend="streaming-replication-slots">レプリケーションスロット</link>が追加されたことで、これは不要になりました。␞␞     </para>␞
␝     <para>␟      Remove server variable <varname>promote_trigger_file</varname>
      (Simon Riggs)␟サーバパラメータ<varname>promote_trigger_file</varname>を削除しました。
(Simon Riggs)␞␞     </para>␞
␝     <para>␟      This was used to promote a standby to primary, but is now more easily
      accomplished with <link linkend="app-pg-ctl"><literal>pg_ctl
      promote</literal></link> or <link
      linkend="functions-recovery-control-table"><function>pg_promote()</function></link>.␟これはスタンバイからプライマリへの昇格に使用されていましたが、現在は<link linkend="app-pg-ctl"><literal>pg_ctl promote</literal></link>または<link linkend="functions-recovery-control-table"><function>pg_promote()</function></link>関数で容易に実行できます。␞␞     </para>␞
␝     <para>␟      Remove read-only server variables <varname>lc_collate</varname>
      and <varname>lc_ctype</varname> (Peter Eisentraut)␟読み取り専用サーバパラメータ<varname>lc_collate</varname>と<varname>lc_ctype</varname>を削除しました。
(Peter Eisentraut)␞␞     </para>␞
␝     <para>␟      Collations and locales can vary between databases so having them
      as read-only server variables was unhelpful.␟照合順序とロケールはデータベースによって異なる可能性があるため、読み取り専用のサーバパラメータは役に立っていませんでした。␞␞     </para>␞
␝     <para>␟      Role inheritance now controls the default
      inheritance status of member roles added during <link
      linkend="sql-grant"><command>GRANT</command></link> (Robert Haas)␟ロール継承で、<link linkend="sql-grant"><command>GRANT</command></link>の実行時に追加されたメンバロールのデフォルトの継承ステータスが制御されるようにしました。
(Robert Haas)␞␞     </para>␞
␝     <para>␟      The role's default inheritance behavior can be overridden with the
      new <command>GRANT ... WITH INHERIT</command> clause.  This allows
      inheritance of some roles and not others because the members'
      inheritance status is set at <command>GRANT</command> time.
      Previously the inheritance status of member roles was controlled
      only by the role's inheritance status, and changes to a role's
      inheritance status affected all previous and future member roles.␟ロールのデフォルトの継承動作は、新しい<command>GRANT ... WITH INHERIT</command>句で上書きできます。
これにより、メンバの継承ステータスは<command>GRANT</command>時に設定されるため、一部のロールだけが継承され、他のロールは継承されません。
以前は、メンバの継承ステータスはロールの継承ステータスによってのみ制御され、ロールの継承ステータスに対する変更は、以前と将来のすべてのメンバロールに影響していました。␞␞     </para>␞
␝     <para>␟      Restrict the privileges of <link
      linkend="sql-createrole"><literal>CREATEROLE</literal></link>
      and its ability to modify other roles (Robert Haas)␟<link linkend="sql-createrole"><literal>CREATEROLE</literal></link>の権限と他のロールを変更する能力を制限しました。
(Robert Haas)␞␞     </para>␞
␝     <para>␟      Previously roles with <literal>CREATEROLE</literal> privileges could
      change many aspects of any non-superuser role.  Such changes,
      including adding members, now require the role requesting
      the change to have <literal>ADMIN OPTION</literal> permission.
      For example, they can now change the <literal>CREATEDB</literal>,
      <literal>REPLICATION</literal>, and <literal>BYPASSRLS</literal>
      properties only if they also have those permissions.␟以前は、<literal>CREATEROLE</literal>権限を持つロールは、スーパーユーザ以外のロールの多くの側面を変更することができました。
メンバの追加を含むこれらの変更には、変更を要求するロールに<literal>ADMIN OPTION</literal>権限が要求されるようになりました。
たとえば、<literal>CREATEDB</literal>、<literal>REPLICATION</literal>、<literal>BYPASSRLS</literal>プロパティを変更できるのは、これらの権限を持つ場合に限られます。␞␞     </para>␞
␝     <para>␟      Remove symbolic links for the <application>postmaster</application>
      binary (Peter Eisentraut)␟<application>postmaster</application>バイナリへのシンボリックリンクを削除しました。
(Peter Eisentraut)␞␞     </para>␞
␝  <sect2 id="release-16-changes">␟   <title>Changes</title>␟   <title>変更点</title>␞␞␞
␝    <para>␟     Below you will find a detailed account of the changes between
    <productname>PostgreSQL</productname> 16 and the previous major
    release.␟<productname>PostgreSQL</productname> 16と前メジャーリリースとの詳細な変更点を記載しました。␞␞    </para>␞
␝   <sect3 id="release-16-server">␟    <title>Server</title>␟    <title>サーバ</title>␞␞␞
␝    <sect4 id="release-16-optimizer">␟     <title>Optimizer</title>␟     <title>オプティマイザ</title>␞␞␞
␝       <para>␟        Allow incremental sorts in more cases, including
        <literal>DISTINCT</literal> (David Rowley)␟インクリメンタルソートが<literal>DISTINCT</literal>を含むより多くの場合で使用可能にしました。
(David Rowley)␞␞       </para>␞
␝       <para>␟        Add the ability for aggregates having <literal>ORDER BY</literal>
        or <literal>DISTINCT</literal> to use pre-sorted data (David
        Rowley)␟<literal>ORDER BY</literal>または<literal>DISTINCT</literal>を持つ集約で、ソート済みのデータを使用できるようにしました。
(David Rowley)␞␞       </para>␞
␝       <para>␟        The new server variable <link
        linkend="guc-enable-presorted-aggregate"><varname>enable_presorted_aggregate</varname></link>
        can be used to disable this.␟新しいサーバパラメータ<link linkend="guc-enable-presorted-aggregate"><varname>enable_presorted_aggregate</varname></link>を使用することで、この機能を無効にできます。␞␞       </para>␞
␝       <para>␟        Allow memoize atop a <literal>UNION ALL</literal> (Richard Guo)␟<literal>UNION ALL</literal>の最上位ノードでMemoizeを利用可能にしました。
(Richard Guo)␞␞       </para>␞
␝       <para>␟        Allow anti-joins to be performed with the non-nullable input as
        the inner relation (Richard Guo)␟非NULL入力を内部リレーションとするアンチ結合を実行可能にしました。
(Richard Guo)␞␞       </para>␞
␝       <para>␟        Allow parallelization of <link
        linkend="queries-join"><literal>FULL</literal></link> and internal
        right <literal>OUTER</literal> hash joins (Melanie Plageman,
        Thomas Munro)␟<link linkend="queries-join"><literal>FULL</literal></link>ハッシュ結合と内部の右<literal>OUTER</literal>ハッシュ結合で並列処理が実行できるようにしました。
(Melanie Plageman, Thomas Munro)␞␞       </para>␞
␝       <para>␟        Improve the accuracy of <link
        linkend="gin"><literal>GIN</literal></link> index access optimizer
        costs (Ronan Dunklau)␟<link linkend="gin"><literal>GIN</literal></link>インデックスアクセスのオプティマイザコスト精度を改善しました。
(Ronan Dunklau)␞␞       </para>␞
␝    <sect4 id="release-16-performance">␟     <title>General Performance</title>␟     <title>性能一般</title>␞␞␞
␝       <para>␟        Allow more efficient addition of heap and index pages (Andres
        Freund)␟ヒープページとインデックスページをより効率的に追加できるようにしました。
(Andres Freund)␞␞       </para>␞
␝       <para>␟        During non-freeze operations, perform page <link
        linkend="vacuum-for-wraparound">freezing</link> where appropriate
        (Peter Geoghegan)␟非凍結処理中でも、必要に応じてページの<link linkend="vacuum-for-wraparound">凍結</link>を実行するようにしました。
(Peter Geoghegan)␞␞       </para>␞
␝       <para>␟        This makes full-table freeze vacuums less necessary.␟これにより、テーブル全体の凍結バキュームの必要性が低くなります。␞␞       </para>␞
␝       <para>␟        Allow window functions to use the faster <link
        linkend="syntax-window-functions"><literal>ROWS</literal></link>
        mode internally when <literal>RANGE</literal> mode is active but
        unnecessary (David Rowley)␟<literal>RANGE</literal>モードがアクティブであるが不要な場合に、ウィンドウ関数が内部的に高速な<link linkend="syntax-window-functions"><literal>ROWS</literal></link>モードを使用できるようにしました。
(David Rowley)␞␞       </para>␞
␝       <para>␟        Allow optimization of always-increasing window functions <link
        linkend="functions-window-table"><function>ntile()</function></link>,
        <function>cume_dist()</function> and
        <function>percent_rank()</function> (David Rowley)␟常に増加するウィンドウ関数<link linkend="functions-window-table"><function>ntile()</function></link>、<function>cume_dist()</function>、<function>percent_rank()</function>の最適化を可能にしました。
(David Rowley)␞␞       </para>␞
␝       <para>␟        Allow aggregate functions <link
        linkend="functions-aggregate-table"><function>string_agg()</function></link>
        and <function>array_agg()</function> to be parallelized (David
        Rowley)␟集約関数<link linkend="functions-aggregate-table"><function>string_agg()</function></link>と<function>array_agg()</function>で並列処理をできるようにしました。
(David Rowley)␞␞       </para>␞
␝       <para>␟        Improve performance by caching <link
        linkend="ddl-partitioning-overview"><literal>RANGE</literal></link>
        and <literal>LIST</literal> partition lookups (Amit Langote,
        Hou Zhijie, David Rowley)␟<link linkend="ddl-partitioning-overview"><literal>RANGE</literal></link>および<literal>LIST</literal>パーティション検索をキャッシュすることでパフォーマンスを改善しました。
(Amit Langote, Hou Zhijie, David Rowley)␞␞       </para>␞
␝       <para>␟        Allow control of the shared buffer usage by vacuum and analyze
        (Melanie Plageman)␟VACUUMとANALYZEによる共有バッファ使用量の制御が可能になりました。
(Melanie Plageman)␞␞       </para>␞
␝       <para>␟        The <link
        linkend="sql-vacuum"><command>VACUUM</command></link>/<link
        linkend="sql-analyze"><command>ANALYZE</command></link>
        option is <literal>BUFFER_USAGE_LIMIT</literal>, and the <link
        linkend="app-vacuumdb"><application>vacuumdb</application></link>
        option is <option>--buffer-usage-limit</option>.
        The default value is set by server variable <link
        linkend="guc-vacuum-buffer-usage-limit"><varname>vacuum_buffer_usage_limit</varname></link>,
        which also controls autovacuum.␟<link linkend="sql-vacuum"><command>VACUUM</command></link>/<link linkend="sql-analyze"><command>ANALYZE</command></link>オプションは<literal>BUFFER_USAGE_LIMIT</literal>で、<link linkend="app-vacuumdb"><application>vacuumdb</application></link>オプションは<option>--buffer-usage-limit</option>です。
デフォルト値はサーバパラメータ<link linkend="guc-vacuum-buffer-usage-limit"><varname>vacuum_buffer_usage_limit</varname></link>で設定され、自動バキュームもこれで制御されます。␞␞       </para>␞
␝       <para>␟        Support <link
        linkend="guc-wal-sync-method"><literal>wal_sync_method=fdatasync</literal></link>
        on <systemitem class="osname">Windows</systemitem> (Thomas Munro)␟<systemitem class="osname">Windows</systemitem>で<link linkend="guc-wal-sync-method"><literal>wal_sync_method=fdatasync</literal></link>がサポートされました。
(Thomas Munro)␞␞       </para>␞
␝       <para>␟        Allow <link linkend="storage-hot"><acronym>HOT</acronym></link>
        updates if only <literal>BRIN</literal>-indexed columns are updated
        (Matthias van de Meent, Josef Simanek, Tomas Vondra)␟<literal>BRIN</literal>インデックスの列のみが更新される場合でも<link linkend="storage-hot"><acronym>HOT</acronym></link>更新できるようにしました。
(Matthias van de Meent, Josef Simanek, Tomas Vondra)␞␞       </para>␞
␝       <para>␟        Improve the speed of updating the <link
        linkend="guc-update-process-title">process title</link> (David
        Rowley)␟<link linkend="guc-update-process-title">プロセスタイトル</link>の更新速度を改善しました。
(David Rowley)␞␞       </para>␞
␝       <para>␟        Allow <type>xid</type>/<type>subxid</type> searches and
        <acronym>ASCII</acronym> string detection to use vector operations
        (Nathan Bossart, John Naylor)␟<type>xid</type>/<type>subxid</type>検索と<acronym>ASCII</acronym>文字列検出でベクトル演算が使用できるようになりました。
(Nathan Bossart, John Naylor)␞␞       </para>␞
␝       <para>␟        <acronym>ASCII</acronym> detection is particularly useful for
        <link linkend="sql-copy"><command>COPY FROM</command></link>.
        Vector operations are also used for some C array searches.␟<acronym>ASCII</acronym>文字列検出は、<link linkend="sql-copy"><command>COPY FROM</command></link>で特に役立ちます。
ベクトル演算は、いくつかのC配列検索にも使用されます。␞␞       </para>␞
␝       <para>␟        Reduce overhead of memory allocations (Andres Freund, David Rowley)␟メモリ割り当てのオーバーヘッドを削減しました。
(Andres Freund, David Rowley)␞␞       </para>␞
␝    <sect4 id="release-16-monitoring">␟     <title>Monitoring</title>␟     <title>監視</title>␞␞␞
␝       <para>␟        Add system view <link
        linkend="monitoring-pg-stat-io-view"><structname>pg_stat_io</structname></link>
        view to track <acronym>I/O</acronym> statistics (Melanie Plageman)␟<acronym>I/O</acronym>統計を追跡するための<link linkend="monitoring-pg-stat-io-view"><structname>pg_stat_io</structname></link>システムビューを追加しました。
(Melanie Plageman)␞␞       </para>␞
␝       <para>␟        Record statistics on the last sequential and index scans on tables
        (Dave Page)␟テーブルに対する最後のシーケンシャルスキャンとインデックススキャンに関する統計情報を記録するようにしました。
(Dave Page)␞␞       </para>␞
␝       <para>␟        This information appears in <link
        linkend="pg-stat-all-tables-view"><structname>pg_stat_*_tables</structname></link>
        and <link
        linkend="monitoring-pg-stat-all-indexes-view"><structname>pg_stat_*_indexes</structname></link>.␟この情報は<link linkend="pg-stat-all-tables-view"><structname>pg_stat_*_tables</structname></link>と<link linkend="monitoring-pg-stat-all-indexes-view"><structname>pg_stat_*_indexes</structname></link>に表示されます。␞␞       </para>␞
␝       <para>␟        Record statistics on the occurrence of updated rows moving to
        new pages (Corey Huinker)␟新しいページへの移動が発生した更新された行の統計情報を記録するようにしました。
(Corey Huinker)␞␞       </para>␞
␝       <para>␟        The <literal>pg_stat_*_tables</literal> column is <link
        linkend="monitoring-pg-stat-all-tables-view"><structfield>n_tup_newpage_upd</structfield></link>.␟<literal>pg_stat_*_tables</literal>列は<link linkend="monitoring-pg-stat-all-tables-view"><structfield>n_tup_newpage_upd</structfield></link>です。␞␞       </para>␞
␝       <para>␟        Add speculative lock information to the <link
        linkend="view-pg-locks"><structname>pg_locks</structname></link>
        system view (Masahiko Sawada, Noriyoshi Shinoda)␟投機的ロックの情報を<link linkend="view-pg-locks"><structname>pg_locks</structname></link>システムビューに追加しました。
(Masahiko Sawada, Noriyoshi Shinoda)␞␞       </para>␞
␝       <para>␟        The transaction id is displayed in the
        <structfield>transactionid</structfield> column and
        the speculative insertion token is displayed in the
        <structfield>objid</structfield> column.␟トランザクションIDは<structfield>transactionid</structfield>列に、投機的挿入トークンは<structfield>objid</structfield>列に表示されます。␞␞       </para>␞
␝       <para>␟        Add the display of prepared statement result types to the <link
        linkend="view-pg-prepared-statements"><structname>pg_prepared_statements</structname></link>
        view (Dagfinn Ilmari Mannsåker)␟<link linkend="view-pg-prepared-statements"><structname>pg_prepared_statements</structname></link>ビューにプリペアド文の結果型の表示を追加しました。
(Dagfinn Ilmari Mannsåker)␞␞       </para>␞
␝       <para>␟        Create subscription statistics
        entries at subscription creation time so <link
        linkend="pg-stat-database-view"><structfield>stats_reset</structfield></link>
        is accurate (Andres Freund)␟<link linkend="pg-stat-database-view"><structfield>stats_reset</structfield></link>が正確になるように、サブスクリプション作成時にサブスクリプション統計エントリを作成するようにしました。
(Andres Freund)␞␞       </para>␞
␝       <para>␟        Previously entries were created only when the first statistics
        were reported.␟以前は、最初の統計が報告されたときにのみエントリが作成されていました。␞␞       </para>␞
␝       <para>␟        Correct the <acronym>I/O</acronym>
        accounting for temp relation writes shown in <link
        linkend="pg-stat-database-view"><structname>pg_stat_database</structname></link>
        (Melanie Plageman)␟<link linkend="pg-stat-database-view"><structname>pg_stat_database</structname></link>で表示される一時リレーション書き込みの<acronym>I/O</acronym>集計を修正しました。
(Melanie Plageman)␞␞       </para>␞
␝       <para>␟        Add function <link
        linkend="monitoring-stats-backend-funcs-table"><function>pg_stat_get_backend_subxact()</function></link>
        to report on a session's subtransaction cache (Dilip Kumar)␟セッションのサブトランザクションキャッシュを報告する<link linkend="monitoring-stats-backend-funcs-table"><function>pg_stat_get_backend_subxact()</function></link>関数を追加しました。
(Dilip Kumar)␞␞       </para>␞
␝       <para>␟        Have <link
        linkend="monitoring-stats-backend-funcs-table"><function>pg_stat_get_backend_idset()</function></link>,
        <function>pg_stat_get_backend_activity()</function>, and related
        functions use the unchanging backend id (Nathan Bossart)␟<link linkend="monitoring-stats-backend-funcs-table"><function>pg_stat_get_backend_idset()</function></link>、<function>pg_stat_get_backend_activity()</function>、および関連する関数で、変更されないバックエンドIDを使用するようにしました。
(Nathan Bossart)␞␞       </para>␞
␝       <para>␟        Previously the index values might change during the lifetime of
        the session.␟以前は、セッションの存続期間中にインデックス値が変更される可能性がありました。␞␞       </para>␞
␝       <para>␟        Report stand-alone backends with a special backend type (Melanie
        Plageman)␟特別なバックエンドタイプを持つスタンドアローンのバックエンドが表示されるようになりました。
(Melanie Plageman)␞␞       </para>␞
␝       <para>␟        Add wait event <link
        linkend="wait-event-timeout-table"><literal>SpinDelay</literal></link>
        to report spinlock sleep delays (Andres Freund)␟スピンロック遅延時間を報告するための待機イベント<link linkend="wait-event-timeout-table"><literal>SpinDelay</literal></link>を追加しました。
(Andres Freund)␞␞       </para>␞
␝       <para>␟        Create new wait event <link
        linkend="wait-event-io-table"><literal>DSMAllocate</literal></link>
        to indicate waiting for dynamic shared memory allocation (Thomas
        Munro)␟動的共有メモリ割り当て待機を示す新しい待機イベント<link linkend="wait-event-io-table"><literal>DSMAllocate</literal></link>を作成しました。
(Thomas Munro)␞␞       </para>␞
␝       <para>␟        Previously this type of wait was reported as
        <literal>DSMFillZeroWrite</literal>, which was also used by
        <function>mmap()</function> allocations.␟以前は、このタイプの待機は<function>mmap()</function>割り当てでも使用されている<literal>DSMFillZeroWrite</literal>と報告されていました。␞␞       </para>␞
␝       <para>␟        Add the database name to the <link
        linkend="guc-update-process-title">process title</link> of logical
        <acronym>WAL</acronym> senders (Tatsuhiro Nakamori)␟論理<acronym>WAL</acronym>送信の<link linkend="guc-update-process-title">プロセスタイトル</link>にデータベース名を追加しました。
(Tatsuhiro Nakamori)␞␞       </para>␞
␝       <para>␟        Physical <acronym>WAL</acronym> senders do not display a database
        name.␟物理<acronym>WAL</acronym>送信ではデータベース名を表示しません。␞␞       </para>␞
␝       <para>␟        Add checkpoint and <literal>REDO LSN</literal> information to <link
        linkend="guc-log-checkpoints"><varname>log_checkpoints</varname></link>
        messages (Bharath Rupireddy, Kyotaro Horiguchi)␟チェックポイントと<literal>REDO LSN</literal>情報を<link linkend="guc-log-checkpoints"><varname>log_checkpoints</varname></link>メッセージに追加しました。
(Bharath Rupireddy, Kyotaro Horiguchi)␞␞       </para>␞
␝       <para>␟        Provide additional details during client certificate failures
        (Jacob Champion)␟クライアント証明書のエラー時に、より詳細な情報を提供するようにしました。
(Jacob Champion)␞␞       </para>␞
␝    <sect4 id="release-16-privileges">␟     <title>Privileges</title>␟     <title>権限</title>␞␞␞
␝       <para>␟        Add predefined role <link
        linkend="predefined-roles"><literal>pg_create_subscription</literal></link>
        with permission to create subscriptions (Robert Haas)␟サブスクリプション作成の権限を持つ定義済みロール<link linkend="predefined-roles"><literal>pg_create_subscription</literal></link>を追加しました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        Allow subscriptions to not require passwords (Robert Haas)␟パスワードを必要としないサブスクリプションが利用可能になりました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        This is accomplished with the option <link
        linkend="sql-createsubscription"><literal>password_required=false</literal></link>.␟これは、<link linkend="sql-createsubscription"><literal>password_required=false</literal></link>オプションで実現できます。␞␞       </para>␞
␝       <para>␟        Simplify permissions for <link linkend="sql-lock"><command>LOCK
        TABLE</command></link> (Jeff Davis)␟<link linkend="sql-lock"><command>LOCK TABLE</command></link>の権限を単純化しました。
(Jeff Davis)␞␞       </para>␞
␝       <para>␟        Previously a user's ability to perform <command>LOCK
        TABLE</command> at various lock levels was limited to the
        lock levels required by the commands they had permission
        to execute on the table.  For example, someone with <link
        linkend="sql-update"><command>UPDATE</command></link>
        permission could perform all lock levels except <literal>ACCESS
        SHARE</literal>, even though it was a lesser lock level.  Now users
        can issue lesser lock levels if they already have permission for
        greater lock levels.␟以前は、ユーザがさまざまなロックレベルで<command>LOCK TABLE</command>を実行できる機能は、テーブルに対して実行する権限を持つコマンドに必要なロックレベルに制限されていました。
たとえば、<link linkend="sql-update"><command>UPDATE</command></link>権限を持つユーザは、たとえそれが低いロックレベルであっても、<literal>ACCESS SHARE</literal>を除くすべてのロックレベルを実行できました。
現在ではユーザは、より大きなロックレベルの権限を持っていれば、より小さなロックレベルを発行できるようになりました。␞␞       </para>␞
␝       <para>␟        Allow <link linkend="sql-altergroup"><literal>ALTER GROUP group_name
        ADD USER user_name</literal></link> to be performed with <literal>ADMIN
        OPTION</literal> (Robert Haas)␟<literal>ADMIN OPTION</literal>を伴った<link linkend="sql-altergroup"><literal>ALTER GROUP group_name ADD USER user_name</literal></link>を実行できるようにしました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        Previously <literal>CREATEROLE</literal> permission was required.␟以前は<literal>CREATEROLE</literal>権限が必要でした。␞␞       </para>␞
␝       <para>␟        Allow <link linkend="sql-grant"><command>GRANT</command></link>
        to use <literal>WITH ADMIN TRUE</literal>/<literal>FALSE</literal>
        syntax (Robert Haas)␟<link linkend="sql-grant"><command>GRANT</command></link>で<literal>WITH ADMIN TRUE</literal>/<literal>FALSE</literal>構文を使用できるようにしました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        Previously only the <literal>WITH ADMIN OPTION</literal> syntax
        was supported.␟以前は、<literal>WITH ADMIN OPTION</literal>構文のみがサポートされていました。␞␞       </para>␞
␝       <para>␟        Allow roles that create other roles to automatically
        inherit the new role's rights or the ability to <link
        linkend="sql-set-role"><command>SET ROLE</command></link> to the
        new role (Robert Haas, Shi Yu)␟他のロールを作成するロールが、新しいロールの権限、または新しいロールに<link linkend="sql-set-role"><command>SET ROLE</command></link>をする機能を自動的に継承できるようにしました。
(Robert Haas, Shi Yu)␞␞       </para>␞
␝       <para>␟        This is controlled by server variable <link
        linkend="guc-createrole-self-grant"><varname>createrole_self_grant</varname></link>.␟これはサーバパラメータ<link linkend="guc-createrole-self-grant"><varname>createrole_self_grant</varname></link>で制御します。␞␞       </para>␞
␝       <para>␟        Prevent users from changing the default privileges of non-inherited
        roles (Robert Haas)␟ユーザが継承していないロールのデフォルト権限を変更できないようにしました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        This is now only allowed for inherited roles.␟これからは、継承されたロールに対してのみ許可されるようになりました。␞␞       </para>␞
␝       <para>␟        When granting role membership, require the granted-by role to be
        a role that has appropriate permissions (Robert Haas)␟ロールのメンバシップを付与するときに、付与元のロールが適切な権限を持つロールであることを要求されるようになりました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        This is a requirement even when a non-bootstrap superuser is
        granting role membership.␟これは、ブートストラップ以外のスーパーユーザがロールメンバシップを付与する場合でも必要です。␞␞       </para>␞
␝       <para>␟        Allow non-superusers to grant permissions using a granted-by user
        that is not the current user (Robert Haas)␟スーパーユーザ以外のユーザが、現在のユーザでない付与元のユーザを使用して権限を付与できるようにしました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        The current user still must have sufficient permissions given by
        the specified granted-by user.␟現在のユーザは、依然として指定された付与元のユーザによって与えられた権限を持っている必要があります。␞␞       </para>␞
␝       <para>␟        Add <link linkend="sql-grant"><command>GRANT</command></link> to
        control permission to use <link linkend="sql-set-role"><command>SET
        ROLE</command></link> (Robert Haas)␟<link linkend="sql-grant"><command>GRANT</command></link>に<link linkend="sql-set-role"><command>SET ROLE</command></link>を使用する権限の制御を追加しました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        This is controlled by a new <literal>GRANT ... SET</literal>
        option.␟これは新しい<literal>GRANT ... SET</literal>オプションで制御されます。␞␞       </para>␞
␝       <para>␟        Add dependency tracking to roles which have granted privileges
        (Robert Haas)␟付与された権限を持つロールの依存関係を追跡するようになりました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        For example, removing <literal>ADMIN OPTION</literal> will fail if
        there are privileges using that option;  <literal>CASCADE</literal>
        must be used to revoke dependent permissions.␟たとえば、<literal>ADMIN OPTION</literal>を使用している権限がある場合、そのオプションの削除は失敗します。
依存する権限を取り消すには<literal>CASCADE</literal>を使用する必要があります。␞␞       </para>␞
␝       <para>␟        Add dependency tracking of grantors for <link
        linkend="sql-grant"><command>GRANT</command></link> records
        (Robert Haas)␟<link linkend="sql-grant"><command>GRANT</command></link>レコードの権限所有者(grantor)の依存関係の追跡を追加しました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        This guarantees that <link
        linkend="catalog-pg-auth-members"><structname>pg_auth_members</structname></link>.<structfield>grantor</structfield>
        values are always valid.␟これにより、<link linkend="catalog-pg-auth-members"><structname>pg_auth_members</structname>.<structfield>grantor</structfield></link>の値が常に有効であることが保証されます。␞␞       </para>␞
␝       <para>␟        Allow multiple role membership records (Robert Haas)␟複数のロールメンバシップを持つレコードが許可されるようになりました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        Previously a new membership grant would remove a previous matching
        membership grant, even if other aspects of the grant did not match.␟以前は、新しいメンバシップ付与が付与の他の側面と一致していなくても、以前の一致するメンバシップ付与を削除していました。␞␞       </para>␞
␝       <para>␟        Prevent removal of superuser privileges for the bootstrap user
        (Robert Haas)␟ブートストラップユーザからのスーパーユーザ権限の削除を禁止しました。
(Robert Haas)␞␞       </para>␞
␝       <para>␟        Restoring such users could lead to errors.␟このようなユーザをリストアすると、エラーが発生する可能性があります。␞␞       </para>␞
␝       <para>␟        Allow <link
        linkend="functions-aclitem-fn-table"><function>makeaclitem()</function></link>
        to accept multiple privilege names (Robins Tharakan)␟<link linkend="functions-aclitem-fn-table"><function>makeaclitem()</function></link>が複数の権限名を受け付けられるようにしました。
(Robins Tharakan)␞␞       </para>␞
␝       <para>␟        Previously only a single privilege name, like <link
        linkend="sql-select"><command>SELECT</command></link>, was
        accepted.␟以前は<link linkend="sql-select"><command>SELECT</command></link>などのように、1つの権限名しか受け付けませんでした。␞␞       </para>␞
␝    <sect4 id="release-16-server-config">␟     <title>Server Configuration</title>␟     <title>サーバ設定</title>␞␞␞
␝       <para>␟        Add support for <productname>Kerberos</productname> credential
        delegation (Stephen Frost)␟<productname>Kerberos</productname>の認証情報の委任をサポートしました。
(Stephen Frost)␞␞       </para>␞
␝       <para>␟        This is enabled with server variable <link
        linkend="guc-gss-accept-delegation"><varname>gss_accept_delegation</varname></link>
        and <application>libpq</application> connection parameter <link
        linkend="libpq-connect-gssdelegation"><literal>gssdelegation</literal></link>.␟これは、サーバパラメータ<link linkend="guc-gss-accept-delegation"><varname>gss_accept_delegation</varname></link>と<application>libpq</application>接続パラメータ<link linkend="libpq-connect-gssdelegation"><literal>gssdelegation</literal></link>で有効にできます。␞␞       </para>␞
␝       <para>␟        Allow the <acronym>SCRAM</acronym> iteration
        count to be set with server variable <link
        linkend="guc-scram-iterations"><varname>scram_iterations</varname></link>
        (Daniel Gustafsson)␟サーバパラメータ<link linkend="guc-scram-iterations"><varname>scram_iterations</varname></link>で<acronym>SCRAM</acronym>の繰り返し回数を設定できるようにしました。
(Daniel Gustafsson)␞␞       </para>␞
␝       <para>␟        Improve performance of server variable management (Tom Lane)␟サーバパラメータ管理のパフォーマンスを改善しました。
(Tom Lane)␞␞       </para>␞
␝       <para>␟        Tighten restrictions on which server variables can be reset
        (Masahiko Sawada)␟サーバパラメータのリセットに関する制限を強化しました。
(Masahiko Sawada)␞␞       </para>␞
␝       <para>␟        Previously, while certain variables, like <link
        linkend="guc-default-transaction-isolation"><varname>transaction_isolation</varname></link>,
        were not affected by <link linkend="sql-reset"><command>RESET
        ALL</command></link>, they could be individually reset in
        inappropriate situations.␟以前は、<link linkend="guc-default-transaction-isolation"><varname>transaction_isolation</varname></link>のような特定の変数は<link linkend="sql-reset"><command>RESET ALL</command></link>の影響を受けませんでしたが、不適切な状況では個別にリセットする可能性がありました。␞␞       </para>␞
␝       <para>␟        Move various <link
        linkend="config-setting-configuration-file"><filename>postgresql.conf</filename></link>
        items into new categories (Shinya Kato)␟さまざまな<link linkend="config-setting-configuration-file"><filename>postgresql.conf</filename></link>項目を新しいカテゴリに移動しました。
(Shinya Kato)␞␞       </para>␞
␝       <para>␟        This also affects the categories displayed in the <link
        linkend="view-pg-settings"><structname>pg_settings</structname></link>
        view.␟これは<link linkend="view-pg-settings"><structname>pg_settings</structname></link>ビューに表示されるカテゴリにも影響します。␞␞       </para>␞
␝       <para>␟        Prevent configuration file recursion beyond 10 levels (Julien
        Rouhaud)␟設定ファイルが10レベルを超えて再帰アクセスすることを防止しました。
(Julien Rouhaud)␞␞       </para>␞
␝       <para>␟        Allow <link linkend="autovacuum">autovacuum</link> to more
        frequently honor changes to delay settings (Melanie Plageman)␟<link linkend="autovacuum">autovacuum</link>が遅延設定の変更をより頻繁に確認するようにしました。
(Melanie Plageman)␞␞       </para>␞
␝       <para>␟        Rather than honor changes only at the start of each relation,
        honor them at the start of each block.␟各リレーションの開始時にのみ変更を確認するのではなく、各ブロックの開始時にも確認するようになりました。␞␞       </para>␞
␝       <para>␟        Remove restrictions that archive files be durably renamed
        (Nathan Bossart)␟アーカイブファイルの名前を永続的に変更する制限を削除しました。
(Nathan Bossart)␞␞       </para>␞
␝       <para>␟        The <link
        linkend="guc-archive-command"><varname>archive_command</varname></link>
        command is now more likely to be called with already-archived
        files after a crash.␟<link linkend="guc-archive-command"><varname>archive_command</varname></link>コマンドは、クラッシュ後にすでにアーカイブ済みのファイルを呼び出す可能性が高くなりました。␞␞       </para>␞
␝       <para>␟        Prevent <link
        linkend="guc-archive-library"><varname>archive_library</varname></link>
        and <link
        linkend="guc-archive-command"><varname>archive_command</varname></link>
        from being set at the same time (Nathan Bossart)␟<link linkend="guc-archive-library"><varname>archive_library</varname></link>と<link linkend="guc-archive-command"><varname>archive_command</varname></link>を同時に設定できないようにしました。
(Nathan Bossart)␞␞       </para>␞
␝       <para>␟        Previously <varname>archive_library</varname> would override
        <varname>archive_command</varname>.␟以前は、<varname>archive_library</varname>が<varname>archive_command</varname>よりも優先されていました。␞␞       </para>␞
␝       <para>␟        Allow the postmaster to terminate children with an abort signal
        (Tom Lane)␟postmasterがABORTシグナルで子プロセスを終了できるようにしました。
(Tom Lane)␞␞       </para>␞
␝       <para>␟        This allows collection of a core dump for a
        stuck child process.  This is controlled by <link
        linkend="guc-send-abort-for-crash"><varname>send_abort_for_crash</varname></link>
        and <link
        linkend="guc-send-abort-for-kill"><varname>send_abort_for_kill</varname></link>.
        The postmaster's <option>-T</option> switch is now the same as
        setting <varname>send_abort_for_crash</varname>.␟これにより、停止した子プロセスのコアダンプを収集できるようになりました。
これは<link linkend="guc-send-abort-for-crash"><varname>send_abort_for_crash</varname></link>と<link linkend="guc-send-abort-for-kill"><varname>send_abort_for_kill</varname></link>で制御されます。
現在、postmasterの<option>-T</option>スイッチは<varname>send_abort_for_crash</varname>を設定することと同じです。␞␞       </para>␞
␝       <para>␟        Remove the non-functional postmaster <option>-n</option> option
        (Tom Lane)␟機能しないpostmaster<option>-n</option>オプションを削除しました。
(Tom Lane)␞␞       </para>␞
␝       <para>␟        Allow the server to reserve backend slots for roles with <link
        linkend="predefined-roles"><literal>pg_use_reserved_connections</literal></link>
        membership (Nathan Bossart)␟<link linkend="predefined-roles"><literal>pg_use_reserved_connections</literal></link>メンバシップであるロールに対して、バックエンドスロットを予約できるようにサーバを設定しました。
(Nathan Bossart)␞␞       </para>␞
␝       <para>␟        The number of reserved slots is set by server variable <link
        linkend="guc-reserved-connections"><varname>reserved_connections</varname></link>.␟予約スロット数は、サーバパラメータ<link linkend="guc-reserved-connections"><varname>reserved_connections</varname></link>で設定します。␞␞       </para>␞
␝       <para>␟        Allow <link linkend="guc-huge-pages">huge pages</link> to
        work on newer versions of <systemitem class="osname">Windows
        10</systemitem> (Thomas Munro)␟<systemitem class="osname">Windows 10</systemitem>以降のバージョンで<link linkend="guc-huge-pages">huge pages</link>を使用できるようにしました。
(Thomas Munro)␞␞       </para>␞
␝       <para>␟        This adds the special handling required to enable huge pages
        on newer versions of <systemitem class="osname">Windows
        10</systemitem>.␟これにより、<systemitem class="osname">Windows 10</systemitem>以降のバージョンでヒープページを有効にするために必要となる特別な処理が追加されます。␞␞       </para>␞
␝       <para>␟        Add <link
        linkend="guc-debug-io-direct"><varname>debug_io_direct</varname></link>
        setting for developer usage (Thomas Munro, Andres Freund,
        Bharath Rupireddy)␟開発者用の<link linkend="guc-debug-io-direct"><varname>debug_io_direct</varname></link>設定を追加しました。
(Thomas Munro, Andres Freund, Bharath Rupireddy)␞␞       </para>␞
␝       <para>␟        While primarily for developers, <link
        linkend="guc-wal-sync-method"><literal>wal_sync_method=open_sync</literal></link>/<literal>open_datasync</literal>
        has been modified to not use direct <acronym>I/O</acronym> with
        <literal>wal_level=minimal</literal>;  this is now enabled with
        <literal>debug_io_direct=wal</literal>.␟主に開発者向けですが、<link linkend="guc-wal-sync-method"><literal>wal_sync_method=open_sync</literal></link>/<literal>open_datasync</literal>は、<literal>wal_level=minimal</literal>でのダイレクト<acronym>I/O</acronym>を使用しないように修正されました。
これは、<literal>debug_io_direct=wal</literal>で有効にできます。␞␞       </para>␞
␝       <para>␟        Add function <link
        linkend="functions-admin-backup-table"><function>pg_split_walfile_name()</function></link>
        to report the segment and timeline values of <acronym>WAL</acronym>
        file names (Bharath Rupireddy)␟<acronym>WAL</acronym>ファイル名のセグメント値とタイムライン値を報告する<link linkend="functions-admin-backup-table"><function>pg_split_walfile_name()</function></link>関数を追加しました。
(Bharath Rupireddy)␞␞       </para>␞
␝       <para>␟        Add support for regular expression matching on database and role
        entries in <filename>pg_hba.conf</filename> (Bertrand Drouvot)␟<filename>pg_hba.conf</filename>内のデータベースエントリとロールエントリで正規表現マッチングをサポートしました。
(Bertrand Drouvot)␞␞       </para>␞
␝       <para>␟        Regular expression patterns are prefixed with a slash.  Database
        and role names that begin with slashes need to be double-quoted
        if referenced in <filename>pg_hba.conf</filename>.␟正規表現パターンはスラッシュで始まります。
スラッシュで始まるデータベース名とロール名は、<filename>pg_hba.conf</filename>で参照される場合、二重引用符で囲む必要があります。␞␞       </para>␞
␝       <para>␟        Improve user-column handling of <link
        linkend="runtime-config-file-locations"><filename>pg_ident.conf</filename></link>
        to match <filename>pg_hba.conf</filename> (Jelte Fennema)␟<link linkend="runtime-config-file-locations"><filename>pg_ident.conf</filename></link>のユーザ列処理を<filename>pg_hba.conf</filename>と一致するよう改善しました。
(Jelte Fennema)␞␞       </para>␞
␝       <para>␟        Specifically, add support for <literal>all</literal>, role
        membership with <literal>+</literal>, and regular expressions
        with a leading slash.  Any user name that matches these patterns
        must be double-quoted.␟具体的には<literal>all</literal>、<literal>+</literal>でのロールメンバシップ、先頭にスラッシュを付けた正規表現のサポートを追加しました。
これらのパターンに一致するユーザ名は二重引用符で囲む必要があります。␞␞       </para>␞
␝       <para>␟        Allow include files in <filename>pg_hba.conf</filename> and
        <filename>pg_ident.conf</filename> (Julien Rouhaud)␟<filename>pg_hba.conf</filename>と<filename>pg_ident.conf</filename>でファイルのインクルードができるようになりました。
(Julien Rouhaud)␞␞       </para>␞
␝       <para>␟        These are controlled by <literal>include</literal>,
        <literal>include_if_exists</literal>, and
        <literal>include_dir</literal>.  System views <link
        linkend="view-pg-hba-file-rules"><structname>pg_hba_file_rules</structname></link>
        and <link
        linkend="view-pg-ident-file-mappings"><structname>pg_ident_file_mappings</structname></link>
        now display the file name.␟これらは<literal>include</literal>、<literal>include_if_exists</literal>、<literal>include_dir</literal>で制御されます。
システムビュー<link linkend="view-pg-hba-file-rules"><structname>pg_hba_file_rules</structname></link>と<link linkend="view-pg-ident-file-mappings"><structname>pg_ident_file_mappings</structname></link>にファイル名が表示されるようになりました。␞␞       </para>␞
␝       <para>␟        Allow <filename>pg_hba.conf</filename> tokens to be of unlimited
        length (Tom Lane)␟<filename>pg_hba.conf</filename>でのトークンの長さ制限を無くしました。
(Tom Lane)␞␞       </para>␞
␝       <para>␟        Add rule and map numbers to the system view <link
        linkend="view-pg-hba-file-rules"><structname>pg_hba_file_rules</structname></link>
        (Julien Rouhaud)␟システムビュー<link linkend="view-pg-hba-file-rules"><structname>pg_hba_file_rules</structname></link>にルール番号とマップ番号を追加しました。
(Julien Rouhaud)␞␞       </para>␞
␝    <sect4 id="release-16-localization">␟     <title><link linkend="charset">Localization</link></title>␟     <title><link linkend="charset">ローカライゼーション</link></title>␞␞␞
␝       <para>␟        Determine the default encoding from the locale when using
        <acronym>ICU</acronym> (Jeff Davis)␟<acronym>ICU</acronym>を使用する場合はロケールからデフォルトのエンコーディングを決定するようにしました。
(Jeff Davis)␞␞       </para>␞
␝       <para>␟        Previously the default was always <literal>UTF-8</literal>.␟以前のデフォルトは常に<literal>UTF-8</literal>でした。␞␞       </para>␞
␝       <para>␟        Have <link linkend="sql-createdatabase"><command>CREATE
        DATABASE</command></link> and <link
        linkend="sql-createcollation"><command>CREATE
        COLLATION</command></link>'s <literal>LOCALE</literal> options, and
        <link linkend="app-initdb"><application>initdb</application></link>
        and <link
        linkend="app-createdb"><application>createdb</application></link>
        <option>--locale</option> options, control
        non-<application>libc</application> collation providers (Jeff
        Davis)␟<link linkend="sql-createdatabase"><command>CREATE DATABASE</command></link>と<link linkend="sql-createcollation"><command>CREATE COLLATION</command></link>の<literal>LOCALE</literal>オプション、および<link linkend="app-initdb"><application>initdb</application></link>と<link linkend="app-createdb"><application>createdb</application></link>の<option>--locale</option>オプションは、<application>libc</application>以外の照合順序プロバイダを制御するようにしました。
(Jeff Davis)␞␞       </para>␞
␝       <para>␟        Previously they only controlled <application>libc</application>
        providers.␟以前は、<application>libc</application>プロバイダのみを制御していました。␞␞       </para>␞
␝       <para>␟        Add predefined collations <literal>unicode</literal> and
        <literal>ucs_basic</literal> (Peter Eisentraut)␟定義済み照合順序として<literal>unicode</literal>と<literal>ucs_basic</literal>を追加しました。
(Peter Eisentraut)␞␞       </para>␞
␝       <para>␟        This only works if <acronym>ICU</acronym> support is enabled.␟これは<acronym>ICU</acronym>サポートが有効になっている場合にのみ機能します。␞␞       </para>␞
␝       <para>␟        Allow custom <acronym>ICU</acronym> collation rules to be created
        (Peter Eisentraut)␟カスタム<acronym>ICU</acronym>照合ルールの作成できるようにしました。
(Peter Eisentraut)␞␞       </para>␞
␝       <para>␟        This is done using <link
        linkend="sql-createcollation"><command>CREATE
        COLLATION</command></link>'s new <literal>RULES</literal>
        clause, as well as new options for <link
        linkend="sql-createdatabase"><command>CREATE
        DATABASE</command></link>, <link
        linkend="app-createdb"><application>createdb</application></link>,
        and <link
        linkend="app-initdb"><application>initdb</application></link>.␟これは、<link linkend="sql-createcollation"><command>CREATE COLLATION</command></link>の新しい<literal>RULES</literal>句と、<link linkend="sql-createdatabase"><command>CREATE DATABASE</command></link>、<link linkend="app-createdb"><application>createdb</application></link>、<link linkend="app-initdb"><application>initdb</application></link>の新しいオプションを使用して行われます。␞␞       </para>␞
␝       <para>␟        Allow <systemitem class="osname">Windows</systemitem> to import
        system locales automatically (Juan José Santamaría Flecha)␟<systemitem class="osname">Windows</systemitem>でシステムロケールを自動的にインポートできるようにしました。
(Juan José Santamaría Flecha)␞␞       </para>␞
␝       <para>␟        Previously, only <acronym>ICU</acronym> locales could be imported
        on <systemitem class="osname">Windows</systemitem>.␟以前は<systemitem class="osname">Windows</systemitem>上では<acronym>ICU</acronym>ロケールのみインポートできました。␞␞       </para>␞
␝   <sect3 id="release-16-logical">␟    <title><link linkend="logical-replication">Logical Replication</link></title>␟    <title><link linkend="logical-replication">論理レプリケーション</link></title>␞␞␞
␝      <para>␟       Allow <link linkend="logicaldecoding">logical decoding</link>
       on standbys (Bertrand Drouvot, Andres Freund, Amit Khandekar)␟スタンバイでの<link linkend="logicaldecoding">ロジカルデコーディング</link>ができるようになりました。
(Bertrand Drouvot, Andres Freund, Amit Khandekar)␞␞      </para>␞
␝      <para>␟       Snapshot <acronym>WAL</acronym> records are
       required for logical slot creation but cannot be
       created on standbys.  To avoid delays, the new function <link
       linkend="functions-snapshot-synchronization-table"><function>pg_log_standby_snapshot()</function></link>
       allows creation of such records.␟スナップショット<acronym>WAL</acronym>レコードはロジカルスロットの作成に必要ですが、スタンバイでは作成できません。
遅延を回避するために、新しい関数<link linkend="functions-snapshot-synchronization-table"><function>pg_log_standby_snapshot()</function></link>でこのようなレコードの作成ができるようになりました。␞␞      </para>␞
␝      <para>␟       Add server variable to control how logical decoding publishers
       transfer changes and how subscribers apply them (Shi Yu)␟ロジカルデコーディングのパブリッシャーが変更を転送する方法と、サブスクライバーが変更を適用する方法を制御するためのサーバパラメータを追加しました。
(Shi Yu)␞␞      </para>␞
␝      <para>␟       The variable is <link
       linkend="guc-debug-logical-replication-streaming"><varname>debug_logical_replication_streaming</varname></link>.␟そのパラメータは<link linkend="guc-debug-logical-replication-streaming"><varname>debug_logical_replication_streaming</varname></link>です。␞␞      </para>␞
␝      <para>␟       Allow logical replication initial table synchronization to copy
       rows in binary format (Melih Mutlu)␟論理レプリケーションの初期テーブル同期で行をバイナリ形式でコピーできるようにしました。
(Melih Mutlu)␞␞      </para>␞
␝      <para>␟       This is only possible for subscriptions marked as binary.␟これは、バイナリとしてマークされたサブスクリプションに対してのみ可能です。␞␞      </para>␞
␝      <para>␟       Allow parallel application of logical replication (Hou Zhijie,
       Wang Wei, Amit Kapila)␟論理レプリケーションのパラレル適用が可能になりました。
(Hou Zhijie, Wang Wei, Amit Kapila)␞␞      </para>␞
␝      <para>␟       The <link linkend="sql-createsubscription"><command>CREATE
       SUBSCRIPTION</command></link> <option>STREAMING</option>
       option now supports <literal>parallel</literal> to enable
       application of large transactions by parallel workers.  The number
       of parallel workers is controlled by the new server variable <link
       linkend="guc-max-parallel-apply-workers-per-subscription"><varname>max_parallel_apply_workers_per_subscription</varname></link>.
       Wait events <link
       linkend="wait-event-activity-table"><literal>LogicalParallelApplyMain</literal></link>,
       <literal>LogicalParallelApplyStateChange</literal>, and
       <literal>LogicalApplySendData</literal> were also added.  Column
       <structfield>leader_pid</structfield> was added to system view <link
       linkend="monitoring-pg-stat-subscription"><structname>pg_stat_subscription</structname></link>
       to track parallel activity.␟<link linkend="sql-createsubscription"><command>CREATE SUBSCRIPTION</command></link>の<option>STREAMING</option>オプションで、パラレルワーカーによる大規模なトランザクションの適用を可能にする新たな<literal>parallel</literal>をサポートするようになりました。
パラレルワーカー数は新しいサーバパラメータ<link linkend="guc-max-parallel-apply-workers-per-subscription"><varname>max_parallel_apply_workers_per_subscription</varname></link>で制御されます。
また、待機イベント<link linkend="wait-event-activity-table"><literal>LogicalParallelApplyMain</literal></link>、<literal>LogicalParallelApplyStateChange</literal>、および<literal>LogicalApplySendData</literal>も追加されました。
パラレルアクティビティを追跡するために、システムビュー<link linkend="monitoring-pg-stat-subscription"><structname>pg_stat_subscription</structname></link>に<structfield>leader_pid</structfield>列が追加されました。␞␞      </para>␞
␝      <para>␟       Improve performance for <link
       linkend="logical-replication-architecture">logical replication
       apply</link> without a primary key (Onder Kalaci, Amit Kapila)␟主キーを使用しない<link linkend="logical-replication-architecture">論理レプリケーション適用</link>のパフォーマンスを改善しました。
(Onder Kalaci, Amit Kapila)␞␞      </para>␞
␝      <para>␟       Specifically, <literal>REPLICA IDENTITY FULL</literal> can now
       use btree indexes rather than sequentially scanning the table to
       find matches.␟具体的には、<literal>REPLICA IDENTITY FULL</literal>は一致を見つけるためにテーブルをシーケンシャルスキャンするのではなく、Btreeインデックスを使用できるようになりました。␞␞      </para>␞
␝      <para>␟       Allow logical replication subscribers to process only changes that
       have no origin (Vignesh C, Amit Kapila)␟論理レプリケーションのサブスクライバーが、オリジンを持たない変更のみを処理できるようにしました。
(Vignesh C, Amit Kapila)␞␞      </para>␞
␝      <para>␟       This can be used to avoid replication loops.  This is controlled
       by the new <literal>CREATE SUBSCRIPTION ... ORIGIN</literal> option.␟これを使用することで、レプリケーションループを回避できます。
これは、新しい<literal>CREATE SUBSCRIPTION ... ORIGIN</literal>オプションで制御されます。␞␞      </para>␞
␝      <para>␟       Perform logical replication <link
       linkend="sql-select"><command>SELECT</command></link> and
       <acronym>DML</acronym> actions as the table owner (Robert Haas)␟論理レプリケーションの<link linkend="sql-select"><command>SELECT</command></link>と<acronym>DML</acronym>アクションをテーブルの所有者として実行するようにしました。
(Robert Haas)␞␞      </para>␞
␝      <para>␟       This improves security and now requires subscription
       owners to be either superusers or to have <link
       linkend="sql-set-role"><command>SET ROLE</command></link>
       permission on all roles owning tables in the replication set.
       The previous behavior of performing all operations as the
       subscription owner can be enabled with the subscription <link
       linkend="sql-createsubscription"><option>run_as_owner</option></link>
       option.␟これによりセキュリティが向上し、サブスクリプションの所有者はスーパーユーザであるか、またはレプリケーションセット内のテーブルを所有するすべてのロールに対する<link linkend="sql-set-role"><command>SET ROLE</command></link>権限を持っている必要があります。
以前の動作である、すべての操作をサブスクリプション所有者として実行するには、サブスクリプションの<link linkend="sql-createsubscription"><option>run_as_owner</option></link>オプションを使用することで可能です。␞␞      </para>␞
␝      <para>␟       Have <link
       linkend="guc-wal-retrieve-retry-interval"><varname>wal_retrieve_retry_interval</varname></link>
       operate on a per-subscription basis (Nathan Bossart)␟<link linkend="guc-wal-retrieve-retry-interval"><varname>wal_retrieve_retry_interval</varname></link>がサブスクリプション単位で動作するようになりました。
(Nathan Bossart)␞␞      </para>␞
␝      <para>␟       Previously the retry time was applied
       globally.  This also adds wait events <link
       linkend="wait-event-lwlock-table">><literal>LogicalRepLauncherDSA</literal></link>
       and <literal>LogicalRepLauncherHash</literal>.␟以前は、リトライ時間はグローバルに適用されていました。
これにより、待機イベント<link linkend="wait-event-lwlock-table"><literal>LogicalRepLauncherDSA</literal></link>および<literal>LogicalRepLauncherHash</literal>も追加されます。␞␞      </para>␞
␝   <sect3 id="release-16-utility">␟    <title>Utility Commands</title>␟    <title>ユーティリティコマンド</title>␞␞␞
␝      <para>␟       Add <link linkend="sql-explain"><command>EXPLAIN</command></link>
       option <literal>GENERIC_PLAN</literal> to display the generic plan
       for a parameterized query (Laurenz Albe)␟パラメータ化された問い合わせの汎用プランを表示する<link linkend="sql-explain"><command>EXPLAIN</command></link>の<literal>GENERIC_PLAN</literal>を追加しました。
(Laurenz Albe)␞␞      </para>␞
␝      <para>␟       Allow a <link linkend="sql-copy"><command>COPY FROM</command></link>
       value to map to a column's <literal>DEFAULT</literal> (Israel
       Barth Rubio)␟<link linkend="sql-copy"><command>COPY FROM</command></link>で列の<literal>DEFAULT</literal>に値をマップできるようにしました。
(Israel Barth Rubio)␞␞      </para>␞
␝      <para>␟       Allow <link linkend="sql-copy"><command>COPY</command></link>
       into foreign tables to add rows in batches (Andrey Lepikhov,
       Etsuro Fujita)␟外部テーブルへの<link linkend="sql-copy"><command>COPY</command></link>で行をバッチ追加できるようにしました。
(Andrey Lepikhov, Etsuro Fujita)␞␞      </para>␞
␝      <para>␟       This is controlled by the <link
       linkend="postgres-fdw"><application>postgres_fdw</application></link>
       option <link
       linkend="postgres-fdw-options-cost-estimation"><option>batch_size</option></link>.␟これは<link linkend="postgres-fdw"><application>postgres_fdw</application></link>の<link linkend="postgres-fdw-options-cost-estimation"><option>batch_size</option></link>オプションで制御します。␞␞      </para>␞
␝      <para>␟       Allow the <literal>STORAGE</literal> type to be specified by <link
       linkend="sql-createtable"><command>CREATE TABLE</command></link>
       (Teodor Sigaev, Aleksander Alekseev)␟<link linkend="sql-createtable"><command>CREATE TABLE</command></link>で<literal>STORAGE</literal>タイプを指定できるようにしました。
(Teodor Sigaev, Aleksander Alekseev)␞␞      </para>␞
␝      <para>␟       Previously only <link linkend="sql-altertable"><command>ALTER
       TABLE</command></link> could control this.␟以前は、<link linkend="sql-altertable"><command>ALTER TABLE</command></link>のみがこれを制御できました。␞␞      </para>␞
␝      <para>␟       Allow <link linkend="sql-createtrigger">truncate triggers</link>
       on foreign tables (Yugo Nagata)␟外部テーブルでの<link linkend="sql-createtrigger">TRUNCATEトリガ</link>ができるようにしました。
(Yugo Nagata)␞␞      </para>␞
␝      <para>␟       Allow <link
       linkend="sql-vacuum"><command>VACUUM</command></link> and <link
       linkend="app-vacuumdb"><application>vacuumdb</application></link>
       to only process <link
       linkend="storage-toast"><literal>TOAST</literal></link> tables
       (Nathan Bossart)␟<link linkend="sql-vacuum"><command>VACUUM</command></link>と<link linkend="app-vacuumdb"><application>vacuumdb</application></link>が<link linkend="storage-toast"><literal>TOAST</literal></link>テーブルのみを処理できるようにしました。
(Nathan Bossart)␞␞      </para>␞
␝      <para>␟       This is accomplished by having <link
       linkend="sql-vacuum"><command>VACUUM</command></link>
       turn off <literal>PROCESS_MAIN</literal> or by <link
       linkend="app-vacuumdb"><application>vacuumdb</application></link>
       using the <option>--no-process-main</option> option.␟これは、<link linkend="sql-vacuum"><command>VACUUM</command></link>で<literal>PROCESS_MAIN</literal>をオフにするか、<link linkend="app-vacuumdb"><application>vacuumdb</application></link>で<option>--no-process-main</option>オプションを使用して実現できます。␞␞      </para>␞
␝      <para>␟       Add <link linkend="sql-vacuum"><command>VACUUM</command></link>
       options to skip or update all <link
       linkend="vacuum-for-wraparound">frozen</link> statistics (Tom Lane,
       Nathan Bossart)␟<link linkend="sql-vacuum"><command>VACUUM</command></link>に<link linkend="vacuum-for-wraparound">凍結された</link>統計情報をスキップまたはすべて更新するオプションを追加しました。
(Tom Lane, Nathan Bossart)␞␞      </para>␞
␝      <para>␟       The options are <literal>SKIP_DATABASE_STATS</literal> and
       <literal>ONLY_DATABASE_STATS</literal>.␟オプションは<literal>SKIP_DATABASE_STATS</literal>と<literal>ONLY_DATABASE_STATS</literal>です。␞␞      </para>␞
␝      <para>␟       Change <link linkend="sql-reindex"><command>REINDEX
       DATABASE</command></link> and <link
       linkend="sql-reindex"><command>REINDEX SYSTEM</command></link>
       to no longer require an argument (Simon Riggs)␟<link linkend="sql-reindex"><command>REINDEX DATABASE</command></link>と<link linkend="sql-reindex"><command>REINDEX SYSTEM</command></link>で引数が不要になりました。
(Simon Riggs)␞␞      </para>␞
␝      <para>␟       Previously the database name had to be specified.␟以前は、データベース名を指定する必要がありました。␞␞      </para>␞
␝      <para>␟       Allow <link linkend="sql-createstatistics"><command>CREATE
       STATISTICS</command></link> to generate a statistics name if none
       is specified (Simon Riggs)␟何も指定されていない場合は<link linkend="sql-createstatistics"><command>CREATE STATISTICS</command></link>で統計名を生成できるようにしました。
(Simon Riggs)␞␞      </para>␞
␝   <sect3 id="release-16-datatypes">␟    <title>Data Types</title>␟    <title>データ型</title>␞␞␞
␝      <para>␟       Allow non-decimal <link linkend="sql-syntax-bit-strings">integer
       literals</link> (Peter Eisentraut)␟10進数以外の<link linkend="sql-syntax-bit-strings">整数リテラル</link>が利用可能になりました。
(Peter Eisentraut)␞␞      </para>␞
␝      <para>␟       For example, <literal>0x42F</literal>, <literal>0o273</literal>,
       and <literal>0b100101</literal>.␟例えば、<literal>0x42F</literal>、<literal>0o273</literal>、<literal>0b100101</literal>などです。␞␞      </para>␞
␝      <para>␟       Allow <link linkend="datatype-numeric"><type>NUMERIC</type></link>
       to process hexadecimal, octal, and binary integers of any size
       (Dean Rasheed)␟<link linkend="datatype-numeric"><type>NUMERIC</type></link>が任意のサイズの16進数、8進数、2進数の整数を処理できるようにしました。
(Dean Rasheed)␞␞      </para>␞
␝      <para>␟       Previously only unquoted eight-byte integers were supported with
       these non-decimal bases.␟以前は、これらの非10進数では、引用符で囲まれていない8バイトの整数のみがサポートされていました。␞␞      </para>␞
␝      <para>␟       Allow underscores in integer and numeric <link
       linkend="sql-syntax-bit-strings">constants</link> (Peter Eisentraut,
       Dean Rasheed)␟整数と数値の<link linkend="sql-syntax-bit-strings">定数</link>でアンダースコアを使用できるようにしました。
(Peter Eisentraut, Dean Rasheed)␞␞      </para>␞
␝      <para>␟       This can improve readability for long strings of digits.␟これにより、長い数字列の読みやすさが向上します。␞␞      </para>␞
␝      <para>␟       Accept the spelling <literal>+infinity</literal> in datetime input
       (Vik Fearing)␟日時入力で<literal>+infinity</literal>の表現を受け付けるようにしました。
(Vik Fearing)␞␞      </para>␞
␝      <para>␟       Prevent the specification of <literal>epoch</literal> and
       <literal>infinity</literal> together with other fields in datetime
       strings (Joseph Koshakow)␟日時文字列で他のフィールドと一緒に<literal>epoch</literal>と<literal>infinity</literal>を指定することを禁止しました。
(Joseph Koshakow)␞␞      </para>␞
␝      <para>␟       Remove undocumented support for date input in the form
       <literal>Y<replaceable>year</replaceable>M<replaceable>month</replaceable>D<replaceable>day</replaceable></literal>
       (Joseph Koshakow)␟文書化されていない<literal>Y<replaceable>year</replaceable>M<replaceable>month</replaceable>D<replaceable>day</replaceable></literal>形式の日付入力サポートを削除しました。
(Joseph Koshakow)␞␞      </para>␞
␝      <para>␟       Add functions <link
       linkend="functions-info-validity-table"><function>pg_input_is_valid()</function></link>
       and <function>pg_input_error_info()</function> to check for type
       conversion errors (Tom Lane)␟型変換エラーをチェックする関数<link linkend="functions-info-validity-table"><function>pg_input_is_valid()</function></link>と<function>pg_input_error_info()</function>を追加しました。
(Tom Lane)␞␞      </para>␞
␝   <sect3 id="release-16-general">␟    <title>General Queries</title>␟    <title>問い合わせ一般</title>␞␞␞
␝      <para>␟       Allow subqueries in the <literal>FROM</literal> clause to omit
       aliases (Dean Rasheed)␟<literal>FROM</literal>句の副問い合わせで別名を省略できるようにしました。
(Dean Rasheed)␞␞      </para>␞
␝      <para>␟       Add support for enhanced numeric literals in
       <acronym>SQL/JSON</acronym> paths (Peter Eisentraut)␟<acronym>SQL/JSON</acronym>パスで拡張された数値リテラルに対応しました。
(Peter Eisentraut)␞␞      </para>␞
␝      <para>␟       For example, allow hexadecimal, octal, and binary integers and
       underscores between digits.␟たとえば、16進数、8進数、および2進数の整数で、桁間のアンダースコアが利用可能になりました。␞␞      </para>␞
␝   <sect3 id="release-16-functions">␟    <title>Functions</title>␟    <title>関数</title>␞␞␞
␝      <para>␟       Add <acronym>SQL/JSON</acronym> constructors (Nikita Glukhov,
       Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Amit Langote)␟<acronym>SQL/JSON</acronym>のコンストラクタを追加しました。
(Nikita Glukhov, Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Amit Langote)␞␞      </para>␞
␝      <para>␟       The new functions <link
       linkend="functions-json-creation-table"><function>JSON_ARRAY()</function></link>,
       <link
       linkend="functions-aggregate-table"><function>JSON_ARRAYAGG()</function></link>,
       <function>JSON_OBJECT()</function>, and
       <function>JSON_OBJECTAGG()</function> are part of the
       <acronym>SQL</acronym> standard.␟新しい関数<link linkend="functions-json-creation-table"><function>JSON_ARRAY()</function></link>、<link linkend="functions-aggregate-table"><function>JSON_ARRAYAGG()</function></link>、<function>JSON_OBJECT()</function>、および<function>JSON_OBJECTAGG()</function>は、標準<acronym>SQL</acronym>の一部です。␞␞      </para>␞
␝      <para>␟       Add <acronym>SQL/JSON</acronym> object checks (Nikita Glukhov,
       Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Amit Langote,
       Andrew Dunstan)␟<acronym>SQL/JSON</acronym>オブジェクト検査を追加しました。
(Nikita Glukhov, Teodor Sigaev, Oleg Bartunov, Alexander Korotkov, Amit Langote, Andrew Dunstan)␞␞      </para>␞
␝      <para>␟       The <link linkend="functions-sqljson-misc"><literal>IS
       JSON</literal></link> checks include checks for values, arrays,
       objects, scalars, and unique keys.␟<link linkend="functions-sqljson-misc"><literal>IS JSON</literal></link>検査は、値、配列、オブジェクト、スカラ、一意キーの検査を含みます。␞␞      </para>␞
␝      <para>␟       Allow <acronym>JSON</acronym> string parsing to use vector
       operations (John Naylor)␟<acronym>JSON</acronym>文字列解析でベクトル演算を使用できるようにしました。
(John Naylor)␞␞      </para>␞
␝      <para>␟       Improve the handling of full text highlighting function <link
       linkend="textsearch-functions-table"><function>ts_headline()</function></link>
       for <literal>OR</literal> and <literal>NOT</literal> expressions
       (Tom Lane)␟全文検索結果を強調する(<link linkend="textsearch-functions-table"><function>ts_headline()</function></link>)関数での<literal>OR</literal>および<literal>NOT</literal>式に対する処理を改善しました。
(Tom Lane)␞␞      </para>␞
␝      <para>␟       Add functions to add, subtract, and generate
       <type>timestamptz</type> values in a specified time zone (Przemyslaw
       Sztoch, Gurjeet Singh)␟指定したタイムゾーンの<type>timestamptz</type>値を加算、減算、生成する関数を追加しました。
(Przemyslaw Sztoch, Gurjeet Singh)␞␞      </para>␞
␝      <para>␟       The functions are <link
       linkend="functions-datetime-table"><function>date_add()</function></link>,
       <function>date_subtract()</function>, and <link
       linkend="functions-srf-series"><function>generate_series()</function></link>.␟関数は<link linkend="functions-datetime-table"><function>date_add()</function></link>、<function>date_subtract()</function>、<link linkend="functions-srf-series"><function>generate_series()</function></link>です。␞␞      </para>␞
␝      <para>␟       Change <link
       linkend="functions-datetime-table"><function>date_trunc(unit,
       timestamptz, time_zone)</function></link> to be an immutable
       function (Przemyslaw Sztoch)␟<link linkend="functions-datetime-table"><function>date_trunc(unit, timestamptz, time_zone)</function></link>を不変(immutable)関数に変更しました。
(Przemyslaw Sztoch)␞␞      </para>␞
␝      <para>␟       This allows the creation of expression indexes using this function.␟これにより、この関数を使用して式インデックスを作成できます。␞␞      </para>␞
␝      <para>␟       Add server variable <link
       linkend="functions-info-session-table"><literal>SYSTEM_USER</literal></link>
       (Bertrand Drouvot)␟サーバパラメータ<link linkend="functions-info-session-table"><literal>SYSTEM_USER</literal></link>を追加しました。
(Bertrand Drouvot)␞␞      </para>␞
␝      <para>␟       This reports the authentication method and its authenticated user.␟認証方式と認証したユーザを報告します。␞␞      </para>␞
␝      <para>␟       Add functions <link
       linkend="array-functions-table"><function>array_sample()</function></link>
       and <function>array_shuffle()</function> (Martin Kalcher)␟関数<link linkend="array-functions-table"><function>array_sample()</function></link>と<function>array_shuffle()</function>を追加しました。
(Martin Kalcher)␞␞      </para>␞
␝      <para>␟       Add aggregate function <link
       linkend="functions-aggregate-table"><function>ANY_VALUE()</function></link>
       which returns any value from a set (Vik Fearing)␟集合から任意の値を返す集約関数<link linkend="functions-aggregate-table"><function>ANY_VALUE()</function></link>を追加しました。
(Vik Fearing)␞␞      </para>␞
␝      <para>␟       Add function <link
       linkend="functions-math-random-table"><function>random_normal()</function></link>
       to supply normally-distributed random numbers (Paul Ramsey)␟正規分布の乱数を提供する<link linkend="functions-math-random-table"><function>random_normal()</function></link>関数を追加しました。
(Paul Ramsey)␞␞      </para>␞
␝      <para>␟       Add error function <link
       linkend="functions-math-func-table"><function>erf()</function></link>
       and its complement <function>erfc()</function> (Dean Rasheed)␟誤差関数<link linkend="functions-math-func-table"><function>erf()</function></link>と相補誤差関数<function>erfc()</function>を追加しました。
(Dean Rasheed)␞␞      </para>␞
␝      <para>␟       Improve the accuracy of numeric <link
       linkend="functions-math-func-table"><function>power()</function></link>
       for integer exponents (Dean Rasheed)␟整数の指数に対する<link linkend="functions-math-func-table"><function>power()</function></link>の数値の精度を改善しました。
(Dean Rasheed)␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="datatype-xml-creating"><function>XMLSERIALIZE()</function></link>
       option <literal>INDENT</literal> to pretty-print its output
       (Jim Jones)␟出力を読みやすく表示するための<link linkend="datatype-xml-creating"><function>XMLSERIALIZE()</function></link>関数の<literal>INDENT</literal>オプションを追加しました。
(Jim Jones)␞␞      </para>␞
␝      <para>␟       Change <link
       linkend="functions-admin-collation"><function>pg_collation_actual_version()</function></link>
       to return a reasonable value for the default collation (Jeff Davis)␟デフォルトの照合順序に対して妥当な値を返すように<link linkend="functions-admin-collation"><function>pg_collation_actual_version()</function></link>関数を変更しました。
(Jeff Davis)␞␞      </para>␞
␝      <para>␟       Previously it returned <literal>NULL</literal>.␟以前は<literal>NULL</literal>を返していました。␞␞      </para>␞
␝      <para>␟       Allow <link
       linkend="functions-admin-genfile-table"><function>pg_read_file()</function></link>
       and <function>pg_read_binary_file()</function> to ignore missing
       files (Kyotaro Horiguchi)␟<link linkend="functions-admin-genfile-table"><function>pg_read_file()</function></link>と<function>pg_read_binary_file()</function>があるべき場所に無いファイルを無視できるようにしました。
(Kyotaro Horiguchi)␞␞      </para>␞
␝      <para>␟       Add byte specification (<literal>B</literal>) to <link
       linkend="functions-admin-dbsize"><function>pg_size_bytes()</function></link>
       (Peter Eisentraut)␟<link linkend="functions-admin-dbsize"><function>pg_size_bytes()</function></link>にバイト指定の(<literal>B</literal>)を追加しました。
(Peter Eisentraut)␞␞      </para>␞
␝      <para>␟       Allow <link
       linkend="functions-info-catalog-table"><function>to_reg</function></link>*
       functions to accept numeric <acronym>OID</acronym>s as input
       (Tom Lane)␟<link linkend="functions-info-catalog-table"><function>to_reg</function></link>*関数群が<acronym>OID</acronym>の数値を入力として受け付けるようにしました。
(Tom Lane)␞␞      </para>␞
␝      <para>␟       Add the ability to get the current function's <acronym>OID</acronym>
       in <application>PL/pgSQL</application> (Pavel Stehule)␟<application>PL/pgSQL</application>で現在の関数の<acronym>OID</acronym>を取得する機能を追加しました。
(Pavel Stehule)␞␞      </para>␞
␝      <para>␟       This is accomplished with <link
       linkend="plpgsql-statements-diagnostics"><command>GET DIAGNOSTICS
       variable = PG_ROUTINE_OID</command></link>.␟これは<link linkend="plpgsql-statements-diagnostics"><command>GET DIAGNOSTICS variable = PG_ROUTINE_OID</command></link>で実現します。␞␞      </para>␞
␝      <para>␟       Add <application>libpq</application> connection option <link
       linkend="libpq-connect-require-auth"><option>require_auth</option></link>
       to specify a list of acceptable authentication methods (Jacob
       Champion)␟受け入れ可能な認証方式のリストを指定するための<application>libpq</application>接続オプション<link linkend="libpq-connect-require-auth"><option>require_auth</option></link>を追加しました。
(Jacob Champion)␞␞      </para>␞
␝      <para>␟       This can also be used to disallow certain authentication methods.␟これは、特定の認証方式を禁止するためにも使用できます。␞␞      </para>␞
␝      <para>␟       Allow multiple <application>libpq</application>-specified hosts
       to be randomly selected (Jelte Fennema)␟<application>libpq</application>で指定した複数のホストからランダムに選択できるようにしました。
(Jelte Fennema)␞␞      </para>␞
␝      <para>␟       This is enabled with <link
       linkend="libpq-connect-load-balance-hosts"><literal>load_balance_hosts=random</literal></link>
       and can be used for load balancing.␟これは<link linkend="libpq-connect-load-balance-hosts"><literal>load_balance_hosts=random</literal></link>で有効になり、ロードバランシングに使用できます。␞␞      </para>␞
␝      <para>␟       Add <application>libpq</application> option <link
       linkend="libpq-connect-sslcertmode"><option>sslcertmode</option></link>
       to control transmission of the client certificate (Jacob Champion)␟クライアント証明書の送信を制御する<application>libpq</application>の<link linkend="libpq-connect-sslcertmode"><option>sslcertmode</option></link>オプションを追加しました。
(Jacob Champion)␞␞      </para>␞
␝      <para>␟       The option values are <literal>disable</literal>,
       <literal>allow</literal>, and <literal>require</literal>.␟オプションの値は、<literal>disable</literal>、<literal>allow</literal>、<literal>require</literal>です。␞␞      </para>␞
␝      <para>␟       Allow <application>libpq</application> to use the system certificate
       pool for certificate verification (Jacob Champion, Thomas Habets)␟<application>libpq</application>が証明書の検証にシステム証明書プールを使用できるようにしました。
(Jacob Champion, Thomas Habets)␞␞      </para>␞
␝      <para>␟       This is enabled with <link
       linkend="libpq-connect-sslrootcert"><literal>sslrootcert=system</literal></link>,
       which also enables <link
       linkend="libpq-connect-sslmode"><literal>sslmode=verify-full</literal></link>.␟これは<link linkend="libpq-connect-sslrootcert"><literal>sslrootcert=system</literal></link>で有効になります。
これにより<link linkend="libpq-connect-sslmode"><literal>sslmode=verify-full</literal></link>も有効にします。␞␞      </para>␞
␝   <sect3 id="release-16-client-apps">␟    <title>Client Applications</title>␟    <title>クライアントアプリケーション</title>␞␞␞
␝      <para>␟       Allow <link linkend="ecpg"><command>ECPG</command></link>
       variable declarations to use typedef names that match unreserved
       <acronym>SQL</acronym> keywords (Tom Lane)␟<link linkend="ecpg"><command>ECPG</command></link>の変数宣言で予約されていない<acronym>SQL</acronym>キーワードに一致するtypedef名を使用できるようにしました。
(Tom Lane)␞␞      </para>␞
␝      <para>␟       This change does prevent keywords which match C typedef names from
       being processed as keywords in later <command>EXEC SQL</command>
       blocks.␟この変更により、Cのtypedef名と一致するキーワードは、後の<command>EXEC SQL</command>ブロックでキーワードとして処理されなくなります。␞␞      </para>␞
␝       <para>␟        Allow <application>psql</application> to control the maximum
        width of header lines in expanded format (Platon Pronko)␟<application>psql</application>で展開された形式でのヘッダ行の最大幅を制御できるようにしました。
(Platon Pronko)␞␞       </para>␞
␝       <para>␟        This is controlled by <link
        linkend="app-psql-meta-command-pset-xheader-width"><option>xheader_width</option></link>.␟これは<link linkend="app-psql-meta-command-pset-xheader-width"><option>xheader_width</option></link>で制御します。␞␞       </para>␞
␝       <para>␟        Add <application>psql</application> command <link
        linkend="app-psql-meta-command-drg"><command>\drg</command></link>
        to show role membership details (Pavel Luzanov)␟<application>psql</application>にロールメンバシップの詳細を表示する<link linkend="app-psql-meta-command-drg"><command>\drg</command></link>コマンドを追加しました。
(Pavel Luzanov)␞␞       </para>␞
␝       <para>␟        The <literal>Member of</literal> output column has been removed
        from <command>\du</command> and <command>\dg</command> because
        this new command displays this information in more detail.␟この新しいコマンドでより詳細な情報を表示するため<command>\du</command>と<command>\dg</command>から<literal>Member of</literal>出力列が削除されました。␞␞       </para>␞
␝       <para>␟        Allow <application>psql</application>'s access privilege commands
        to show system objects (Nathan Bossart)␟<application>psql</application>のアクセス権限コマンドでシステムオブジェクトを表示できるようにしました。
(Nathan Bossart)␞␞       </para>␞
␝       <para>␟        The options are <link
        linkend="app-psql-meta-command-dp-lc"><command>\dpS</command></link>
        and <link
        linkend="app-psql-meta-command-z"><command>\zS</command></link>.␟オプションは<link linkend="app-psql-meta-command-dp-lc"><command>\dpS</command></link>と<link linkend="app-psql-meta-command-z"><command>\zS</command></link>です。␞␞       </para>␞
␝       <para>␟        Add <literal>FOREIGN</literal> designation
        to <application>psql</application> <link
        linkend="app-psql-meta-command-d"><command>\d+</command></link>
        for foreign table children and partitions (Ian Lawrence Barwick)␟<application>psql</application>の<link linkend="app-psql-meta-command-d"><command>\d+</command></link>に外部テーブルの子テーブルとパーティションの<literal>FOREIGN</literal>表示を追加しました。
(Ian Lawrence Barwick)␞␞       </para>␞
␝       <para>␟        Prevent <link
        linkend="app-psql-meta-command-df-uc"><command>\df+</command></link>
        from showing function source code (Isaac Morland)␟<link linkend="app-psql-meta-command-df-uc"><command>\df+</command></link>で関数のソースコードを表示しないようにしました。
(Isaac Morland)␞␞       </para>␞
␝       <para>␟        Function bodies are more easily viewed with <link
        linkend="app-psql-meta-command-sf"><command>\sf</command></link>.␟関数本体は<link linkend="app-psql-meta-command-sf"><command>\sf</command></link>で見やすくなりました。␞␞       </para>␞
␝       <para>␟        Allow <application>psql</application> to submit queries using
        the extended query protocol (Peter Eisentraut)␟<application>psql</application>が拡張問い合わせプロトコルを使用して問い合わせを送信できるようにしました。
(Peter Eisentraut)␞␞       </para>␞
␝       <para>␟        Passing arguments to such queries is done
        using the new <application>psql</application> <link
        linkend="app-psql-meta-command-bind"><command>\bind</command></link>
        command.␟このような問い合わせへの引数の渡しは、新しい<application>psql</application>の<link linkend="app-psql-meta-command-bind"><command>\bind</command></link>コマンドを使って行います。␞␞       </para>␞
␝       <para>␟        Allow <application>psql</application> <link
        linkend="app-psql-meta-command-watch"><command>\watch</command></link>
        to limit the number of executions (Andrey Borodin)␟<application>psql</application>の<link linkend="app-psql-meta-command-watch"><command>\watch</command></link>を実行回数を制限できるようにしました。
(Andrey Borodin)␞␞       </para>␞
␝       <para>␟        The <command>\watch</command> options can now be named when
        specified.␟<command>\watch</command>オプションは、指定されたときに名前を付けることができるようになりました。␞␞       </para>␞
␝       <para>␟        Detect invalid values for <application>psql</application> <link
        linkend="app-psql-meta-command-watch"><command>\watch</command></link>,
        and allow zero to specify no delay (Andrey Borodin)␟<application>psql</application>の<link linkend="app-psql-meta-command-watch"><command>\watch</command></link>で無効な値を検出し、遅延なしを指定できるよう0を許可しました。
(Andrey Borodin)␞␞       </para>␞
␝       <para>␟        Allow <application>psql</application> scripts to obtain the exit
        status of shell commands and queries
       (Corey Huinker, Tom Lane)␟<application>psql</application>スクリプトでシェルコマンドや問い合わせの終了ステータスを取得できるようにしました。
(Corey Huinker, Tom Lane)␞␞       </para>␞
␝       <para>␟        The new <application>psql</application> control variables are <link
        linkend="app-psql-variables-shell-error"><literal>SHELL_ERROR</literal></link>
        and <link
        linkend="app-psql-variables-shell-exit-code"><literal>SHELL_EXIT_CODE</literal></link>.␟新しい<application>psql</application>制御変数は、<link linkend="app-psql-variables-shell-error"><literal>SHELL_ERROR</literal></link>と<link linkend="app-psql-variables-shell-exit-code"><literal>SHELL_EXIT_CODE</literal></link>です。␞␞       </para>␞
␝       <para>␟        Various <application>psql</application> tab completion improvements
        (Vignesh C, Aleksander Alekseev, Dagfinn Ilmari Mannsåker,
        Shi Yu, Michael Paquier, Ken Kato, Peter Smith)␟様々な<application>psql</application>のタブ補完機能を改善しました。
(Vignesh C, Aleksander Alekseev, Dagfinn Ilmari Mannsåker, Shi Yu, Michael Paquier, Ken Kato, Peter Smith)␞␞       </para>␞
␝       <para>␟        Add <application>pg_dump</application> control of dumping child
        tables and partitions (Gilles Darold)␟<application>pg_dump</application>で子テーブルとパーティションのダンプを制御できるようにしました。
(Gilles Darold)␞␞       </para>␞
␝        <option>--exclude-table-data-and-children</option>.␟        The new options are <option>--table-and-children</option>,
        <option>--exclude-table-and-children</option>, and
        <option>--exclude-table-data-and-children</option>.␟新しいオプションは<option>--table-and-children</option>、<option>--exclude-table-and-children</option>、<option>--exclude-table-data-and-children</option>です。␞␞       </para>␞
␝       <para>␟        Add <application>LZ4</application> and
        <application>Zstandard</application> compression to
        <application>pg_dump</application> (Georgios Kokolatos, Justin
        Pryzby)␟<application>pg_dump</application>に<application>LZ4</application>圧縮と<application>Zstandard</application>圧縮を追加しました。
(Georgios Kokolatos, Justin Pryzby)␞␞       </para>␞
␝       <para>␟        Allow <application>pg_dump</application> and <link
        linkend="app-pgbasebackup"><application>pg_basebackup</application></link>
        to use <literal>long</literal> mode for compression (Justin Pryzby)␟<application>pg_dump</application>と<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>で圧縮に<literal>long</literal>モードを使用できるようにしました。
 (Justin Pryzby)␞␞       </para>␞
␝       <para>␟        Improve <application>pg_dump</application> to accept a more
        consistent compression syntax (Georgios Kokolatos)␟<application>pg_dump</application>を改良して、より一貫性のある圧縮構文を受け付けるようにしました。
(Georgios Kokolatos)␞␞       </para>␞
␝        Options like <option>--compress=gzip:5</option>.␟        Options like <option>--compress=gzip:5</option>.␟<option>--compress=gzip:5</option>のようなオプションです。␞␞       </para>␞
␝   <sect3 id="release-16-server-apps">␟    <title>Server Applications</title>␟    <title>サーバアプリケーション</title>␞␞␞
␝      <para>␟       Add <link
       linkend="app-initdb"><application>initdb</application></link>
       option to set server variables for the duration of
       <application>initdb</application> and all future server starts
       (Tom Lane)␟<application>initdb</application>および将来のすべてのサーバ起動時にサーバパラメータを設定するための<link linkend="app-initdb"><application>initdb</application></link>オプションを追加しました。
(Tom Lane)␞␞      </para>␞
␝      <para>␟       The option is <option>-c name=value</option>.␟オプションは<option>-c name=value</option>です。␞␞      </para>␞
␝      <para>␟       Add options to <link
       linkend="app-createuser"><application>createuser</application></link>
       to control more user options (Shinya Kato)␟<link linkend="app-createuser"><application>createuser</application></link>に、より多くのユーザオプションを制御するオプションを追加しました。
(Shinya Kato)␞␞      </para>␞
␝      <para>␟       Specifically, the new options control the valid-until date,
       bypassing of row-level security, and role membership.␟具体的には、新しいオプションは、有効期限、行レベルのセキュリティのバイパス、およびロールメンバシップを制御します。␞␞      </para>␞
␝      <para>␟       Deprecate <link
       linkend="app-createuser"><application>createuser</application></link>
       option <option>--role</option> (Nathan Bossart)␟<link linkend="app-createuser"><application>createuser</application></link>の<option>--role</option>オプションを非推奨としました。
(Nathan Bossart)␞␞      </para>␞
␝      <para>␟       This option could be easily confused with new
       <application>createuser</application> role membership options,
       so option <option>--member-of</option> has been added with the
       same functionality.  The <option>--role</option> option can still
       be used.␟このオプションは、新しい<application>createuser</application>ロールのメンバシップオプションと混同されやすいため、同じ機能を持つ<option>--member-of</option>オプションが追加されました。
<option>--role</option>オプションは引き続き使用できます。␞␞      </para>␞
␝      <para>␟       Allow control of <link
       linkend="app-vacuumdb"><application>vacuumdb</application></link>
       schema processing (Gilles Darold)␟<link linkend="app-vacuumdb"><application>vacuumdb</application></link>でスキーマ処理の制御ができるようにしました。
(Gilles Darold)␞␞      </para>␞
␝       <option>--exclude-schema</option>.␟       These are controlled by options <option>--schema</option> and
       <option>--exclude-schema</option>.␟これらは、<option>--schema</option>および<option>--exclude-schema</option>オプションで制御されます。␞␞      </para>␞
␝      <para>␟       Use new <link linkend="sql-vacuum"><command>VACUUM</command></link>
       options to improve the performance of <link
       linkend="app-vacuumdb"><application>vacuumdb</application></link>
       (Tom Lane, Nathan Bossart)␟<link linkend="app-vacuumdb"><application>vacuumdb</application></link>のパフォーマンスを改善するために新しい<link linkend="sql-vacuum"><command>VACUUM</command></link>オプションを使用するようにしました。
(Tom Lane, Nathan Bossart)␞␞      </para>␞
␝      <para>␟       Have <link
       linkend="pgupgrade"><application>pg_upgrade</application></link>
       set the new cluster's locale and encoding (Jeff Davis)␟<link linkend="pgupgrade"><application>pg_upgrade</application></link>で新しいクラスタのロケールとエンコーディングを設定しました。
(Jeff Davis)␞␞      </para>␞
␝      <para>␟       This removes the requirement that the new cluster be created with
       the same locale and encoding settings.␟これにより、新しいクラスタを同じロケールとエンコーディング設定で作成する必要がなくなります。␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="pgupgrade"><application>pg_upgrade</application></link>
       option to specify the default transfer mode (Peter Eisentraut)␟<link linkend="pgupgrade"><application>pg_upgrade</application></link>にデフォルトの転送モードを指定するためのオプションを追加しました。
(Peter Eisentraut)␞␞      </para>␞
␝       The option is <option>--copy</option>.␟       The option is <option>--copy</option>.␟そのオプションは<option>--copy</option>です。␞␞      </para>␞
␝      <para>␟       Improve <link
       linkend="app-pgbasebackup"><application>pg_basebackup</application></link>
       to accept numeric compression options (Georgios Kokolatos,
       Michael Paquier)␟<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>が数値の圧縮オプションを受け付けるように改善しました。
(Georgios Kokolatos, Michael Paquier)␞␞      </para>␞
␝       Options like <option>--compress=server-5</option> are now supported.␟       Options like <option>--compress=server-5</option> are now supported.␟<option>--compress=server-5</option>のようなオプションがサポートされるようになりました。␞␞      </para>␞
␝      <para>␟       Fix <link
       linkend="app-pgbasebackup"><application>pg_basebackup</application></link>
       to handle tablespaces stored in the <envar>PGDATA</envar> directory
       (Robert Haas)␟<link linkend="app-pgbasebackup"><application>pg_basebackup</application></link>で<envar>PGDATA</envar>ディレクトリに格納されたテーブル空間を処理できるように修正しました。
(Robert Haas)␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="pgwaldump"><application>pg_waldump</application></link>
       option <option>--save-fullpage</option> to dump full page images
       (David Christensen)␟<link linkend="pgwaldump"><application>pg_waldump</application></link>にページ全体のイメージをダンプするための<option>--save-fullpage</option>オプションを追加しました。
(David Christensen)␞␞      </para>␞
␝      <para>␟       Allow <link
       linkend="pgwaldump"><application>pg_waldump</application></link>
       options <option>-t</option>/<option>--timeline</option> to accept
       hexadecimal values (Peter Eisentraut)␟<link linkend="pgwaldump"><application>pg_waldump</application></link>の<option>-t</option>/<option>--timeline</option>オプションで16進数値を受け付けるようにしました。
(Peter Eisentraut)␞␞      </para>␞
␝      <para>␟       Add support for progress reporting to <link
       linkend="app-pgverifybackup"><application>pg_verifybackup</application></link>
       (Masahiko Sawada)␟<link linkend="app-pgverifybackup"><application>pg_verifybackup</application></link>に進捗レポート機能を追加しました。
(Masahiko Sawada)␞␞      </para>␞
␝      <para>␟       Allow <link
       linkend="app-pgrewind"><application>pg_rewind</application></link>
       to properly track timeline changes (Heikki Linnakangas)␟<link linkend="app-pgrewind"><application>pg_rewind</application></link>がタイムラインの変更を正しく追跡できるようにしました。
(Heikki Linnakangas)␞␞      </para>␞
␝      <para>␟       Previously if <application>pg_rewind</application> was run after
       a timeline switch but before a checkpoint was issued, it might
       incorrectly determine that a rewind was unnecessary.␟以前は、<application>pg_rewind</application>がタイムラインの切り替え後でチェックポイントが発行される前に実行された場合、<application>pg_rewind</application>は巻き戻しが不要であると誤って判断する可能性がありました。␞␞      </para>␞
␝      <para>␟       Have <link
       linkend="app-pgreceivewal"><application>pg_receivewal</application></link>
       and <link
       linkend="app-pgrecvlogical"><application>pg_recvlogical</application></link>
       cleanly exit on <literal>SIGTERM</literal> (Christoph Berg)␟<link linkend="app-pgreceivewal"><application>pg_receivewal</application></link>と<link linkend="app-pgrecvlogical"><application>pg_recvlogical</application></link>が<literal>SIGTERM</literal>で正常終了するようになりました。
(Christoph Berg)␞␞      </para>␞
␝      <para>␟       This signal is often used by <application>systemd</application>.␟このシグナルは、<application>systemd</application>によってしばしば使用されます。␞␞      </para>␞
␝   <sect3 id="release-16-source-code">␟    <title>Source Code</title>␟    <title>ソースコード</title>␞␞␞
␝      <para>␟       Build <acronym>ICU</acronym> support by default (Jeff Davis)␟<acronym>ICU</acronym>サポートのビルドがデフォルトになりました。
(Jeff Davis)␞␞      </para>␞
␝      <para>␟       This removes <link linkend="installation">build
       flag</link> <option>--with-icu</option> and adds flag
       <option>--without-icu</option>.␟これにより、<link linkend="installation">ビルドフラグ</link>の<option>--with-icu</option>が削除され、<option>--without-icu</option>フラグが追加されます。␞␞      </para>␞
␝      <para>␟       Add support for SSE2 (Streaming <acronym>SIMD</acronym> Extensions
       2) vector operations on x86-64 architectures (John Naylor)␟x86-64アーキテクチャでのSSE2(Streaming <acronym>SIMD</acronym> Extensions 2)ベクトル演算のサポートを追加しました。
(John Naylor)␞␞      </para>␞
␝      <para>␟       Add support for Advanced <acronym>SIMD</acronym> (Single
       Instruction Multiple Data) (<acronym>NEON</acronym>) instructions
       on <acronym>ARM</acronym> architectures (Nathan Bossart)␟<acronym>ARM</acronym>アーキテクチャで高度な<acronym>SIMD</acronym>(Single Instruction Multiple Data)(<acronym>NEON</acronym>)命令のサポートを追加しました。
(Nathan Bossart)␞␞      </para>␞
␝      <para>␟       Have <systemitem class="osname">Windows</systemitem>
       binaries built with <productname>MSVC</productname> use
       <literal>RandomizedBaseAddress</literal> (<acronym>ASLR</acronym>)
       (Michael Paquier)␟<productname>MSVC</productname>による<systemitem class="osname">Windows</systemitem>バイナリビルドで<literal>RandomizedBaseAddress</literal>(<acronym>ASLR</acronym>)を使用するようにしました。
(Michael Paquier)␞␞      </para>␞
␝      <para>␟       This was already enabled on <productname>MinGW</productname> builds.␟これはすでに<productname>MinGW</productname>ビルドで有効になっています。␞␞      </para>␞
␝      <para>␟       Prevent extension libraries from exporting their symbols by default
       (Andres Freund, Tom Lane)␟拡張ライブラリのシンボルがデフォルトでエクスポートしないようにしました。
(Andres Freund, Tom Lane)␞␞      </para>␞
␝      <para>␟       Functions that need to be called from the core backend
       or other extensions must now be explicitly marked
       <literal>PGDLLEXPORT</literal>.␟コアバックエンドや他の拡張機能から呼び出す必要のある関数は、明示的に<literal>PGDLLEXPORT</literal>とマークする必要があります。␞␞      </para>␞
␝      <para>␟       Require <systemitem class="osname">Windows 10</systemitem> or
       newer versions (Michael Paquier, Juan José Santamaría Flecha)␟<systemitem class="osname">Windows 10</systemitem>以降のバージョンが必要になりました。
(Michael Paquier, Juan José Santamaría Flecha)␞␞      </para>␞
␝      <para>␟       Previously <systemitem class="osname">Windows Vista</systemitem> and
       <systemitem class="osname">Windows XP</systemitem> were supported.␟以前は、<systemitem class="osname">Windows Vista</systemitem>と<systemitem class="osname">Windows XP</systemitem>がサポートされていました。␞␞      </para>␞
␝      <para>␟       Require <productname>Perl</productname> version 5.14 or later
       (John Naylor)␟<productname>Perl</productname>バージョン5.14以降が必要になりました。
(John Naylor)␞␞      </para>␞
␝      <para>␟       Require <productname>Bison</productname> version 2.3 or later
       (John Naylor)␟<productname>Bison</productname>バージョン2.3以降が必要になりました。
(John Naylor)␞␞      </para>␞
␝      <para>␟       Require <productname>Flex</productname> version 2.5.35 or later
       (John Naylor)␟<productname>Flex</productname>バージョン2.5.35以降が必要になりました。
(John Naylor)␞␞      </para>␞
␝      <para>␟       Require <acronym>MIT</acronym> Kerberos for
       <acronym>GSSAPI</acronym> support (Stephen Frost)␟<acronym>GSSAPI</acronym>サポートのために<acronym>MIT</acronym>Kerberosを必要になりました。
(Stephen Frost)␞␞      </para>␞
␝      <para>␟       Remove support for <productname>Visual Studio 2013</productname>
       (Michael Paquier)␟<productname>Visual Studio 2013</productname>のサポートを削除しました。
(Michael Paquier)␞␞      </para>␞
␝      <para>␟       Remove support for <systemitem class="osname">HP-UX</systemitem>
       (Thomas Munro)␟<systemitem class="osname">HP-UX</systemitem>のサポートを削除しました。
(Thomas Munro)␞␞      </para>␞
␝      <para>␟       Remove support for <productname>HP/Intel Itanium</productname>
       (Thomas Munro)␟<productname>HP/Intel Itanium</productname>のサポートを削除しました。
(Thomas Munro)␞␞      </para>␞
␝      <para>␟       Remove support for <productname>M68K</productname>,
       <productname>M88K</productname>, <productname>M32R</productname>,
       and <productname>SuperH</productname> <acronym>CPU</acronym>
       architectures (Thomas Munro)␟<productname>M68K</productname>、<productname>M88K</productname>、<productname>M32R</productname>、<productname>SuperH</productname> <acronym>CPU</acronym>アーキテクチャのサポートを削除しました。
(Thomas Munro)␞␞      </para>␞
␝      <para>␟       Remove <link linkend="libpq"><application>libpq</application></link>
       support for <acronym>SCM</acronym> credential authentication
       (Michael Paquier)␟<acronym>SCM</acronym>証明書認証用の<link linkend="libpq"><application>libpq</application></link>サポートを削除しました。
(Michael Paquier)␞␞      </para>␞
␝      <para>␟       Backend support for this authentication method was removed in
       <productname>PostgresSQL</productname> 9.1.␟この認証方式のバックエンドサポートは<productname>PostgreSQL</productname> 9.1で削除されました。␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="install-meson"><application>meson</application></link>
       build system (Andres Freund, Nazir Bilal Yavuz, Peter Eisentraut)␟<link linkend="install-meson"><application>meson</application></link>ビルドシステムを追加しました。
(Andres Freund, Nazir Bilal Yavuz, Peter Eisentraut)␞␞      </para>␞
␝      <para>␟       This eventually will replace the <productname>Autoconf</productname>
       and <systemitem class="osname">Windows</systemitem>-based
       <productname>MSVC</productname> build systems.␟これは最終的に、<productname>Autoconf</productname>と<systemitem class="osname">Windows</systemitem>ベースの<productname>MSVC</productname>ビルドシステムを置き換えることになります。␞␞      </para>␞
␝      <para>␟       Allow control of the location of the
       <application>openssl</application> binary used by the build system
       (Peter Eisentraut)␟ビルドシステムが使用する<application>openssl</application>バイナリの場所を制御できるようにしました。
(Peter Eisentraut)␞␞      </para>␞
␝      <para>␟       Make finding <application>openssl</application>
       program a <application>configure</application> or
       <application>meson</application> option␟<application>configure</application>または<application>meson</application>オプションで<application>openssl</application>プログラムの検索をできるようにしました。␞␞      </para>␞
␝      <para>␟       Add build option to allow testing of small table segment sizes
       (Andres Freund)␟小さなテーブルセグメントサイズのテストを可能にするビルドオプションを追加しました。
(Andres Freund)␞␞      </para>␞
␝      <para>␟       The build options are <link
       linkend="configure-option-with-segsize"><option>--with-segsize-blocks</option></link>
       and <option>-Dsegsize_blocks</option>.␟ビルドオプションは<link linkend="configure-option-with-segsize"><option>--with-segsize-blocks</option></link>と<option>-Dsegsize_blocks</option>です。␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="source"><application>pgindent</application></link> options
       (Andrew Dunstan)␟<link linkend="source"><application>pgindent</application></link>オプションを追加しました。
(Andrew Dunstan)␞␞      </para>␞
␝       and <option>--build</option> were also removed.␟       The new options are <option>--show-diff</option>,
       <option>--silent-diff</option>, <option>--commit</option>,
       and <option>--help</option>, and allow multiple
       <option>--exclude</option> options.  Also require the typedef file
       to be explicitly specified.  Options <option>--code-base</option>
       and <option>--build</option> were also removed.␟新しいオプションは<option>--show-diff</option>、<option>--silent-diff</option>、<option>--commit</option>、<option>--help</option>で、複数の<option>--exclude</option>オプションが可能です。
また、typedefファイルを明示的に指定する必要があります。
オプション<option>--code-base</option>と<option>--build</option>は削除されました。␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="source"><application>pg_bsd_indent</application></link>
       source code to the main tree (Tom Lane)␟<link linkend="source"><application>pg_bsd_indent</application></link>ソースコードをメインツリーに追加しました。
(Tom Lane)␞␞      </para>␞
␝      <para>␟       Improve <application>make_ctags</application> and
       <application>make_etags</application> (Yugo Nagata)␟<application>make_ctags</application>と<application>make_etags</application>を改善しました。
 (Yugo Nagata)␞␞      </para>␞
␝      <para>␟       Adjust <link
       linkend="catalog-pg-attribute"><structname>pg_attribute</structname></link>
       columns for efficiency (Peter Eisentraut)␟効率を上げるために<link linkend="catalog-pg-attribute"><structname>pg_attribute</structname></link>の列を調整しました。
(Peter Eisentraut)␞␞      </para>␞
␝   <sect3 id="release-16-modules">␟    <title>Additional Modules</title>␟    <title>追加モジュール</title>␞␞␞
␝      <para>␟       Improve use of extension-based indexes on boolean columns (Zongliang
       Quan, Tom Lane)␟boolean型の列で拡張ベースのインデックスを使用する機能を改善しました。
(Zongliang Quan, Tom Lane)␞␞      </para>␞
␝      <para>␟       Add support for Daitch-Mokotoff Soundex to <link
       linkend="fuzzystrmatch"><application>fuzzystrmatch</application></link>
       (Dag Lem)␟<link linkend="fuzzystrmatch"><application>fuzzystrmatch</application></link>でDaitch-Mokotoff Soundexがサポートされました。
(Dag Lem)␞␞      </para>␞
␝      <para>␟       Allow <link
       linkend="auto-explain"><application>auto_explain</application></link>
       to log values passed to parameterized statements (Dagfinn Ilmari
       Mannsåker)␟<link linkend="auto-explain"><application>auto_explain</application></link>がパラメータ化された文に渡された値をログへ記録するようになりました。
(Dagfinn Ilmari Mannsåker)␞␞      </para>␞
␝      <para>␟       This affects queries using server-side <link
       linkend="sql-prepare"><command>PREPARE</command></link>/<link
       linkend="sql-execute"><command>EXECUTE</command></link>
       and client-side parse/bind.  Logging is controlled by <link
       linkend="auto-explain-configuration-parameters-log-parameter-max-length"><literal>auto_explain.log_parameter_max_length</literal></link>;
       by default query parameters will be logged with no length
       restriction.␟これは、サーバ側の<link linkend="sql-prepare"><command>PREPARE</command></link>/<link linkend="sql-execute"><command>EXECUTE</command></link>とクライアント側のPARSE/BINDを使用する問い合わせに影響します。
ログの記録は<link linkend="auto-explain-configuration-parameters-log-parameter-max-length"><literal>auto_explain.log_parameter_max_length</literal></link>で制御されます。
デフォルトでは、問い合わせパラメータは長さ制限なしでログに記録されます。␞␞      </para>␞
␝      <para>␟       Have <link
       linkend="auto-explain"><application>auto_explain</application></link>'s
       <option>log_verbose</option> mode honor the value of <link
       linkend="guc-compute-query-id"><varname>compute_query_id</varname></link>
       (Atsushi Torikoshi)␟<link linkend="auto-explain"><application>auto_explain</application></link>の<option>log_verbose</option>モードが<link linkend="guc-compute-query-id"><varname>compute_query_id</varname></link>の値を遵守するようになりました。
(Atsushi Torikoshi)␞␞      </para>␞
␝      <para>␟       Previously even if
       <varname>compute_query_id</varname> was enabled, <link
       linkend="auto-explain-configuration-parameters-log-verbose"><option>log_verbose</option></link>
       was not showing the query identifier.␟以前は、<varname>compute_query_id</varname>が有効になっていても、<link linkend="auto-explain-configuration-parameters-log-verbose"><option>log_verbose</option></link>は問い合わせ識別子を表示していませんでした。␞␞      </para>␞
␝      <para>␟       Change the maximum length of <link
       linkend="ltree"><application>ltree</application></link> labels
       from 256 to 1000 and allow hyphens (Garen Torikian)␟<link linkend="ltree"><application>ltree</application></link>ラベルの最大長が256から1000に変更され、ハイフンが利用可能になりました。
(Garen Torikian)␞␞      </para>␞
␝      <para>␟       Have <link
       linkend="pgstatstatements"><structname>pg_stat_statements</structname></link>
       normalize constants used in utility commands (Michael Paquier)␟<link linkend="pgstatstatements"><structname>pg_stat_statements</structname></link>でユーティリティコマンドで使用される定数を正規化します。
(Michael Paquier)␞␞      </para>␞
␝      <para>␟       Previously constants appeared instead of placeholders, e.g.,
       <literal>$1</literal>.␟以前は、プレースホルダの代わりに定数、例えば<literal>$1</literal>が表示されていました。␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="pgwalinspect"><application>pg_walinspect</application></link>
       function <link
       linkend="pgwalinspect-funcs-pg-get-wal-block-info"><function>pg_get_wal_block_info()</function></link>
       to report <acronym>WAL</acronym> block information (Michael Paquier,
       Melanie Plageman, Bharath Rupireddy)␟<acronym>WAL</acronym>ブロック情報を報告する<link linkend="pgwalinspect"><application>pg_walinspect</application></link>の<link linkend="pgwalinspect-funcs-pg-get-wal-block-info"><function>pg_get_wal_block_info()</function></link>関数を追加しました。
(Michael Paquier, Melanie Plageman, Bharath Rupireddy)␞␞      </para>␞
␝      <para>␟       Change how <link
       linkend="pgwalinspect"><application>pg_walinspect</application></link>
       functions <link
       linkend="pgwalinspect-funcs-pg-get-wal-records-info"><function>pg_get_wal_records_info()</function></link>
       and <link
       linkend="pgwalinspect-funcs-pg-get-wal-stats"><function>pg_get_wal_stats()</function></link>
       interpret ending <acronym>LSN</acronym>s (Bharath Rupireddy)␟<link linkend="pgwalinspect"><application>pg_walinspect</application></link>の<link linkend="pgwalinspect-funcs-pg-get-wal-records-info"><function>pg_get_wal_records_info()</function></link>と<link linkend="pgwalinspect-funcs-pg-get-wal-stats"><function>pg_get_wal_stats()</function></link>関数が末尾<acronym>LSN</acronym>を解釈する方法を変更しました。
(Bharath Rupireddy)␞␞      </para>␞
␝      <para>␟       Previously ending <acronym>LSN</acronym>s which represent
       nonexistent <acronym>WAL</acronym> locations would generate
       an error, while they will now be interpreted as the end of the
       <acronym>WAL</acronym>.␟以前は存在しない<acronym>WAL</acronym>の場所を表す末尾の<acronym>LSN</acronym>はエラーを生成していましたが、今後は<acronym>WAL</acronym>の末尾として解釈されます。␞␞      </para>␞
␝      <para>␟       Add detailed descriptions of <acronym>WAL</acronym> records in <link
       linkend="pgwalinspect"><application>pg_walinspect</application></link>
       and <link
       linkend="pgwaldump"><application>pg_waldump</application></link>
       (Melanie Plageman, Peter Geoghegan)␟<acronym>WAL</acronym>レコードの詳細な記述を<link linkend="pgwalinspect"><application>pg_walinspect</application></link>と<link linkend="pgwaldump"><application>pg_waldump</application></link>に追加しました。
(Melanie Plageman, Peter Geoghegan)␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="pageinspect"><application>pageinspect</application></link>
       function <link
       linkend="pageinspect-b-tree-funcs"><function>bt_multi_page_stats()</function></link>
       to report statistics on multiple pages (Hamid Akhtar)␟<link linkend="pageinspect"><application>pageinspect</application></link>で複数ページの統計を報告する<link linkend="pageinspect-b-tree-funcs"><function>bt_multi_page_stats()</function></link>関数を追加しました。
(Hamid Akhtar)␞␞      </para>␞
␝      <para>␟       This is similar to <function>bt_page_stats()</function> except it
       can report on a range of pages.␟これは<function>bt_page_stats()</function>と似ていますが、ページの範囲を指定してレポートできる点が異なります。␞␞      </para>␞
␝      <para>␟       Add empty range output column to <link
       linkend="pageinspect"><application>pageinspect</application></link>
       function <link
       linkend="pageinspect-brin-funcs"><function>brin_page_items()</function></link>
       (Tomas Vondra)␟<link linkend="pageinspect"><application>pageinspect</application></link>の<link linkend="pageinspect-brin-funcs"><function>brin_page_items()</function></link>関数に空の範囲出力を示す列を追加しました。
(Tomas Vondra)␞␞      </para>␞
␝      <para>␟       Redesign archive modules to be more flexible (Nathan Bossart)␟アーカイブモジュールをより柔軟に再設計しました。
(Nathan Bossart)␞␞      </para>␞
␝      <para>␟       Initialization changes will require modules written for older
       versions of Postgres to be updated.␟初期化の変更により、古いバージョンのPostgres用に書かれたモジュールを更新する必要があります。␞␞      </para>␞
␝      <para>␟       Correct inaccurate <link
       linkend="pgstatstatements"><application>pg_stat_statements</application></link>
       row tracking extended query protocol statements (Sami Imseih)␟不正確な<link linkend="pgstatstatements"><application>pg_stat_statements</application></link>の拡張問い合わせプロトコル文追跡を修正しました。
(Sami Imseih)␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="pgbuffercache"><application>pg_buffercache</application></link>
       function <function>pg_buffercache_usage_counts()</function> to
       report usage totals (Nathan Bossart)␟<link linkend="pgbuffercache"><application>pg_buffercache</application></link>に使用量の合計を報告する<function>pg_buffercache_usage_counts()</function>関数を追加しました。
(Nathan Bossart)␞␞      </para>␞
␝      <para>␟       Add <link
       linkend="pgbuffercache"><application>pg_buffercache</application></link>
       function <function>pg_buffercache_summary()</function> to report
       summarized buffer statistics (Melih Mutlu)␟<link linkend="pgbuffercache"><application>pg_buffercache</application></link>にバッファの概要を報告する<function>pg_buffercache_summary()</function>関数を追加しました。
(Melih Mutlu)␞␞      </para>␞
␝      <para>␟       Allow the schemas of required extensions to be
       referenced in extension scripts using the new syntax
       <literal>@extschema:referenced_extension_name@</literal>
       (Regina Obe)␟新しい構文<literal>@extschema:referenced_extension_name@</literal>を使用して、必要な拡張のスキーマを拡張スクリプトで参照できるようにしました。
(Regina Obe)␞␞      </para>␞
␝      <para>␟       Allow required extensions to
       be marked as non-relocatable using <link
       linkend="extend-extensions-files-no-relocate"><literal>no_relocate</literal></link>
       (Regina Obe)␟<link linkend="extend-extensions-files-no-relocate"><literal>no_relocate</literal></link>を使用して、必要な拡張を再配置不可能としてマークできるようにしました。
(Regina Obe)␞␞      </para>␞
␝      <para>␟       This allows <literal>@extschema:referenced_extension_name@</literal>
       to be treated as a constant for the lifetime of the extension.␟これにより、<literal>@extschema:referenced_extension_name@</literal>は、拡張の存続期間中、定数として扱われます。␞␞      </para>␞
␝       <para>␟        Allow <application>postgres_fdw</application> to do aborts in
        parallel (Etsuro Fujita)␟<application>postgres_fdw</application>が並列処理を中断できるようにしました。
(Etsuro Fujita)␞␞       </para>␞
␝       <para>␟        This is enabled with
        <application>postgres_fdw</application> option <link
        linkend="postgres-fdw-options-transaction-management"><option>parallel_abort</option></link>.␟これは<application>postgres_fdw</application>のオプション<link linkend="postgres-fdw-options-transaction-management"><option>parallel_abort</option></link>で有効にできます。␞␞       </para>␞
␝       <para>␟        Make <link linkend="sql-analyze"><command>ANALYZE</command></link>
        on foreign <application>postgres_fdw</application> tables more
        efficient (Tomas Vondra)␟外部<application>postgres_fdw</application>テーブルの<link linkend="sql-analyze"><command>ANALYZE</command></link>をより効率的にしました。
(Tomas Vondra)␞␞       </para>␞
␝       <para>␟        The <application>postgres_fdw</application> option <link
        linkend="postgres-fdw-options-cost-estimation"><option>analyze_sampling</option></link>
        controls the sampling method.␟<application>postgres_fdw</application>オプションの<link linkend="postgres-fdw-options-cost-estimation"><option>analyze_sampling</option></link>はサンプリング方法を制御します。␞␞       </para>␞
␝       <para>␟        Restrict shipment of <link
        linkend="datatype-oid"><type>reg</type></link>* type constants
        in <application>postgres_fdw</application> to those referencing
        built-in objects or extensions marked as shippable (Tom Lane)␟<application>postgres_fdw</application>での<link linkend="datatype-oid"><type>reg</type></link>*型の定数の送出を、送出可能としてマークされた組み込みオブジェクトまたは拡張を参照するものに制限しました。
(Tom Lane)␞␞       </para>␞
␝       <para>␟        Have <application>postgres_fdw</application> and <link
        linkend="dblink"><application>dblink</application></link> handle
        interrupts during connection establishment (Andres Freund)␟<application>postgres_fdw</application>と<link linkend="dblink"><application>dblink</application></link>で接続確立中の割り込みを処理するようにしました。
(Andres Freund)␞␞       </para>␞
␝  <sect2 id="release-16-acknowledgements">␟   <title>Acknowledgments</title>␟   <title>謝辞</title>␞␞␞
␝   <para>␟    The following individuals (in alphabetical order) have contributed
    to this release as patch authors, committers, reviewers, testers,
    or reporters of issues.␟以下の人々（アルファベット順）はパッチ作者、コミッター、レビューア、テスターあるいは問題の報告者として本リリースに貢献しました。␞␞   </para>␞
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
