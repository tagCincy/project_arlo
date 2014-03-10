json.accounts @accounts do |a|
    json.account do
        json.first_name a.user.first_name
        json.last_name a.user.last_name
        json.email a.user.email
        json.handle a.handle
        json.description a.description
        json.technician a.technician
        json.groups a.member_groups, :name, :code, :description
    end
end