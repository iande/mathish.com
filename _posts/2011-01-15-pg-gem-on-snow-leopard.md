---
layout: post
title: pg gem on OS X
tags: postgres rubygems ruby code
---
### Building `pg` gem on OS X Snow Leopard

After PostgreSQL has been installed with ports, `pg_config` and other tools
can be found in `"/opt/local/lib/postgresql84/bin"`.  Add this path to
`$PATH` and set `ARCHFLAGS="-arch x86_64"`.

These can be set within the same command line when installing the gem:

    PATH=${PATH}:/opt/local/lib/postgresql84/bin ARCHFLAGS="-arch x86_64" gem install pg

They can also be set in their own right:

    export PATH=${PATH}:/opt/local/lib/postgresl84/bin
    export ARCHFLAGS="-arch x86_64"
    bundle
