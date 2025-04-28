User.find_or_create_by!(email: 'admin@gcm.local') do |user|
    user.name                  = 'Admin GCM'
    user.password              = 'senhaSegura'
    user.password_confirmation = 'senhaSegura'
    user.admin                 = true
    user.first_access          = false
  end