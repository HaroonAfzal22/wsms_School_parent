
-keep class us.zoom.**{*;}
-keep class com.zipow.**{*;}
-keep class us.zipow.**{*;}
-keep class org.webrtc.**{*;}
-keep class us.google.protobuf.**{*;}
-keep class com.google.crypto.tink.**{*;}
-keep class androidx.security.crypto.**{*;}



-keep class com.facebook.jni.** { *; }

# WebRTC

-keep class org.webrtc.** { *; }
-dontwarn org.chromium.build.BuildHooksAndroid

# Jisti Meet SDK

-keep class org.jitsi.meet.** { *; }
-keep class org.jitsi.meet.sdk.** { *; }

# We added the following when we switched minifyEnabled on. Probably because we
# ran the app and hit problems...

-keep class com.facebook.react.bridge.CatalystInstanceImpl* { *; }
-keep class com.facebook.react.bridge.ExecutorToken* { *; }
-keep class com.facebook.react.bridge.JavaScriptExecutor* { *; }
-keep class com.facebook.react.bridge.ModuleRegistryHolder* { *; }
-keep class com.facebook.react.bridge.ReadableType* { *; }
-keep class com.facebook.react.bridge.queue.NativeRunnable* { *; }
-keep class com.facebook.react.devsupport.** { *; }

-dontwarn com.facebook.react.devsupport.**
-dontwarn com.google.appengine.**
-dontwarn com.squareup.okhttp.**
-dontwarn javax.servlet.**

# ^^^ We added the above when we switched minifyEnabled on.

# Rule to avoid build errors related to SVGs.
-keep public class com.horcrux.svg.** {*;}