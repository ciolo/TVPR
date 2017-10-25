frame_names = dir(strcat(path_person,'/*.png'));
new_folder = '/Normalized';
mkdir(path_person, new_folder);
new_path = strcat(strcat(path_person, new_folder), '/');
iteration = 0; %per distinguere il primo frame, che sar?? semopre quello centrale.
centroids_x = []; % forse non ?? necessario salvare qui i centroidi!! Anzi ne sono quasi sicuro
centroids_y = [];
finish = false;
for frame_name = frame_names'
    if finish == false
        
        %carico frame
        path_to_frame = strcat(frame_name.folder,'/', frame_name.name);
        frame = imread(path_to_frame);
        
        %ricavo la persona dal background e la filtro in modo da avere
        %una sagoma bianca del soggetto.
        person = imsubtract(bg_frame,frame);
        filtered_person = (person > 13000); %pi?? ?? alto e pi?? sono precisi i centroidi, ma si vengono a creare vari problemi
        
        %filtered_person = medfilt2(filtered_person, [10 10]);
        filtered_person = filt(filtered_person, 30);
%         
        %essendoci del rumore, a volte avremo alcune aree bianche che
        %potrebbero dare problemi nel calcolo del rettangolo massimo che
        %vogliamo usare. Allora, calcolo le regioni connesse dell'immagine, per
        %ogni regione calcolo l'area e la metto in un vettore. Tendenzialmente
        %mi aspetto che l'area maggiore sia quella della persona: quindi,
        %calcolo l'indice della regione con area massima, e poich? la regione
        %dell'uomo sar? sconnessa da quella dei rumori eventuali, l'indice
        %calcolato corrispender? al numero utilizzato per identificare la
        %regione del soggetto mediante funzione bwlabel.
        %quindi creo la nuova immagine senza rumore (righe 33, 34).
        
        %connected_region = bwlabel(filtered_person);
        %areas = regionprops(connected_region, 'Area');
        %areas_vector = [areas(:).Area];
        %[max_area, max_index] = max(areas_vector);
        
        [rows,cols,found] = find(filtered_person == 0);
        
        % non uso connectedregion perch? anche se ? quella che voglio, magari
        % era la regione contrassegnata da un numero diverso da 1, ma io in bw
        % voglio solo 1 e 0.
        
%         bw = zeros(size(filtered_person));
%         bw(rows,cols) = filtered_person(rows, cols);
%         
%         
%         s = regionprops(bw,'centroid');

        [cY, cX] = getCentroid(frame);
        
        %salvarli tutti forse non serve a nulla???
        %centroids_x = cat(1, centroids_x, cX);
        %centroids_y = cat(1, centroids_y, cY);
        
        
        
        if iteration == 0
            x_min = min(cols);
            x_max = max(cols);
            
            x_window = (x_max - x_min) + 90;
            
            y_min = min(rows);
            y_max = max(rows);
            
            y_window = (y_max - y_min) + 60;
            
            new_frame = frame(floor(cY(length(cY)) - y_window/2) : ...
                floor(cY(length(cY)) + y_window/2), ...
                floor(cX(length(cY)) - floor(x_window/2)) : ...
                floor(cX(length(cY)) + x_window/2));
            frame_id = 'centralFrame.png';
            
            imwrite( new_frame, strcat(new_path, frame_id));
            central_min = frame(cY, cX);
            iteration = iteration + 1;
            
            %forse non zerve il -+ x_window/2
        elseif  floor(cX(length(cY))) > floor(x_window/2) && ...
                floor(cX(length(cY))) <= floor((max(size(frame)) - x_window/2))
                
            new_frame = frame(floor(cY(length(cY)) - y_window/2) : ...
                floor(cY(length(cY)) + y_window/2), ...
                floor(cX(length(cY)) - floor(x_window/2)) : ...
                floor(cX(length(cY)) + x_window/2));
            
            
            %[i,j,frame_min] = find(new_frame);
            frame_min = frame(cY, cX);
            
            N = double(central_min)/double(frame_min);
            new_frame = N*new_frame;
            if iteration < 10 
                frame_id = strcat('frame00', num2str(iteration), '.png');
            elseif iteration < 100
                frame_id = strcat('frame0', num2str(iteration), '.png');
            else
                frame_id = strcat('frame', num2str(iteration), '.png');
            end
            
            imwrite(new_frame, strcat(new_path, frame_id)); 
            iteration = iteration + 1;
                 
        elseif floor(cX(length(cY))) > (max(size(frame)) - x_window/2)...
                && person_num <= num_persons/2
            finish = true;
        elseif floor(cX(length(cY))) <= x_window/2 ...
                && person_num > num_persons/2
            finish = true;
        end
    end
end