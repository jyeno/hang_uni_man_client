set(HANG_UNI_MAN_SRC main.cpp resources.qrc)

add_executable(hang_uni_man ${HANG_UNI_MAN_SRC})

target_compile_definitions(hang_uni_man PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(hang_uni_man PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
)

