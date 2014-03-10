json.issue do
    json.subject @issue.subject
    json.description @issue.description
    json.author @issue.account.handle
    json.categories @issue.categories, :name
    
    json.comments @issue.comments do |c|
        json.comment c.comment
        json.commenter c.account.handle
    end
    
    json.solutions @issue.solutions do |s|
        json.solution s.solution
        json.technician s.account.handle

        json.comments s.comments do |c|
            json.comment c.comment
            json.commenter c.account.handle
        end
    end
end