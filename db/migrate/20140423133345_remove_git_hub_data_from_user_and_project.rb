class RemoveGitHubDataFromUserAndProject < ActiveRecord::Migration
  def up
    remove_column :projects, :data
    remove_column :users, :github_data
    remove_column :users, :github_access_token
    remove_column :users, :ssh_key_uploaded_to_github
  end

  def down
    add_column :users, :ssh_key_uploaded_to_github, :boolean
    add_column :users, :github_access_token, :string
    add_column :users, :github_data, :text
    add_column :projects, :data, :text
  end
end
