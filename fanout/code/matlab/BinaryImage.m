function BinaryImage
% converts an image (here, MondaLisa) into greyscale, and then thrsholds to
% binary, then subsamples the image to make it smaller.
%

format compact

clc
tic

imgname = 'leaf-skeleton-800px.jpg';
figure(1)
subplot(1,2,1)
[rgb,map] = imread(imgname); %#ok<NASGU>
image(rgb); title('RGB image')
axis equal  tight

size(rgb)

gray = rgb2gray(rgb);

subplot(1,2,2)
image(gray); title('Grayscale image')
colormap gray
axis equal  tight

figure(2)
thresh = 100;
BW= gray>thresh;

subplot(1,2,1)
px = sum(sum(BW));
image(BW); title(['BW image, Thres = ',num2str(thresh),', ',num2str(px),'px'])
axis equal  tight
colormap([0,0,0;1,1,1])

subplot(1,2,2)

spac = 2;  % change this value to make bigger/smaller

BWsub = BW(1:spac:end,1:spac:end);
subpx = sum(sum(BWsub));
image(BWsub); title(['subsampled BW image, Thres = ',num2str(thresh),', ',num2str(subpx),'px'])
axis equal  tight
colormap([0,0,0;1,1,1])



toc
tic

%dist =  binaryEarthMoversDistance(BWsub,BWstartsub)
%dist =  binaryEarthMoversDistance(BWsub,flipud(BWstartsub))


toc
% imwrite(gray, 'MonaLisaGray.png')
 imwrite(BW, 'leafBW.png')
% imwrite(BWsub, 'MonaLisaBW3.png')
% imwrite(BWstart, 'MonaLisaBWstart.png')
% imwrite(BWstartsub, 'MonaLisaBWStartSub.png')