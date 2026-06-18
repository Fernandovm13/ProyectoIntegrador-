# ProGuard rules for the Android application.
# By default, R8 is enabled automatically when isMinifyEnabled is true.

# Preserve Flutter engine classes from being obfuscated/shrunk
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }

# General optimizations
-dontwarn okhttp3.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-keepattributes Signature,InnerClasses,AnnotationDefault,EnclosingMethod

# Print mapping file to locate obfuscated symbols
-printmapping mapping.txt

# Suppress warnings from missing Play Core classes in R8
-dontwarn com.google.android.play.core.**
