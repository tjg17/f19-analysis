%resizes f19
% clc;
% new_image = zeros(64,64,18,12);
% for timepoint = 1:12
%     for col = 1:64
%         slice = image(:,col,:);
%         slice = squeeze(slice);
%         slice_resized = imresize(slice,[64,18]);
%         new_image(:,col,:,timepoint) = slice_resized;
%     end
% end

pause(2)
imagetoshow = squeeze(new_image(:,:,:,2));
imshow(imagetoshow(:,:,1),[])
pause(0.3)
imshow(imagetoshow(:,:,2),[])
pause(0.3)
imshow(imagetoshow(:,:,3),[])
pause(0.3)
imshow(imagetoshow(:,:,4),[])
pause(0.3)
imshow(imagetoshow(:,:,5),[])
pause(0.3)
imshow(imagetoshow(:,:,6),[])
pause(0.3)
imshow(imagetoshow(:,:,7),[])
pause(0.3)
imshow(imagetoshow(:,:,8),[])
pause(0.3)
imshow(imagetoshow(:,:,9),[])
pause(0.3)
imshow(imagetoshow(:,:,10),[])
pause(0.3)
imshow(imagetoshow(:,:,11),[])
pause(0.3)
imshow(imagetoshow(:,:,12),[])
pause(0.3)
imshow(imagetoshow(:,:,13),[])
pause(0.3)
imshow(imagetoshow(:,:,14),[])
pause(0.3)
imshow(imagetoshow(:,:,15),[])
pause(0.3)
imshow(imagetoshow(:,:,16),[])
pause(0.3)
imshow(imagetoshow(:,:,17),[])
pause(0.3)
imshow(imagetoshow(:,:,18),[])