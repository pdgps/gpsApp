package com.example.gpsapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.location.GnssMeasurementsEvent
import android.location.LocationManager
import android.os.Handler
import android.os.Looper
import android.location.GnssClock

class MainActivity : FlutterActivity() {
    private val CHANNEL = "gnss_plugin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getGnssTime") {
                getGnssTime(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getGnssTime(result: MethodChannel.Result) {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        val gnssListener = object : GnssMeasurementsEvent.Callback() {
            override fun onGnssMeasurementsReceived(event: GnssMeasurementsEvent) {

                val gnssClock: GnssClock = event.clock
                val timeNanos: Long = gnssClock.timeNanos
                val fullBiasNanos: Long? = gnssClock.fullBiasNanos

                if (fullBiasNanos == null || fullBiasNanos == 0L){
                    result.error("UNAVAILABLE", "Bias no disponible", null)
                    return
                }

                val gnssTimeMillis: Long = (timeNanos - fullBiasNanos)/1_000_000L

                if (gnssTimeMillis > 0) {
                    result.success(gnssTimeMillis)
                }else{
                    result.error("UNAVAILABLE","Timestamp no disponible", null)
                }
                locationManager.unregisterGnssMeasurementsCallback(this)

            }
        }

        val handler = Handler(Looper.getMainLooper())
        locationManager.registerGnssMeasurementsCallback(gnssListener, handler)
    }
}