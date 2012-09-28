project(windowtitle-plasmoid)

find_package(KDE4 "4.9" REQUIRED)

include(KDE4Defaults)
 
install(DIRECTORY package/
        DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.plasma.applet.windowtitle)
 
install(FILES package/metadata.desktop
        DESTINATION ${SERVICES_INSTALL_DIR} RENAME plasma-applet-windowtitle.desktop)
