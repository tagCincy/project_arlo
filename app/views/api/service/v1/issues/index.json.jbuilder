json.issues @issues do |i|
    json.issue do
        json.subject i.subject
        json.description i.description
        json.author i.account.handle
        json.categories i.categories, :name
    end
end