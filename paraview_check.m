% Vorhandensein des Paraview-Konfig-Ordners pruefen

% Ort des Konfig-Ordnes, je nach Betriebssystem
if ispc
    paraview_config_path = strcat(getenv('APPDATA'),'\ParaView');
elseif isunix || ismac
    paraview_config_path = strcat(getenv('HOME'),'/.config/ParaView');
end

% Falls Paraview-Konfig-Ordner vorhanden, paraview-Macros dorthin kopieren
if isfolder(paraview_config_path)
    copyfile('paraview/vonMises.py', strcat(paraview_config_path,'/Macros/vonMises.py'))
end