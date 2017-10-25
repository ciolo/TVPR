tic
for video_num = 1:22
    if(video_num < 10)
        path=strcat('../img/g00',num2str(video_num));
    else
        path=strcat('../img/g0',num2str(video_num));
    end
    
    frame_names = dir(strcat(path,'/*.png')); %salvo qui tutti i frame
    
    bg_frame = imread( strcat(path,'/frame00000.png') ); %assegno frame di backGround

    raw_bg_mask = bg_frame < mean(mean(bg_frame));
    %the following is a more step to improve precision: deleted areas 
    %"unwalkable" that can cause only noise.
    bg_mask = raw_bg_mask(125:380, 35:625);
    
    interruption = 0;
    person_in_scene = 0;
    person_count = 0;
    %assegna a frame_name un elemento di frame_names alla volta ciclando
    for frame_name = frame_names'

        %concateno 2 stringa: 1. Nome cartella del frame, 2. Nome frame
        path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
        
        %lo leggo per avere l'immagine vera e propria
        frame = imread(path_to_frame);
        
        raw_mask = frame < mean(mean(bg_frame));
        mask = raw_mask(125:380, 35:625);
        
        if sum(sum(mask)) > 3000
            if ~person_in_scene
                interruption = 0;
                person_in_scene = 1;
                %waitforbuttonpress
                person_count = person_count + 1;
                %Creo una nuova Cartella
                if person_count < 10
                    person_folder = strcat('/person0', num2str(person_count));
                else
                    person_folder = strcat('/person', num2str(person_count));
                end
                mkdir(path, person_folder);
                
            end
        elseif person_in_scene
            interruption = interruption + 1;
        end
        if interruption > 3
            interruption = 0;
            person_in_scene = 0;
        end
        
        if person_in_scene
           imwrite( frame, strcat(path, person_folder, '/', frame_name.name) );
        end
    end

end
toc