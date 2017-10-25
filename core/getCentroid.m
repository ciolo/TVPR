function [x, y] = getCentroid(frame)
    %padding perch? ritaglio l'immagine secondo il padding: levo i tavoli e
    %i bordi neri: nessuno mai ci camminer? sopra e causano solo rumore.
    padding_t = 135;
    padding_l = 35;
    padding_b = 115;
    padding_r = 15;
    %cerco di rimuovere il rumore dall'immagine e ottenere i punti massimi
    %e verosimili per l'altezza di una persona (il <3800).
    frame_n = imcomplement( frame(padding_t:480-padding_b, padding_l:640-padding_r) );
    
    %da qui a...
    R = 15;
    frame_n = imopen(frame_n, strel('disk', R));
    frame_n = imclose(frame_n, strel('disk', R));
    %... qui ? un alternativa a medfilt2(...[20 20])
    
    frame_n = frame_n.*uint16(frame_n < 38000);
    %ora cerco i punti massimi nell'immagine, e salvo le coordinate su row
    %e col
    frame_punto = uint16(frame_n == max(max(frame_n)));
    [row, col] = find(frame_punto);    
    %di questi pixel massimi, che sono la testa circa mi calcolo il
    %centroide, che pi? o meno ? la cocuzza. almeno non ? il pene.
    %riaggiungo i paddin per avere le coordinate del centroide rispetto a
    %tutta la scena
    x = floor(mean(row))+padding_t;
    y = floor(mean(col))+padding_l;
end