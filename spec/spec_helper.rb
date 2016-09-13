require 'mkmf'
require 'pry'

module Dependencies
  extend self
  def check
    @ok ||= begin
      fail 'You must install shellcheck (https://github.com/koalaman/shellcheck) to run bash tests' unless MakeMakefile::find_executable 'shellcheck'
      true
    end
  end
end

def valid_bash(script_path)
  expect(system("bash -n #{script_path}")).to eq(true)
end

def good_bash(script_path)
  expect(system("shellcheck #{script_path}")).to eq(true)
end

Dependencies.check

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
