f = @(x, y)  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) - 1/3*exp(-(x+1).^2 - y.^2);
testaxis = getaxis(-3, 3, 100, 'equidistant');
testgrid = tensorgrid(testaxis, testaxis);

for step = [1.0, 0.5, 0.25, 0.125, 0.0625, 0.03125]

    [xs, ys] = meshgrid(-3 : step : 3);
    zs = f(xs, ys);
    g = @(x, y) interp2(xs, ys, zs, x, y);

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



