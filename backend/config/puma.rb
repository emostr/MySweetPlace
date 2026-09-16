threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

bind "tcp://#{ENV.fetch("BIND", "127.0.0.1")}:#{ENV.fetch("PORT", 3000)}"

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
