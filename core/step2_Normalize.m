tic
for video_num = 1:22
    video_num
    if(video_num < 10)
        path=strcat('../img/g00',num2str(video_num));
    else
        path=strcat('../img/g0',num2str(video_num));
    end
    
    frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame
    
    bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround
   
    pathFolder = strcat(path, '/person*');
    persons = dir(pathFolder)';
    if video_num == 7 || video_num == 15
        num_persons = max(size((persons))) - 1;
    else
        num_persons = max(size((persons)));
    end

    for person_num = 1 : num_persons
        if person_num < 10
            path_person = strcat(path, '/person0', num2str(person_num));
        else
            path_person = strcat(path, '/person', num2str(person_num));
        end
        centralFrameDetector;
        normalizeCutAndTranslate;
        LBPTop;
    end
end


toc