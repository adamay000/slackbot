module.exports =
  # コマンドの前につけるプリフィックス
  COMMAND:
    PREFIX: '!'
    SPLIT: ' '
    BLACKLIST: [
      'general'
      'random'
    ]
  # 権限
  PERMISSION:
    DEFAULT: 'DEFAULT'
    ADMIN: 'ADMIN'
    OWNER: 'OWNER'
  # チャンネル諸々
  CHANNEL:
    PRESENCE:
      ACTIVE: 'active'
      AWAY: 'away'
