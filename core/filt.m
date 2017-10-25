function filtered_img = filt(img, R)
padding_t = 160;
padding_l = 35;
padding_b = 115;
padding_r = 15;
%cerco di rimuovere il rumore dall'immagine e ottenere i punti massimi
%e verosimili per l'altezza di una persona (il <3800).
filtered_img = imcomplement( img(padding_t:480-padding_b, padding_l:640-padding_r) );

%da qui a...
filtered_img = imopen(filtered_img, strel('disk', R));
filtered_img = imclose(filtered_img, strel('disk', R));
end