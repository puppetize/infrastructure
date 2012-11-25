#!/bin/sh
patch -N -p0 <<EOF
--- /opt/ruby/lib/ruby/gems/1.9.1/gems/puppet-3.0.1/lib/puppet/provider/service/upstart.rb.orig	2012-11-08 12:58:07.158285836 +0000
+++ /opt/ruby/lib/ruby/gems/1.9.1/gems/puppet-3.0.1/lib/puppet/provider/service/upstart.rb	2012-11-10 23:49:02.033626064 +0000
@@ -64,7 +64,7 @@
   end
 
   def upstart_version
-    @@upstart_version ||= initctl("--version").match(/initctl \(upstart ([^\)]*)\)/)[1]
+    @upstart_version ||= initctl("--version").match(/initctl \(upstart ([^\)]*)\)/)[1]
   end
 
   # Where is our override script?
EOF
exit 0
