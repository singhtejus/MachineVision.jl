function CalcSobelGradients(img::Array)
    rows   = size(img, 1);
    cols   = size(img, 2);

    ximage = zeros(rows,cols);
    yimage = zeros(rows,cols);
    simage = zeros(rows,cols);

    maxim = zeros(Float32,3);
    maxim[1] = 0;
    maxim[2] = 0;
    maxim[3] = 0;
    for i in 2:rows-1
        for j in 2:cols-1
            
            gx = abs(
                -img[i-1, j-1] - 2*img[i, j-1] - img[i+1, j-1] + img[i-1, j+1] +  2*img[i, j+1] + img[i+1, j+1])
            maxim[1] = max(gx, maxim[1])
            ximage[i, j] = gx
    
            gy = abs(-img[i-1, j-1] -2*img[i-1, j] - img[i-1, j+1] + img[i+1, j-1] + 2*img[i+1, j] + img[i+1, j+1])
            maxim[2] = max(gy, maxim[2])
            yimage[i, j] = gy
            
            sgm = sqrt(gx^2 + gy^2)
            maxim[3] = max(sgm, maxim[3])
            simage[i, j] = sgm
        end
    end
    
    # Normalize the images between 0 and 255
    ximage .= ximage .* (255 / maxim[1])
    yimage .= yimage .* (255 / maxim[2])
    simage .= simage .* (255 / maxim[3])

    return ximage, yimage, simage
end