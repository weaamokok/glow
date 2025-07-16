package com.example.glow

import android.appwidget.AppWidgetProvider
import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import android.content.Intent
import android.app.PendingIntent
import android.content.ComponentName

class MyWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_widget)

            views.setTextViewText(R.id.widget_title, prefs.getString("widgetTitle", "No Title"))
            views.setTextViewText(R.id.widget_category, prefs.getString("widgetCategory", ""))
            views.setTextViewText(R.id.widget_details, prefs.getString("widgetDetails", ""))
            views.setTextViewText(R.id.widget_priority, prefs.getString("widgetPriority", ""))

            val intent = Intent(context, CompleteActionReceiver::class.java).apply {
                action = "COMPLETE_ACTION_CLICKED"
            }
            val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.button_complete_action, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
