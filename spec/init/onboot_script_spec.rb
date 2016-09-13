require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe 'onboot' do
  it 'is valid bash' do
    valid_bash('./init/onboot_script')
  end

  it 'is good bash' do
    good_bash('./init/onboot_script')
  end
end
