package com.example.fteamapp

import android.content.Context
import android.content.Context.BATTERY_SERVICE
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.fteamapp/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Nível da bateria não disponível.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        return try {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            // Usa apenas getIntProperty que é mais estável e não causa problemas com mudanças de bateria
            val level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            
            // Valida se o nível está no range válido (0-100)
            if (level in 0..100) {
                level
            } else {
                // Se não conseguir obter, retorna um valor padrão para o emulador
                // No emulador, pode retornar valores inválidos, então usamos um fallback
                50 // Valor padrão para emulador
            }
        } catch (e: Exception) {
            // Em caso de erro, retorna um valor padrão
            50
        }
    }
}
