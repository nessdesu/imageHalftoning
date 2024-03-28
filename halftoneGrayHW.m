I = imread('cameraman.tif');
I2 = imread('face.tif');
I3 = imread('crowd.tif');
% uint8 ile image pixellerini uygun bir sekilde 0-255 degerleri arasinda
% almamiza yardimci oluyor
output1 = halftoneGray(uint8(I));
output2 = halftoneGray(uint8(I2));
output3 = halftoneGray((uint8(I3)));

%% Sirasiyla image adi ve end of comment arasindaki yorum satirlarini kaldirip ilgili imageleri gorebilirsiniz
% -- cameraman.tif --
%subplot(1,2,1);
%imshow(I);
%title('Original Image')
%subplot(1,2,2);
%imshow(output1);
%title('Halftone Gray Image')
%imwrite(output1, 'cameraman.png');
% -- end of comment --

% -- face.tif --
%subplot(1,2,1);
%imshow(I2);
%title('Original Image')
%subplot(1,2,2);
%imshow(output2);
%title('Halftone Gray Image')
%imwrite(output2, 'face.png');
% -- end of comment --

% -- crowd.tif --
subplot(1,2,1);
imshow(I3);
title('Original Image')
subplot(1,2,2);
imshow(output3);
title('Halftone Gray Image')
imwrite(output3, 'crowd.png');
% -- end of comment --

function output = halftoneGray(I)
[x,y] = size(I);  %image boyutunda bir matris olusturuyoruz
% bu matrisin 3 ve 3un katlarinda olmasini sagliyoruz; bunun sebebi siyah ve
% beyazdan olusan patternlerimiz 3x3luk matrislerde gosteriliyor, boylece
% image icerisindeki her bir pixelimiz 3x3luk matris haline getiriliyor.
xp = ceil(x/3)*3; 
yp = ceil(y/3)*3;

Image = 255*ones(xp,yp);
Image(1:x,1:y) = I;

s = 3;
pattern = zeros(s,s,s*s+1); %yukseklik, genislik ve toplam pattern sayisi
% 3x3'luk bir matriste (3*3)+1 = 10 adet pattern bulunmaktadir.

%patternler buradan basliyor. image boyutuna gore 10 adet patternimiz var
% 0lar siyahlari 255 ise beyazlari temsil ediyor, bu sekilde yuklenen
% resimin pixellerindeki degere gore siyah ve beyazlardan olusan matrisler
% ilgili pixellere yerlestiriliyor ve resim bu patternler dogrultusunda
% sekil aliyor
pattern(:,:,1) = [0 0 0; 0 0 0; 0 0 0];
pattern(:,:,2) = [0 255 0;0 0 0; 0 0 0];
pattern(:,:,3) = [0 255 0;0 0 0; 0 0 255];
pattern(:,:,4) = [255 255 0;0 0 0; 0 0 255];
pattern(:,:,5) = [255 255 0;0 0 0; 255 0 255];
pattern(:,:,6) = [255 255 255;0 0 0; 255 0 255];
pattern(:,:,7) = [255 255 255;0 0 255; 255 0 255];
pattern(:,:,8) = [255 255 255;0 0 255; 255 255 255];
pattern(:,:,9) = [255 255 255;255 0 255; 255 255 255];
pattern(:,:,10)= [255 255 255;255 255 255; 255 255 255];

newImg = zeros(x,y);  %sifirlardan olusan bir matris olusturuyoruz, boylece pixellerin hangi patterne karsilik geldigini tutabiliriz

% ic ice iki for kullanarak 3x3luk matrisimizin icerisinde dolasiyoruz.
for i=1:xp/3
    for j=1:yp/3
    % pixelin hangi patterne karsilik geldigini buluyoruz.
    avgInImage = mean(mean(Image((i*3-2):(i*3),(j*3-2):(j*3))));
    pn = ceil(avgInImage/(256/(s*s+1)));
    % patterni yerlestirerek image i olusturuyoruz
    newImg((i*3-2):(i*3),(j*3-2):(j*3)) = pattern(:,:,pn);
    end
end
newImg = uint8(newImg); %image i uint8 formatina ceviriyoruz.
output = newImg(1:x,1:y); %halftone haline getirilen image'i orijinal boyuta gore sakliyoruz.
end