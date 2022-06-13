set(HANG_UNI_MAN_SRC main.cpp resources.qrc)

add_executable(${PROJECT_NAME} ${HANG_UNI_MAN_SRC})

target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
)

add_custom_target(run COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME})
