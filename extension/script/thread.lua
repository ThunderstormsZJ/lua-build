local thd = require "bee.thread"
thd.channel_produce = thd.channel
thd.channel_consume = thd.channel
return thd
