set(HANG_UNI_MAN_SRC main.cpp resources.qrc)

qt_add_executable(${PROJECT_NAME} ${HANG_UNI_MAN_SRC} MANUAL_FINALIZATION)

qt_add_qml_module(${PROJECT_NAME}
    URI br.uni.hangman
    VERSION 1.0
    QML_FILES
        ui/Game.qml
        ui/Room.qml
        ui/Main.qml
        ui/Keyboard.qml
        ui/HiddenWord.qml
    SOURCES
        core.cpp
        core.h
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Svg
    Qt6::Network
    Qt6::Quick
    Qt6::QuickControls2
)

qt_import_qml_plugins(${PROJECT_NAME})
qt_finalize_executable(${PROJECT_NAME})

add_custom_target(run COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME})
