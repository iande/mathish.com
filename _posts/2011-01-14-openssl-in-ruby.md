---
layout: post
title: OpenSSL in Ruby
---
The following code assumes that there is a subdirectory named `certs`
containing known certificates in PEM format, and a subdir `keys`
containing the client's private RSA key.  Further, there are lots of comments
specific to my actual needs, namely exporting keys generated in Java using
`keytool` for an [Apache ActiveMQ](http://activemq.apache.org/) message
broker.  Lastly, to use the `ca_path` method, the `certs` directory needs to
be properly indexed using `c_rehash` (make sure the underlying version of
`openssl` matches the version Ruby's OpenSSL extension was built against,
otherwise the hash algorithm may not be the same.)

The code that follow was written for my own benefit in understanding the
mapping between the OpenSSL C API and API available in Ruby.  The actual
connection established is specific to my needs, but the OpenSSL setup should
be pretty common.  The type of the private key will differ depending upon the
algorithm used during the generation of the certificate.

{% highlight ruby %}
#!/usr/bin/env ruby

require 'socket'
require 'openssl'

SSL_HOST = 'localhost'
SSL_PORT = 61612
SSL_CERT_DIR = File.expand_path('certs', File.dirname(__FILE__))
SSL_BROKER_CERT = File.expand_path('broker.pem', SSL_CERT_DIR)
SSL_CLIENT_CERT = File.expand_path('client.pem', SSL_CERT_DIR)
SSL_CLIENT_KEY = File.expand_path('keys/client.key', File.dirname(__FILE__))

USE_BROKER_CERT_FILE = false
USE_CLIENT_CERT = false

# Things to note:
#
# I am using Apache ActiveMQ to test this SSL stuff.  It's java based, so there's
# a lot of `keytool` to `openssl` conversion going on, including an external Java
# program to dump the private key from the keytool keystore, because apparently
# keytool doesn't provide a way to do that.
#
# The commands used:
#
# 1. Active MQ client and broker cert generation:
# Create the broker cert/keypair
# > keytool -genkey -alias broker -keyalg RSA -keystore broker.ks
# Export the broker certificate (DER format)
# > keytool -export -alias broker -keystore broker.ks -file broker.der
# Create the client cert/keypair
# > keytool -genkey -alias client -keyalg RSA -keystore client.ks
# Add the broker cert to the client's trust-store (just to generate the trust stores,
# we don't use the client store on the client side, because we're using Ruby + OpenSSL)
# > keytool -import -alias broker -keystore client.ts -file broker.der
# Export client certificate
# > keytool -export -alias client -keystore client.ks -file client.der
# Import client cert into broker trust store
# > keytool -import -alias client -keystore broker.ts -file client.der
# This gets all the keys and whatnot set up for ActiveMQ.  Indeed, these steps
# can be found at: http://activemq.apache.org/how-do-i-use-ssl.html
#
# Next, we need to get these keys into OpenSSL acceptable forms
# (see: http://conshell.net/wiki/index.php/Keytool_to_OpenSSL_Conversion_tips)
# Convert the broker keytool DER cert into a PEM cert
# > openssl x509 -out broker.pem -outform pem -in broker.der -inform der
# Convert the client keytool DER cert into a PEM cert
# > openssl x509 -out client.pem -outform pem -in client.der -inform der
# As I am using ActiveMQ, there isn't a need to generate anything more on the
# broker side.  The client just needs the PEM form for SSL trust.
# However, when the broker requires ssl authentication (needClientAuth=true on the
# transport URI), we will need the client's private key from the keystore as well.
# Unfortunately, there is no keytool command (as far as I've seen so far) that will
# export this from a java keystore.  So, we make use of the DumpKey program copied
# from http://www.herongyang.com/crypto/Migrating_Keys_keytool_to_OpenSSL.html and
# found in examples/DumpKey.java to export the private key.
# Finally, we convert the private key output to a form usable by OpenSSL:
# > openssl enc -in client_bin.key -out client.key -a
# And wrap the output file with "-----BEGIN/END PRIVATE KEY-----" as outlined in
# http://www.herongyang.com/crypto/Migrating_Keys_keytool_to_OpenSSL_4.html
#
# Quite a bit of work... thanks Java!  Hopefully tests will require less work
# by using only OpenSSH within a stub broker.



tcp_sock = TCPSocket.new(SSL_HOST, SSL_PORT)
ctx = OpenSSL::SSL::SSLContext.new
ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER|OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT

if USE_BROKER_CERT_FILE
  # Specify the cert file directly
  ctx.ca_file = SSL_BROKER_CERT
  ctx.ca_path = nil
else
  # ... or the path to a series of cert files
  #
  # Theoretically, either method would work once c_rehash has been run on
  # a directory containing the certs.  However, with OpenSSL 1.0.0a, the
  # ca_path setting appears to not work at all, so I cannot test this
  # at the moment.
  #
  # Scratch that, OpenSSL didn't break anything, I did.
  # Ruby's OpenSSL extension was built against the OS X OpenSSL version (0.9.8l)
  # I was using c_rehash in such a way that it was calling on the 1.0.0a version
  # installed via port.  ca_path isn't broken, but the hashing mechanism between
  # 0.9.x and 1.0.x is different.
  ctx.ca_file = nil
  ctx.ca_path = SSL_CERT_DIR
end

if USE_CLIENT_CERT
  ctx.cert = OpenSSL::X509::Certificate.new(File.read(SSL_CLIENT_CERT))
  ctx.key = OpenSSL::PKey::RSA.new(File.read(SSL_CLIENT_KEY))
end

puts "CA File: #{ctx.ca_file}"
puts "CA Path: #{ctx.ca_path}"


ssl_sock = OpenSSL::SSL::SSLSocket.new(tcp_sock, ctx)

ssl_sock.sync_close = true

ssl_sock.connect
begin
  ssl_sock.post_connection_check('Apache ActiveMQ')
rescue => ex
  puts "!!!!!! WARNING !!!!!!!"
  puts
  puts "Post check failed"
  puts "#{ex.inspect}"
  puts
  puts "!!!!!! WARNING !!!!!!!"
end

puts
puts ssl_sock.peer_cert_chain.inspect
puts

# ssl_sock.puts 'GET / HTTP/1.1'
# ssl_sock.puts "Host: #{SSL_HOST}"
# ssl_sock.puts 'Connection: close'
# ssl_sock.puts
# 
# in_body = false
# while line = ssl_sock.gets
#   in_body ||= line.chomp.empty?
#   puts line if !in_body
# end

ssl_sock.puts "CONNECT\n\n\x00"
#sleep(2)
t = Thread.new(ssl_sock) do |s|
  read_it = ""
  while (c = s.getc rescue nil)
    if c.ord == 0
      puts "Read Frame: #{read_it}"
      read_it = ""
    else
      read_it << c
    end
  end
  #s.puts "DISCONNECT\n\n\x00"
  #puts "Finally: #{s.gets}"
end
ssl_sock.puts "SUBSCRIBE\nid:sub-001\ndestination:/queue/testing/ssl\nack:auto\n\n\000"

ssl_sock.puts "SEND\ndestination:/queue/testing/ssl\nreceipt:rcpt-001\ncontent-length:5\n\nhello\000"

sleep(2)
puts
puts "Disconnecting"
ssl_sock.puts "DISCONNECT\n\n\x00"
t.join

ssl_sock.close
{% endhighlight %}
