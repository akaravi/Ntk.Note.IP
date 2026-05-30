package ca.karavi.ipnote.app

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.time.Duration
import java.time.Instant

internal data class WidgetIpSnapshot(
    val address: String,
    val scope: String,
    val isIpv6: Boolean,
)

internal object WidgetIpFetcher {
    private const val TAG = "WidgetIpFetcher"
    private const val KEY_API_BASE_URL = "widget_api_base_url"
    private const val KEY_IP_ADDRESS = "widget_ip_address"
    private const val KEY_IP_SCOPE = "widget_ip_scope"
    private const val KEY_IS_IPV6 = "widget_ip_is_ipv6"
    private const val KEY_LOCATION = "widget_ip_location"
    private const val KEY_UPDATED_AT = "widget_ip_updated_at"
    private const val STALE_MINUTES = 30L
    private const val CONNECT_TIMEOUT_MS = 15_000
    private const val READ_TIMEOUT_MS = 15_000

    fun shouldFetch(widgetData: SharedPreferences): Boolean {
        val ip = widgetData.getString(KEY_IP_ADDRESS, null)?.trim().orEmpty()
        if (ip.isEmpty()) {
            return true
        }

        val updatedAt = widgetData.getString(KEY_UPDATED_AT, null)?.trim().orEmpty()
        if (updatedAt.isEmpty()) {
            return true
        }

        return try {
            val age = Duration.between(Instant.parse(updatedAt), Instant.now())
            age.toMinutes() >= STALE_MINUTES
        } catch (_: Exception) {
            true
        }
    }

    fun fetchAndPersist(context: Context): Boolean {
        val widgetData = HomeWidgetPlugin.getData(context)
        if (!shouldFetch(widgetData)) {
            return false
        }

        val apiBaseUrl = resolveApiBaseUrl(context, widgetData)
        return try {
            val snapshot = fetchMyIp(apiBaseUrl)
            persist(context, snapshot)
            true
        } catch (error: Exception) {
            Log.e(TAG, "Failed to fetch widget IP from $apiBaseUrl", error)
            false
        }
    }

    private fun resolveApiBaseUrl(context: Context, widgetData: SharedPreferences): String {
        val fromWidget = widgetData.getString(KEY_API_BASE_URL, null)?.trim().orEmpty()
        if (fromWidget.isNotEmpty()) {
            return fromWidget.trimEnd('/')
        }

        return context.getString(R.string.widget_api_base_url).trimEnd('/')
    }

    private fun fetchMyIp(apiBaseUrl: String): WidgetIpSnapshot {
        val endpoint = "$apiBaseUrl/api/v1/IpLookup/GetMyIp"
        val body = httpGet(endpoint)
        val root = JSONObject(body)
        if (!root.optBoolean("isSuccess", false)) {
            val message = root.optString("errorMessage", "GetMyIp failed")
            throw IllegalStateException(message)
        }

        val data = root.optJSONObject("data")
            ?: throw IllegalStateException("GetMyIp returned no data")

        val address = data.optString("address").trim()
        if (address.isEmpty()) {
            throw IllegalStateException("GetMyIp returned empty address")
        }

        val scopeCode = data.opt("scope")
        val scope = mapScope(scopeCode)
        val isIpv6 = data.optBoolean("isIPv6", false)

        return WidgetIpSnapshot(
            address = address,
            scope = scope,
            isIpv6 = isIpv6,
        )
    }

    private fun mapScope(raw: Any?): String {
        val code = when (raw) {
            is Number -> raw.toInt()
            is String -> raw.toIntOrNull() ?: return raw
            else -> return ""
        }

        return when (code) {
            0 -> "Public"
            1 -> "Private"
            2 -> "Loopback"
            3 -> "LinkLocal"
            4 -> "UniqueLocal"
            5 -> "Reserved"
            6 -> "Cgnat"
            else -> ""
        }
    }

    private fun httpGet(url: String): String {
        val connection = (URL(url).openConnection() as HttpURLConnection).apply {
            requestMethod = "GET"
            connectTimeout = CONNECT_TIMEOUT_MS
            readTimeout = READ_TIMEOUT_MS
            setRequestProperty("Accept", "application/json")
        }

        try {
            val status = connection.responseCode
            val stream = if (status in 200..299) {
                connection.inputStream
            } else {
                connection.errorStream
            }

            val body = stream?.use { input ->
                BufferedReader(InputStreamReader(input)).use { it.readText() }
            }.orEmpty()

            if (status !in 200..299) {
                throw IllegalStateException("HTTP $status: $body")
            }

            if (body.isBlank()) {
                throw IllegalStateException("Empty HTTP response")
            }

            return body
        } finally {
            connection.disconnect()
        }
    }

    private fun persist(context: Context, snapshot: WidgetIpSnapshot) {
        HomeWidgetPlugin.getData(context).edit().apply {
            putString(KEY_IP_ADDRESS, snapshot.address)
            putString(KEY_IP_SCOPE, snapshot.scope)
            putBoolean(KEY_IS_IPV6, snapshot.isIpv6)
            putString(KEY_LOCATION, "")
            putString(KEY_UPDATED_AT, Instant.now().toString())
        }.commit()
    }
}
