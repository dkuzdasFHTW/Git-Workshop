function run_workshop()
% RUN_WORKSHOP  Workshop-Hauptscript
%   Sucht automatisch alle Teilnehmer-Dateien (participant_*.m),
%   führt sie aus, um Datenstrukturen zu laden,
%   und plottet alle Datensätze gemeinsam in einem Diagramm.
%
%   VERWENDUNG:
%       run_workshop
%
%   Jeder Teilnehmer erstellt eine Datei participant_[vorname].m,
%   die eine Struktur mit folgenden Feldern zurückgibt:
%       data.name    - Name des Teilnehmers (String)
%       data.x       - x-Werte für den Plot (numerischer Vektor)
%       data.y       - y-Werte für den Plot (numerischer Vektor)
%       data.color   - Farbe der Linie (String oder RGB-Tripel)
%       data.marker  - (optional) Plot-Marker, z.B. 'o', 's', '^'
%       data.label   - (optional) Legendenbeschriftung (String)
%
%   WORKFLOW:
%       1. Alle participant_*.m-Dateien werden mit dir() gesucht
%       2. Jede Funktion wird mit feval() aufgerufen
%       3. Datensätze werden in einem gemeinsamen Figure geplottet



    clear; close all; clc;
    
    
    %% ── 1. Alle Teilnehmer-Dateien finden ──────────────────────────────────
    files = dir(fullfile(fileparts(mfilename('fullpath')), 'participant_*.m'));
    
    if isempty(files)
        warning('run_workshop:noFiles', ...
            'Keine participant_*.m-Dateien gefunden!\n%s', ...
            'Bitte zuerst eine eigene Datei erstellen und committen.');
        return;
    end
    
    fprintf('Gefunden: %d Teilnehmer-Datei(en)\n\n', numel(files));
    
    %% ── 2. Daten aus jeder Datei laden ─────────────────────────────────────
    allData = {};          % Cell-Array für Datensätze
    failedFiles = {};      % Fehlgeschlagene Dateien
    
    for i = 1:numel(files)
        % Dateiname → Funktionsname (ohne .m-Endung)
        funcName = erase(files(i).name, '.m');
        
        fprintf('  [%2d/%d]  Lade: %s ... ', i, numel(files), funcName);
        
        try
            % Datei muss im MATLAB-Pfad oder aktuellen Ordner sein
            addpath(fileparts(files(i).folder));
            
            % Funktion dynamisch aufrufen
            data = feval(funcName);
            
            % Pflichtfelder prüfen
            validateData(data, funcName);
            
            % Optionale Felder mit Standardwerten füllen
            data = fillDefaults(data, funcName);
            
            allData{end+1} = data; %#ok<AGROW>
            fprintf('✓\n');
            
        catch e
            failedFiles{end+1} = funcName; %#ok<AGROW>
            fprintf('✗  FEHLER: %s\n', e.message);
        end
    end
    
    fprintf('\nErfolgreich geladen: %d / %d\n', ...
            numel(allData), numel(files));
    
    if isempty(allData)
        error('run_workshop:noData', ...
              'Keine gültigen Datensätze geladen. Bitte participant_*.m prüfen.');
    end
    
    %% ── 3. Gemeinsamen Plot erstellen ───────────────────────────────────────
    fig = figure( ...
        'Name',     'Workshop: Gemeinsamer Plot', ...
        'Position', [80, 80, 1100, 650], ...
        'Color',    'white' ...
    );
    hold on
    
    % Alle Datensätze plotten
    for i = 1:numel(allData)
        d = allData{i};
        
        plot(d.x, d.y, ...
             ['-', d.marker], ...
             'Color',       d.color, ...
             'LineWidth',   2.0, ...
             'MarkerSize',  7, ...
             'MarkerFaceColor', d.color, ...
             'DisplayName', d.label ...
        );
    end
    
    % Achsen & Beschriftungen
    % set(gca, 'YScale', 'log')
    xlabel( 'x');
    ylabel( 'Werte');
    title(sprintf('Git Workshop – %d Teilnehmer gemeinsam', numel(allData)), ...
          'FontSize', 16, 'FontWeight', 'bold');
    
    legend( 'Location', 'best', 'FontSize', 10);
    
    hold off
    

end


%% ── Hilfsfunktionen ─────────────────────────────────────────────────────────

function validateData(data, funcName)
% Prüft, ob alle Pflichtfelder vorhanden und gültig sind.
    required = {'name', 'x', 'y', 'color'};
    for i = 1:numel(required)
        if ~isfield(data, required{i})
            error('Pflichtfeld "%s" fehlt in %s()', required{i}, funcName);
        end
    end
    if numel(data.x) ~= numel(data.y)
        error('x und y müssen gleich lang sein (x:%d, y:%d)', ...
              numel(data.x), numel(data.y));
    end
    if isempty(data.x)
        error('x und y dürfen nicht leer sein');
    end
end


function data = fillDefaults(data, funcName)
% Füllt optionale Felder mit vernünftigen Standardwerten.
    if ~isfield(data, 'marker') || isempty(data.marker)
        data.marker = 'o';
    end
    if ~isfield(data, 'label') || isempty(data.label)
        data.label = data.name;
    end
end
