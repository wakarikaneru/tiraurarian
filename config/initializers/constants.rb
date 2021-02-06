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

  CARD_ZOMBIE = "ゾンビー"
  CARD_PRICE = 1000
  CARD_PACK = 5
  CARD_BOX_EXPAND_PRICE = 1000

  CARD_PRIZE = 100

  CARD_RULE = [300, 200, 100]
  CARD_RULE_NAME = ["スーパーヘビー級", "ヘビー級", "ジュニア級"]
  CARD_ELEMENTS = ["無", "木", "火", "土", "金", "水", "光", "闇", "全"]
  CARD_ELEMENTALS = ["ボイド", "青龍", "朱雀", "麒麟", "白虎", "玄武", "コスモス", "カオス", "神"]

  CARD_EFFFECT = [ [0, 0, 0, 0, 0, 0, 0, 0, 0],
                   [0, 0, -1, 1, 0, 0, 1, 0, 0],
                   [0, 0, 0, -1, 1, 0, 1, 0, 0],
                   [0, 0, 0, 0, -1, 1, 1, 0, 0],
                   [0, 1, 0, 0, 0, -1, 1, 0, 0],
                   [0, -1, 1, 0, 0, 0, 1, 0, 0],
                   [0, 0, 0, 0, 0, 0, 0, 1, 0],
                   [0, 1, 1, 1, 1, 1, 0, 0, 0],
                   [0, 0, 0, 0, 0, 0, 0, 0, 0] ]

  CARD_ENVIRONMENT = [ [0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 1, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 1, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 1, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 1, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 1, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0],
                       [0, 1, 1, 1, 1, 1, 0, 0, 0] ]
end
