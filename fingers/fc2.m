hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Setup blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true, ...
                                'MinimumBlobArea', 3000, ...
                                'MaximumCount', 5);


    img1 = imread("1.jpeg");
    %img1 = flip(img1,2);
    img2 = rgb2gray(img1);                                                        
    lvl = graythresh(img2);                                                      
    img3 = imbinarize(img2, lvl);     
    img4 = bwareaopen(img3, 500);
    img5 = medfilt2(img4, [5 5]);
    img6 = imfill(img5,'holes');
    img7 = imtophat(img6,strel('disk',35));
    
    
%     img1 = imread("ofek.jpeg");
%     img2 = rgb2gray(img1);
%     lvl = graythresh(img2);
%     img3 = imbinarize(img2, lvl);
%     img7 = imtophat(img3,strel('disk',10));
    [cc_2,bb_2] = step(hblob,img7);    %fingers
    [B,L] = bwboundaries(img7, 'noholes');
    nof = num2str(size(bb_2,1));
    nof1 = size(bb_2,1);
    nof1
    CHAR_STR = '  not identified';