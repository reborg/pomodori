---
layout: default
title: Welcome to Pomodori!
---

Pomodori is a tool based on the pomodoro technique (PT) by [Francesco Cirillo](http://cirillosscrapbook.wordpress.com/) available for Mac Os X (Leopard, Snow Leopard 10.6 Core 2 Duo and Lion 10.7 please look at the Requirements section to know which version to download). Pomodori measures the pomodoro time and stores pomodoro descriptions with the help of only a single click. Pomodori shows metrics to help you plan future activities and detailed charts. For more information about the technique please visit [pomodoro community](http://www.pomodorotechnique.com/).

WHAT IS THE POMODORO TECHNIQUE?
-------------------------------
The Pomodoro Technique (PT) is a time and focus management technique which improves productivity and quality of work. Starting with the PT is incredibily simple, you just need a timer (shameless promotion, what about Pomodori?) that counts 25 minutes:

![Start Easy](resources/start-easy.png "Start Easy")

Then read the book [Pomodoro Technique Illustrated](http://www.pomodoro-book.com/) by Staffan Noteberg and the original [paper](http://www.pomodorotechnique.com/) by Francesco and you should be all set.

SCREENSHOTS
-----------

General view:

![General View](resources/general-view.png "General View")

Done Pomodoro:

![Pomodoro Done](resources/pomodoro-done.png "Pomodoro Done")

FEATURES
--------------------

The project is young and features are added fast. Do you want a new feature? Please enter it here: [Github-Issues](http://github.com/reborg/pomodori/issues) or send your comment to reborg @ reborg.net

Release 0.7 (Sun 18 Dec 2011)

This release is based on MacRuby 0.10 and works on Mac OS X 10.7.x Lion. This release should not be used if you're still using Snow Leopard (use 0.6 in that case). There are no new features in this release other than the compatibility with Lion. Please download Pomodori 0.7 [here](http://reborg.github.com/pomodori/resources/pomodori-0.7.zip). 

Release 0.6

MacRuby 0.6 is now the default embedded macruby. Also fixed a bug importing frameworks on case sensitive file systems (http://github.com/reborg/pomodori/issues#issue/4). Please download Pomodori 0.6 [here](http://reborg.github.com/pomodori/resources/pomodori-0.6.zip). 

Release 0.5

This release introduces compatibility with Snow Leopard Mac Os X 10.6. If you have Snow Leopard please download Pomodori 0.5 [here](http://reborg.github.com/pomodori/resources/pomodori-0.5.zip). Other than fixes for the OS version bump, this release also embed MacRuby in the executable so you don't need a separate installtion: just unzip and go!

Release 0.4

This release was the last based on MacRuby 0.4 (the last compatible with Mac OS X Leopard 10.5). If you are still running on Leopard Mac Os X 10.5 please download version 0.4 [here](http://reborg.github.com/pomodori/resources/pomodori-0.4.zip). Included in this release:

* Fixed bug related to pomodoros recorded with different timezones
* Added unicode support to pomodoro descriptions [ticket 11](http://reborg.lighthouseapp.com/projects/25822/tickets/11-scandinavic-characters-such-as-crash-pomodori)
* Removed too short days (less than 6 pomodoros) from average count

Release 0.3

* Total count of pomodoros on title bar
* Previously used tags (word starting with @something) are inserted as default for the next pomodoro description
* Clicking on Yesterday or Today count opens descriptions for yesterday's or today's pomodoros
* Clicking on the Average count opens the summary by day chart
* Performance improvement by caching pomodoros in memory
* Some other UI tweak and internal refactorings

Release 0.2

* Added "Pomodoro Summary by Day" chart that shows the count of pomodoros by day in a bar chart
* Better looking UI
* Improved stability

Release 0.1

* Pomodori automatically starts a 25 mins countdown when launched
* Pomodori rings a bell at the end of the 25 mins
* A description can be added to the pomodoro just spent and a timestamp is saved automatically
* A database is created in ~/Library/Application Support/Pomodori where you can read the descriptions (for the final realease advanced report capabilities will be provided)
* Pomodori starts a break timer (5 mins) automatically as soon as you add the description
* Pomodori rings again at the end of the break and starts another 25 mins pomodoro
* And so on, until you've got everything DONE!
* A pomodoro can be voided (no information stored) and Pomodori jumps directly to the break

COMING SOON (MAYBE)
------------------

* Major rewrite under developement. Dropping HotCocoa and moving interface deisgn in XCode.
* Tag management to tag pomodoros belonging to a certain category
* More advanced charts such as pomodoros worked by tag
* After 4 pomodoros Pomodori will kindly remember you that is time for a longer break
* Timer visible in the menubar
* Many many more...
* Fixed bug related to pomodoros recorded with different timezones
* Added unicode support to pomodoro descriptions []

REQUIREMENTS
------------

Mac Os X 10.7 Lion users:

* Just download Pomodori release 0.7, unzip in /Applications folder and go.

Mac Os X 10.6 Snow Leopard (64bits, see limitations) Users:

* Just download Pomodori release 0.6, unzip and go.

Mac OS X 10.5 Leopard users:

* Download MacRuby 0.4 binaries from [MacRuby binaries](http://www.macruby.org/files/MacRuby%200.4.zip)
* Unzip and double click on the installer and follow the instructions
* Unzip and use Pomodori 0.4

LIMITATIONS
-----------

MacRuby doesn't completely work on 32 bit architectures (the Mac on Intel Core Duo are 32 bit only, Mac with Intel Core 2 Duo are 64 bit). If you happen to have an "old" Mac with an Intel Core Duo chip, you should wait unitl the next MacRuby release is available to use Pomodori or switch to Mac Os X 10.7 Lion.

INSTALL
-------

* Download the pomodori release archive based on your Mac Os X version. For Lion users please download [here](http://reborg.github.com/pomodori/resources/pomodori-0.7.zip)
* Unzip and copy to Pomodori.app to /Applications
* Please report installation issues at [Github-Issues](http://github.com/reborg/pomodori/issues)

DEVELOPING
----------

You need to install MacRuby 0.10 available [here](http://www.macruby.org/files/MacRuby%200.10.zip). Then Git clone git://github.com/reborg/pomodori.git to create a local "pomodori" directory. cd into the pomodori directory and then:

* (Optional but recommended) run the test suite with 'macrake test' (not working as of 18/12/2011 after releasing for Lion).
* 'macrake run' from the root directory to generate the app and run it
* 'macrake deploy' to create a pomodori app distribution with embedded MacRuby
* './script/console' to load an interactive console with pre-loaded HotCocoa and Pomodori classes

LINKS
-----

* [Homepage](http://reborg.github.com/pomodori)
* [Tracking](http://github.com/reborg/pomodori/issues) at Github Issues Tracker
* [Blog](http://blog.reborg.net) my blog where I also talk about pomodoros
* Mail me at:  reborg -at- reborg -dot- net

LICENSE
-------

(The MIT License)

Copyright (c) 2009-2012 ReBorg - Renzo Borgatti

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
