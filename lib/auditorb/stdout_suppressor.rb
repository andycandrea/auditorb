module Auditorb
  # Certain commands print out a large volume of information to STDOUT. This is
  # meant to suppress the output of those commands so that all output (excluding
  # errors) originates from auditorb itself.
  class StdoutSuppressor
    def self.suppress
      original_stdout = $stdout.clone
      $stdout.reopen(File.new('/dev/null', 'w'))
      return_value = yield
    ensure
      $stdout.reopen(original_stdout)
      return_value
    end
  end
end
