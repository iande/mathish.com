---
layout: post
title: OpenSSL - Brief Notes
disqus_identifier: openssl_brief_notes
---
When setting up OpenSSL validation in Ruby, I ran into a few issues.  I'll
revisit this post later, but for my own memory, here's the big one:

Use the `openssl` command that matches the version that Ruby was built
against.  This isn't a big issue for the most part, but the `c_rehash`
command which creates symlinks to certs based on a hash relies on different
hashing techniques in OpenSSL 0.9.x and 1.x

Also, migrating keys between `openssl` and Java's `keytool` is a lot like
having teeth pulled but without the novocaine and prescription pain killers
afterward.

Some links that were useful in this whole process:

* [http://www.ibm.com/developerworks/linux/library/l-openssl.html](http://www.ibm.com/developerworks/linux/library/l-openssl.html)
* [http://conshell.net/wiki/index.php/Keytool_to_OpenSSL_Conversion_tips](http://conshell.net/wiki/index.php/Keytool_to_OpenSSL_Conversion_tips)
* [http://activemq.apache.org/how-do-i-use-ssl.html](http://activemq.apache.org/how-do-i-use-ssl.html)
* [https://github.com/ruby/ruby/blob/trunk/sample/openssl/echo_cli.rb](https://github.com/ruby/ruby/blob/trunk/sample/openssl/echo_cli.rb)
* [http://andyjeffries.co.uk/articles/x509-encrypted-authenticated-socket-ruby-client](http://andyjeffries.co.uk/articles/x509-encrypted-authenticated-socket-ruby-client)

As anyone who has done any SSL work in Ruby knows,
[Ruby's OpenSSL Docs](http://ruby-doc.org/stdlib/libdoc/openssl/rdoc/index.html)
suck, but as I am not doing anything to directly improve them, I suppose bitching is rather pointless.