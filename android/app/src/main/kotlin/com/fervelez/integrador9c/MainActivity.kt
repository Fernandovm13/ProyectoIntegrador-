package com.fervelez.integrador9c

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "fake_gps_detector"
    private var pendingResult: MethodChannel.Result? = null
    private val PERMISSION_REQUEST_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "isFakeGpsEnabled") {
                pendingResult = result
                if (hasLocationPermission()) {
                    checkMockLocationAndReturn()
                } else {
                    requestLocationPermission()
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun hasLocationPermission(): Boolean {
        val fineLocation = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        )
        val coarseLocation = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )
        return fineLocation == PackageManager.PERMISSION_GRANTED ||
                coarseLocation == PackageManager.PERMISSION_GRANTED
    }

    private fun requestLocationPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ),
            PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                checkMockLocationAndReturn()
            } else {
                // Si el permiso es denegado, bloqueamos el acceso
                pendingResult?.success(true)
                pendingResult = null
            }
        }
    }

    private fun checkMockLocationAndReturn() {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        val isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
        val isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)

        if (!isGpsEnabled && !isNetworkEnabled) {
            // Si la ubicación está apagada en el sistema, bloqueamos por seguridad
            pendingResult?.success(true)
            pendingResult = null
            return
        }

        // 1. Revisar última ubicación conocida
        var lastKnownMocked = false
        val providers = locationManager.getProviders(true)
        for (provider in providers) {
            try {
                val loc = locationManager.getLastKnownLocation(provider)
                if (loc != null && isLocationMocked(loc)) {
                    lastKnownMocked = true
                    break
                }
            } catch (e: SecurityException) {
                // Ignorar y probar otro proveedor
            }
        }

        if (lastKnownMocked) {
            pendingResult?.success(true)
            pendingResult = null
            return
        }

        // 2. Solicitar actualización rápida de ubicación si no se detectó en la última conocida
        val listener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                val isMocked = isLocationMocked(location)
                locationManager.removeUpdates(this)
                if (pendingResult != null) {
                    pendingResult?.success(isMocked)
                    pendingResult = null
                }
            }
            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            override fun onProviderEnabled(provider: String) {}
            override fun onProviderDisabled(provider: String) {}
        }

        try {
            val provider = if (isGpsEnabled) {
                LocationManager.GPS_PROVIDER
            } else {
                LocationManager.NETWORK_PROVIDER
            }

            locationManager.requestLocationUpdates(provider, 0L, 0f, listener)

            // Timeout de 3 segundos para no congelar la pantalla de inicio si tarda demasiado
            Handler(Looper.getMainLooper()).postDelayed({
                locationManager.removeUpdates(listener)
                if (pendingResult != null) {
                    pendingResult?.success(false)
                    pendingResult = null
                }
            }, 3000)

        } catch (e: SecurityException) {
            pendingResult?.success(true)
            pendingResult = null
        }
    }

    private fun isLocationMocked(location: Location): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            location.isMock
        } else {
            @Suppress("DEPRECATION")
            location.isFromMockProvider
        }
    }
}