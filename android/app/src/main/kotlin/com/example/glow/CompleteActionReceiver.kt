package com.example.glow

import android.widget.RemoteViews

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.os.Handler
import android.os.Looper
import android.util.Log

class CompleteActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == "COMPLETE_ACTION_CLICKED") {
            Handler(Looper.getMainLooper()).post {
                Toast.makeText(context, "Action marked complete!", Toast.LENGTH_SHORT).show()
            }

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val provider = ComponentName(context, MyWidgetProvider::class.java)
            val ids = appWidgetManager.getAppWidgetIds(provider)

            for (id in ids) {
                val views = RemoteViews(context.packageName, R.layout.home_widget)
                val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                val editor = prefs.edit()
                val isCompleted = prefs.getBoolean("widgetIsCompleted", false)

                try {
                    if (isCompleted) {
                        views.setImageViewResource(R.id.button_complete_action, R.drawable.ic_check)
                    } else {
                        views.setImageViewResource(R.id.button_complete_action, 0)
                    }
                    appWidgetManager.updateAppWidget(id, views)
                    editor.putBoolean("widgetIsCompleted", !isCompleted)
                    editor.apply()
                } catch (e: Exception) {
                    Log.e("WidgetError", "Failed to update widget: ${e.message}")
                }


            }
        }
    }
}
