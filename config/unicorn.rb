# $PIL$

APP_ROOT = "/root/pastie"
# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 1

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "#{APP_ROOT}" # available in 0.94.0+

# listen on TCP 8000
listen 8000

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
#pid "#{APP_ROOT}/shared/pids/unicorn.pid"

# some applications/frameworks log to stderr or stdout, so prevent
# them from going to /dev/null when daemonized here:
#stderr_path "#{APP_ROOT}/shared/logs/unicorn.stderr.log"
#stdout_path "#{APP_ROOT}/shared/logs/unicorn.stdout.log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
#preload_app false
#GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = "#{APP_ROOT}/shared/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
end
