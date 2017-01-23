# MIT License
#
# Copyright (c) 2017 Adam Bouhenguel
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'json'

require_relative 'test_auditor'

class Auditing::SuiteAuditor
  def initialize
    @tests = []
  end

  def create_test_auditor(label:, file:, line:, time:, file_path_proc:)
    sessions = []

    test = {
      "label" => label,
      "file" => file,
      "line" => line,
      "timestamp" => Auditing.format_time(time),
      "outcome" => nil,
      "sessions" => sessions
    }
    @tests.push(test)

    Auditing::TestAuditor.new(
        file_path_proc: file_path_proc,
        emit_outcome: ->(outcome) { test["outcome"] = outcome },
        emit_session: ->(session) { sessions.push(session) })
  end

  def flush(path)
    File.open(path, 'a') do |f|
      @tests.each do |test|
        f.puts JSON.generate(test)
      end
    end
  end
end
