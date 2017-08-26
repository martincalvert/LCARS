worker_processes 4
working_directory '/srv/lcars'
timeout 60
stderr_path '/dev/stderr'
stdout_path '/dev/stdout'
preload_app true
listen 3000, backlog: 256
