{ mi, ... }:
#nixos_kawaii.png @https://t.me/nixos_zhcn/712551
''
  {
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
    "logo": {
      "type": "kitty-direct",
      "source": "/home/${mi.userName}/Pictures/wallpaper/nixos_kawaii.png",
      "color": {
        "1": "",
        "2": "",
        "3": "",
        "4": "",
        "5": "",
        "6": "",
        "7": "",
        "8": "",
        "9": "",
      },
      "width": null,
      "height": null,
      "padding": {
        "top": 0,
        "left": 0,
        "right": 2,
      },
      "printRemaining": true,
      "preserveAspectRatio": false,
      "recache": false,
      "position": "left",
      "chafa": {
        "fgOnly": false,
        "symbols": "block+border+space-wide-inverted",
      },
    },
    "display": {
      "stat": false,
      "pipe": false,
      "showErrors": false,
      "disableLinewrap": true,
      "hideCursor": false,
      "separator": "⋮ ",
      "color": {
        "keys": "#f4b8e4",
        "title": "#f4b8e4",
        "output": "",
        "separator": "#f4b8e4",
      },
      "brightColor": true,
      "duration": {
        "abbreviation": false,
        "spaceBeforeUnit": "default",
      },
      "size": {
        "maxPrefix": "YB",
        "binaryPrefix": "iec",
        "ndigits": 2,
        "spaceBeforeUnit": "default",
      },
      "temp": {
        "unit": "D",
        "ndigits": 1,
        "color": {
          "green": "32",
          "yellow": "93",
          "red": "91",
        },
        "spaceBeforeUnit": "default",
      },
      "percent": {
        "type": ["num"],
        "ndigits": 0,
        "color": {
          "green": "32",
          "yellow": "93",
          "red": "91",
        },
        "spaceBeforeUnit": "default",
        "width": 0,
      },
      "bar": {
        "char": {
          "elapsed": "■",
          "total": "-",
        },
        "border": {
          "left": "[ ",
          "right": " ]",
          "leftElapsed": "",
          "rightElapsed": "",
        },
        "color": {
          "elapsed": "auto",
          "total": "97",
          "border": "97",
        },
        "width": 10,
      },
      "fraction": {
        "ndigits": 2,
      },
      "noBuffer": false,
      "key": {
        "width": 0,
        "type": "icon",
        "paddingLeft": 0,
      },
      "freq": {
        "ndigits": 2,
        "spaceBeforeUnit": "default",
      },
      "constants": [],
    },
    "general": {
      "thread": true,
      "processingTimeout": 5000,
      "detectVersion": true,
      "playerName": "",
      "dsForceDrm": false,
    },
    "modules": [
      {
        "type": "title",
        "key": " ",
        "keyIcon": "",
        "fqdn": false,
        "color": {
          "user": "",
          "at": "#f4b8e4",
          "host": "",
        },
      },
      {
        "type": "separator",
        "string": "━",
        "outputColor": "#f4b8e4",
        "length": 0,
      },
      {
        "type": "os",
        "keyIcon": " ",
        "format": "{name} {version}",
      },
      {
        "type": "kernel",
        "keyIcon": " ",
        "format": "{release}",
      },
      {
        "type": "packages",
        "keyIcon": " ",
        "disabled": ["winget"],
        "combined": false,
        "format": "{nix-all}",
      },
      {
        "type": "de",
        "keyIcon": " ",
        "slowVersionDetection": false,
      },
      {
        "type": "wm",
        "keyIcon": " ",
        "detectPlugin": false,
        "format": "{process-name} ({protocol-name})",
      },
      {
        "type": "memory",
        "keyIcon": "󰍛 ",
        "percent": {
          "green": 50,
          "yellow": 80,
          "type": 0,
        },
      },
      {
        "type": "uptime",
        "keyIcon": "󰔟 ",
        "format": "{days}d {hours}h {minutes}m",
      },
      {
        "type": "colors",
        "key": " ",
        "keyIcon": "",
        "symbol": "block",
        "paddingLeft": 0,
        "block": {
          "width": 3,
          "range": [0, 15],
        },
      },
    ],
  }
''
