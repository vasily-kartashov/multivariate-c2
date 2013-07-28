multivariate-C2
===========================

Multivariate shape-preserving C2 tensor interpolation


Compilation
------------------
Compile the extension for you platform

    mex tensorinterp.cpp pchip.cpp
    

Settings up the grid
------------------
Define the axes for your tensor and create the grid spanned by these axes. The number of axes is unlimited. 
    
    axis1 = getaxis(-1, 1, 20, 'equidistant');
    axis2 = getaxis(-1, 1, 20, 'equidistant');
    grid = tensorgrid(axis1, axis2);

The first two parameters of getaxis define define lower and upper boundary, the third parameter sets the number of points, 
the last parameter defines the distribution of the dots. The following distributions are implemented

 * chebyshev
 * quadratic
 * cubic
 * exponential
 * double-exponential
 * triple-exponential
 * generalized polynomial

The method getaxis returns an array, so you can alway use your own axes, with points concentrated at the most interesting areas


Initialize the grid
-------------------------

    % Initialize the grid
    vs = zeros(grid.ns);
    for i = 1 : grid.ns(1)
        for j = 1 : grid.ns(2)
            vs(i, j) = f(grid.axes{1}(i), grid.axes{2}(j));
        end
    end

Interpolate
-------------------------
Once the grid is set up and initialized you can use tensorinterp to interpolate the values.

    g = @(x, y) tensorinterp(grid, vs, [x, y]);

You can interpolate multiple values at once by putting a multiple rows as third argument into ltinterp. 
The resulting vector always has 1 column and as many rows as the third argument.

Performance
-------------------------
On a standard 2D peaks function

| Grid step                | 1.00 | 0.50 | 0.25 | 0.0625 | 0.03125 |
|--------------------------|------|------|------|--------|---------|
| interp2 (time)           | 2.63 | 2.64 | 2.71 | 3.4385 | 5.12514 |
| tensorinterp (time)      | 0.26 | 0.25 | 0.26 | 0.4070 | 1.31109 |
| interp2 (max error)      | 4.04 | 1.20 | 0.36 | 0.0216 | 0.00553 |
| tensorinterp (max error) | 3.55 | 0.98 | 0.25 | 0.0124 | 0.00292 |

