function im = draw_dict(im, min_row, max_row, min_column, max_column, line_size, line_color)
color = line_color;
height = size(im, 1);
width = size(im, 2);
for i=1:line_size
    % top line
    for j=min_column - line_size - (i-1):max_column + line_size + (i-1)
        heightIdx = min_row - line_size - (i-1);
        if heightIdx >= 1 && heightIdx <= height && j >= 1 && j <= width
            im(heightIdx, j, :) = color;
        end
    end
    % bottom line
    for j=min_column - line_size - (i-1):max_column + line_size + (i-1)
        heightIdx = max_row + line_size + (i-1);
        if heightIdx >= 1 && heightIdx <= height && j >= 1 && j <= width
            im(heightIdx, j, :) = color;
        end
    end
    % left line
    for j=min_row - line_size - (i-1):max_row + line_size + (i-1)
        widthIdx = min_column - line_size - (i-1);
        if j >= 1 && j <= height && widthIdx >= 1 && widthIdx <= width
            im(j, widthIdx, :) = color;
        end
    end
    % right line
    for j=min_row - line_size - (i-1):max_row + line_size + (i-1)
        widthIdx = max_column + line_size + (i-1);
        if j >= 1 && j <= height && widthIdx >= 1 && widthIdx <= width
            im(j, widthIdx, :) = color;
        end
    end
end
