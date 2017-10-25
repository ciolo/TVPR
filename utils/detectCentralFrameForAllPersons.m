for i = 1:22
    i
    if(i < 10)
        pathFolder=strcat('../img/g00',num2str(i),'/person*');
    else
        pathFolder=strcat('../img/g0',num2str(i),'/person*');
    end
    
    for person = dir(pathFolder)'
        path_person = strcat(person.folder,'/', person.name);
        %ClassifiePerson
        %centralFrameDetector
        %cutAndNormalize
        LBPTop
    end
end