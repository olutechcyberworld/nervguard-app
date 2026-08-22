tree

.
├── analysis_options.yaml
├── android
│   ├── app
│   │   ├── build.gradle.kts
│   │   └── src
│   │       ├── debug
│   │       │   └── AndroidManifest.xml
│   │       ├── main
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── java
│   │       │   │   └── io
│   │       │   │       └── flutter
│   │       │   │           └── plugins
│   │       │   │               └── GeneratedPluginRegistrant.java
│   │       │   ├── kotlin
│   │       │   │   └── com
│   │       │   │       └── olutech
│   │       │   │           └── nervguard
│   │       │   │               └── MainActivity.kt
│   │       │   └── res
│   │       │       ├── drawable
│   │       │       │   └── launch_background.xml
│   │       │       ├── drawable-v21
│   │       │       │   └── launch_background.xml
│   │       │       ├── mipmap-hdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-mdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── values
│   │       │       │   ├── strings.xml
│   │       │       │   └── styles.xml
│   │       │       └── values-night
│   │       │           └── styles.xml
│   │       └── profile
│   │           └── AndroidManifest.xml
│   ├── build.gradle.kts
│   ├── gradle
│   │   └── wrapper
│   │       ├── gradle-wrapper.jar
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   ├── local.properties
│   ├── nervguard_android.iml
│   └── settings.gradle.kts
├── assets
│   ├── app_icon
│   │   └── app_icon.png
│   └── brand
│       └── olutech_logo.png
├── build
│   └── 889b4bb774bae25ba689b7b99513fc86
│       ├── _composite.stamp
│       ├── gen_dart_plugin_registrant.stamp
│       └── gen_localizations.stamp
├── ios
│   ├── Flutter
│   │   ├── AppFrameworkInfo.plist
│   │   ├── Debug.xcconfig
│   │   ├── ephemeral
│   │   │   ├── flutter_lldb_helper.py
│   │   │   └── flutter_lldbinit
│   │   ├── flutter_export_environment.sh
│   │   ├── Generated.xcconfig
│   │   └── Release.xcconfig
│   ├── Runner
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   ├── AppIcon.appiconset
│   │   │   │   ├── Contents.json
│   │   │   │   ├── Icon-App-1024x1024@1x.png
│   │   │   │   ├── Icon-App-20x20@1x.png
│   │   │   │   ├── Icon-App-20x20@2x.png
│   │   │   │   ├── Icon-App-20x20@3x.png
│   │   │   │   ├── Icon-App-29x29@1x.png
│   │   │   │   ├── Icon-App-29x29@2x.png
│   │   │   │   ├── Icon-App-29x29@3x.png
│   │   │   │   ├── Icon-App-40x40@1x.png
│   │   │   │   ├── Icon-App-40x40@2x.png
│   │   │   │   ├── Icon-App-40x40@3x.png
│   │   │   │   ├── Icon-App-60x60@2x.png
│   │   │   │   ├── Icon-App-60x60@3x.png
│   │   │   │   ├── Icon-App-76x76@1x.png
│   │   │   │   ├── Icon-App-76x76@2x.png
│   │   │   │   └── Icon-App-83.5x83.5@2x.png
│   │   │   └── LaunchImage.imageset
│   │   │       ├── Contents.json
│   │   │       ├── LaunchImage@2x.png
│   │   │       ├── LaunchImage@3x.png
│   │   │       ├── LaunchImage.png
│   │   │       └── README.md
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   ├── GeneratedPluginRegistrant.h
│   │   ├── GeneratedPluginRegistrant.m
│   │   ├── Info.plist
│   │   ├── Runner-Bridging-Header.h
│   │   └── SceneDelegate.swift
│   ├── RunnerTests
│   │   └── RunnerTests.swift
│   ├── Runner.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   │   ├── contents.xcworkspacedata
│   │   │   └── xcshareddata
│   │   │       ├── IDEWorkspaceChecks.plist
│   │   │       └── WorkspaceSettings.xcsettings
│   │   └── xcshareddata
│   │       └── xcschemes
│   │           └── Runner.xcscheme
│   └── Runner.xcworkspace
│       ├── contents.xcworkspacedata
│       └── xcshareddata
│           ├── IDEWorkspaceChecks.plist
│           └── WorkspaceSettings.xcsettings
├── lib
│   ├── app.dart
│   ├── background
│   │   ├── background_intervention_core.dart
│   │   ├── ble_payload_parsers.dart
│   │   └── foreground_task_handler.dart
│   ├── core
│   │   ├── config
│   │   │   └── app_config.dart
│   │   ├── constants
│   │   │   ├── app_constants.dart
│   │   │   └── ble_constants.dart
│   │   ├── theme
│   │   │   └── app_theme.dart
│   │   └── widgets
│   │       └── glass_widgets.dart
│   ├── data
│   │   ├── local
│   │   │   ├── dao
│   │   │   │   ├── calibration_stats_dao.dart
│   │   │   │   ├── calibration_stats_dao.g.dart
│   │   │   │   ├── intervention_log_dao.dart
│   │   │   │   ├── intervention_log_dao.g.dart
│   │   │   │   ├── monitoring_session_dao.dart
│   │   │   │   ├── monitoring_session_dao.g.dart
│   │   │   │   ├── preference_weights_dao.dart
│   │   │   │   ├── preference_weights_dao.g.dart
│   │   │   │   ├── stress_event_dao.dart
│   │   │   │   └── stress_event_dao.g.dart
│   │   │   └── database
│   │   │       ├── app_database.dart
│   │   │       └── app_database.g.dart
│   │   ├── preferences
│   │   │   └── app_preferences.dart
│   │   └── remote
│   │       └── supabase_sync_client.dart
│   ├── domain
│   │   ├── models
│   │   │   ├── ble_message.dart
│   │   │   ├── calibration_stats.dart
│   │   │   ├── correlated_window.dart
│   │   │   ├── device_state.dart
│   │   │   ├── feature_vector.dart
│   │   │   ├── inference_output.dart
│   │   │   ├── intervention_overlay_state.dart
│   │   │   ├── intervention_pool.dart
│   │   │   └── main_message.dart
│   │   └── services
│   │       ├── ble_service.dart
│   │       ├── fake_ble_service.dart
│   │       ├── notification_service.dart
│   │       ├── real_ble_service.dart
│   │       └── sync_service.dart
│   ├── main.dart
│   └── presentation
│       ├── providers
│       │   ├── ble_providers.dart
│       │   ├── calibration_stats_provider.dart
│       │   ├── device_state_provider.dart
│       │   ├── foreground_intervention_engine_provider.dart
│       │   ├── inference_consumer_provider.dart
│       │   ├── inference_providers.dart
│       │   ├── infrastructure_providers.dart
│       │   ├── intervention_pool_provider.dart
│       │   ├── onboarding_provider.dart
│       │   └── warmup_reset_providers.dart
│       ├── router
│       │   └── app_router.dart
│       └── screens
│           ├── dashboard
│           │   └── dashboard_screen.dart
│           ├── history
│           │   └── history_screen.dart
│           ├── intervention
│           ├── onboarding
│           │   ├── account_screen.dart
│           │   ├── calibration_screen.dart
│           │   ├── device_scan_screen.dart
│           │   ├── intervention_pool_screen.dart
│           │   ├── permissions_screen.dart
│           │   └── welcome_screen.dart
│           ├── settings
│           │   ├── about_screen.dart
│           │   ├── device_pairing_screen.dart
│           │   └── settings_screen.dart
│           ├── shell
│           │   └── app_shell.dart
│           └── splash
│               └── splash_screen.dart
├── linux
│   ├── CMakeLists.txt
│   ├── flutter
│   │   ├── CMakeLists.txt
│   │   ├── ephemeral
│   │   ├── generated_plugin_registrant.cc
│   │   ├── generated_plugin_registrant.h
│   │   └── generated_plugins.cmake
│   └── runner
│       ├── CMakeLists.txt
│       ├── main.cc
│       ├── my_application.cc
│       └── my_application.h
├── macos
│   ├── Flutter
│   │   ├── ephemeral
│   │   │   ├── flutter_export_environment.sh
│   │   │   └── Flutter-Generated.xcconfig
│   │   ├── Flutter-Debug.xcconfig
│   │   ├── Flutter-Release.xcconfig
│   │   └── GeneratedPluginRegistrant.swift
│   ├── Runner
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   └── AppIcon.appiconset
│   │   │       ├── app_icon_1024.png
│   │   │       ├── app_icon_128.png
│   │   │       ├── app_icon_16.png
│   │   │       ├── app_icon_256.png
│   │   │       ├── app_icon_32.png
│   │   │       ├── app_icon_512.png
│   │   │       ├── app_icon_64.png
│   │   │       └── Contents.json
│   │   ├── Base.lproj
│   │   │   └── MainMenu.xib
│   │   ├── Configs
│   │   │   ├── AppInfo.xcconfig
│   │   │   ├── Debug.xcconfig
│   │   │   ├── Release.xcconfig
│   │   │   └── Warnings.xcconfig
│   │   ├── DebugProfile.entitlements
│   │   ├── Info.plist
│   │   ├── MainFlutterWindow.swift
│   │   └── Release.entitlements
│   ├── RunnerTests
│   │   └── RunnerTests.swift
│   ├── Runner.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   │   └── xcshareddata
│   │   │       └── IDEWorkspaceChecks.plist
│   │   └── xcshareddata
│   │       └── xcschemes
│   │           └── Runner.xcscheme
│   └── Runner.xcworkspace
│       ├── contents.xcworkspacedata
│       └── xcshareddata
│           └── IDEWorkspaceChecks.plist
├── nervguard.iml
├── projectDir.md
├── pubspec.lock
├── pubspec.yaml
├── README.md
├── test
│   ├── dao
│   │   └── intervention_log_dao_test.dart
│   ├── parsers
│   │   └── ble_payload_parsers_test.dart
│   ├── preferences
│   │   └── app_preferences_test.dart
│   ├── providers
│   │   ├── calibration_stats_provider_test.dart
│   │   ├── device_state_notifier_test.dart
│   │   ├── foreground_intervention_engine_provider_test.dart
│   │   ├── inference_consumer_provider_test.dart
│   │   ├── inference_providers_test.dart
│   │   ├── intervention_pool_provider_test.dart
│   │   └── warmup_reset_providers_test.dart
│   ├── services
│   │   └── sync_service_test.dart
│   └── widget_test.dart
├── web
│   ├── favicon.png
│   ├── icons
│   │   ├── Icon-192.png
│   │   ├── Icon-512.png
│   │   ├── Icon-maskable-192.png
│   │   └── Icon-maskable-512.png
│   ├── index.html
│   └── manifest.json
└── windows
    ├── CMakeLists.txt
    ├── flutter
    │   ├── CMakeLists.txt
    │   ├── ephemeral
    │   ├── generated_plugin_registrant.cc
    │   ├── generated_plugin_registrant.h
    │   └── generated_plugins.cmake
    └── runner
        ├── CMakeLists.txt
        ├── flutter_window.cpp
        ├── flutter_window.h
        ├── main.cpp
        ├── resource.h
        ├── resources
        │   └── app_icon.ico
        ├── runner.exe.manifest
        ├── Runner.rc
        ├── utils.cpp
        ├── utils.h
        ├── win32_window.cpp
        └── win32_window.h

108 directories, 217 files
