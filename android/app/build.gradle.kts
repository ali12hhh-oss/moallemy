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

        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
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
            // Release is intentionally unsigned until a private keystore is supplied.
            // GitHub Actions can build an unsigned release APK safely.
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

// Modern AGP plugin DSL can leave release artifacts inside android/app/build.
// Flutter CLI expects them under the project-root build/ directory, so copy
// both release artifacts after Gradle finishes.
val flutterProjectRoot = rootProject.projectDir.parentFile
val flutterApkOutputDir = File(flutterProjectRoot, "build/app/outputs/flutter-apk")
val flutterBundleOutputDir = File(flutterProjectRoot, "build/app/outputs/bundle/release")

val copyReleaseApkForFlutter = tasks.register<Copy>("copyReleaseApkForFlutter") {
    from(layout.buildDirectory.dir("outputs/apk/release"))
    include("app-release.apk")
    into(flutterApkOutputDir)
}

tasks.named("assembleRelease") {
    finalizedBy(copyReleaseApkForFlutter)
}

val copyReleaseAabForFlutter = tasks.register<Copy>("copyReleaseAabForFlutter") {
    from(layout.buildDirectory.dir("outputs/bundle/release"))
    include("app-release.aab")
    into(flutterBundleOutputDir)
}

tasks.named("bundleRelease") {
    finalizedBy(copyReleaseAabForFlutter)
}
