clear all;
w1 = 1; w2 = 10; w3 = 10;
myCouple1 = [];
myCouple2 = [];
k = 1;
upright = true;
nn = 32;
r = 3;
alpha = 0.00005;
l = 3;
for video_num = 1:22
    if(video_num < 10)
        pathFolder=strcat('../dataset/g00',num2str(video_num),'/p*');
    else
        pathFolder=strcat('../dataset/g0',num2str(video_num),'/p*');
    end
    
    disp(strcat('Video ', num2str(video_num)));
    persons = dir(pathFolder)';
    
    num_persons = max(size((persons)));

    for i = 1 : (num_persons)/2
        best_score = inf; best = 0;
        person = persons(i);
        path = strcat(person.folder,'/', person.name,'/');
        
        queryXY = imread(strcat(path, 'XYPlane.png'));
        queryXT = imread(strcat(path, 'XTPlane.png'));
        queryYT = imread(strcat(path, 'YTPlane.png'));
        
        queryLBPxy = extractLBPFeatures(queryXY,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
        queryLBPxt = extractLBPFeatures(queryXT,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
        queryLBPyt = extractLBPFeatures(queryYT,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
        queryLBP = [queryLBPxy queryLBPxt queryLBPyt];
        
        for j = (num_persons)/2 + 1 : num_persons
            
            person = persons(j);
            path = strcat(person.folder,'/', person.name,'/');
            galleryXY = fliplr(imread(strcat(path, 'XYPlane.png')));
            queryXT = fliplr(imread(strcat(path, 'XTPlane.png')));
            queryYT = fliplr(imread(strcat(path, 'YTPlane.png')));
            
            galleryLBPxy = extractLBPFeatures(galleryXY,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
            galleryLBPxt = extractLBPFeatures(queryXT,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
            galleryLBPyt = extractLBPFeatures(queryYT,'Upright', upright, 'NumNeighbors', nn, 'Radius', r);
            
            galleryLBP = [galleryLBPxy galleryLBPxt galleryLBPyt];
            %usare distanza chiquadro
    
    %   The chi-squared distance between two vectors is defined as:
    %    d(x,y) = sum( (xi-yi)^2 / (xi+yi) ) / 2;
    %   The chi-squared distance is useful when comparing histograms.
    
            %lbp = [(queryLBPxy-galleryLBPxy).^2, (queryLBPxt-galleryLBPxt).^2, (queryLBPyt-galleryLBPyt).^2];
            lbp = (queryLBP-galleryLBP).^2/(queryLBP+galleryLBP);
    
    %Le righe seguenti estraggono l informazione di altezza dal piano XY    
            s= floor(size(queryXY)./2);
            c1 = queryXY(s(1)-l:s(1)+l,s(2)-l:s(2)+l);
            h1 = mean(mean(c1));
            q= floor(size(galleryXY)./2);
            c2 = galleryXY(q(1)-l:q(1)+l,q(2)-l:q(2)+l);
            h2 = mean(mean(c2));
            
            
            meanD = sum(lbp)/2;
            couple(i,j) = meanD;
            meanD = sum(w1*(queryLBPxy-galleryLBPxy).^2 + w2*(queryLBPxt-galleryLBPxt).^2 + w3*(queryLBPyt-galleryLBPyt).^2)+abs(h1-h2)*alpha;
            
            if(meanD < best_score)
                best = j;
                best_score = meanD;
            end
        end
        disp(strcat(strcat(num2str(i), ' - '), num2str(best)));
        myCouple1(k) = i;
        myCouple2(k) = best;
        k = k + 1;
    end
    disp(' ');
end

myCouple1 = myCouple1';
myCouple2 = myCouple2';

score;