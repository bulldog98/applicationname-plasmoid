project(applicationname-plasmoid)

find_package(KDE4 "4.8" REQUIRED)

include(KDE4Defaults)
 
install(DIRECTORY package/
        DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/applicationname)
 
install(FILES package/metadata.desktop
        DESTINATION ${SERVICES_INSTALL_DIR} RENAME plasma-applet-applicationname.desktop)
