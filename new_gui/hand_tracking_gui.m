%Config:
clc
clear
close all
pc_cam = "FaceTime HD Camera (Built-in)";
microsoft_cam = "Microsoft® LifeCam HD-3000";
cur_cam = pc_cam;
warning('off');

handles.webcam=webcam(cur_cam);
if(cur_cam == pc_cam)
    pause(1);
end
handles.wait_for_continue = 0;
img= snapshot(handles.webcam);
% if(cur_cam ==pc_cam )
%     pause(2);
% end
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
                       'String','Restart',...
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
                       'String','Start',...
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
    finger_history_len = 5;
    finger_history = zeros(1,finger_history_len);
    img=snapshot(handles.webcam);
    [img_height, img_width ,spectrum] = size(img);
    board = ones(img_height, img_width,3);
    fh = figure(1);
    fh.WindowState = 'maximized';

    imshow(board,[])
    

    while 1
        try
        
        img=(snapshot(handles.webcam));
        [hue,sat,v]=rgb2hsv(img);
        v_mask=(v<0.95).*(v>0.05);
        handles.hand.old_BB=handles.hand.BB;
        handles=find_bracelet_hs(handles,v_mask.*hue,v_mask.*sat);
        if handles.bracelet.BB(1)~=0
            handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat);

            [finger_num, center_of_mass] = count_fingers(handles.hand.mask);

            finger_history = circshift(finger_history,1);
            finger_history(1) = finger_num;

            finger_num = mode(finger_history);
            [px, py] = scale_pointer(center_of_mass(1),center_of_mass(2),img_width, img_height);
            px = img_width - px;
            board = painter(board, [px,py], finger_num);
%             imshow(handles.hand.mask,[], 'Parent', gui_handles.ax2);
            %drawnow;
%             if handles.hand.BB(1)~=0
%                 img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
%             end
            %imshow(uint8(painter),[], 'Parent', gui_handles.ax1)
            

            subplot(2,2,[1,3])
            imshow(board(1:floor(img_height*2/3),:,:),[])
           

            title("finger num:" + num2str(finger_num), 'FontSize',30)
            hold on
            plot(px,py,'b+','MarkerSize',15,'LineWidth',3);
            hold off
            [mask_height,mask_width] = size(handles.hand.mask);
            pad_mask = handles.hand.mask;%padarray(handles.hand.mask,max(0,500-mask_height),max(0,500-mask_width));
            subplot(2,2,4)
            imshow(flip(pad_mask,2),[]);
             fh.WindowState = 'maximized';







        end
        catch e
            disp(e)
            disp(e.stack(1))
            title("error detected",'FontSize',30,'Color','red');
        end
    end
end


function [gui_handles, handles] = calibration_loop(parent,handles)
    gui_handles = guidata(parent);
        while ~get(gui_handles.stop,'Value')
            gui_handles = guidata(parent);
            switch gui_handles.bg.SelectedObject.String
                case 'Restart'
                    handles = start_function(gui_handles,handles);
                case 'Capture'
                    if ~handles.wait_for_continue
                        handles = capture_function(gui_handles,handles);
                    else
                        pause(0.1);
                    end
                case 'Start'
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

function [x,y] = scale_pointer(px,py,size_x,size_y)
y = py;
x = px;
sizing_factor_x = 1.5;
sizing_factor_y = 2;

img_center_x = floor(size_x/2);
img_center_y = floor(size_y/2);

% x = img_center_x + sizing_factor_x*(px - img_center_x);
y = img_center_y + sizing_factor_y*(py - img_center_y) ;

x = max(0, min([x,size_x]));
y = max(0, min([y,size_y]));
end
