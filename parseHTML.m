clc, clear

% Select file
file = 'pp_drf_20191209.html';

% Open file
fid = fopen(file, 'rt','n','UTF-8');
if fid < 3
    error('Error opening file: %s', filename);
end

% Scan entire file into one string
rawHtml = fscanf(fid,'%c');

% Use regular expressions to identify Past Performance HTML blocks.
expr = '<div\s+class="ppLines\s+clearfix\s+scratchedClose">';
ppLinesHeader = regexp(rawHtml,expr);
nHorses = length(ppLinesHeader);
for iHorse = 1:nHorses-1
    thisHorse = sprintf('Horse%d',iHorse);
    ppHtml.(thisHorse) = rawHtml(ppLinesHeader(iHorse):ppLinesHeader(iHorse+1)-1);
end
thisHorse = sprintf('Horse%d',nHorses);
endExpr = '</span></div></div></div></div></div></div>';
endInd = regexp(rawHtml,endExpr);
ppHtml.(thisHorse) = rawHtml(ppLinesHeader(nHorses):endInd+30);

ppData = parsePpBlocks(ppHtml);


%% Console Print
disp('--------------------')
disp('HORSE RACE PP PARSER')
disp('--------------------')
fprintf('\nHorses:\n')
disp('- - - - - -')
for iHorse = 1:nHorses
    thisHorse = sprintf('Horse%d',iHorse);
    name = ppData.(thisHorse).name;
    fprintf('%s\n',name)
end





