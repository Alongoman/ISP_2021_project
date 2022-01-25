%Config:
clc
clear
close all

warning('off');
handles.webcam=webcam('Microsoft® LifeCam HD-3000');
handles.wait_for_continue = 0;
img=snapshot(handles.webcam);
gui_handles.fig = figure('Name','The Visual Mouse',...
    'Position', [150, 100, 1500, 1000],...
    'NumberTitle','off');
gui_handles.ax1 = subplot(2,1,1);
gui_handles.ax2 = subplot(2,1,2);
%gui_handles.ax1.Position = [0.1 0.4 0.7 0.5];
%gui_handles.ax2.Position = [0.4 0.05 0.3 0.3];
sgtitle('The Visual Mouse', 'FontSize', 32);
gui_handles.capture = uicontrol('style','pushbutton','string','capture',...
    'Position',[1200, 500, 150, 80], 'FontSize',16);
gui_handles.start = uicontrol('style','pushbutton','string','Start \ Restart',...
    'Position',[1200, 600, 150, 80], 'FontSize',16);
gui_handles.continue = uicontrol('style','pushbutton','string','Continue',...
    'Position',[1200, 400, 150, 80], 'FontSize',16);
gui_handles.stop = uicontrol('style','pushbutton','string','Stop',...
    'Position',[1200, 300, 150, 80], 'FontSize',16);
gui_handles.state = 0;
guidata(gui_handles.fig,gui_handles);
gui_handles.capture.Callback = {@capture_callback};
gui_handles.start.Callback = {@start_callback};
gui_handles.continue.Callback = {@continue_callback};
gui_handles.stop.Callback = {@stop_callback};
main_loop(gui_handles.fig,handles);

function main_loop(parent,handles)
    gui_handles = guidata(parent);
        while gui_handles.state ~= 4
        gui_handles = guidata(parent);
        pause(0.15)
        switch gui_handles.state
            case 0 %before start
            case 1 %staret/restart
                handles = start_function(gui_handles,handles);
            case 2 %capture
                if ~handles.wait_for_continue
                    handles = capture_function(gui_handles,handles);
                else
                end
            case 3 %continue
                handles = continue_function(gui_handles,handles);
            case 4  %exit
                closereq();
        end
        end
end

function handles = start_function(gui_handles,handles)
    img=snapshot(handles.webcam);
    imshow(img,[],'Parent', gui_handles.ax1)
    handles.wait_for_continue = 0;
end

function handles = capture_function(gui_handles,handles)
    img=snapshot(handles.webcam);
    imshow(img,[], 'Parent', gui_handles.ax1)
    init_point = ginput(1);
    handles = initial_bracelet_rep_hs(handles,img,init_point,'green');
    [handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img);
    img2=insertShape(img,'Rectangle',handles.bracelet.BB,'Color','red','LineWidth',5);
    img2=insertShape(img2,'Rectangle',first_time_hand_BB,'Color','blue','LineWidth',5);
    imshow(img2,[],'Parent', gui_handles.ax1)
    handles.wait_for_continue = 1;
end

function handles = continue_function(gui_handles,handles)
    for i = 1:1
        img=(snapshot(handles.webcam));
        [hue,sat,v]=rgb2hsv(img);
        v_mask=(v<0.95).*(v>0.05);
        handles.hand.old_BB=handles.hand.BB;
        handles=find_bracelet_hs(handles,v_mask.*hue,v_mask.*sat);
        if handles.bracelet.BB(1)~=0
            handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat);
            imshow(handles.hand.mask,[], 'Parent', gui_handles.ax2)
            if handles.hand.BB(1)~=0
                img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
            end
            imshow(uint8(img2),[], 'Parent', gui_handles.ax1)
            hold on
            plot(handles.bracelet.center(1),handles.bracelet.center(2),'b+','MarkerSize',15,'LineWidth',3)
            hold off
        end
    end
end


function start_callback(hObject, eventdata)
    gui_handles = guidata(hObject.Parent);
    gui_handles.state = 1;
    guidata(hObject.Parent,gui_handles);
end

function capture_callback(hObject, eventdata)
    gui_handles = guidata(hObject.Parent);
    gui_handles.state = 2;
    guidata(hObject.Parent,gui_handles);
end

function continue_callback(hObject, eventdata)
    gui_handles = guidata(hObject.Parent);
    gui_handles.state = 3;
    guidata(hObject.Parent,gui_handles);
end

function stop_callback(hObject, eventdata)
    gui_handles = guidata(hObject.Parent);
    gui_handles.state = 4;
    guidata(hObject.Parent,gui_handles);
end