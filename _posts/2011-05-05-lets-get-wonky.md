---
layout: post
title: Let's Get Wonky!
---
So, the email I (and scads of other people) got from Slicehost the other day
was pretty uninformative, referenced a "forum" for continuing the conversation
and didn't link to it, and did very little to ease many of the anxieties it
raised.  After determining that the email (with a Rack Space letter head) was
referring to the Slicehost forum, I spent some time reading up on the coming
changes, and was underwhelmed.  There's a lot of re-assurances, a fair bit
of hand-waving and talk of everything moving to the Rack Space Cloud.  Clouds
are grand, what with their puffy and ephemeral qualities, but I'm just after
simple web hosting.  This site uses almost no real bandwidth (a testament
to my inability or un-desire to actually engage an audience) and serves up
static HTML.  My requirements are pretty minimal.  I really don't need the
ability to dynamically add instances to handle the load.

Don't get me wrong, cloud computing interests me and I can see its utility,
just not here.  Not for a static site that Jekyll lovingly compiles into
HTML every time I `git push deploy`.

So I, and I suspect many others are doing the same, jumped ship.  I'd heard
good things about [Linode](http://www.linode.com/), so I signed up.  The
account management system is already familiar to me, and I get more resources
at $0.05 less each month.

Unfortunately, a new host comes with a new set of IP addresses, which means
updating DNS records, which in turn means stale DNS caches.  You might have
problems getting here over the next couple days, or you might be running
with the new DNS entries mere moments after I push the changes through my
registrar.  It's hard to say, but eventually the updates will make their
way to you, so sit tight and we'll return after this short break!

PS: In the mean time, enjoy the following identity: {% m %}e^{i\theta} = \cos\theta + i\sin\theta{% em %}
