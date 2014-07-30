require 'spec_helper'
require 'faker'

describe ApplicationHelper do
  describe '#title' do
    it 'returns the default title' do
      helper.title.should eq('Default title')
    end

    it 'returns given title' do
      helper.title('Test title')
      helper.content_for(:title).should eq('Test title')
    end
  end
end
