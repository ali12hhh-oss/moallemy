plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.daleel.child"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.daleel.child"
        minSdk = 21
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

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}

// Flutter 3.47 + the modern Android Gradle Plugin DSL can leave the
// generated APK/AAB under android/app/build instead of copying it to the
// root build directory where the Flutter CLI expects to find it.
// Copy the release artifacts explicitly after Gradle finishes assembling them.
val flutterApkOutput = rootProject.layout.projectDirectory.dir("../build/app/outputs/flutter-apk")
val flutterAabOutput = rootProject.layout.projectDirectory.dir("../build/app/outputs/bundle/release")

tasks.register<Copy>("copyReleaseApkToFlutterOutput") {
    from(layout.buildDirectory.dir("outputs/apk/release"))
    include("app-release.apk")
    into(flutterApkOutput)
}

tasks.register<Copy>("copyReleaseAabToFlutterOutput") {
    from(layout.buildDirectory.dir("outputs/bundle/release"))
    include("app-release.aab")
    into(flutterAabOutput)
}

tasks.named("assembleRelease") {
    finalizedBy("copyReleaseApkToFlutterOutput")
}

tasks.named("bundleRelease") {
    finalizedBy("copyReleaseAabToFlutterOutput")
}
