json.solution do
    json.solution @solution.solution
    json.technician @solution.account.handle

    json.comments @solution.comments do |c|
        json.comment c.comment
        json.commenter c.account.handle
    end
end