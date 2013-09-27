About applicationname-plasmoid
==============================
A plasmoid for KDE plasma which shows the application name of the focused window.

Features:

* Shows the application name of the focused windows
* Shows the activity name if no window is focused
* Optionally, it shows the window title (enable it in the settings dialog)
* Optionally, it shows the application icon (enable it in the settings dialog)
* A custom width can be set through the settings dialog
* The font style (bold/italic) and color are customizable
* The label effect (Plain/Raised/Sunken) is customizable too

Very useful when you remove the KWin titlebar.

##How to install
    $ zip applicationname.zip package -r
    $ plasmapkg -i applicationname.zip
    $ kbuildsycoc4

or

    $ mkdir build
    $ cd build
    $ cmake ../
    # make install

##Licensing
LGPL
