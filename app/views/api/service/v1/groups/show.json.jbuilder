json.group do
    json.name @group.name
    json.code @group.code
    json.description @group.description
    json.admin @group.admin.handle
    json.members @group.members, :handle, :technician
end