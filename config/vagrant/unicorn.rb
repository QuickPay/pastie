# $PIL$

worker_processes 1
listen "/tmp/scruffy.sock", :backlog => 8
timeout 90
pid "/tmp/scruffy.pid"
stderr_path "/tmp/unicorn.error_log"
stdout_path "/tmp/unicorn.error_log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app false
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
end

after_fork do |server, worker|
end
