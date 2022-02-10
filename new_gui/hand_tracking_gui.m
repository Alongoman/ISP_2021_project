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
gui_handles.bg = uibuttongroup('Parent',gui_handles.fig,...
                                    'HandleVisibility','on',...
                                    'Title','States:',...
                                    'Units','pixels',...
                                    'FontSize',16,...
                                    'Position',[1250,500,201,251]);
gui_handles.start = uicontrol(gui_handles.bg,...
                       'Style','radiobutton',...
                       'String','Start / Restart',...
                       'Position',[13,161,191,41],...
                       'FontSize',16,...
                       'HandleVisibility','on');
gui_handles.capture = uicontrol(gui_handles.bg,...
                       'Style','radiobutton',...
                       'String','Capture',...
                       'Position',[13,111,191,41],...
                       'FontSize',16,...
                       'HandleVisibility','on');
gui_handles.continue = uicontrol(gui_handles.bg,...
                       'Style','radiobutton',...
                       'String','Continue',...
                       'Position',[13,61,191,41],...
                       'FontSize',16,...
                       'HandleVisibility','on');
gui_handles.stop = uicontrol(gui_handles.bg,...
                       'Style','radiobutton',...
                       'String','Stop',...
                       'Position',[13,11,191,41],...
                       'FontSize',16,...
                       'HandleVisibility','on');
gui_handles.state = 0;
set(gui_handles.bg, 'Visible', 'on');
set(gui_handles.bg,'SelectedObject',gui_handles.start)
guidata(gui_handles.fig,gui_handles);
[gui_handles, handles] = calibration_loop(gui_handles.fig,handles);
main_loop(gui_handles, handles);

function handles = main_loop(gui_handles,handles)
    figure(1);
    finger_history_len = 5;
    finger_history = zeros(1,finger_history_len);
    img=(snapshot(handles.webcam));
    painter = ones(size(img));
    disp(size(painter))
    while 1
        img=(snapshot(handles.webcam));
        [hue,sat,v]=rgb2hsv(img);
        v_mask=(v<0.95).*(v>0.05);
        handles.hand.old_BB=handles.hand.BB;
        handles=find_bracelet_hs(handles,v_mask.*hue,v_mask.*sat);
        if handles.bracelet.BB(1)~=0
            handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat);
            finger_num = count_fingers(handles.hand.mask);
            finger_history = circshift(finger_history,1);
            finger_history(1) = finger_num;
            finger_num = mode(finger_history);
            painter = plot_on_image(painter, handles.bracelet.center, finger_num);
%             imshow(handles.hand.mask,[], 'Parent', gui_handles.ax2);
            %drawnow;
%             if handles.hand.BB(1)~=0
%                 img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
%             end
            %imshow(uint8(painter),[], 'Parent', gui_handles.ax1)
            imshow(painter,[])

            title("finger num:" + num2str(finger_num), 'FontSize',20)
            hold on
            plot(handles.bracelet.center(1),handles.bracelet.center(2),'b+','MarkerSize',15,'LineWidth',3);
            hold off
            drawnow;
        end
    end
end


function [gui_handles, handles] = calibration_loop(parent,handles)
    gui_handles = guidata(parent);
        while ~get(gui_handles.stop,'Value')
            gui_handles = guidata(parent);
            switch gui_handles.bg.SelectedObject.String
                case 'Start / Restart'
                    handles = start_function(gui_handles,handles);
                case 'Capture'
                    if ~handles.wait_for_continue
                        handles = capture_function(gui_handles,handles);
                    else
                        pause(0.1);
                    end
                case 'Continue'
                    close(gui_handles.fig)
                    return;
                case 'Stop'
                    closereq();
                    pause(0.1);
            end
        end
end

function handles = start_function(gui_handles,handles)
    img=snapshot(handles.webcam);
    imshow(img,[],'Parent', gui_handles.ax1);
    drawnow;
    handles.wait_for_continue = 0;
end

function handles = capture_function(gui_handles,handles)
    img=snapshot(handles.webcam);
    imshow(img,[], 'Parent', gui_handles.ax1)
    init_points = ginput(2);
    handles = initial_bracelet_rep_hs(handles,img,init_points,'green');
    [handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img,init_points);
    img2=insertShape(img,'Rectangle',handles.bracelet.BB,'Color','red','LineWidth',5);
    img2=insertShape(img2,'Rectangle',first_time_hand_BB,'Color','blue','LineWidth',5);
    imshow(img2,[],'Parent', gui_handles.ax1)
    drawnow;
    handles.wait_for_continue = 1;
end


