plugins {
    id("com.android.application")
    id("kotlin-android")
    // This is the correct way to add the Google Services plugin in Kotlin DSL
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.skydiary_skeleton"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.skydiary_skeleton"
        // Firebase requires at least minSdk 21
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}
