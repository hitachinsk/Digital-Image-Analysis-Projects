function im = draw_dict(im, min_row, max_row, min_column, max_column, line_size)
color = [255, 0, 0];
for i=1:line_size
    % top line
    for j=min_column - line_size - (i-1):max_column + line_size + (i-1)
        im(min_row - line_size - (i-1), j, :) = color;
    end
    % bottom line
    for j=min_column - line_size - (i-1):max_column + line_size + (i-1)
        im(max_row + line_size + (i-1), j, :) = color;
    end
    % left line
    for j=min_row - line_size - (i-1):max_row + line_size + (i-1)
        im(j, min_column - line_size - (i-1), :) = color;
    end
    % right line
    for j=min_row - line_size - (i-1):max_row + line_size + (i-1)
        im(j, max_column + line_size + (i-1), :) = color;
    end
end
