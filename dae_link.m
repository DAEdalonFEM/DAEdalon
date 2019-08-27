function dae_link

sys = computer;
if isunix
    check = unix('rpm --query netscape');
    if ~check
        unix('netscape www.daedalon.org');
    else
        disp('Netscape nicht gefunden!')
    end
end

if strncmp(sys, 'PC', 2)
    disp('Funktion nicht implementiert!')
end