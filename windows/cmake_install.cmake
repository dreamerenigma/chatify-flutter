# Install script for directory: D:/Programming/Languages/Dart/Projects/chatify/windows

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files/chatify")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/runner/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/agora_rtc_engine/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/audioplayers_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/bitsdojo_window_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/camera_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/cloud_firestore/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/connectivity_plus/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/emoji_picker_flutter/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/file_selector_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_auth/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_core/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_storage/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_webrtc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/local_auth_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_libs_windows_video/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_video/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/permission_handler_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/record_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/screen_retriever_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/share_plus/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/url_launcher_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/volume_controller/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/window_manager/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_local_notifications_windows/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/chatify.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE EXECUTABLE FILES "D:/Programming/Languages/Dart/Projects/chatify/windows/runner/Debug/chatify.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/chatify.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE EXECUTABLE FILES "D:/Programming/Languages/Dart/Projects/chatify/windows/runner/Profile/chatify.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/chatify.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE EXECUTABLE FILES "D:/Programming/Languages/Dart/Projects/chatify/windows/runner/Release/chatify.exe")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "C:/Program Files/chatify/data/icudtl.dat")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "C:/Program Files/chatify/data" TYPE FILE FILES "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/icudtl.dat")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "C:/Program Files/chatify/flutter_windows.dll")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE FILE FILES "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/flutter_windows.dll")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/agora_rtc_engine_plugin.dll;C:/Program Files/chatify/AgoraRtcWrapper.dll;C:/Program Files/chatify/agora_rtc_sdk.dll;C:/Program Files/chatify/glfw3.dll;C:/Program Files/chatify/libagora-fdkaac.dll;C:/Program Files/chatify/libagora-ffmpeg.dll;C:/Program Files/chatify/libagora-soundtouch.dll;C:/Program Files/chatify/libagora-wgc.dll;C:/Program Files/chatify/libagora_ai_echo_cancellation_extension.dll;C:/Program Files/chatify/libagora_ai_echo_cancellation_ll_extension.dll;C:/Program Files/chatify/libagora_ai_noise_suppression_extension.dll;C:/Program Files/chatify/libagora_ai_noise_suppression_ll_extension.dll;C:/Program Files/chatify/libagora_audio_beauty_extension.dll;C:/Program Files/chatify/libagora_clear_vision_extension.dll;C:/Program Files/chatify/libagora_content_inspect_extension.dll;C:/Program Files/chatify/libagora_face_capture_extension.dll;C:/Program Files/chatify/libagora_face_detection_extension.dll;C:/Program Files/chatify/libagora_lip_sync_extension.dll;C:/Program Files/chatify/libagora_screen_capture_extension.dll;C:/Program Files/chatify/libagora_segmentation_extension.dll;C:/Program Files/chatify/libagora_spatial_audio_extension.dll;C:/Program Files/chatify/libagora_video_av1_decoder_extension.dll;C:/Program Files/chatify/libagora_video_av1_encoder_extension.dll;C:/Program Files/chatify/libagora_video_decoder_extension.dll;C:/Program Files/chatify/libagora_video_encoder_extension.dll;C:/Program Files/chatify/libagora_video_quality_analyzer_extension.dll;C:/Program Files/chatify/libaosl.dll;C:/Program Files/chatify/video_dec.dll;C:/Program Files/chatify/video_enc.dll;C:/Program Files/chatify/audioplayers_windows_plugin.dll;C:/Program Files/chatify/bitsdojo_window_windows_plugin.lib;C:/Program Files/chatify/camera_windows_plugin.dll;C:/Program Files/chatify/cloud_firestore_plugin.lib;C:/Program Files/chatify/connectivity_plus_plugin.dll;C:/Program Files/chatify/emoji_picker_flutter_plugin.dll;C:/Program Files/chatify/file_selector_windows_plugin.dll;C:/Program Files/chatify/firebase_auth_plugin.lib;C:/Program Files/chatify/firebase_core_plugin.lib;C:/Program Files/chatify/firebase_storage_plugin.lib;C:/Program Files/chatify/flutter_webrtc_plugin.dll;C:/Program Files/chatify/libwebrtc.dll;C:/Program Files/chatify/iris_method_channel_plugin.dll;C:/Program Files/chatify/iris_method_channel.dll;C:/Program Files/chatify/local_auth_windows_plugin.dll;C:/Program Files/chatify/media_kit_libs_windows_video_plugin.dll;C:/Program Files/chatify/libmpv-2.dll;C:/Program Files/chatify/d3dcompiler_47.dll;C:/Program Files/chatify/libEGL.dll;C:/Program Files/chatify/libGLESv2.dll;C:/Program Files/chatify/vk_swiftshader.dll;C:/Program Files/chatify/vulkan-1.dll;C:/Program Files/chatify/zlib.dll;C:/Program Files/chatify/media_kit_video_plugin.dll;C:/Program Files/chatify/permission_handler_windows_plugin.dll;C:/Program Files/chatify/record_windows_plugin.dll;C:/Program Files/chatify/screen_retriever_windows_plugin.dll;C:/Program Files/chatify/share_plus_plugin.dll;C:/Program Files/chatify/url_launcher_windows_plugin.dll;C:/Program Files/chatify/volume_controller_plugin.dll;C:/Program Files/chatify/window_manager_plugin.dll;C:/Program Files/chatify/flutter_local_notifications_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE FILE FILES
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/agora_rtc_engine/Debug/agora_rtc_engine_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/iris/lib/iris_4.5.2-build.1_DCG_Windows/x64/Release/AgoraRtcWrapper.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/agora_rtc_sdk.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/glfw3.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-fdkaac.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-ffmpeg.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-soundtouch.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-wgc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_echo_cancellation_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_echo_cancellation_ll_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_noise_suppression_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_noise_suppression_ll_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_audio_beauty_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_clear_vision_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_content_inspect_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_face_capture_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_face_detection_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_lip_sync_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_screen_capture_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_segmentation_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_spatial_audio_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_av1_decoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_av1_encoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_decoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_encoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_quality_analyzer_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libaosl.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/video_dec.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/video_enc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/audioplayers_windows/Debug/audioplayers_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/bitsdojo_window_windows/Debug/bitsdojo_window_windows_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/camera_windows/Debug/camera_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/cloud_firestore/Debug/cloud_firestore_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/connectivity_plus/Debug/connectivity_plus_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/emoji_picker_flutter/Debug/emoji_picker_flutter_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/file_selector_windows/Debug/file_selector_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_auth/Debug/firebase_auth_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_core/Debug/firebase_core_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_storage/Debug/firebase_storage_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_webrtc/Debug/flutter_webrtc_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/flutter_webrtc/windows/../third_party/libwebrtc/lib/win64/libwebrtc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/Debug/iris_method_channel_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/shared/Debug/iris_method_channel.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/local_auth_windows/Debug/local_auth_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_libs_windows_video/Debug/media_kit_libs_windows_video_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/libmpv/libmpv-2.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/d3dcompiler_47.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/libEGL.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/libGLESv2.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/vk_swiftshader.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/vulkan-1.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/zlib.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_video/Debug/media_kit_video_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/permission_handler_windows/Debug/permission_handler_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/record_windows/Debug/record_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/screen_retriever_windows/Debug/screen_retriever_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/share_plus/Debug/share_plus_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/url_launcher_windows/Debug/url_launcher_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/volume_controller/Debug/volume_controller_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/window_manager/Debug/window_manager_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_local_notifications_windows/shared/Debug/flutter_local_notifications_windows.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/agora_rtc_engine_plugin.dll;C:/Program Files/chatify/AgoraRtcWrapper.dll;C:/Program Files/chatify/agora_rtc_sdk.dll;C:/Program Files/chatify/glfw3.dll;C:/Program Files/chatify/libagora-fdkaac.dll;C:/Program Files/chatify/libagora-ffmpeg.dll;C:/Program Files/chatify/libagora-soundtouch.dll;C:/Program Files/chatify/libagora-wgc.dll;C:/Program Files/chatify/libagora_ai_echo_cancellation_extension.dll;C:/Program Files/chatify/libagora_ai_echo_cancellation_ll_extension.dll;C:/Program Files/chatify/libagora_ai_noise_suppression_extension.dll;C:/Program Files/chatify/libagora_ai_noise_suppression_ll_extension.dll;C:/Program Files/chatify/libagora_audio_beauty_extension.dll;C:/Program Files/chatify/libagora_clear_vision_extension.dll;C:/Program Files/chatify/libagora_content_inspect_extension.dll;C:/Program Files/chatify/libagora_face_capture_extension.dll;C:/Program Files/chatify/libagora_face_detection_extension.dll;C:/Program Files/chatify/libagora_lip_sync_extension.dll;C:/Program Files/chatify/libagora_screen_capture_extension.dll;C:/Program Files/chatify/libagora_segmentation_extension.dll;C:/Program Files/chatify/libagora_spatial_audio_extension.dll;C:/Program Files/chatify/libagora_video_av1_decoder_extension.dll;C:/Program Files/chatify/libagora_video_av1_encoder_extension.dll;C:/Program Files/chatify/libagora_video_decoder_extension.dll;C:/Program Files/chatify/libagora_video_encoder_extension.dll;C:/Program Files/chatify/libagora_video_quality_analyzer_extension.dll;C:/Program Files/chatify/libaosl.dll;C:/Program Files/chatify/video_dec.dll;C:/Program Files/chatify/video_enc.dll;C:/Program Files/chatify/audioplayers_windows_plugin.dll;C:/Program Files/chatify/bitsdojo_window_windows_plugin.lib;C:/Program Files/chatify/camera_windows_plugin.dll;C:/Program Files/chatify/cloud_firestore_plugin.lib;C:/Program Files/chatify/connectivity_plus_plugin.dll;C:/Program Files/chatify/emoji_picker_flutter_plugin.dll;C:/Program Files/chatify/file_selector_windows_plugin.dll;C:/Program Files/chatify/firebase_auth_plugin.lib;C:/Program Files/chatify/firebase_core_plugin.lib;C:/Program Files/chatify/firebase_storage_plugin.lib;C:/Program Files/chatify/flutter_webrtc_plugin.dll;C:/Program Files/chatify/libwebrtc.dll;C:/Program Files/chatify/iris_method_channel_plugin.dll;C:/Program Files/chatify/iris_method_channel.dll;C:/Program Files/chatify/local_auth_windows_plugin.dll;C:/Program Files/chatify/media_kit_libs_windows_video_plugin.dll;C:/Program Files/chatify/libmpv-2.dll;C:/Program Files/chatify/d3dcompiler_47.dll;C:/Program Files/chatify/libEGL.dll;C:/Program Files/chatify/libGLESv2.dll;C:/Program Files/chatify/vk_swiftshader.dll;C:/Program Files/chatify/vulkan-1.dll;C:/Program Files/chatify/zlib.dll;C:/Program Files/chatify/media_kit_video_plugin.dll;C:/Program Files/chatify/permission_handler_windows_plugin.dll;C:/Program Files/chatify/record_windows_plugin.dll;C:/Program Files/chatify/screen_retriever_windows_plugin.dll;C:/Program Files/chatify/share_plus_plugin.dll;C:/Program Files/chatify/url_launcher_windows_plugin.dll;C:/Program Files/chatify/volume_controller_plugin.dll;C:/Program Files/chatify/window_manager_plugin.dll;C:/Program Files/chatify/flutter_local_notifications_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE FILE FILES
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/agora_rtc_engine/Profile/agora_rtc_engine_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/iris/lib/iris_4.5.2-build.1_DCG_Windows/x64/Release/AgoraRtcWrapper.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/agora_rtc_sdk.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/glfw3.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-fdkaac.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-ffmpeg.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-soundtouch.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-wgc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_echo_cancellation_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_echo_cancellation_ll_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_noise_suppression_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_noise_suppression_ll_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_audio_beauty_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_clear_vision_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_content_inspect_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_face_capture_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_face_detection_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_lip_sync_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_screen_capture_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_segmentation_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_spatial_audio_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_av1_decoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_av1_encoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_decoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_encoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_quality_analyzer_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libaosl.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/video_dec.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/video_enc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/audioplayers_windows/Profile/audioplayers_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/bitsdojo_window_windows/Profile/bitsdojo_window_windows_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/camera_windows/Profile/camera_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/cloud_firestore/Profile/cloud_firestore_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/connectivity_plus/Profile/connectivity_plus_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/emoji_picker_flutter/Profile/emoji_picker_flutter_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/file_selector_windows/Profile/file_selector_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_auth/Profile/firebase_auth_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_core/Profile/firebase_core_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_storage/Profile/firebase_storage_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_webrtc/Profile/flutter_webrtc_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/flutter_webrtc/windows/../third_party/libwebrtc/lib/win64/libwebrtc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/Profile/iris_method_channel_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/shared/Profile/iris_method_channel.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/local_auth_windows/Profile/local_auth_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_libs_windows_video/Profile/media_kit_libs_windows_video_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/libmpv/libmpv-2.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/d3dcompiler_47.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/libEGL.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/libGLESv2.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/vk_swiftshader.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/vulkan-1.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/zlib.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_video/Profile/media_kit_video_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/permission_handler_windows/Profile/permission_handler_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/record_windows/Profile/record_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/screen_retriever_windows/Profile/screen_retriever_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/share_plus/Profile/share_plus_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/url_launcher_windows/Profile/url_launcher_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/volume_controller/Profile/volume_controller_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/window_manager/Profile/window_manager_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_local_notifications_windows/shared/Profile/flutter_local_notifications_windows.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/agora_rtc_engine_plugin.dll;C:/Program Files/chatify/AgoraRtcWrapper.dll;C:/Program Files/chatify/agora_rtc_sdk.dll;C:/Program Files/chatify/glfw3.dll;C:/Program Files/chatify/libagora-fdkaac.dll;C:/Program Files/chatify/libagora-ffmpeg.dll;C:/Program Files/chatify/libagora-soundtouch.dll;C:/Program Files/chatify/libagora-wgc.dll;C:/Program Files/chatify/libagora_ai_echo_cancellation_extension.dll;C:/Program Files/chatify/libagora_ai_echo_cancellation_ll_extension.dll;C:/Program Files/chatify/libagora_ai_noise_suppression_extension.dll;C:/Program Files/chatify/libagora_ai_noise_suppression_ll_extension.dll;C:/Program Files/chatify/libagora_audio_beauty_extension.dll;C:/Program Files/chatify/libagora_clear_vision_extension.dll;C:/Program Files/chatify/libagora_content_inspect_extension.dll;C:/Program Files/chatify/libagora_face_capture_extension.dll;C:/Program Files/chatify/libagora_face_detection_extension.dll;C:/Program Files/chatify/libagora_lip_sync_extension.dll;C:/Program Files/chatify/libagora_screen_capture_extension.dll;C:/Program Files/chatify/libagora_segmentation_extension.dll;C:/Program Files/chatify/libagora_spatial_audio_extension.dll;C:/Program Files/chatify/libagora_video_av1_decoder_extension.dll;C:/Program Files/chatify/libagora_video_av1_encoder_extension.dll;C:/Program Files/chatify/libagora_video_decoder_extension.dll;C:/Program Files/chatify/libagora_video_encoder_extension.dll;C:/Program Files/chatify/libagora_video_quality_analyzer_extension.dll;C:/Program Files/chatify/libaosl.dll;C:/Program Files/chatify/video_dec.dll;C:/Program Files/chatify/video_enc.dll;C:/Program Files/chatify/audioplayers_windows_plugin.dll;C:/Program Files/chatify/bitsdojo_window_windows_plugin.lib;C:/Program Files/chatify/camera_windows_plugin.dll;C:/Program Files/chatify/cloud_firestore_plugin.lib;C:/Program Files/chatify/connectivity_plus_plugin.dll;C:/Program Files/chatify/emoji_picker_flutter_plugin.dll;C:/Program Files/chatify/file_selector_windows_plugin.dll;C:/Program Files/chatify/firebase_auth_plugin.lib;C:/Program Files/chatify/firebase_core_plugin.lib;C:/Program Files/chatify/firebase_storage_plugin.lib;C:/Program Files/chatify/flutter_webrtc_plugin.dll;C:/Program Files/chatify/libwebrtc.dll;C:/Program Files/chatify/iris_method_channel_plugin.dll;C:/Program Files/chatify/iris_method_channel.dll;C:/Program Files/chatify/local_auth_windows_plugin.dll;C:/Program Files/chatify/media_kit_libs_windows_video_plugin.dll;C:/Program Files/chatify/libmpv-2.dll;C:/Program Files/chatify/d3dcompiler_47.dll;C:/Program Files/chatify/libEGL.dll;C:/Program Files/chatify/libGLESv2.dll;C:/Program Files/chatify/vk_swiftshader.dll;C:/Program Files/chatify/vulkan-1.dll;C:/Program Files/chatify/zlib.dll;C:/Program Files/chatify/media_kit_video_plugin.dll;C:/Program Files/chatify/permission_handler_windows_plugin.dll;C:/Program Files/chatify/record_windows_plugin.dll;C:/Program Files/chatify/screen_retriever_windows_plugin.dll;C:/Program Files/chatify/share_plus_plugin.dll;C:/Program Files/chatify/url_launcher_windows_plugin.dll;C:/Program Files/chatify/volume_controller_plugin.dll;C:/Program Files/chatify/window_manager_plugin.dll;C:/Program Files/chatify/flutter_local_notifications_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE FILE FILES
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/agora_rtc_engine/Release/agora_rtc_engine_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/iris/lib/iris_4.5.2-build.1_DCG_Windows/x64/Release/AgoraRtcWrapper.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/agora_rtc_sdk.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/glfw3.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-fdkaac.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-ffmpeg.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-soundtouch.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora-wgc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_echo_cancellation_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_echo_cancellation_ll_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_noise_suppression_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_ai_noise_suppression_ll_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_audio_beauty_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_clear_vision_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_content_inspect_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_face_capture_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_face_detection_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_lip_sync_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_screen_capture_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_segmentation_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_spatial_audio_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_av1_decoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_av1_encoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_decoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_encoder_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libagora_video_quality_analyzer_extension.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/libaosl.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/video_dec.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/agora_rtc_engine/windows/third_party/native/lib/Agora_Native_SDK_for_Windows_FULL/sdk/x86_64/video_enc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/audioplayers_windows/Release/audioplayers_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/bitsdojo_window_windows/Release/bitsdojo_window_windows_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/camera_windows/Release/camera_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/cloud_firestore/Release/cloud_firestore_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/connectivity_plus/Release/connectivity_plus_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/emoji_picker_flutter/Release/emoji_picker_flutter_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/file_selector_windows/Release/file_selector_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_auth/Release/firebase_auth_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_core/Release/firebase_core_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/firebase_storage/Release/firebase_storage_plugin.lib"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_webrtc/Release/flutter_webrtc_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/flutter/ephemeral/.plugin_symlinks/flutter_webrtc/windows/../third_party/libwebrtc/lib/win64/libwebrtc.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/Release/iris_method_channel_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/iris_method_channel/shared/Release/iris_method_channel.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/local_auth_windows/Release/local_auth_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_libs_windows_video/Release/media_kit_libs_windows_video_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/libmpv/libmpv-2.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/d3dcompiler_47.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/libEGL.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/libGLESv2.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/vk_swiftshader.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/vulkan-1.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/ANGLE/zlib.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/media_kit_video/Release/media_kit_video_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/permission_handler_windows/Release/permission_handler_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/record_windows/Release/record_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/screen_retriever_windows/Release/screen_retriever_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/share_plus/Release/share_plus_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/url_launcher_windows/Release/url_launcher_windows_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/volume_controller/Release/volume_controller_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/window_manager/Release/window_manager_plugin.dll"
      "D:/Programming/Languages/Dart/Projects/chatify/windows/plugins/flutter_local_notifications_windows/shared/Release/flutter_local_notifications_windows.dll"
      )
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "C:/Program Files/chatify/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "C:/Program Files/chatify" TYPE DIRECTORY FILES "D:/Programming/Languages/Dart/Projects/chatify/build/native_assets/windows/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "C:/Program Files/chatify/data/flutter_assets")
  
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "C:/Program Files/chatify/data/flutter_assets")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "C:/Program Files/chatify/data" TYPE DIRECTORY FILES "D:/Programming/Languages/Dart/Projects/chatify/build//flutter_assets")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee]|[Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "C:/Program Files/chatify/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "C:/Program Files/chatify/data" TYPE FILE FILES "D:/Programming/Languages/Dart/Projects/chatify/build/windows/app.so")
  endif()
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "D:/Programming/Languages/Dart/Projects/chatify/windows/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "D:/Programming/Languages/Dart/Projects/chatify/windows/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
