package com.enerren.unilever.trucinspection

//import android.app.*
//import android.content.Intent
//import android.os.IBinder
import android.widget.Toast

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class BackNotife : Service() {

//    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
//        onTaskRemoved(intent)
//        Toast.makeText(
//            applicationContext, "This is a Service running in Background",
//            Toast.LENGTH_SHORT
//        ).show()
//        return START_STICKY
//    }
//    override fun onBind(intent: Intent): IBinder? {
//        // TODO: Return the communication channel to the service.
//        throw UnsupportedOperationException("Not yet implemented")
//    }
//    override fun onTaskRemoved(rootIntent: Intent) {
//        val restartServiceIntent = Intent(applicationContext, this.javaClass)
//        restartServiceIntent.setPackage(packageName)
//        startService(restartServiceIntent)
//        super.onTaskRemoved(rootIntent)
//    }

    private val CHANNEL_ID = "ForegroundService Kotlin"
    companion object {
        fun startService(context: Context, message: String) {
            val startIntent = Intent(context, BackNotife::class.java)
            startIntent.putExtra("inputExtra", message)
            ContextCompat.startForegroundService(context, startIntent)
        }
        fun stopService(context: Context) {
            val stopIntent = Intent(context, BackNotife::class.java)
            context.stopService(stopIntent)
        }
    }
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        //do heavy work on a background thread
        val input = intent?.getStringExtra("inputExtra")

        createNotificationChannel()
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0, notificationIntent, 0
        )
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Foreground Service Kotlin Example")
            .setContentText(input)
            .setSmallIcon(R.drawable.ic_stat_onesignal_default)
            .setContentIntent(pendingIntent)
            .build()
        startForeground(1, notification)
        //stopSelf();
        return START_NOT_STICKY
    }
    override fun onBind(intent: Intent): IBinder? {
        return null
    }
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(CHANNEL_ID, "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT)
            val manager = getSystemService(NotificationManager::class.java)
            manager!!.createNotificationChannel(serviceChannel)
        }
    }
}