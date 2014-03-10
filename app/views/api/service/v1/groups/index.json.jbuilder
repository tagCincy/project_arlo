json.groups @groups do |g|
    json.group do
        json.name g.name
        json.code g.code
        json.description g.description
        json.admin g.admin.handle
        json.members g.members, :handle, :technician
    end
end