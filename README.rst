Facebook Conversation Analyser
============================

This is a dumb thing that I wrote because I took three weeks of a data analysis class and now I think I know everything about #bigdata.
This program allegedly goes through your Facebook messages and determines the frequency in which you start conversations with different people.

Usage
-----

The first thing you need to do is log into Facebook and go to Settings -> General -> Download a copy of your Facebook data. This will give you your entire Facebook history, including all your messages.
Next, use https://github.com/ownaginatious/fbchat-archive-parser to parse the message data into a .csv file. As described on their page, this can be done by simply running

.. code:: bash

  fbcap ./messages.htm -f csv > output.csv
  
The code here will assume that your data is contained in output.csv. If you decide to change it, be sure to modify the code accordingly. 

Finally, modify the relevant parameters in fb_convo_analyser.R and execute it. Currently the code has only been tested on my data, so if you get any weird error messages, let me know and I'll try to figure out whatever edge case is throwing it for a loop.

Currently the program is set to just output a histogram distribution of the data, which isn't terribly interesting. If you're running out of something fancy like RStudio, you can visually inspect the resulting dataframe (full.data), which gives you specific statistics for individual people. 
  
