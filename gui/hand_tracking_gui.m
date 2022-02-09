%Config:
clc
clear
close all

warning('off');
h.webcam=webcam('Microsoft® LifeCam HD-3000');
img=snapshot(h.webcam);
h.fig = figure('Name','The Visual Mouse',...
    'Position', [150, 100, 1500, 1000],...
    'NumberTitle','off');
h.ax1 = subplot(2,1,1);
h.ax2 = subplot(2,1,2);
h.ax1.Position = [0.1 0.4 0.7 0.5];
h.ax2.Position = [0.4 0.05 0.3 0.3];
sgtitle('The Visual Mouse', 'FontSize', 32);
h.capture = uicontrol('style','pushbutton','string','capture',...
    'Position',[1200, 500, 150, 80], 'FontSize',16);
h.start = uicontrol('style','pushbutton','string','Start \ Restart',...
    'Position',[1200, 600, 150, 80], 'FontSize',16);
h.continue = uicontrol('style','pushbutton','string','Continue',...
    'Position',[1200, 400, 150, 80], 'FontSize',16);
h.stop = uicontrol('style','pushbutton','string','Stop',...
    'Position',[1200, 300, 150, 80], 'FontSize',16);
h.wait = 1;
handles.run = 0;
guidata(h.fig,h);
h.capture.Callback = {@capture_callback};
h.start.Callback = {@start_callback};
h.continue.Callback = {@continue_callback};
h.stop.Callback = {@stop_callback};

function capture_callback(hObject, eventdata)
    handles = guidata(hObject.Parent);
    handles.start.Value = 0;
    handles.wait = 0;
    img=snapshot(handles.webcam);
    axes(handles.ax1);
    imshow(img,[])
    init_point = ginput(1);
    handles = initial_bracelet_rep_hs(handles,img,init_point,'green');
    [handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img);
    img2=insertShape(img,'Rectangle',handles.bracelet.BB,'Color','red','LineWidth',5);
    img2=insertShape(img2,'Rectangle',first_time_hand_BB,'Color','blue','LineWidth',5);
    imshow(img2,[]);
    drawnow;
    guidata(hObject.Parent,handles);
    pause(30);
end

function start_callback(hObject, eventdata)
    handles = guidata(hObject.Parent);
    figure(handles.fig);
    axes(handles.ax1);
    while handles.wait == 1
        img=snapshot(handles.webcam);
        imshow(img,[]);
        drawnow;
        guidata(hObject.Parent,handles);
    end
end

function continue_callback(hObject, eventdata)
    handles = guidata(hObject.Parent);
    handles.run = 1;
    guidata(hObject.Parent,handles);
    while handles.run == 1
        handles = guidata(hObject.Parent);
        img=(snapshot(handles.webcam));
        [hue,sat,v]=rgb2hsv(img);
        v_mask=(v<0.95).*(v>0.05);
        handles.hand.old_BB=handles.hand.BB;
        handles=find_bracelet_hs(handles,hue,sat);
        if handles.bracelet.BB(1)~=0
            handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat);
            finger_num = count_fingers(handles.hand.mask);

            imshow(handles.hand.mask,[],'Parent', handles.ax2);
            drawnow;
            if handles.hand.BB(1)~=0
                img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
            end
            imshow(uint8(img2),[],'Parent', handles.ax1)
                        title("finger num:" + num2str(finger_num), 'FontSize',64)

            hold on
            plot(handles.bracelet.center(1),handles.bracelet.center(2),'b+','MarkerSize',15,'LineWidth',3)
            hold off
            drawnow;
        end
        guidata(hObject.Parent,handles);
    end
end

function stop_callback(hObject, eventdata)
    handles = guidata(hObject.Parent);
    handles.run = 0;
    handles.wait = 0;
    guidata(hObject.Parent,handles);
    close gcf;
end