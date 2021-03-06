%Config:
clc
clear
close all
pc_cam = "FaceTime HD Camera (Built-in)";
microsoft_cam = "MicrosoftÂ® LifeCam HD-3000";
cur_cam = pc_cam;
warning('off');
handles.webcam=webcam(cur_cam);
if(cur_cam ==pc_cam )
    pause(1);
end
handles.harsh = 0; % will force other conditions for the algorithm
handles.wait_for_continue = 0;
img= snapshot(handles.webcam);

gui_handles.fig = figure('Name','The Virtual Mouse',...
    'Position', [0, 0, 1500, 1000],...
    'NumberTitle','off');
gui_handles.ax1 = subplot(2,1,1);
gui_handles.ax2 = subplot(2,1,2);

%gui_handles.ax1.Position = [0.1 0.4 0.7 0.5];
%gui_handles.ax2.Position = [0.4 0.05 0.3 0.3];
sgtitle('The Virtual Mouse', 'FontSize', 32);
gui_handles.bg = uibuttongroup('Parent',gui_handles.fig,...
    'HandleVisibility','on',...
    'Title','States:',...
    'Units','pixels',...
    'FontSize',16,...
    'Position',[1250,500,201,280]);
gui_handles.start = uicontrol(gui_handles.bg,...
    'Style','radiobutton',...
    'String','Restart',...
    'Position',[13,211,191,41],...
    'FontSize',16,...
    'HandleVisibility','on');
gui_handles.captureLeft = uicontrol(gui_handles.bg,...
    'Style','radiobutton',...
    'String','Capture lefthand',...
    'Position',[13,161,191,41],...
    'FontSize',16,...
    'HandleVisibility','on');
gui_handles.captureRight = uicontrol(gui_handles.bg,...
    'Style','radiobutton',...
    'String','Capture righthand',...
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
instructions = imread("instructions.jpeg");
imshow(instructions,[],'Parent', gui_handles.ax2);
[gui_handles, handles] = calibration_loop(gui_handles.fig,handles);
main_loop(gui_handles, handles);


function handles = main_loop(gui_handles,handles)
finger_arr_hist = [];
finger_arr = [];
isLeft = handles.isLeft;
color = reshape([1,1,1],[1,1,3]);
finger_history_len = 7;
finger_history = zeros(1,finger_history_len);
finger_history2 = zeros(1,finger_history_len);
img=snapshot(handles.webcam);
[img_height, img_width ,spectrum] = size(img);
board = ones(img_height, img_width,3);
instruction2 = imread("instruction2.jpeg");
fh = figure(1);
fh.WindowState = 'maximized';
subplot(2,2,3)
imshow(instruction2);
title("instructions");


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
            handles = find_hand_hsv(handles,v_mask.*hue,v_mask.*sat,v_mask.*v, isLeft);
            if handles.harsh
                handles.hand.mask = fix_hand_mask(handles);
            end
            handles = find_palm_center(handles);
            [finger_num, center_of_mass] = count_fingers(handles);

            BB_hand = handles.hand.BB;
            center_of_mass(1) = center_of_mass(1) + BB_hand(1);
            center_of_mass(2) = center_of_mass(2) + BB_hand(2);
            
            finger_history = circshift(finger_history,1);
            finger_history(1) = finger_num;
            actual_finger = finger_num;
            finger_num_tmp = mode(finger_history);

            finger_history2 = circshift(finger_history2,1);
            finger_history2(1) = finger_num_tmp;
            
            finger_num = mode(finger_history2);
            [px, py] = scale_pointer(center_of_mass(1), center_of_mass(2), img_width, img_height, prev_x, prev_y,painterx_scale,paintery_scale);
            %             px = px+prev_px;
            %             py = py+prev_py;
            prev_px = px;
            prev_py = py;
            prev_x = center_of_mass(1);
            prev_y = center_of_mass(2);
            px = img_width - px;
            [board,color] = painter(board, [px,py], finger_num, color);
            %             imshow(handles.hand.mask,[], 'Parent', gui_handles.ax2);
            %drawnow;
            %             if handles.hand.BB(1)~=0
            %                 img2=insertShape(img,'Rectangle',handles.hand.BB,'Color','red','LineWidth',5);
            %             end
            %imshow(uint8(painter),[], 'Parent', gui_handles.ax1)
            
            
            subplot(2,2,1)
            imshow(board,[], 'XData',[1,painterx_scale], 'YData',[1 paintery_scale]);
            if ~finger_num
                title("Draw","Color",color, 'FontSize',40)
            elseif finger_num == 4 || finger_num == 5
                title("Erase","Color",'k', 'FontSize',40)
            else
                title("Your Color","Color",color, 'FontSize',40)
            end
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
            
            
            finger_arr_hist = [finger_arr_hist, finger_num];
            finger_arr = [finger_arr, actual_finger];
            
            if length(finger_arr_hist) >= 100
                n = length(finger_arr_hist);
                disp("with history")
                for i =0:5
                    k = sum(finger_arr_hist == i);
                    disp(num2str(i) + ": "+ num2str(k))
                end
                disp("no history")
                for i =0:5
                    k = sum(finger_arr == i);
                    disp(num2str(i) + ": "+ num2str(k))
                end
                finger_arr=[];
                finger_arr_hist=[];
            end
            
            
        end
    catch e
        disp(e)
        disp(e.stack(1))
        title("error detected",'FontSize',30,'Color','red');
        subplot(2,2,3)
        imshow(instruction2);
        title("");
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
        case 'Capture righthand'
            isLeft = false;
            if ~handles.wait_for_continue
                handles = capture_function(gui_handles,handles,isLeft);
                handles.isLeft = isLeft;
            else
                pause(0.1);
            end
        case 'Capture lefthand'
            isLeft = true;
            if ~handles.wait_for_continue
                handles = capture_function(gui_handles,handles,isLeft);
                handles.isLeft = isLeft;
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

function handles = capture_function(gui_handles,handles, isLeft)

img=snapshot(handles.webcam);
imshow(img,[], 'Parent', gui_handles.ax1)
init_points = ginput(2);
b = init_points(1,:);
h = init_points(2,:);
handles = initial_bracelet_rep_hs(handles,img,init_points,'green');
[handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img,init_points, isLeft);
img2=insertShape(img,'Rectangle',handles.bracelet.BB,'Color','red','LineWidth',5);
img2=insertShape(img2,'Rectangle',first_time_hand_BB,'Color','blue','LineWidth',5);
imshow(img2,[],'Parent', gui_handles.ax1)
drawnow;
handles.wait_for_continue = 1;
handles.hand.dist_to_center = b-h;
% handles = calibrate_fist(handles);

end

function [px,py] = scale_pointer(x,y,size_x,size_y, prev_x, prev_y,painterx_scale,paintery_scale)
px=x;
py=y;

sizing_factor_x = 1;
sizing_factor_y = 1;

% px =  sizing_factor_x*(x-prev_x);
% py =  sizing_factor_y*(y-prev_y);

px = sizing_factor_x*uint16((painterx_scale-1)\(size_x-1)*(px-1)+1);
py = sizing_factor_y*uint16((paintery_scale-1)\(size_y-1)*(py-1)+1);

px = max(1, min([px,painterx_scale]));
py = max(1, min([py,paintery_scale]));

% px=x;
% py=y;
end
