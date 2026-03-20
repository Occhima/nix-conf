pragma Singleton

import QtQuick

QtObject {
    function clamp01(x) {
        return Math.max(0, Math.min(1, x))
    }

    function safeString(value, fallback) {
        if (value === undefined || value === null)
            return fallback
        const text = String(value).trim()
        return text.length ? text : fallback
    }

    function safeUrl(value) {
        if (value === undefined || value === null)
            return ""
        const text = String(value).trim()
        return text.length ? text : ""
    }

    function mediaTimeStr(value) {
        if (value === undefined || value === null || value < 0)
            return "--:--"

        const total = Math.floor(value)
        const mins = Math.floor(total / 60)
        const secs = String(total % 60).padStart(2, "0")
        return `${mins}:${secs}`
    }

    function weatherIcon(desc) {
        const text = safeString(desc, "").toLowerCase()

        if (text.includes("thunder"))
            return "\u26c8"
        if (text.includes("snow"))
            return "\u2744"
        if (text.includes("rain") || text.includes("drizzle"))
            return "\u2614"
        if (text.includes("cloud") || text.includes("overcast") || text.includes("mist"))
            return "\u2601"
        if (text.includes("clear") || text.includes("sun"))
            return "\u263c"

        return "\u263c"
    }

    function trim(x) {
        return (x ?? "").toString().trim()
    }
}
