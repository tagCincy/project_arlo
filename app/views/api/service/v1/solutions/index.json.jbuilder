json.solutions @solutions do |s|
    json.solution s.solution
    json.technician s.account.handle

    json.comments s.comments do |c|
        json.comment c.comment
        json.commenter c.account.handle
    end
end