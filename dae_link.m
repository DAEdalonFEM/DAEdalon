function dae_link

sys = computer;
if isunix
    try
        unix('xdg-open http://www.daedalon.org')
    catch
        disp('Browser konnte nicht geoeffnet werden!')
    end
end

if strncmp(sys, 'PC', 2)
    disp('Funktion nicht implementiert!')
end
