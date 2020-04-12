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

  CARD_ELEMENTS = ["無", "火", "風", "土", "水", "光", "闇"]
  CARD_ELEMENTALS = ["ボイド", "サラマンダー", "シルフ", "ノーム", "ウンディーネ", "光の精霊", "闇の精霊"]

  CARD_EFFFECT = [ [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
                   [1.0, 1.0, 1.1, 1.0, 1.0, 1.1, 1.0],
                   [1.0, 1.0, 1.0, 1.1, 1.0, 1.1, 1.0],
                   [1.0, 1.0, 1.0, 1.0, 1.1, 1.1, 1.0],
                   [1.0, 1.1, 1.0, 1.0, 1.0, 1.1, 1.0],
                   [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.1],
                   [1.0, 1.1, 1.1, 1.1, 1.1, 1.0, 1.0] ]

  CARD_ENVIRONMENT = [ [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                       [0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0],
                       [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0],
                       [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0] ]
end
