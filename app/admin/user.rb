ActiveAdmin.register User do
 index do
    column :email
    column :is_admin
    column :created_at
    column :updated_at
    column :last_sign_in_at
    column :last_sign_in_ip
    column :sign_in_count
    default_actions
  end

  filter :is_admin, :as => :check_boxes
  filter :email
  filter :projects, :as => :select

  form do |f|
    f.inputs "Account" do
      f.input :email
      f.input :is_admin
      f.input :projects
      f.input :owned_projects
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  
  show do |user|
    attributes_table do
      row :email
      row :is_admin
      row :created_at
      row :updated_at
      row :last_sign_in_at
      row :last_sign_in_ip
      row :sign_in_count
    end
    active_admin_comments
  end
  
  controller do
    def update_resource object, attributes
      attributes.each do |attr|
        if attr[:password].blank? and attr[:password_confirmation].blank?
          attr.delete :password
          attr.delete :password_confirmation
        end
      end
      object.send :update_attributes, *attributes
    end
  end
end
