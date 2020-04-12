
----- CHANGES ------

1) STRUCTURE

    Models -> Related to DB
    Views -> Related to UI (Storyboard, Views)
    Controllers -> Business logic
    
    
2) MODELS
    Perubahan fungsi utk save dan update data supaya bisa langsung kasih notification
    
    previous :
        let activity = Activity(context: db.context)
        .
        .
        .
        .
        
        db.save()
        
    new :
        let activity = Activity(context: db.context)
        .
        .
        .
        .
        
        db.save(object: activity, operation: operationType)    -> operationType = .add / .update
        
3) UTILS

    tambahan folder utils untuk fungsi2 utility yang dipake global (converter, generator, validation dll)
    
    dipindah ke file utils :
    
    a.  alertValidation
    
    b.  priorityIndexGenerator
    
    c.  validateUserInput | return boolean
            fungsi validasi form input user
            
            contoh ada di EditActivityVC, AddActivityVC
        
    d.  dateConverter
        

        

