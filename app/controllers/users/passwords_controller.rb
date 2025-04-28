class Users::PasswordsController < Devise::PasswordsController
    before_action :force_password_change, only: :edit
  
    private
  
    def force_password_change
      if current_user && current_user.first_access?
        redirect_to edit_user_registration_path, alert: 'Por favor, altere sua senha provisória.'
      end
    end
  end
  