%Config:
clc
clear
close all

warning('off');
handles.webcam=webcam('Microsoft® LifeCam HD-3000');
img=snapshot(handles.webcam);
handles.fig = figure('Name','The Visual Mouse',...
     'Position', [150, 100, 1500, 1000],...
     'NumberTitle','off');
handles.ax1 = subplot(2,1,1);  
handles.ax2 = subplot(2,1,2);
% handles.ax1.Position = [0.1 0.4 0.7 0.5];
% handles.ax2.Position = [0.4 0.05 0.3 0.3];
sgtitle('The Visual Mouse', 'FontSize', 32);
handles.capture = uicontrol('style','pushbutton','string','capture',...
     'Position',[1200, 500, 150, 80], 'FontSize',16);
handles.start = uicontrol('style','pushbutton','string','Start \ Restart',...
     'Position',[1200, 600, 150, 80], 'FontSize',16);
handles.continue = uicontrol('style','pushbutton','string','Continue',...
     'Position',[1200, 400, 150, 80], 'FontSize',16);
handles.stop = uicontrol('style','pushbutton','string','Stop',...
     'Position',[1200, 300, 150, 80], 'FontSize',16);

% Initial 
handles.start.Value = 0;
handles.wait = 0;
img=snapshot(handles.webcam);
imshow(img,[], 'Parent', handles.ax1)
init_points = ginput(2);
handles = initial_bracelet_rep_hs(handles,img,init_points,'green');
[handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img,init_points);
img2=insertShape(img,'Rectangle',handles.bracelet.BB,'Color','red','LineWidth',5);
img2=insertShape(img2,'Rectangle',first_time_hand_BB,'Color','blue','LineWidth',5);
imshow(img2,[],'Parent', handles.ax1)
pause(1);
count=0;

%Main Loop
while 1
    img=(snapshot(handles.webcam));
    [hue,sat,v]=rgb2hsv(img);
    v_mask=(v<0.95).*(v>0.05);
    handles.hand.old_BB=handles.hand.BB;
    handles=find_bracelet_hs(handles,v_mask.*hue,v_mask.*sat);
    if handles.bracelet.BB(1)~=0
        handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat);
        imshow(handles.hand.mask,[], 'Parent', handles.ax2)
        if handles.hand.BB(1)~=0
            img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
        end
        imshow(uint8(img2),[], 'Parent', handles.ax1)
        hold on
        plot(handles.bracelet.center(1),handles.bracelet.center(2),'b+','MarkerSize',15,'LineWidth',3)
        hold off
    else
        count=count+1
    end
end
