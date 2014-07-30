require 'spec_helper'
require 'faker'

feature 'Pagination' do
  let(:forum) { create(:forum) }
  # p Topic.default_per_page

  context 'if there is more than default_per_page' do
    let!(:topics) { Topic.default_per_page.times { create(:topic, forum: forum) } }

    scenario 'topics will be paginated' do
      visit forum_path(forum)

      # puts '#{page.html.inspect}'

      within '.pagination', match: :first do
        click_link('2')
      end

      current_fullpath.should == forum_path(forum, page: 2)

      within '.pagination', match: :first do
        click_link('Next')
      end

      current_fullpath.should == forum_path(forum, page: 3)

      within '.pagination', match: :first do
        click_link('Last')
      end

      current_fullpath.should == forum_path(forum, page: 5)

      within '.pagination', match: :first do
        click_link('Prev')
      end

      current_fullpath.should == forum_path(forum, page: 4)

      within '.pagination', match: :first do
        click_link('First')
      end

      current_path.should == forum_path(forum)
    end
  end

  context 'if there is less than default_per_page' do
    let!(:topics) { Topic.default_per_page-1.times { create(:topic, forum: forum) } }

    scenario 'topics will NOT be paginated' do
      visit forum_path(forum)

      page.should_not have_css('.pagination')
    end
  end
end
