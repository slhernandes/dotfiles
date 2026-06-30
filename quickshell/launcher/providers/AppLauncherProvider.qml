pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  property bool showIcons: true
  property list<var> apps: frecencyJson.apps
  property var items: []
  FileView {
    id: frecencyFile
    path: Quickshell.shellDir + "/data/frecency.json"
    watchChanges: true
    onAdapterUpdated: writeAdapter()
    JsonAdapter {
      id: frecencyJson
      property list<var> apps: []
      onAppsChanged: () => {
        root.updateItems();
      }
    }
    onLoaded: () => {
      root.updateItems();
    }
  }

  function updateItems() {
    function compare(a, b) {
      const a_score = calculateScore(a.name);
      const b_score = calculateScore(b.name);
      if (a_score !== b_score) {
        return b_score - a_score > 0 ? 1 : -1;
      }
      if (a.name.toLowerCase() < b.name.toLowerCase())
        return -1;
      else if (a.name.toLowerCase() === b.name.toLowerCase())
        return 0;
      return 1;
    }
    let apps = [...DesktopEntries.applications.values];

    for (let i = apps.length - 1; i >= 0; i--) {
      let swap = false;
      for (let j = 0; j < i; j++) {
        if (compare(apps[j], apps[j + 1]) === 1) {
          const temp = apps[j];
          apps[j] = apps[j + 1];
          apps[j + 1] = temp;
          swap = true;
        }
      }
      if (!swap)
        break;
    }
    root.items = apps;
  }
  function timeScore(secs: int): int {
    const buckets = [
      {
        "duration": 345600,
        "score": 100
      } // 4 days
      ,
      {
        "duration": 1209600,
        "score": 70
      } // 14 days
      ,
      {
        "duration": 2678400,
        "score": 50
      } // 31 days
      ,
      {
        "duration": 7776000,
        "score": 30
      }, // 90 days
    ];
    const defaultScore = 10;
    for (const bucket of buckets) {
      if (secs <= bucket.duration) {
        return bucket.score;
      }
    }
    return defaultScore;
  }


  function findAppFrecencyFromString(appName: string): var {
    for (const app of apps) {
      if (app.name === appName) {
        return app;
      }
    }
    return null;
  }

  function calculateScore(appName: string): int {
    let bonus = 0;
    const app = findAppFrecencyFromString(appName);
    const visits = app?.visits || [];
    const totalVisits = app?.totalVisits || 0;
    const now = Math.floor(Date.now() / 1000);
    for (const ts of visits) {
      bonus += (100 / 100) * root.timeScore(now - ts);
    }

    if (totalVisits > 0 && visits.length > 0) {
      return Math.ceil(totalVisits * bonus / visits.length);
    }
    return -1;
  }
}
