module MessageHelper

  def user_sees_error_message(message)
    expect(page).to have_css '.alert', text: message
  end

  def user_sees_success_message(message)
    expect(page).to have_css '.notice', text: message
  end

end
