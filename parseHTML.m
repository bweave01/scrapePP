clc, clear

% Select file
file = 'pp_drf_20191203.html';

% Open file
fid = fopen(file, 'rt');
if fid < 3
    error('Error opening file: %s', filename);
end

% Scan entire file into one string
rawHtml = fscanf(fid,'%c');

% Use regular expressions to identify Past Performance HTML blocks.
expr = '<div class="ppLines[ ]+clearfix[ ]+scratchedClose">';%'<div class="ppLines clearfix scratchedClose">';
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
