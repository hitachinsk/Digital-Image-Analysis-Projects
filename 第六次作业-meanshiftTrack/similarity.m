function sim = similarity(initTarget, candTarget)
sim = sum(sum(sqrt(initTarget .* candTarget)));
end

