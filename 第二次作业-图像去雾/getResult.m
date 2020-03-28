function result = getResult(image, x, y, tRefined, t0)
brightestIntensity = image(x, y, :);
result = (image - brightestIntensity) ./ max(tRefined, t0) + brightestIntensity;
