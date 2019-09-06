def current_location_template
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

def select_options_template
  {
    "type": "box",
    "layout": "vertical",
    "spacing": "sm",
    "altText": "何をしますか？",
    "contents": [
      # "template": {
      #   "type": "buttons",
      #   "title": "最寄駅探索",
      #   "text": "現在の位置を送信しますか？",
      #   "actions": [
      #       {
      #         "type": "uri",
      #         "label": "位置を送る",
      #         "uri": "line://nv/location"
      #       }
      #   ]
      # }
      {
        "type": "button",
        "style": "link",
        "height": "sm",
        "action": {
          "type": "uri",
          "label": "最寄り駅を検索する",
          "uri": "/callback"
        }
      },
      {
        "type": "button",
        "style": "link",
        "height": "sm",
        "action": {
          "type": "uri",
          "label": "WEBSITE",
          "uri": "https://linecorp.com"
        }
      },
      {
        "type": "spacer",
        "size": "sm"
      }
    ],
  }
end
