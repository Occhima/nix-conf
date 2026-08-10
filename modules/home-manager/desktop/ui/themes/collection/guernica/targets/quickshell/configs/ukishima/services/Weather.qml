pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "root:/data" as Data

Singleton {
    id: root

    property string temperature: "--°"
    property string description: "Weather"
    property string city: "Local"
    property string humidity: "--%"
    property var forecast: []
    readonly property string glyph: glyphFor(description)

    function glyphFor(description): string {
        const value = String(description).toLowerCase()
        if (value.includes("snow") || value.includes("sleet")) return "snow"
        if (value.includes("rain") || value.includes("drizzle") || value.includes("thunder")) return "rain"
        if (value.includes("cloud") || value.includes("overcast") || value.includes("mist") || value.includes("fog")) return "cloud"
        return "sun"
    }

    function symbolFor(description): string {
        const value = String(description).toLowerCase()
        if (value.includes("snow") || value.includes("sleet")) return "❄"
        if (value.includes("rain") || value.includes("drizzle")) return "☂"
        if (value.includes("thunder")) return "ϟ"
        if (value.includes("cloud") || value.includes("overcast")) return "☁"
        if (value.includes("mist") || value.includes("fog")) return "≋"
        return "☀"
    }

    function update(): void {
        request.running = true
    }

    Process {
        id: request
        command: ["curl", "-Lsf", "https://wttr.in/?format=j1"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const payload = JSON.parse(text)
                    const current = (payload.current_condition ?? [])[0]
                    const area = (payload.nearest_area ?? [])[0]
                    if (current) {
                        root.temperature = String(current.temp_C ?? "--") + "°"
                        root.description = (current.weatherDesc ?? [])[0]?.value ?? "Weather"
                        root.humidity = String(current.humidity ?? "--") + "%"
                    }
                    root.city = (area?.areaName ?? [])[0]?.value ?? root.city
                    root.forecast = (payload.weather ?? []).slice(0, 5).map(day => {
                        const hours = day.hourly ?? []
                        const noonDescription = ((hours[4]?.weatherDesc ?? [])[0])?.value
                        const firstDescription = ((hours[0]?.weatherDesc ?? [])[0])?.value
                        const description = noonDescription
                            ?? firstDescription
                            ?? "Clear"
                        return {
                            date: day.date ?? "",
                            symbol: root.symbolFor(description),
                            low: String(day.mintempC ?? "--") + "°",
                            high: String(day.maxtempC ?? "--") + "°"
                        }
                    })
                } catch (error) {
                    console.warn("Unable to parse wttr.in response:", error)
                }
            }
        }
    }

    Timer {
        interval: 1800000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }
}
