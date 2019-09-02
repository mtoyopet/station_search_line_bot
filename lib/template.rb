def template
  {
    "type": "template",
    "altText": "位置検索中",
    "template": {
        "type": "buttons",
        "title": "最寄駅探索",
        "text": "現在の位置を送信しますか？",
        "actions": [
            {
              "type": "uri",
              "label": "位置を送る",
              "uri": "line://nv/location"
            }
        ]
    }
  }
end
