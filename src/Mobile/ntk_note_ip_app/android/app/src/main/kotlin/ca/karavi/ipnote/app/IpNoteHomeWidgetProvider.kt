package ca.karavi.ipnote.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale

class IpNoteHomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = buildRemoteViews(context, widgetData)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun buildRemoteViews(
        context: Context,
        widgetData: SharedPreferences,
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_ip_note)

        val ip = widgetData.getString(KEY_IP_ADDRESS, null)?.trim().orEmpty()
        val scope = widgetData.getString(KEY_IP_SCOPE, null)?.trim().orEmpty()
        val isIpv6 = widgetData.getBoolean(KEY_IS_IPV6, false)
        val location = widgetData.getString(KEY_LOCATION, null)?.trim().orEmpty()
        val updatedAt = widgetData.getString(KEY_UPDATED_AT, null)?.trim().orEmpty()

        if (ip.isEmpty()) {
            views.setTextViewText(R.id.widget_ip_address, context.getString(R.string.widget_no_ip))
            views.setViewVisibility(R.id.widget_scope_chip, View.GONE)
            views.setViewVisibility(R.id.widget_location, View.GONE)
            views.setTextViewText(R.id.widget_updated_at, context.getString(R.string.widget_tap_hint))
        } else {
            views.setTextViewText(R.id.widget_ip_address, ip)

            if (scope.isNotEmpty()) {
                val scopeLabel = if (isIpv6) "IPv6 · $scope" else "IPv4 · $scope"
                views.setTextViewText(R.id.widget_scope_chip, scopeLabel)
                views.setViewVisibility(R.id.widget_scope_chip, View.VISIBLE)
            } else {
                val versionLabel = if (isIpv6) "IPv6" else "IPv4"
                views.setTextViewText(R.id.widget_scope_chip, versionLabel)
                views.setViewVisibility(R.id.widget_scope_chip, View.VISIBLE)
            }

            if (location.isNotEmpty()) {
                views.setTextViewText(R.id.widget_location, location)
                views.setViewVisibility(R.id.widget_location, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_location, View.GONE)
            }

            views.setTextViewText(
                R.id.widget_updated_at,
                formatUpdatedAt(context, updatedAt),
            )
        }

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

        return views
    }

    private fun formatUpdatedAt(context: Context, raw: String): String {
        if (raw.isEmpty()) {
            return context.getString(R.string.widget_tap_hint)
        }

        return try {
            val instant = Instant.parse(raw)
            val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm", Locale.getDefault())
                .withZone(ZoneId.systemDefault())
            "${context.getString(R.string.widget_tap_hint)} · ${formatter.format(instant)}"
        } catch (_: Exception) {
            context.getString(R.string.widget_tap_hint)
        }
    }

    companion object {
        private const val KEY_IP_ADDRESS = "widget_ip_address"
        private const val KEY_IP_SCOPE = "widget_ip_scope"
        private const val KEY_IS_IPV6 = "widget_ip_is_ipv6"
        private const val KEY_LOCATION = "widget_ip_location"
        private const val KEY_UPDATED_AT = "widget_ip_updated_at"
    }
}
