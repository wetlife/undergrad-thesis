one = 1;
eval(tinkerings);
while one ~= 0
    tinkering = input(sprintf('(Enter tinkerings and remember one = 0 breaks things (like this loop :)\n'),'s');
    eval(tinkering)
end