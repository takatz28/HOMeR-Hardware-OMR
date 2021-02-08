function [new_img, lineHeight, spaceHeight] = preprocess(img)

    % check if image is color 
    if (ndims(img) == 3)
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    
    if (~islogical(gray_img))
        thresh = graythresh(gray_img);
        img1 = imbinarize(gray_img, thresh);
    else
        img1 = gray_img;
    end
    
%     img_bw = ones(size(img1)) - img1;
    img_bw = not(img1);
    
    [lineHeight, spaceHeight] = getStaffParam(img_bw);

    % Horizontal projection for staff detection
    % - In this case, only the topmost and bottommost
    %   staff lines are relevant to get upper/lower
    %   bounds
    project_H = sum(img_bw, 2);
    thresh_H = max(project_H) * 0.5;
    x = find(project_H >= thresh_H);

%     if (debug == 1)
%         figure;
%         imshow(not(img_bw));
%         hold on;
%     end    
    % Vertical projection
    % - Left/right-most bar lines are detected for 
    %   side bounds
    project_V = sum(img_bw, 1);
    [~, loc] = findpeaks(project_V);
    left_bound = min(loc) - 20;
    right_bound = max(loc) + 20;
    top_bound = min(x)-(5*(lineHeight + spaceHeight));
    bottom_bound = max(x)+(5*(lineHeight + spaceHeight));

    % Boundary validation for all four sides 
    % - Checks if calculated bounds exceed the image size
    if (left_bound < 1)
        left_bound = 1;
    end
    
    if (top_bound < 1)
        top_bound = 1;
    end
    
    if (right_bound > size(img_bw,2))
        right_bound = size(img_bw,2);
    end
   
    if (bottom_bound > size(img_bw,1))
        bottom_bound = size(img_bw,1);
    end
    
    new_img = img_bw(top_bound:bottom_bound, ...
        left_bound:right_bound);
%     imshow(new_img); pause;

end