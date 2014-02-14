About applicationname-plasmoid
==============================
A plasmoid for KDE plasma which shows the application name of the focused window.

Features:

* Shows the application name of the focused windows
* Shows the activity name if no window is focused
* Optionally, it shows the window title (enable it in the settings dialog)
* Optionally, it shows the application icon (enable it in the settings dialog)
* A fixed width can be set through the settings dialog
* Font style (bold/italic/underline), family and color are customizable too

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=andreascarpino&url=https://github.com/andreascarpino/applicationname-plasmoid&title=ApplicationName Plasmoid&language=&tags=github&category=software)

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
