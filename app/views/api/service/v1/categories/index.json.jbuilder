json.categories @categories do |c|
    json.category do
        json.name c.name
        json.description c.description
    end
end