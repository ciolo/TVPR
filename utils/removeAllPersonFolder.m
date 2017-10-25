for i = 1:23
    if(i < 10)
        path=strcat('../img/g00',num2str(i));
    else
        path=strcat('../img/g0',num2str(i));
    end
    
    person_folders = dir(strcat(path,'/person*'));
    
    for person_folder = person_folders'
        rmdir(strcat(path,'/', person_folder.name), 's');
    end
    
end