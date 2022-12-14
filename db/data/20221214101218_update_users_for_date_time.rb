# frozen_string_literal: true

class UpdateUsersForDateTime < ActiveRecord::Migration[7.0]
  def change
    User.update_all confirmed_at: DateTime.now
  end
end
