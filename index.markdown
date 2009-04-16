---
layout: default
title: Welcome to Pomodori!
---

Pomodori is a Mac OS only tool based on the pomodoro technique (PT) by [Francesco Cirillo](http://cirillosscrapbook.wordpress.com/). Pomodori measures the pomodoro time and stores pomodoro descriptions with only a single click. Pomodori shows metrics to help you plan future activities and detailed charts. For more information about the technique please visit [pomodoro community](http://www.pomodorotechnique.com/).

FEATURES
--------------------

The project is young but features are added fast. Do you want to suggest a feature? Please enter here: [LightHouse](http://reborg.lighthouseapp.com/projects/25822-pomodori/overview)

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

SCREENSHOTS
-----------

Running Pomodoro:

![Pomodoro Running](resources/pomodoro-run.png "Pomodoro Running")

Done Pomodoro:

![Pomodoro Done](resources/pomodoro-done.png "Pomodoro Done")

Pomodoros Count by Day Chart:

![Pomodoro Count](resources/chart-pom-count.png "Pomodoro Chart")


COMING SOON
-----------

* Tag management to tag pomodoros belonging to a certain category
* More advanced charts such as pomodoros worked by tag
* After 4 pomodoros Pomodori will kindly remember you that is time for a longer break
* Timer visible in the menubar
* Many many more...

REQUIREMENTS
------------

* MacRuby 0.4 (is really easy to install while waiting for the official Apple inclusion into Mac Os X)
* Download MacRuby binaries from [MacRuby binaries](http://www.macruby.org/files/MacRuby%200.4.zip)
* Unzip and double click on the installer and follow the instructions

INSTALL
-------

* Download the [pomodori-0.2.zip archive](http://reborg.github.com/pomodori/resources/pomodori-0.2.zip)
* Unzip and copy to pomodori.app to /Applications
* Please report installation issues at [LightHouse](http://reborg.lighthouseapp.com/projects/25822-pomodori/tickets)

DEVELOPING
----------

Git clone git://github.com/reborg/pomodori.git to create a local "pomodori" directory. Then:

* cd pomodori
* Optional but recommended: run the test suite with 'macrake'
* 'macrake run' from the root directory to generate the app and run it
* './script/console' to load an interactive console with pre-loaded HotCocoa and Pomodori classes

LINKS
-----

* [Homepage](http://reborg.github.com/pomodori)
* [Tracking](http://reborg.lighthouseapp.com/projects/25822-pomodori/overview) at LightHouse
* [Blog](http://blog.reborg.net) my blog where I also talk about pomodoros
* Mail me at:  reborg -at- reborg.net

LICENSE
-------

(The MIT License)

Copyright (c) 2009 Renzo Borgatti

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