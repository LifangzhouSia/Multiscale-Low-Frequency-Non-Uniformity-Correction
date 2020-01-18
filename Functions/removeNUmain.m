function dI = removeNUmain(Insy)

[G, L] = pyramid_setup(Insy, layer);

B = pyramid_estimation(G, L);

b = pyramid_reconstruction(B);

dI = Insy - b;

end