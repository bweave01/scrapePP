function ppLines = parsePpLine(data)
%PARSEPPLINE Summary of this function goes here
%   Detailed explanation goes here

expr = '<div\s+class="ppLinesItem">';
lineStarts = regexp(data,expr,'start');
nLines = length(lineStarts);
for iLine = 1:nLines
    if iLine < nLines
        ppLine = data(lineStarts(iLine):lineStarts(iLine+1));
    else
        ppLine = data(lineStarts(iLine):end);
    end
    
    % Distance
    expr = '<span\s+class="distance">(\d.?.?)</span>';
    distance = regexp(ppLine,expr,'tokens');
    
    % Beyer Speed
    expr = '<span\s+class="beyerSpeed\s+noClass">(-?\d+)</span>';
    beyerSpeed = regexp(ppLine,expr,'tokens');
    
    
    ppLines{iLine,1} = distance{1}{:};
    ppLines{iLine,2} = beyerSpeed{1}{:};



end

