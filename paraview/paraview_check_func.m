% Vorhandensein des Paraview-Konfig-Ordners pruefen
function paraview_check_func()

% Ort des Konfig-Ordnes, je nach Betriebssystem
if ispc
    paraview_config_path = strcat(getenv('APPDATA'),'\ParaView');
elseif isunix || ismac
    paraview_config_path = strcat(getenv('HOME'),'/.config/ParaView');
end

paracheckfile = strcat('paraview',filesep,'paraview_check.txt');
load(paracheckfile);
% Pruefen, ob Paraview Config-Ordner vorhanden ist, falls noch nicht getan
if isfolder(paraview_config_path) && ~paraview_check

    % Setze paraview_check in paraview_check.txt auf '1'
    paraID = fopen(paracheckfile, 'w');
    fprintf(paraID,'1');
    fclose(paraID);

    % Question-Dialogbox
    questans = questdlg('Paraview Konfig-Ordner gefunden. Macros dorthin kopieren?', ...
      'Paraview Macros kopieren?', ...
      'Ja','Nein','Ja');
    switch questans
      case 'Ja'
        paraview_macros_path = strcat(paraview_config_path,filesep,'Macros');
        % Pruefen, ob Macros-Ordner in Paraview Config-Ordner vorhanden ist.
        % Falls nicht, Macros-Ordner anlegen.
        if ~isfolder(paraview_macros_path)
            mkdir(paraview_config_path,'Macros');
            fprintf('Paraview Macros-Ordner angelegt.\n');
        end
        % vonMises-Macro in Paraview Macros-Ordner kopieren
        copyfile(strcat('paraview',filesep,'vonMises.py'), strcat(paraview_macros_path,filesep,'vonMises.py'));
        fprintf('Paraview Macro %s nach %s kopiert.\n','vonMises.py',paraview_macros_path);
	% KraftRB-Macro in Paraview Macros-Ordner kopieren
        copyfile(strcat('paraview',filesep,'KraftRB.py'), strcat(paraview_macros_path,filesep,'KraftRB.py'));
        fprintf('Paraview Macro %s nach %s kopiert.\n','KraftRB.py',paraview_macros_path);
    end
end

end % function
