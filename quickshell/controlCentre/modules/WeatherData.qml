pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  readonly property string lastTimestamp: weatherInfo.lastTimestamp
  readonly property string icon: weatherInfo.icon
  readonly property string temperature: weatherInfo.temperature
  readonly property string city: weatherInfo.city
  readonly property string weatherDesc: weatherInfo.weatherDesc

  PersistentProperties {
    id: weatherInfo
    reloadableId: "weatherData"
    property string lastTimestamp
    property string icon
    property string temperature
    property string city
    property string weatherDesc
  }

  Process {
    id: retrieveWeather
    running: false
    command: [`${Variables.configDir}/scripts/weather.sh`]
  }

  FileView {
    id: weatherJson
    path: `file://${Variables.configDir}/weather.json`
    blockLoading: true
  }

  Timer {
    interval: 300000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.reload()
  }

  function getIcon(s) {
    let iconName = "cloud.png";
    switch (s) {
    // clear day
    case "01d":
      {
        iconName = "clear_day.png";
      }
      break;
    // clear night
    case "01n":
      {
        iconName = "clear_night.png";
      }
      break;
    // cloudy
    case "02d":
    case "02n":
    case "03d":
    case "03n":
    case "04d":
    case "04n":
      {
        iconName = "cloud.png";
      }
      break;
    // rainy
    case "09d":
    case "09n":
    case "10d":
    case "10n":
      {
        iconName = "rain.png";
      }
      break;
    // thunderstorm
    case "11d":
    case "11n":
      {
        iconName = "thunderstorm.png";
      }
      break;
    // snow
    case "13d":
    case "13n":
      {
        iconName = "snow.png";
      }
      break;
    // mist
    case "50d":
    case "50n":
      {
        iconName = "mist.png";
      }
      break;
    default:
      {
        iconName = "cloud.png";
      }
    }
    return `file://${Variables.configDir}/icons/${iconName}`;
  }

  function reload() {
    const cur = Date.now();
    if (cur - parseInt(weatherInfo.lastTimestamp) > 900000) {
      weatherInfo.lastTimestamp = cur.toString();
      console.log("updated weather");
      retrieveWeather.running = true;
      weatherJson.reload();
    }
    const data = JSON.parse(weatherJson.text().trim());
    weatherInfo.icon = root.getIcon(data.weather[0].icon);
    weatherInfo.temperature = `${Math.round(parseInt(data.main.temp) - 273.15)}°C`;
    weatherInfo.city = data.name;
    weatherInfo.weatherDesc = data.weather[0].description;
  }
}
