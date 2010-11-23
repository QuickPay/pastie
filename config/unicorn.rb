# $PIL$

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 1

# listen on a Unix domain socket.
# we use a shorter backlog for quicker failover when busy
listen "/dana/data/pastie.pil.dk/unicorn.sock", :backlog => 8

timeout 90

# feel free to point this anywhere accessible on the filesystem
pid "/dana/data/pastie.pil.dk/unicorn.pid"

# some applications/frameworks log to stderr or stdout, so prevent
# them from going to /dev/null when daemonized here:
stderr_path "/dana/data/pastie.pil.dk/logs/unicorn.error_log"
stdout_path "/dana/data/pastie.pil.dk/logs/unicorn.error_log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app false
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
end

after_fork do |server, worker|
end
