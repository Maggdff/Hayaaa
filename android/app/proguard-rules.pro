-keep class **.zego.** { *; }
-keep class **.**.zego_zpns.** { *; }
# Disable optional manufacturer push integrations
-dontwarn com.heytap.msp.push.**
-dontwarn com.huawei.hms.**
-dontwarn com.vivo.push.**
-dontwarn com.xiaomi.mipush.**
