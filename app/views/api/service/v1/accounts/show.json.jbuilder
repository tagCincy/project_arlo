json.account do
    json.first_name @account.user.first_name
    json.last_name @account.user.last_name
    json.email @account.user.email
    json.handle @account.handle
    json.description @account.description
    json.technician @account.technician

    json.groups @account.member_groups, :name, :code, :description
end