---
layout: post
title: Fixed performance issue
---

Well over 400 Pomodoros
=======================

I started noticing an increasing delay during the use of the Pomodori tool since some weeks ago. I easily correlated the problem to the increasing number of pomodoros in my pomodoro database. Right now I have around 450 entries in the table and every time I started Pomodori, or simply switching between running/break status resulted in this annoying 2 secs refresh of the user interface.

I decided to investigate and I found to major problems: first, I was calling the computation of the average twice by mistake and second, even removing the double call, find all pomodoros was really slow. I had a look at the Kirbybase manual to see what I was doing wrong and there is a very nicely done [performance section there](http://www.netpromi.com/files/kirbybase_ruby_manual.html#tips-on-improving-performance "Perf section") that says "Beware of Date/DateTime". Of course I was using Time as the database type for pomodoros timestamps!

I migrated the type of the column to string and modified the rest of the application to deal with string comparisons for date related queries. I created a [string extension](http://github.com/reborg/pomodori/blob/master/lib/pomodori/extensions/timestamp.rb "String Extension") to deal with timestamps. The problem then was how to migrate the already existing database file (pomodoro.tbl) to the new column type. I extracted the migration portion from KirbyStorage into a new [migration class](http://github.com/reborg/pomodori/blob/master/lib/pomodori/migration.rb "Migration Class") where I check at startup if the database should be migrated. So if you are using Pomodori already you shouldn't be worried to trash your old pomodoro history.

Now I'm happy to have back my nice and fluid Pomodori interface. By the way numbers for the find all went down from 1.4s to 0.14s.

New Features
------------

There are several other important things I'm working on right now. I'm going to open a window if you click on the yesterday's count to show you the related Pomodoros. The pomodoro/count/day that now is a separate chart will be integrated in the main window to give you a quick overview of your performance in the last 30 days. I'm also working on a secret feature.... don't tell anyone.

*Happy pomodoros to all*

