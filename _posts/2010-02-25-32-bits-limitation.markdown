---
layout: post
title: 32 bits architecture limitation
---

Intel Core Duo Incompatibility
==============================
MacRuby which Pomodori uses underneath is not totally 32bit compatible. Something not working completely is for example the support for regular expressions like the ones in time.rb httpdate method. I tried a few workarounds to skip the httpdate time processing without success. The fact that I don't own a 32 bits machine makes almost impossible to produce a patch that works. So if you installed Pomodori and got something like:

    Applications/Pomodori.app/Contents/Frameworks/MacRuby.framework/
    Versions/0.5/usr/lib/ruby/1.9.0/time.rb:372: 
    too short escaped multibyte character: /\A\s*
             (?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)\x20
             (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\x20
             (\d\d|\x20\d)\x20
             (\d\d):(\d\d):(\d\d)\x20
             (\d{4})
             \s*\z/ix
    timestamp.rb:1:in `<main>': compile error (SyntaxError)
    from pomodori.rb:2:in `<main>'

you just hit the bug. I know the MacRuby guys are working hard on fixing all the remaining 32 bit incompatibilities. It's pretty possible this will be fixed in MacRuby 0.6. To know if you're able to run Pomodori open your "About This Mac" and look at the hardware section: if you have a Intel Core 2 Duo you should be ok while if you have an Intel Core Duo without the number "2" you can't run Pomodori.

*Sorry for the trouble*
