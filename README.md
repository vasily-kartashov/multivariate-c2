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
I used the following rather ugly function to test the C2 interpolation

    f = @(x, y)  min(1, max(0, sin(pi * x) .* exp(y .^ 2)));

| step size              |  1.00000000 |  0.50000000 |  0.25000000 |  0.12500000 |  0.06250000 |  0.03125000 |
|------------------------|----------|----------|----------|----------|----------|----------|
| linear interp2 (time)  |  4.45180619 |  4.54680184 |  4.84996840 |  5.39132561 |  7.66961989 |  15.19599350 |
| tensorinterp (time)    |  0.06541921 |  0.06483289 |  0.06430650 |  0.06496665 |  0.06267017 |  0.06510319 |
| linear interp2 (error) |  1.00000000 |  0.97538862 |  0.94113427 |  0.87040651 |  0.70139536 |  0.32155183 |
| tensorinterp (error)   |  1.00000000 |  0.99513808 |  0.98109631 |  0.92873718 |  0.74976413 |  0.27757992 |

All in all on average 100-fold acceleration with approximately the same magnitude of errors.

For a three dimensional function

    f = @(x, y, z)  x + sin(y .* z) .* max(exp(x - y), ones(size(x)));


we get the following results 

| step size              |  1.00000 |  0.50000 |  0.25000 |  0.12500 |
|------------------------|----------|----------|----------|----------|
| spline interp3 (time)  |  23.44589 |  63.92122 |  74.83716 |  347.18997 |
| tensorinterp (time)    |  0.47495 |  0.49752 |  0.48584 |  0.57527 |
| spline interp3 (error) |  0.44298 |  0.05928 |  0.03329 |  0.01165 |
| tensorinterp (error)   |  0.44298 |  0.05572 |  0.03058 |  0.02129 |

As one can easilty see, the accuracy stays similar in both cases while the performance differs in magnitudes.


