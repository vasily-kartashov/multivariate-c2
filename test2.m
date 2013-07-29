f = @(x, y)  min(1, max(0, sin(pi * x) .* exp(y .^ 2)));
testaxis = getaxis(-3, 3, 100, 'equidistant');
testgrid = tensorgrid(testaxis, testaxis);

for step = [1.0, 0.5, 0.25, 0.125, 0.0625, 0.03125]

    [xs, ys] = meshgrid(-3 : step : 3);
    zs = f(xs, ys);
    g = @(x, y) interp2(xs, ys, zs, x, y, 'cubic');

    ax = getaxis(-3, 3, round(6 / step) + 1, 'equidistant');
    grid = tensorgrid(ax, ax);
    h = @(x, y) tensorinterp(grid, zs', [x, y]);
    
    % error functions
    ge = @(x, y) abs(g(x, y) - f(x, y));
    he = @(x, y) abs(h(x, y) - f(x, y));
    
    rg = findmax(ge, testgrid);
    rh = findmax(he, testgrid);
    
    step
    rg
    rh
    
end



