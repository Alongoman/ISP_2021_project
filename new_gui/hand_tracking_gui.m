%Config:
clc
clear
close all
pc_cam = "FaceTime HD Camera (Built-in)";
microsoft_cam = "Microsoft® LifeCam HD-3000";
cur_cam = microsoft_cam;
warning('off');
camera='Microsoft® LifeCam HD-3000';
handles.webcam=webcam(camera);
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
finger_history_len = 7;
finger_history = zeros(1,finger_history_len);
img=snapshot(handles.webcam);
[img_height, img_width ,spectrum] = size(img);
board = ones(img_height, img_width,3);
fh = figure(1);
fh.WindowState = 'maximized';
imshow(board,[]);
painterx_scale = img_width;
paintery_scale = img_height;

prev_x = 1;
prev_y = 1;
prev_px = 1;
prev_py = 1;


while 1
    try
        
        img=(snapshot(handles.webcam));
        [hue,sat,v]=rgb2hsv(img);
        v_mask=(v>0.25);
        handles.hand.old_BB=handles.hand.BB;
        handles=find_bracelet_hs(handles,v_mask.*hue,v_mask.*sat);
        if handles.bracelet.BB(1)~=0
            handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat);
            
            [finger_num, center_of_mass] = count_fingers(handles.hand.mask);
            BB_hand = handles.hand.BB;
            center_of_mass(1) = center_of_mass(1) + BB_hand(1);
            center_of_mass(2) = center_of_mass(2) + BB_hand(2);
            
            finger_history = circshift(finger_history,1);
            finger_history(1) = finger_num;
            
            finger_num = mode(finger_history);
            [px, py] = scale_pointer(center_of_mass(1), center_of_mass(2), img_width, img_height, prev_x, prev_y,painterx_scale,paintery_scale);
            %             px = px+prev_px;
            %             py = py+prev_py;
            prev_px = px;
            prev_py = py;
            prev_x = center_of_mass(1);
            prev_y = center_of_mass(2);
            px = img_width - px;
            [board,color] = painter(board, [px,py], finger_num);
            %             imshow(handles.hand.mask,[], 'Parent', gui_handles.ax2);
            %drawnow;
            %             if handles.hand.BB(1)~=0
            %                 img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
            %             end
            %imshow(uint8(painter),[], 'Parent', gui_handles.ax1)
            
            
            subplot(2,2,[1,3])
            imshow(board,[], 'XData',[1,painterx_scale], 'YData',[1 paintery_scale]);
            title("Your Color","Color",color, 'FontSize',40)
            
            hold on
            plot(px,py,'b+','MarkerSize',15,'LineWidth',3);
            hold off
            [mask_height,mask_width] = size(handles.hand.mask);
            pad_mask = handles.hand.mask;%padarray(handles.hand.mask,max(0,500-mask_height),max(0,500-mask_width));
            subplot(2,2,4)
            imshow(flip(pad_mask,2),[]);
            title("finger num:" + num2str(finger_num), 'FontSize',40)
            
            subplot(2,2,2)
            imshow(flip(img,2),[])
            hold on
            plot(img_width-center_of_mass(1),center_of_mass(2),'b+','MarkerSize',15,'LineWidth',3);
            hold off
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

function [px,py] = scale_pointer(x,y,size_x,size_y, prev_x, prev_y,painterx_scale,paintery_scale)
px=x;
py=y;

% sizing_factor_x = 1;
% sizing_factor_y = 1;
% 
% px =  sizing_factor_x*(x-prev_x);
% py =  sizing_factor_y*(y-prev_y);

px = uint16((painterx_scale-1)\(size_x-1)*(px-1)+1);
py = uint16((paintery_scale-1)\(size_y-1)*(py-1)+1);

px = max(1, min([px,painterx_scale]));
py = max(1, min([py,paintery_scale]));

px=x;
py=y;
end
