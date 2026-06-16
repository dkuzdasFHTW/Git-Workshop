function data = participant_Gerhard()
% PARTICIPANT_EXAMPLE  Vorlage für Teilnehmer-Dateien
%   initial state recovered
%   ANLEITUNG:
%   1. Diese Datei kopieren als:  participant_[euer_vorname].m
%      Beispiel: participant_otto.m
%
%   2. Den Funktionsnamen anpassen:
%      function data = participant_[euer_vorname]()
%
%   3. Die Felder mit euren Daten befüllen.
%
%   4. In MATLAB testen:
%      >> d = participant_[euer_vorname]();
%      >> disp(d)
%
%   5. Committen & Pushen:
%      $ git add participant_[euer_vorname].m
%      $ git commit -m "Add: Participant [Name] data"
%      $ git push origin main
%
%   WICHTIG:
%   - Dateiname muss mit Funktionsname übereinstimmen!
%   - Nur Kleinbuchstaben, kein Leerzeichen, keine Umlaute
%   - participant_example.m ist NUR eine Vorlage – nicht committen!
%
%   Workshop: Git & MATLAB Versionsmanagement

    %% ── Pflichtfelder – bitte ausfüllen! ───────────────────────────────────

    % Euer Name (erscheint in Legende und Ausgabe)
    data.name   = 'Gerhard';            % ← ÄNDERN

    % Farbe eurer Linie im Plot
    % Optionen: 'red', 'blue', 'green', 'magenta', 'cyan', 'black',
    %           '#FF5733' (Hex), [0.2 0.5 0.8] (RGB 0..1)
    data.color  = [0.2, 1, 1];             % ← ÄNDERN (Blau als Beispiel)

    %% ── x-Werte: Unabhängige Variable ──────────────────────────────────────
    %   Beispiele:
    %     Zeit:        data.x = 0:0.1:2*pi;
    %     Messnummern: data.x = 1:10;
    %     Frequenzen:  data.x = [50, 100, 200, 500, 1000];
    
    data.x = 1:10;                             

    %% ── y-Werte: Eure Messdaten ─────────────────────────────────────────────
    %   Sein kreativ! Möglichkeiten:
    %     Quadratzahlen:   data.y = data.x .^ 2;
    %     Fibonacci:       data.y = [1,1,2,3,5,8,13,21,34,55];
    %     Sinuswelle:      data.y = sin(data.x * pi / 5);
    %     Zufallswerte:    data.y = cumsum(randn(1, numel(data.x)));
    %     Eigene Messung:  data.y = [12.3, 13.1, 12.8, 14.2, 15.0, ...];

    data.y = data.x.^ (3);                       % ← ANPASSEN (Quadratzahlen als Beispiel)

    %% ── Optionale Felder ────────────────────────────────────────────────────

    % Plot-Marker: 'o', 's', '^', 'd', '*', '+', 'x', 'p', 'h'
    data.marker = 's';

    % Legendenbeschriftung (Standard: data.name)
    data.label  = [data.name, ', f(x) = x^3'];

end
