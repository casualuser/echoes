require 'rubygems'
require 'open3'
require 'talks'

task :test do
 stdin, stdout, stderr = Open3.popen3 \
    './node_modules/mocha/bin/mocha ./spec/*_spec.coffee --compilers coffee:coffee-script -R spec -c'

  puts stdout_array = stdout.readlines
  puts stderr_array = stderr.readlines

  stdout_strings = stdout_array.to_s
  stderr_strings = stderr_array.to_s

  if stderr_strings and
     error_match = stderr_strings.match(/(\d+) of (\d+) tests failed/)

    failed_count, total_count = error_match.captures

    message = "#{failed_count} of #{total_count} tests failed"
  else
    complete_count, = stdout_strings.match(/(\d+) tests complete/).captures

    if pending_matches = stdout_strings.match(/(\d+) tests pending/)
      pending_count, = pending_matches.captures
    end

    message = "#{complete_count} tests complete"
    message += ", #{pending_count} tests pending" if pending_count
  end

  Talks.say message, notify: true
end