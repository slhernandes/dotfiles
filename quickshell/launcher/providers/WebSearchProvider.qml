pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  property string placeholderText: "Web Search"
  property bool showIcons: true
  // property real widthMult: 0.5
  property real heightMult: 0.75
  // property int elideMode: Text.ElideRight
  property var items: [
    {
      "name": "<b>D</b>uckDuck<b>G</b>o",
      "url": "https://duckduckgo.com/?t=ftsa&ia=web&q=",
      "icon": `file://${Variables.configDir}/icons/ddg.png`,
      "bang": "dg"
    },
    {
      "name": "<b>W</b>i<b>k</b>ipedia",
      "url": "https://en.wikipedia.org/w/index.php?search=",
      "icon": `file://${Variables.configDir}/icons/wikipedia.svg`,
      "bang": "wk"
    },
    {
      "name": "<b>A</b>rch<b>W</b>iki",
      "url": "https://wiki.archlinux.org/index.php?search=",
      "icon": `file://${Variables.configDir}/icons/arch.svg`,
      "bang": "aw"
    },
    {
      "name": "<b>A</b>rch User <b>R</b>epository",
      "url": "https://aur.archlinux.org/packages?O=0&K=",
      "icon": `file://${Variables.configDir}/icons/arch.svg`,
      "bang": "ar"
    },
    {
      "name": "<b>G</b>it<b>h</b>ub",
      "url": "https://github.com/search?q=",
      "icon": `file://${Variables.configDir}/icons/github.svg`,
      "bang": "gh"
    },
    {
      "name": "<b>Y</b>ou<b>T</b>ube",
      "url": "https://www.youtube.com/results?search_query=",
      "icon": `file://${Variables.configDir}/icons/youtube.svg`,
      "bang": "yt"
    },
    {
      "name": "<b>W</b>olfram|<b>A</b>lpha",
      "url": "https://www.wolframalpha.com/input?i=",
      "icon": `file://${Variables.configDir}/icons/wolfram.svg`,
      "bang": "wa"
    },
    {
      "name": "<b>S</b>team<b>D</b>B",
      "url": "https://steamdb.info/search/?a=all&q=",
      "icon": `file://${Variables.configDir}/icons/steam.svg`,
      "bang": "sd"
    },
    {
      "name": "<b>p</b>roton<b>d</b>b",
      "url": "https://www.protondb.com/search?q=",
      "icon": `file://${Variables.configDir}/icons/steam.svg`,
      "bang": "pd"
    }
  ]

  function execute(item: var, inputText: string) {
    if (!item || inputText.length <= 0)
      return;

    const spChars = [
      {
        "search": "%",
        "replace": "%25"
      },
      {
        "search": "#",
        "replace": "%23"
      },
      {
        "search": "$",
        "replace": "%24"
      },
      {
        "search": "&",
        "replace": "%26"
      },
      {
        "search": "+",
        "replace": "%2B"
      },
      {
        "search": ",",
        "replace": "%2C"
      },
      {
        "search": "/",
        "replace": "%2F"
      },
      {
        "search": ":",
        "replace": "%3A"
      },
      {
        "search": ";",
        "replace": "%3B"
      },
      {
        "search": "=",
        "replace": "%3D"
      },
      {
        "search": "?",
        "replace": "%3F"
      },
      {
        "search": "@",
        "replace": "%40"
      }
    ];
    let searchText = inputText[0] === "!" ? inputText.split(" ").slice(1).join(" ") : inputText;
    for (const spChar of spChars) {
      searchText = searchText.replace(spChar.search, spChar.replace);
    }
    searchText = searchText.split(" ").join("+");
    Quickshell.execDetached([Variables.browser, item.url + searchText]);
  }

  function updateItems() {
    return;
  }

  function filter(inputText: string): list<var> {
    if (inputText.length <= 0)
      return root.items;
    let filteredItems = [];
    if (inputText[0] === "!") {
      let bang = inputText.split(" ")[0].slice(1) ?? "dg";
      for (const item of items) {
        if (item.bang.includes(bang)) {
          filteredItems.push(item);
        }
      }
    } else {
      return root.items;
    }
    return filteredItems;
  }
}
