module Constants
  TRANSLATE_LANGUAGE = ["ja", "en", "zh"]

  NOTICE_RETENTION_PERIOD = 7.days
  MESSAGE_RETENTION_PERIOD = 30.days

  DISTRIBUTE_RATIO = 0.005
  DISTRIBUTE_MIN = 100
  TAX_RATIO = 0.01
  TAX_MIN = 1

  PREMIUM_PRICE = 50000
  PREMIUM_LIMIT = 1.days

  STOCK_COMPANY_NAME_ELEMENTS = ["", "ニュース", "サービス", "スクラッチ", "テクノロジー", "ナビ", "オープン", "ロボティクス", "ネットワーク",
    "ネットワークス", "ヒューマン", "インタラクティブ", "マーケット", "マーケティング", "プラネット", "コネクテッド", "メディア", "オプト",
    "マイスター", "ネクスト", "バイオ", "ケミカル", "テック", "フォース", "アセット", "ナレッジ", "マーチャント", "ワークス", "スタンダード",
    "エージェント", "マネー", "インサイド", "リンク", "アンド", "モチベーション", "スタイル", "デザイン", "ペイ", "ジャパン", "パワー",
    "マテリアル", "デバイス", "オプティ", "マインド", "ネット", "ビット", "エナジー", "キャリア", "ヘルスケア", "ピクセル", "メモリ", "ハウス",
    "スペース", "フィールド", "スマート", "ドライブ", "システム", "システムズ", "リンク", "サイエンス", "クレジット", "ワークス", "コム",
    "ケミカル", "コンセプト", "インフォ", "インターネット", "イー", "デジタル", "クリエイト", "クラウド", "フューチャー", "ユニバーサル" ]

  STOCK_COMPANY_NAME_ELEMENTS_AFTER = ["工業", "重工業", "興業", "鋼業", "化学", "電力", "電気", "電機", "技研", "研究所", "交通", "証券",
    "ホールディングス", "グループ", "カンパニー", "コーポレーション", "キャピタル", "サービス", "エレクトロニクス", "セミコンダクター",
    "フーズ", "ペイ", "ラボ", "モバイル", "エンジニアリング", "リテイリング", "バンク", "ドットコム", "エンターテインメント", "ロジスティクス",
    "企画", "開発"]

  CARD_ZOMBIE = "ゾンビー"
  CARD_PRICE = 1000
  CARD_PACK = 5
  CARD_BOX_EXPAND_PRICE = 1000
  CARD_SEND_PRICE = 1000
  CARD_JUDGE_PRICE = 1000

  CARD_PRIZE = 1000
  CARD_DESTROY_RATIO = 0.2
  CARD_HOF_COUNT = 30

  CARD_RULE = [300, 200, 100]
  CARD_RULE_NAME = ["スーパーヘビー級", "ヘビー級", "ジュニア級"]
  CARD_ELEMENTS = ["無", "木", "火", "土", "金", "水", "光", "闇", "全", "？", "虚", "神"]
  CARD_ELEMENTALS = ["カオス", "青龍", "朱雀", "麒麟", "白虎", "玄武", "アマテラス", "ツクヨミ", "コスモス", "正体不明", "真理", "宣言"]

  CARD_EFFFECT = [ [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0],
                   [0, 0,-1, 1, 0, 0, 1, 0, 0, 1, 1, 0],
                   [0, 0, 0,-1, 1, 0, 1, 0, 0, 1, 1, 0],
                   [0, 0, 0, 0,-1, 1, 1, 0, 0, 1, 1, 0],
                   [0, 1, 0, 0, 0,-1, 1, 0, 0, 1, 1, 0],
                   [0,-1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0],
                   [0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0],
                   [0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0],
                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0],
                   [-1,-1,-1,-1,-1,-1,-1,-1,-1, 0,-1,-1],
                   [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
                   [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0] ]

  CARD_ENVIRONMENT = [ [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ]

  TIRAMON_RULE_NAME = ["チャンピオンシップ", "ヘビー級", "ジュニア級", "アンダーマッチ"]
  TIRAMON_FIGHT_TERM = [12.hour, 3.hour, 2.hour, 10.minute]
  TIRAMON_FIGHT_VARTH = [100000, 8000, 4000, 300]
  TIRAMON_PAYMENT_SITE = 12.hour

  TIRAMON_NAME = "野生のチラモン"

  TIRAMON_MOVE_VALUE = [40, 2, 200, 20, 40, 1]
  TIRAMON_MP_DAMAGE = [5.0, 10.0]
  TIRAMON_RECOVER_RATIO = [0.10, 0.05, 0.20]

  TIRAMON_ELEMENTS = ["打", "投", "極", "無"]

  TIRAMON_MOTIVATION = [
    ["余裕がありそうだ", "非常に冷静だ", "表情は柔らかい"],
    ["若干余裕がありそうだ", "非常に落ち着いている", "冷静に相手を見据えている"],
    ["落ち着いている", "表情は読めない", "相手を見据えている"],
    ["やる気がありそうだ！", "油断はない！", "静かな闘志で満ちている！"],
    ["やる気が満ち溢れている！！", "万全の体制！！", "眼光は鋭い！！"],
    ["やる気が爆発しそうだ！！！", "闘志が満ち溢れている！！！", "その眼は闘志で燃え上がっている！！！"],
  ]
  TIRAMON_RISK = [
    ["様子見の攻撃だ", "小手調べの攻撃だ", "軽い攻撃だ"],
    ["着実な攻撃だ", "堅実な攻撃だ", "確実にダメージを積み上げていく"],
    ["果敢な攻撃だ", "勇敢に攻撃していく", "重い攻撃だ"],
    ["大技を狙っている…！", "この攻撃はなるべくもらいたくない…！", "試合の流れが変わりそうだ…！"],
    ["大技を狙っている！", "これはもらってはいけない攻撃だ！", "試合の流れを変える一撃！"],
    ["超大技を狙っている！！", "決まれば試合終了は必至だ！！", "これで決まるか！！"],
    ["奥の手を狙っている！！！", "必殺の一撃を狙う！！！", "フィニッシュ宣言！！！", "試合を終わらせるつもりだ！！！"],
  ]

  TIRAMON_HIT_RATE_PURORESU = [
    ["無謀な攻めだ！！！", "予想不可能の行動！！！"],
    ["仕掛けが早すぎる！！", "いきなり仕掛けていった！！"],
    ["強引に行った！", "仕掛けていった！"],
    ["決まるか…！", "決まりそうだ…！"],
    ["決めに行った！", "ここが勝負所！"],
    ["確実に決めに行った！！", "狙いすましていた！！"],
    ["満を持して決めに行った！！！", "絶対に決める！！！"],
  ]
  TIRAMON_HIT_RATE_SHOOT = [
    ["完全に読み切られている！！！", "鉄壁の防御だ！！！"],
    ["読まれている！！", "完全に隙がない！！"],
    ["警戒されている！", "隙がない！"],
    ["警戒されているが…！", "微妙なところだ…！"],
    ["僅かな隙を突いた！", "一瞬の油断を突いた！"],
    ["これは読んでいなかったようだ！！", "相手の虚を突いた！！"],
    ["完全に予想外のようだ！！！", "これは躱せない！！！"],
  ]

  TIRAMON_SUCCESS_ATTACK = ["が決まった！", "が決まる！", "が炸裂！", "が爆発！"]
  TIRAMON_FAIL_ATTACK = ["うまくきまらなかった！", "決まらなかった！", "間一髪で決まらなかった！", "惜しい、決まらなかった！"]

  TIRAMON_WEIGHT_DAMAGE = [
    ["パワーでは分がある！", "体格を活かす！"],
    ["パワーで圧倒する！！", "体格差を見せつける！！"],
    ["圧倒的な体格差！！！", "絶望的な体格差！！！"],
  ]
  TIRAMON_KIAI_DAMAGE = [
    ["あまり力が入っていない…！", "なんとか力を振り絞る…！", "気合だけで技を出していく…！"],
    ["力のこもった一撃！", "会心の一撃！", "気合の一撃！"],
    ["全力の一撃！！", "渾身の一撃！！", "気合を振り絞った一撃！！"],
    ["すべてを出し尽くす！！！", "魂の一撃！！！", "この一撃にすべてを賭ける！！！"],
  ]
  TIRAMON_RANDOM_DAMAGE = [
    ["クリティカルヒット！", "クリティカルヒット！", "クリティカルヒット！", "クリティカルヒット！", "うまく決まった！"],
    ["クリティカルヒット！！", "クリティカルヒット！！", "クリティカルヒット！！", "クリティカルヒット！！", "完璧に決まった！！"],
    ["クリティカルヒット！！！", "クリティカルヒット！！！", "クリティカルヒット！！！", "クリティカルヒット！！！", "闘魂爆発！！！"],
  ]
  TIRAMON_DAMAGE = [
    ["全く効いていない！！！"],
    ["効いているようだ！！"],
    ["着実に効いている！"],
    ["効いている…！"],
    ["すごく効いている！"],
    ["ものすごく効いている！！"],
    ["痛恨の一撃！！！"],
    ["終わった……！！！"],
  ]

  TIRAMON_MOVE = ["が動いた！", "が仕掛ける！", "が攻める！"]
  TIRAMON_TIRED = ["は疲れて動けない…！", "ががっくりと膝をつく…！", "はスタミナ切れのようだ…！"]
  TIRAMON_DOUBLE_DOWN = ["お互いに倒れて動けない…！", "ダブルダウン…！", "どちらが先に動けるか…！", "死闘の果てに、一体どちらが勝利を掴むのか…！"]

  TIRAMON_GIVE_UP = ["はギブアップ！！！", "は戦闘不能！！！", "はレフェリーの判断で戦闘不能とみなされた！！！", "陣営からタオルが投げ込まれた！！！"]
  TIRAMON_GUTS = ["は根性で踏みとどまった！！！", "はまだ闘える！！！", "は精根尽き果て、なおまだ闘う！！！", "はなぜまだ闘えるのか！！！", "はまだ倒れない！！！" ]
end
