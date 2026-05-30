package ca.karavi.ipnote.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
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
        val needsFetch = WidgetIpFetcher.shouldFetch(widgetData)
        val showLoading = widgetData.getString(KEY_IP_ADDRESS, null).orEmpty().trim().isEmpty() && needsFetch
        renderAll(context, appWidgetManager, appWidgetIds, widgetData, showLoading)

        if (!needsFetch) {
            return
        }

        val pendingResult = goAsync()
        Thread {
            try {
                WidgetIpFetcher.fetchAndPersist(context)
            } catch (error: Exception) {
                Log.e(TAG, "Background widget IP refresh failed", error)
            } finally {
                val latest = HomeWidgetPlugin.getData(context)
                renderAll(context, appWidgetManager, appWidgetIds, latest, showLoading = false)
                pendingResult.finish()
            }
        }.start()
    }

    private fun renderAll(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
        showLoading: Boolean,
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                val views = buildRemoteViews(context, widgetData, showLoading)
                appWidgetManager.updateAppWidget(widgetId, views)
            } catch (error: Exception) {
                Log.e(TAG, "Failed to update home widget $widgetId", error)
            }
        }
    }

    private fun buildRemoteViews(
        context: Context,
        widgetData: SharedPreferences,
        showLoading: Boolean,
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_ip_note)

        val ip = widgetData.getString(KEY_IP_ADDRESS, null)?.trim().orEmpty()
        val scope = widgetData.getString(KEY_IP_SCOPE, null)?.trim().orEmpty()
        val isIpv6 = widgetData.getBoolean(KEY_IS_IPV6, false)
        val location = widgetData.getString(KEY_LOCATION, null)?.trim().orEmpty()
        val updatedAt = widgetData.getString(KEY_UPDATED_AT, null)?.trim().orEmpty()

        if (ip.isEmpty()) {
            views.setTextViewText(
                R.id.widget_ip_address,
                if (showLoading) {
                    context.getString(R.string.widget_loading_ip)
                } else {
                    context.getString(R.string.widget_no_ip)
                },
            )
            views.setViewVisibility(R.id.widget_scope_chip, View.GONE)
            views.setViewVisibility(R.id.widget_location, View.GONE)
            views.setTextViewText(
                R.id.widget_updated_at,
                if (showLoading) {
                    context.getString(R.string.widget_fetching_status)
                } else {
                    context.getString(R.string.widget_tap_hint)
                },
            )
        } else {
            views.setTextViewText(R.id.widget_ip_address, ip)

            if (scope.isNotEmpty()) {
                val scopeLabel = if (isIpv6) "IPv6 · $scope" else "IPv4 · $scope"
                views.setTextViewText(R.id.widget_scope_chip, scopeLabel)
            } else {
                views.setTextViewText(
                    R.id.widget_scope_chip,
                    if (isIpv6) "IPv6" else "IPv4",
                )
            }
            views.setViewVisibility(R.id.widget_scope_chip, View.VISIBLE)

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

        val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

        return views
    }

    private fun formatUpdatedAt(context: Context, raw: String): String {
        if (raw.isEmpty()) {
            return context.getString(R.string.widget_updated_unknown)
        }

        return try {
            val instant = Instant.parse(raw)
            val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm", Locale.getDefault())
                .withZone(ZoneId.systemDefault())
            "${context.getString(R.string.widget_updated_prefix)} ${formatter.format(instant)}"
        } catch (_: Exception) {
            context.getString(R.string.widget_updated_unknown)
        }
    }

    companion object {
        private const val TAG = "IpNoteHomeWidget"
        private const val KEY_IP_ADDRESS = "widget_ip_address"
        private const val KEY_IP_SCOPE = "widget_ip_scope"
        private const val KEY_IS_IPV6 = "widget_ip_is_ipv6"
        private const val KEY_LOCATION = "widget_ip_location"
        private const val KEY_UPDATED_AT = "widget_ip_updated_at"
    }
}
